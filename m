From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/7] lpfc 8.3.1 : Main body of fixes/changes
Date: Mon, 6 Apr 2009 18:48:10 -0400
Message-ID: <1239058090.2344.31.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:43069 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbZDFWsV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 18:48:21 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n36MmJHn017095
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 15:48:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


8.3.1 Fixes/Changes :

- Fix incorrect byte-swapping on word 4 of IOCB (data length) which
  caused LUNs to not be discovered on big-endian (e.g. PPC)

- Remove a bad cast of MBslimaddr which loses the __iomem (sparse)

- Make lpfc_debugfs_mask_disc_trc static (sparse)

- Correct misspelled word BlockGuard in lpfc_logmsg.h comment

- Replaced repeated code segment for canceling IOCBs from a list with
  a function call, lpfc_sli_cancel_iocbs().

- Increased HBQ buffers to support 40KB SSC sequences.

- Added sysfs interface to update speed and topology parameter without
  link bounce.

- Fixed bug with sysfs fc_host WWNs not being updated after changing
  the WWNs.

- Check if the active mailbox is NULL in the beginning of the mailbox
  timeout handler - fixes panic in the mailbox timeout handler while
  running IO stress test

- Fixed system panic in lpfc_pci_remove_one() due to ndlp indirect
  reference to phba through vport

- Removed de-reference of scsi device after call to scsi_done() to fix
  panic in scsi completion path while accessing scsi device after
  scsi_done is called.

- Fixed "Nodelist not empty" message when unloading the driver after
  target reboot test

- Added LP2105 HBA model description

- Added code to print all 16 words of unrecognized ASYNC events

- Fixed memory leak in vport create + delete loop

- Added support for handling dual error bit from HBA

- Fixed a driver NULL pointer dereference in lpfc_sli_process_sol_iocb

- Fixed a discovery bug with FC switch reboot in lpfc_setup_disc_node

- Take NULL termintator into account when calculating available buffer space



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |    2 
 lpfc_attr.c      |   67 +++++++++++++---
 lpfc_crtn.h      |    2 
 lpfc_debugfs.c   |    5 -
 lpfc_disc.h      |    1 
 lpfc_els.c       |   75 ++++--------------
 lpfc_hbadisc.c   |   80 ++++++++-----------
 lpfc_init.c      |  104 +++++++++++++++++++++----
 lpfc_logmsg.h    |    2 
 lpfc_nportdisc.c |   18 ----
 lpfc_scsi.c      |   47 ++++++-----
 lpfc_sli.c       |  221 ++++++++++++++++++++++++++++++++++++-------------------
 12 files changed, 378 insertions(+), 246 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2009-04-06 18:29:31.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2009-04-06 18:31:09.000000000 -0400
@@ -2216,18 +2216,41 @@ LPFC_VPORT_ATTR_R(scan_down, 1, 0, 1,
  * non-zero return value from lpfc_issue_lip()
  * -EINVAL val out of range
  **/
-static int
-lpfc_topology_set(struct lpfc_hba *phba, int val)
+static ssize_t
+lpfc_topology_store(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
 {
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	int val = 0;
+	int nolip = 0;
+	const char *val_buf = buf;
 	int err;
 	uint32_t prev_val;
+
+	if (!strncmp(buf, "nolip ", strlen("nolip "))) {
+		nolip = 1;
+		val_buf = &buf[strlen("nolip ")];
+	}
+
+	if (!isdigit(val_buf[0]))
+		return -EINVAL;
+	if (sscanf(val_buf, "%i", &val) != 1)
+		return -EINVAL;
+
 	if (val >= 0 && val <= 6) {
 		prev_val = phba->cfg_topology;
 		phba->cfg_topology = val;
+		if (nolip)
+			return strlen(buf);
+
 		err = lpfc_issue_lip(lpfc_shost_from_vport(phba->pport));
-		if (err)
+		if (err) {
 			phba->cfg_topology = prev_val;
-		return err;
+			return -EINVAL;
+		} else
+			return strlen(buf);
 	}
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 		"%d:0467 lpfc_topology attribute cannot be set to %d, "
@@ -2240,7 +2263,6 @@ module_param(lpfc_topology, int, 0);
 MODULE_PARM_DESC(lpfc_topology, "Select Fibre Channel topology");
 lpfc_param_show(topology)
 lpfc_param_init(topology, 0, 0, 6)
-lpfc_param_store(topology)
 static DEVICE_ATTR(lpfc_topology, S_IRUGO | S_IWUSR,
 		lpfc_topology_show, lpfc_topology_store);
 
@@ -2281,7 +2303,7 @@ lpfc_stat_data_ctrl_store(struct device 
 	unsigned long base, step, bucket_type;
 
 	if (!strncmp(buf, "setbucket", strlen("setbucket"))) {
-		if (strlen(buf) > LPFC_MAX_DATA_CTRL_LEN)
+		if (strlen(buf) > (LPFC_MAX_DATA_CTRL_LEN - 1))
 			return -EINVAL;
 
 		strcpy(bucket_data, buf);
@@ -2598,12 +2620,29 @@ static struct bin_attribute sysfs_drvr_s
  * non-zero return value from lpfc_issue_lip()
  * -EINVAL val out of range
  **/
-static int
-lpfc_link_speed_set(struct lpfc_hba *phba, int val)
+static ssize_t
+lpfc_link_speed_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
 {
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	int val = 0;
+	int nolip = 0;
+	const char *val_buf = buf;
 	int err;
 	uint32_t prev_val;
 
+	if (!strncmp(buf, "nolip ", strlen("nolip "))) {
+		nolip = 1;
+		val_buf = &buf[strlen("nolip ")];
+	}
+
+	if (!isdigit(val_buf[0]))
+		return -EINVAL;
+	if (sscanf(val_buf, "%i", &val) != 1)
+		return -EINVAL;
+
 	if (((val == LINK_SPEED_1G) && !(phba->lmt & LMT_1Gb)) ||
 		((val == LINK_SPEED_2G) && !(phba->lmt & LMT_2Gb)) ||
 		((val == LINK_SPEED_4G) && !(phba->lmt & LMT_4Gb)) ||
@@ -2611,14 +2650,19 @@ lpfc_link_speed_set(struct lpfc_hba *phb
 		((val == LINK_SPEED_10G) && !(phba->lmt & LMT_10Gb)))
 		return -EINVAL;
 
-	if ((val >= 0 && val <= LPFC_MAX_LINK_SPEED)
+	if ((val >= 0 && val <= 8)
 		&& (LPFC_LINK_SPEED_BITMAP & (1 << val))) {
 		prev_val = phba->cfg_link_speed;
 		phba->cfg_link_speed = val;
+		if (nolip)
+			return strlen(buf);
+
 		err = lpfc_issue_lip(lpfc_shost_from_vport(phba->pport));
-		if (err)
+		if (err) {
 			phba->cfg_link_speed = prev_val;
-		return err;
+			return -EINVAL;
+		} else
+			return strlen(buf);
 	}
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -2665,7 +2709,6 @@ lpfc_link_speed_init(struct lpfc_hba *ph
 	return -EINVAL;
 }
 
-lpfc_param_store(link_speed)
 static DEVICE_ATTR(lpfc_link_speed, S_IRUGO | S_IWUSR,
 		lpfc_link_speed_show, lpfc_link_speed_store);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2009-04-06 18:30:50.000000000 -0400
@@ -184,6 +184,8 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
 struct lpfc_iocbq * lpfc_sli_get_iocbq(struct lpfc_hba *);
 void lpfc_sli_release_iocbq(struct lpfc_hba *, struct lpfc_iocbq *);
 uint16_t lpfc_sli_next_iotag(struct lpfc_hba *, struct lpfc_iocbq *);
+void lpfc_sli_cancel_iocbs(struct lpfc_hba *, struct list_head *, uint32_t,
+			   uint32_t);
 
 void lpfc_reset_barrier(struct lpfc_hba * phba);
 int lpfc_sli_brdready(struct lpfc_hba *, uint32_t);
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2009-04-06 18:29:31.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2009-04-06 18:30:50.000000000 -0400
@@ -95,7 +95,7 @@ module_param(lpfc_debugfs_max_slow_ring_
 MODULE_PARM_DESC(lpfc_debugfs_max_slow_ring_trc,
 	"Set debugfs slow ring trace depth");
 
-int lpfc_debugfs_mask_disc_trc;
+static int lpfc_debugfs_mask_disc_trc;
 module_param(lpfc_debugfs_mask_disc_trc, int, 0);
 MODULE_PARM_DESC(lpfc_debugfs_mask_disc_trc,
 	"Set debugfs discovery trace mask");
@@ -399,8 +399,7 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
 
 	len +=  snprintf(buf+len, size-len, "HBA SLIM\n");
 	lpfc_memcpy_from_slim(buffer,
-		((uint8_t *)phba->MBslimaddr) + lpfc_debugfs_last_hba_slim_off,
-		1024);
+		phba->MBslimaddr + lpfc_debugfs_last_hba_slim_off, 1024);
 
 	ptr = (uint32_t *)&buffer[0];
 	off = lpfc_debugfs_last_hba_slim_off;
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2008-10-18 10:32:52.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2009-04-06 18:30:58.000000000 -0400
@@ -99,6 +99,7 @@ struct lpfc_nodelist {
 #define NLP_USG_FREE_ACK_BIT	0x8	/* Indicate ndlp memory free invoked */
 
 	struct timer_list   nlp_delayfunc;	/* Used for delayed ELS cmds */
+	struct lpfc_hba *phba;
 	struct fc_rport *rport;			/* Corresponding FC transport
 						   port structure */
 	struct lpfc_vport *vport;
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2009-04-06 18:29:31.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2009-04-06 18:30:58.000000000 -0400
@@ -5058,19 +5058,9 @@ lpfc_els_flush_cmd(struct lpfc_vport *vp
 	}
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		cmd = &piocb->iocb;
-		list_del_init(&piocb->list);
-
-		if (!piocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, piocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(piocb->iocb_cmpl) (phba, piocb, piocb);
-		}
-	}
+	/* Cancell all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 
 	return;
 }
@@ -5121,18 +5111,11 @@ lpfc_els_flush_all_cmd(struct lpfc_hba  
 		lpfc_sli_issue_abort_iotag(phba, pring, piocb);
 	}
 	spin_unlock_irq(&phba->hbalock);
-	while (!list_empty(&completions)) {
-		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		cmd = &piocb->iocb;
-		list_del_init(&piocb->list);
-		if (!piocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, piocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(piocb->iocb_cmpl) (phba, piocb, piocb);
-		}
-	}
+
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
+
 	return;
 }
 
@@ -6468,7 +6451,6 @@ static void lpfc_fabric_abort_vport(stru
 	LIST_HEAD(completions);
 	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
-	IOCB_t *cmd;
 
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(piocb, tmp_iocb, &phba->fabric_iocb_list,
@@ -6481,15 +6463,9 @@ static void lpfc_fabric_abort_vport(stru
 	}
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		list_del_init(&piocb->list);
-
-		cmd = &piocb->iocb;
-		cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-		cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-		(piocb->iocb_cmpl) (phba, piocb, piocb);
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 }
 
 /**
@@ -6506,10 +6482,9 @@ static void lpfc_fabric_abort_vport(stru
 void lpfc_fabric_abort_nport(struct lpfc_nodelist *ndlp)
 {
 	LIST_HEAD(completions);
-	struct lpfc_hba  *phba = ndlp->vport->phba;
+	struct lpfc_hba  *phba = ndlp->phba;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
-	IOCB_t *cmd;
 
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(piocb, tmp_iocb, &phba->fabric_iocb_list,
@@ -6521,15 +6496,9 @@ void lpfc_fabric_abort_nport(struct lpfc
 	}
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		list_del_init(&piocb->list);
-
-		cmd = &piocb->iocb;
-		cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-		cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-		(piocb->iocb_cmpl) (phba, piocb, piocb);
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 }
 
 /**
@@ -6546,20 +6515,12 @@ void lpfc_fabric_abort_nport(struct lpfc
 void lpfc_fabric_abort_hba(struct lpfc_hba *phba)
 {
 	LIST_HEAD(completions);
-	struct lpfc_iocbq *piocb;
-	IOCB_t *cmd;
 
 	spin_lock_irq(&phba->hbalock);
 	list_splice_init(&phba->fabric_iocb_list, &completions);
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		list_del_init(&piocb->list);
-
-		cmd = &piocb->iocb;
-		cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-		cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-		(piocb->iocb_cmpl) (phba, piocb, piocb);
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 }
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2009-04-06 18:31:09.000000000 -0400
@@ -443,6 +443,7 @@ struct lpfc_hba {
 	uint32_t hba_flag;	/* hba generic flags */
 #define HBA_ERATT_HANDLED	0x1 /* This flag is set when eratt handled */
 
+#define DEFER_ERATT		0x4 /* Deferred error attention in progress */
 	struct lpfc_dmabuf slim2p;
 
 	MAILBOX_t *mbox;
@@ -723,4 +724,3 @@ lpfc_sli_read_hs(struct lpfc_hba *phba)
 
 	return;
 }
-
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-04-06 18:29:31.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-04-06 18:31:09.000000000 -0400
@@ -78,7 +78,7 @@ lpfc_terminate_rport_io(struct fc_rport 
 		return;
 	}
 
-	phba  = ndlp->vport->phba;
+	phba  = ndlp->phba;
 
 	lpfc_debugfs_disc_trc(ndlp->vport, LPFC_DISC_TRC_RPORT,
 		"rport terminate: sid:x%x did:x%x flg:x%x",
@@ -1862,9 +1862,14 @@ lpfc_disable_node(struct lpfc_vport *vpo
  * @vport: Pointer to Virtual Port object.
  * @ndlp: Pointer to FC node object.
  * @did: FC_ID of the node.
- *	This function is always called when node object need to
- * be initialized. It initializes all the fields of the node
- * object.
+ *
+ * This function is always called when node object need to be initialized.
+ * It initializes all the fields of the node object. Although the reference
+ * to phba from @ndlp can be obtained indirectly through it's reference to
+ * @vport, a direct reference to phba is taken here by @ndlp. This is due
+ * to the life-span of the @ndlp might go beyond the existence of @vport as
+ * the final release of ndlp is determined by its reference count. And, the
+ * operation on @ndlp needs the reference to phba.
  **/
 static inline void
 lpfc_initialize_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
@@ -1877,6 +1882,7 @@ lpfc_initialize_node(struct lpfc_vport *
 	ndlp->nlp_delayfunc.data = (unsigned long)ndlp;
 	ndlp->nlp_DID = did;
 	ndlp->vport = vport;
+	ndlp->phba = vport->phba;
 	ndlp->nlp_sid = NLP_NO_SID;
 	kref_init(&ndlp->kref);
 	NLP_INT_NODE_ACT(ndlp);
@@ -2086,7 +2092,6 @@ lpfc_no_rpi(struct lpfc_hba *phba, struc
 	struct lpfc_sli *psli;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *iocb, *next_iocb;
-	IOCB_t *icmd;
 	uint32_t rpi, i;
 
 	lpfc_fabric_abort_nport(ndlp);
@@ -2122,19 +2127,9 @@ lpfc_no_rpi(struct lpfc_hba *phba, struc
 		}
 	}
 
-	while (!list_empty(&completions)) {
-		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		list_del_init(&iocb->list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			icmd = &iocb->iocb;
-			icmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			icmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(iocb->iocb_cmpl)(phba, iocb, iocb);
-		}
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 
 	return 0;
 }
@@ -2186,9 +2181,13 @@ lpfc_unreg_all_rpis(struct lpfc_vport *v
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		mbox->context1 = NULL;
 		rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
-		if (rc == MBX_NOT_FINISHED) {
+		if (rc != MBX_TIMEOUT)
 			mempool_free(mbox, phba->mbox_mem_pool);
-		}
+
+		if ((rc == MBX_TIMEOUT) || (rc == MBX_NOT_FINISHED))
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
+				"1836 Could not issue "
+				"unreg_login(all_rpis) status %d\n", rc);
 	}
 }
 
@@ -2206,12 +2205,14 @@ lpfc_unreg_default_rpis(struct lpfc_vpor
 		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		mbox->context1 = NULL;
 		rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
-		if (rc == MBX_NOT_FINISHED) {
+		if (rc != MBX_TIMEOUT)
+			mempool_free(mbox, phba->mbox_mem_pool);
+
+		if ((rc == MBX_TIMEOUT) || (rc == MBX_NOT_FINISHED))
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
 					 "1815 Could not issue "
-					 "unreg_did (default rpis)\n");
-			mempool_free(mbox, phba->mbox_mem_pool);
-		}
+					 "unreg_did (default rpis) status %d\n",
+					 rc);
 	}
 }
 
@@ -2470,14 +2471,13 @@ lpfc_setup_disc_node(struct lpfc_vport *
 			if (ndlp->nlp_flag & NLP_RCV_PLOGI)
 				return NULL;
 
-			spin_lock_irq(shost->host_lock);
-			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-			spin_unlock_irq(shost->host_lock);
-
 			/* Since this node is marked for discovery,
 			 * delay timeout is not needed.
 			 */
 			lpfc_cancel_retry_delay_tmo(vport, ndlp);
+			spin_lock_irq(shost->host_lock);
+			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
+			spin_unlock_irq(shost->host_lock);
 		} else
 			ndlp = NULL;
 	} else {
@@ -2740,19 +2740,9 @@ lpfc_free_tx(struct lpfc_hba *phba, stru
 	}
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		list_del_init(&iocb->list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			icmd = &iocb->iocb;
-			icmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			icmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 }
 
 static void
@@ -3173,7 +3163,7 @@ lpfc_nlp_release(struct kref *kref)
 	lpfc_nlp_remove(ndlp->vport, ndlp);
 
 	/* clear the ndlp active flag for all release cases */
-	phba = ndlp->vport->phba;
+	phba = ndlp->phba;
 	spin_lock_irqsave(&phba->ndlp_lock, flags);
 	NLP_CLR_NODE_ACT(ndlp);
 	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
@@ -3181,7 +3171,7 @@ lpfc_nlp_release(struct kref *kref)
 	/* free ndlp memory for final ndlp release */
 	if (NLP_CHK_FREE_REQ(ndlp)) {
 		kfree(ndlp->lat_data);
-		mempool_free(ndlp, ndlp->vport->phba->nlp_mem_pool);
+		mempool_free(ndlp, ndlp->phba->nlp_mem_pool);
 	}
 }
 
@@ -3204,7 +3194,7 @@ lpfc_nlp_get(struct lpfc_nodelist *ndlp)
 		 * ndlp reference count that is in the process of being
 		 * released.
 		 */
-		phba = ndlp->vport->phba;
+		phba = ndlp->phba;
 		spin_lock_irqsave(&phba->ndlp_lock, flags);
 		if (!NLP_CHK_NODE_ACT(ndlp) || NLP_CHK_FREE_ACK(ndlp)) {
 			spin_unlock_irqrestore(&phba->ndlp_lock, flags);
@@ -3240,7 +3230,7 @@ lpfc_nlp_put(struct lpfc_nodelist *ndlp)
 	"node put:        did:x%x flg:x%x refcnt:x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag,
 		atomic_read(&ndlp->kref.refcount));
-	phba = ndlp->vport->phba;
+	phba = ndlp->phba;
 	spin_lock_irqsave(&phba->ndlp_lock, flags);
 	/* Check the ndlp memory free acknowledge flag to avoid the
 	 * possible race condition that kref_put got invoked again
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-04-06 18:29:31.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-04-06 18:31:09.000000000 -0400
@@ -302,6 +302,7 @@ int
 lpfc_config_port_post(struct lpfc_hba *phba)
 {
 	struct lpfc_vport *vport = phba->pport;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	LPFC_MBOXQ_t *pmb;
 	MAILBOX_t *mb;
 	struct lpfc_dmabuf *mp;
@@ -359,6 +360,11 @@ lpfc_config_port_post(struct lpfc_hba *p
 	       sizeof (struct lpfc_name));
 	memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
 	       sizeof (struct lpfc_name));
+
+	/* Update the fc_host data structures with new wwn. */
+	fc_host_node_name(shost) = wwn_to_u64(vport->fc_nodename.u.wwn);
+	fc_host_port_name(shost) = wwn_to_u64(vport->fc_portname.u.wwn);
+
 	/* If no serial number in VPD data, use low 6 bytes of WWNN */
 	/* This should be consolidated into parse_vpd ? - mr */
 	if (phba->SerialNumber[0] == 0) {
@@ -598,8 +604,6 @@ lpfc_hba_down_post(struct lpfc_hba *phba
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_dmabuf *mp, *next_mp;
-	struct lpfc_iocbq *iocb;
-	IOCB_t *cmd = NULL;
 	LIST_HEAD(completions);
 	int i;
 
@@ -627,20 +631,9 @@ lpfc_hba_down_post(struct lpfc_hba *phba
 		pring->txcmplq_cnt = 0;
 		spin_unlock_irq(&phba->hbalock);
 
-		while (!list_empty(&completions)) {
-			iocb = list_get_first(&completions, struct lpfc_iocbq,
-				list);
-			cmd = &iocb->iocb;
-			list_del_init(&iocb->list);
-
-			if (!iocb->iocb_cmpl)
-				lpfc_sli_release_iocbq(phba, iocb);
-			else {
-				cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-				cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-				(iocb->iocb_cmpl) (phba, iocb, iocb);
-			}
-		}
+		/* Cancel all the IOCBs from the completions list */
+		lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+				      IOERR_SLI_ABORTED);
 
 		lpfc_sli_abort_iocb_ring(phba, pring);
 		spin_lock_irq(&phba->hbalock);
@@ -856,6 +849,72 @@ lpfc_offline_eratt(struct lpfc_hba *phba
 }
 
 /**
+ * lpfc_handle_deferred_eratt - The HBA hardware deferred error handler
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked to handle the deferred HBA hardware error
+ * conditions. This type of error is indicated by HBA by setting ER1
+ * and another ER bit in the host status register. The driver will
+ * wait until the ER1 bit clears before handling the error condition.
+ **/
+static void
+lpfc_handle_deferred_eratt(struct lpfc_hba *phba)
+{
+	uint32_t old_host_status = phba->work_hs;
+	struct lpfc_sli_ring  *pring;
+	struct lpfc_sli *psli = &phba->sli;
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+		"0479 Deferred Adapter Hardware Error "
+		"Data: x%x x%x x%x\n",
+		phba->work_hs,
+		phba->work_status[0], phba->work_status[1]);
+
+	spin_lock_irq(&phba->hbalock);
+	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+	spin_unlock_irq(&phba->hbalock);
+
+
+	/*
+	 * Firmware stops when it triggred erratt. That could cause the I/Os
+	 * dropped by the firmware. Error iocb (I/O) on txcmplq and let the
+	 * SCSI layer retry it after re-establishing link.
+	 */
+	pring = &psli->ring[psli->fcp_ring];
+	lpfc_sli_abort_iocb_ring(phba, pring);
+
+	/*
+	 * There was a firmware error. Take the hba offline and then
+	 * attempt to restart it.
+	 */
+	lpfc_offline_prep(phba);
+	lpfc_offline(phba);
+
+	/* Wait for the ER1 bit to clear.*/
+	while (phba->work_hs & HS_FFER1) {
+		msleep(100);
+		phba->work_hs = readl(phba->HSregaddr);
+		/* If driver is unloading let the worker thread continue */
+		if (phba->pport->load_flag & FC_UNLOADING) {
+			phba->work_hs = 0;
+			break;
+		}
+	}
+
+	/*
+	 * This is to ptrotect against a race condition in which
+	 * first write to the host attention register clear the
+	 * host status register.
+	 */
+	if ((!phba->work_hs) && (!(phba->pport->load_flag & FC_UNLOADING)))
+		phba->work_hs = old_host_status & ~HS_FFER1;
+
+	phba->hba_flag &= ~DEFER_ERATT;
+	phba->work_status[0] = readl(phba->MBslimaddr + 0xa8);
+	phba->work_status[1] = readl(phba->MBslimaddr + 0xac);
+}
+
+/**
  * lpfc_handle_eratt - The HBA hardware error handler
  * @phba: pointer to lpfc hba data structure.
  *
@@ -894,6 +953,9 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 				  (char *) &board_event,
 				  LPFC_NL_VENDOR_ID);
 
+	if (phba->hba_flag & DEFER_ERATT)
+		lpfc_handle_deferred_eratt(phba);
+
 	if (phba->work_hs & HS_FFER6) {
 		/* Re-establishing Link */
 		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
@@ -1321,7 +1383,8 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		m = (typeof(m)){"LPe11000", max_speed, "PCIe"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR_DCSP:
-		m = (typeof(m)){"LPe11002-SP", max_speed, "PCIe"};
+		m = (typeof(m)){"LP2105", max_speed, "PCIe"};
+		GE = 1;
 		break;
 	case PCI_DEVICE_ID_ZMID:
 		m = (typeof(m)){"LPe1150", max_speed, "PCIe"};
@@ -3032,8 +3095,6 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 
 	lpfc_free_sysfs_attr(vport);
 
-	kthread_stop(phba->worker_thread);
-
 	/* Release all the vports against this physical port */
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
@@ -3051,7 +3112,12 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 	 * clears the rings, discards all mailbox commands, and resets
 	 * the HBA.
 	 */
+
+	/* HBA interrupt will be diabled after this call */
 	lpfc_sli_hba_down(phba);
+	/* Stop kthread signal shall trigger work_done one more time */
+	kthread_stop(phba->worker_thread);
+	/* Final cleanup of txcmplq and reset the HBA */
 	lpfc_sli_brdrestart(phba);
 
 	lpfc_stop_phba_timers(phba);
diff -upNr a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
--- a/drivers/scsi/lpfc/lpfc_logmsg.h	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h	2009-04-06 18:30:50.000000000 -0400
@@ -27,7 +27,7 @@
 #define LOG_FCP                       0x40	/* FCP traffic history */
 #define LOG_NODE                      0x80	/* Node table events */
 #define LOG_TEMP                      0x100	/* Temperature sensor events */
-#define LOG_BG			      0x200	/* BlockBuard events */
+#define LOG_BG			      0x200	/* BlockGuard events */
 #define LOG_MISC                      0x400	/* Miscellaneous events */
 #define LOG_SLI                       0x800	/* SLI events */
 #define LOG_FCP_ERROR                 0x1000	/* log errors, not underruns */
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2009-04-06 18:30:50.000000000 -0400
@@ -192,7 +192,6 @@ lpfc_els_abort(struct lpfc_hba *phba, st
 	struct lpfc_sli  *psli = &phba->sli;
 	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
 	struct lpfc_iocbq *iocb, *next_iocb;
-	IOCB_t *cmd;
 
 	/* Abort outstanding I/O on NPort <nlp_DID> */
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_DISCOVERY,
@@ -223,19 +222,10 @@ lpfc_els_abort(struct lpfc_hba *phba, st
 	}
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		cmd = &iocb->iocb;
-		list_del_init(&iocb->list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
+
 	lpfc_cancel_retry_delay_tmo(phba->pport, ndlp);
 	return 0;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-04-06 18:29:31.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2009-04-06 18:30:58.000000000 -0400
@@ -272,14 +272,14 @@ lpfc_rampdown_queue_depth(struct lpfc_hb
  **/
 static inline void
 lpfc_rampup_queue_depth(struct lpfc_vport  *vport,
-			struct scsi_device *sdev)
+			uint32_t queue_depth)
 {
 	unsigned long flags;
 	struct lpfc_hba *phba = vport->phba;
 	uint32_t evt_posted;
 	atomic_inc(&phba->num_cmd_success);
 
-	if (vport->cfg_lun_queue_depth <= sdev->queue_depth)
+	if (vport->cfg_lun_queue_depth <= queue_depth)
 		return;
 	spin_lock_irqsave(&phba->hbalock, flags);
 	if (((phba->last_ramp_up_time + QUEUE_RAMP_UP_INTERVAL) > jiffies) ||
@@ -737,7 +737,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 	 * Due to difference in data length between DIF/non-DIF paths,
 	 * we need to set word 4 of IOCB here
 	 */
-	iocb_cmd->un.fcpi.fcpi_parm = le32_to_cpu(scsi_bufflen(scsi_cmnd));
+	iocb_cmd->un.fcpi.fcpi_parm = scsi_bufflen(scsi_cmnd);
 	return 0;
 }
 
@@ -1693,10 +1693,12 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
 	int result;
-	struct scsi_device *sdev, *tmp_sdev;
+	struct scsi_device *tmp_sdev;
 	int depth = 0;
 	unsigned long flags;
 	struct lpfc_fast_path_event *fast_path_evt;
+	struct Scsi_Host *shost = cmd->device->host;
+	uint32_t queue_depth, scsi_id;
 
 	lpfc_cmd->result = pIocbOut->iocb.un.ulpWord[4];
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
@@ -1807,11 +1809,10 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 
 	lpfc_update_stats(phba, lpfc_cmd);
 	result = cmd->result;
-	sdev = cmd->device;
 	if (vport->cfg_max_scsicmpl_time &&
 	   time_after(jiffies, lpfc_cmd->start_time +
 		msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
-		spin_lock_irqsave(sdev->host->host_lock, flags);
+		spin_lock_irqsave(shost->host_lock, flags);
 		if (pnode && NLP_CHK_NODE_ACT(pnode)) {
 			if (pnode->cmd_qdepth >
 				atomic_read(&pnode->cmd_pending) &&
@@ -1824,22 +1825,26 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 
 			pnode->last_change_time = jiffies;
 		}
-		spin_unlock_irqrestore(sdev->host->host_lock, flags);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 	} else if (pnode && NLP_CHK_NODE_ACT(pnode)) {
 		if ((pnode->cmd_qdepth < LPFC_MAX_TGT_QDEPTH) &&
 		   time_after(jiffies, pnode->last_change_time +
 			      msecs_to_jiffies(LPFC_TGTQ_INTERVAL))) {
-			spin_lock_irqsave(sdev->host->host_lock, flags);
+			spin_lock_irqsave(shost->host_lock, flags);
 			pnode->cmd_qdepth += pnode->cmd_qdepth *
 				LPFC_TGTQ_RAMPUP_PCENT / 100;
 			if (pnode->cmd_qdepth > LPFC_MAX_TGT_QDEPTH)
 				pnode->cmd_qdepth = LPFC_MAX_TGT_QDEPTH;
 			pnode->last_change_time = jiffies;
-			spin_unlock_irqrestore(sdev->host->host_lock, flags);
+			spin_unlock_irqrestore(shost->host_lock, flags);
 		}
 	}
 
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
+
+	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
+	queue_depth = cmd->device->queue_depth;
+	scsi_id = cmd->device->id;
 	cmd->scsi_done(cmd);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
@@ -1847,28 +1852,28 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		 * If there is a thread waiting for command completion
 		 * wake up the thread.
 		 */
-		spin_lock_irqsave(sdev->host->host_lock, flags);
+		spin_lock_irqsave(shost->host_lock, flags);
 		lpfc_cmd->pCmd = NULL;
 		if (lpfc_cmd->waitq)
 			wake_up(lpfc_cmd->waitq);
-		spin_unlock_irqrestore(sdev->host->host_lock, flags);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return;
 	}
 

 	if (!result)
-		lpfc_rampup_queue_depth(vport, sdev);
+		lpfc_rampup_queue_depth(vport, queue_depth);
 
 	if (!result && pnode && NLP_CHK_NODE_ACT(pnode) &&
 	   ((jiffies - pnode->last_ramp_up_time) >
 		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
 	   ((jiffies - pnode->last_q_full_time) >
 		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
-	   (vport->cfg_lun_queue_depth > sdev->queue_depth)) {
-		shost_for_each_device(tmp_sdev, sdev->host) {
+	   (vport->cfg_lun_queue_depth > queue_depth)) {
+		shost_for_each_device(tmp_sdev, shost) {
 			if (vport->cfg_lun_queue_depth > tmp_sdev->queue_depth){
-				if (tmp_sdev->id != sdev->id)
+				if (tmp_sdev->id != scsi_id)
 					continue;
 				if (tmp_sdev->ordered_tags)
 					scsi_adjust_queue_depth(tmp_sdev,
@@ -1884,7 +1889,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		}
 		lpfc_send_sdev_queuedepth_change_event(phba, vport, pnode,
 			0xFFFFFFFF,
-			sdev->queue_depth - 1, sdev->queue_depth);
+			queue_depth , queue_depth + 1);
 	}
 
 	/*
@@ -1895,8 +1900,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	    NLP_CHK_NODE_ACT(pnode)) {
 		pnode->last_q_full_time = jiffies;
 
-		shost_for_each_device(tmp_sdev, sdev->host) {
-			if (tmp_sdev->id != sdev->id)
+		shost_for_each_device(tmp_sdev, shost) {
+			if (tmp_sdev->id != scsi_id)
 				continue;
 			depth = scsi_track_queue_full(tmp_sdev,
 					tmp_sdev->queue_depth - 1);
@@ -1908,7 +1913,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		 * scsi_track_queue_full.
 		 */
 		if (depth == -1)
-			depth = sdev->host->cmd_per_lun;
+			depth = shost->cmd_per_lun;
 
 		if (depth) {
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
@@ -1924,11 +1929,11 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	 * If there is a thread waiting for command completion
 	 * wake up the thread.
 	 */
-	spin_lock_irqsave(sdev->host->host_lock, flags);
+	spin_lock_irqsave(shost->host_lock, flags);
 	lpfc_cmd->pCmd = NULL;
 	if (lpfc_cmd->waitq)
 		wake_up(lpfc_cmd->waitq);
-	spin_unlock_irqrestore(sdev->host->host_lock, flags);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-04-06 18:29:31.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-04-06 18:31:09.000000000 -0400
@@ -185,6 +185,38 @@ lpfc_sli_release_iocbq(struct lpfc_hba *
 }
 
 /**
+ * lpfc_sli_cancel_iocbs - Cancel all iocbs from a list.
+ * @phba: Pointer to HBA context object.
+ * @iocblist: List of IOCBs.
+ * @ulpstatus: ULP status in IOCB command field.
+ * @ulpWord4: ULP word-4 in IOCB command field.
+ *
+ * This function is called with a list of IOCBs to cancel. It cancels the IOCB
+ * on the list by invoking the complete callback function associated with the
+ * IOCB with the provided @ulpstatus and @ulpword4 set to the IOCB commond
+ * fields.
+ **/
+void
+lpfc_sli_cancel_iocbs(struct lpfc_hba *phba, struct list_head *iocblist,
+		      uint32_t ulpstatus, uint32_t ulpWord4)
+{
+	struct lpfc_iocbq *piocb;
+
+	while (!list_empty(iocblist)) {
+		list_remove_head(iocblist, piocb, struct lpfc_iocbq, list);
+
+		if (!piocb->iocb_cmpl)
+			lpfc_sli_release_iocbq(phba, piocb);
+		else {
+			piocb->iocb.ulpStatus = ulpstatus;
+			piocb->iocb.un.ulpWord[4] = ulpWord4;
+			(piocb->iocb_cmpl) (phba, piocb, piocb);
+		}
+	}
+	return;
+}
+
+/**
  * lpfc_sli_iocb_cmd_type - Get the iocb type
  * @iocb_cmnd: iocb command code.
  *
@@ -818,8 +850,8 @@ static struct lpfc_hbq_init lpfc_els_hbq
 	.profile = 0,
 	.ring_mask = (1 << LPFC_ELS_RING),
 	.buffer_count = 0,
-	.init_count = 20,
-	.add_count = 5,
+	.init_count = 40,
+	.add_count = 40,
 };
 
 /* HBQ for the extra ring if needed */
@@ -1596,7 +1628,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 			 * Ring <ringno> handler: unexpected completion IoTag
 			 * <IoTag>
 			 */
-			lpfc_printf_vlog(cmdiocbp->vport, KERN_WARNING, LOG_SLI,
+			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 					 "0322 Ring %d handler: "
 					 "unexpected completion IoTag x%x "
 					 "Data: x%x x%x x%x x%x\n",
@@ -2324,7 +2356,6 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 {
 	LIST_HEAD(completions);
 	struct lpfc_iocbq *iocb, *next_iocb;
-	IOCB_t *cmd = NULL;
 
 	if (pring->ringno == LPFC_ELS_RING) {
 		lpfc_fabric_abort_hba(phba);
@@ -2343,19 +2374,9 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 
 	spin_unlock_irq(&phba->hbalock);
 
-	while (!list_empty(&completions)) {
-		iocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		cmd = &iocb->iocb;
-		list_del_init(&iocb->list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
 }
 
 /**
@@ -2373,8 +2394,6 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba
 {
 	LIST_HEAD(txq);
 	LIST_HEAD(txcmplq);
-	struct lpfc_iocbq *iocb;
-	IOCB_t *cmd = NULL;
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
 
@@ -2392,34 +2411,12 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba
 	spin_unlock_irq(&phba->hbalock);
 
 	/* Flush the txq */
-	while (!list_empty(&txq)) {
-		iocb = list_get_first(&txq, struct lpfc_iocbq, list);
-		cmd = &iocb->iocb;
-		list_del_init(&iocb->list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_DOWN;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	lpfc_sli_cancel_iocbs(phba, &txq, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_DOWN);
 
 	/* Flush the txcmpq */
-	while (!list_empty(&txcmplq)) {
-		iocb = list_get_first(&txcmplq, struct lpfc_iocbq, list);
-		cmd = &iocb->iocb;
-		list_del_init(&iocb->list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_DOWN;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	lpfc_sli_cancel_iocbs(phba, &txcmplq, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_DOWN);
 }
 
 /**
@@ -3251,6 +3248,21 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
 
+	/* Check the pmbox pointer first.  There is a race condition
+	 * between the mbox timeout handler getting executed in the
+	 * worklist and the mailbox actually completing. When this
+	 * race condition occurs, the mbox_active will be NULL.
+	 */
+	spin_lock_irq(&phba->hbalock);
+	if (pmbox == NULL) {
+		lpfc_printf_log(phba, KERN_WARNING,
+				LOG_MBOX | LOG_SLI,
+				"0353 Active Mailbox cleared - mailbox timeout "
+				"exiting\n");
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
+
 	/* Mbox cmd <mbxCommand> timeout */
 	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 			"0310 Mailbox command x%x timeout Data: x%x x%x x%p\n",
@@ -3258,6 +3270,7 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 			phba->pport->port_state,
 			phba->sli.sli_flag,
 			phba->sli.mbox_active);
+	spin_unlock_irq(&phba->hbalock);
 
 	/* Setting state unknown so lpfc_sli_abort_iocb_ring
 	 * would get IOCB_ERROR from lpfc_sli_issue_iocb, allowing
@@ -3364,6 +3377,12 @@ lpfc_sli_issue_mbox(struct lpfc_hba *phb
 		goto out_not_finished;
 	}
 
+	/* If HBA has a deferred error attention, fail the iocb. */
+	if (unlikely(phba->hba_flag & DEFER_ERATT)) {
+		spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
+		goto out_not_finished;
+	}
+
 	psli = &phba->sli;
 
 	mb = &pmbox->mb;
@@ -3728,6 +3747,10 @@ __lpfc_sli_issue_iocb(struct lpfc_hba *p
 	if (unlikely(pci_channel_offline(phba->pcidev)))
 		return IOCB_ERROR;
 
+	/* If HBA has a deferred error attention, fail the iocb. */
+	if (unlikely(phba->hba_flag & DEFER_ERATT))
+		return IOCB_ERROR;
+
 	/*
 	 * We should never get an IOCB if we are in a < LINK_DOWN state
 	 */
@@ -3906,6 +3929,7 @@ lpfc_sli_async_event_handler(struct lpfc
 	uint16_t temp;
 	struct temp_event temp_event_data;
 	struct Scsi_Host *shost;
+	uint32_t *iocb_w;
 
 	icmd = &iocbq->iocb;
 	evt_code = icmd->un.asyncstat.evt_code;
@@ -3913,13 +3937,23 @@ lpfc_sli_async_event_handler(struct lpfc
 
 	if ((evt_code != ASYNC_TEMP_WARN) &&
 		(evt_code != ASYNC_TEMP_SAFE)) {
+		iocb_w = (uint32_t *) icmd;
 		lpfc_printf_log(phba,
 			KERN_ERR,
 			LOG_SLI,
 			"0346 Ring %d handler: unexpected ASYNC_STATUS"
-			" evt_code 0x%x\n",
+			" evt_code 0x%x \n"
+			"W0  0x%08x W1  0x%08x W2  0x%08x W3  0x%08x\n"
+			"W4  0x%08x W5  0x%08x W6  0x%08x W7  0x%08x\n"
+			"W8  0x%08x W9  0x%08x W10 0x%08x W11 0x%08x\n"
+			"W12 0x%08x W13 0x%08x W14 0x%08x W15 0x%08x\n",
 			pring->ringno,
-			icmd->un.asyncstat.evt_code);
+			icmd->un.asyncstat.evt_code,
+			iocb_w[0], iocb_w[1], iocb_w[2], iocb_w[3],
+			iocb_w[4], iocb_w[5], iocb_w[6], iocb_w[7],
+			iocb_w[8], iocb_w[9], iocb_w[10], iocb_w[11],
+			iocb_w[12], iocb_w[13], iocb_w[14], iocb_w[15]);
+
 		return;
 	}
 	temp_event_data.data = (uint32_t)temp;
@@ -4178,17 +4212,9 @@ lpfc_sli_host_down(struct lpfc_vport *vp
 
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
-	while (!list_empty(&completions)) {
-		list_remove_head(&completions, iocb, struct lpfc_iocbq, list);
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			iocb->iocb.ulpStatus = IOSTAT_LOCAL_REJECT;
-			iocb->iocb.un.ulpWord[4] = IOERR_SLI_DOWN;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_DOWN);
 	return 1;
 }
 
@@ -4215,8 +4241,6 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 	struct lpfc_sli_ring *pring;
 	struct lpfc_dmabuf *buf_ptr;
 	LPFC_MBOXQ_t *pmb;
-	struct lpfc_iocbq *iocb;
-	IOCB_t *cmd = NULL;
 	int i;
 	unsigned long flags = 0;
 
@@ -4244,18 +4268,9 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 	}
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
-	while (!list_empty(&completions)) {
-		list_remove_head(&completions, iocb, struct lpfc_iocbq, list);
-		cmd = &iocb->iocb;
-
-		if (!iocb->iocb_cmpl)
-			lpfc_sli_release_iocbq(phba, iocb);
-		else {
-			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-			cmd->un.ulpWord[4] = IOERR_SLI_DOWN;
-			(iocb->iocb_cmpl) (phba, iocb, iocb);
-		}
-	}
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_DOWN);
 
 	spin_lock_irqsave(&phba->hbalock, flags);
 	list_splice_init(&phba->elsbuf, &completions);
@@ -5137,11 +5152,31 @@ lpfc_sli_check_eratt(struct lpfc_hba *ph
 		return 0;
 	}
 
+	/*
+	 * If there is deferred error attention, do not check for error
+	 * attention
+	 */
+	if (unlikely(phba->hba_flag & DEFER_ERATT)) {
+		spin_unlock_irq(&phba->hbalock);
+		return 0;
+	}
+
 	/* Read chip Host Attention (HA) register */
 	ha_copy = readl(phba->HAregaddr);
 	if (ha_copy & HA_ERATT) {
 		/* Read host status register to retrieve error event */
 		lpfc_sli_read_hs(phba);
+
+		/* Check if there is a deferred error condition is active */
+		if ((HS_FFER1 & phba->work_hs) &&
+			((HS_FFER2 | HS_FFER3 | HS_FFER4 | HS_FFER5 |
+			HS_FFER6 | HS_FFER7) & phba->work_hs)) {
+			phba->hba_flag |= DEFER_ERATT;
+			/* Clear all interrupt enable conditions */
+			writel(0, phba->HCregaddr);
+			readl(phba->HCregaddr);
+		}
+
 		/* Set the driver HA work bitmap */
 		phba->work_ha |= HA_ERATT;
 		/* Indicate polling handles this ERATT */
@@ -5230,6 +5265,16 @@ lpfc_sp_intr_handler(int irq, void *dev_
 				/* Indicate interrupt handler handles ERATT */
 				phba->hba_flag |= HBA_ERATT_HANDLED;
 		}
+
+		/*
+		 * If there is deferred error attention, do not check for any
+		 * interrupt.
+		 */
+		if (unlikely(phba->hba_flag & DEFER_ERATT)) {
+			spin_unlock_irq(&phba->hbalock);
+			return IRQ_NONE;
+		}
+
 		/* Clear up only attention source related to slow-path */
 		writel((ha_copy & (HA_MBATT | HA_R2_CLR_MSK)),
 			phba->HAregaddr);
@@ -5301,8 +5346,22 @@ lpfc_sp_intr_handler(int irq, void *dev_
 			}
 		}
 		spin_lock_irqsave(&phba->hbalock, iflag);
-		if (work_ha_copy & HA_ERATT)
+		if (work_ha_copy & HA_ERATT) {
 			lpfc_sli_read_hs(phba);
+			/*
+			 * Check if there is a deferred error condition
+			 * is active
+			 */
+			if ((HS_FFER1 & phba->work_hs) &&
+				((HS_FFER2 | HS_FFER3 | HS_FFER4 | HS_FFER5 |
+				HS_FFER6 | HS_FFER7) & phba->work_hs)) {
+				phba->hba_flag |= DEFER_ERATT;
+				/* Clear all interrupt enable conditions */
+				writel(0, phba->HCregaddr);
+				readl(phba->HCregaddr);
+			}
+		}
+
 		if ((work_ha_copy & HA_MBATT) && (phba->sli.mbox_active)) {
 			pmb = phba->sli.mbox_active;
 			pmbox = &pmb->mb;
@@ -5466,6 +5525,14 @@ lpfc_fp_intr_handler(int irq, void *dev_
 		ha_copy = readl(phba->HAregaddr);
 		/* Clear up only attention source related to fast-path */
 		spin_lock_irqsave(&phba->hbalock, iflag);
+		/*
+		 * If there is deferred error attention, do not check for
+		 * any interrupt.
+		 */
+		if (unlikely(phba->hba_flag & DEFER_ERATT)) {
+			spin_unlock_irq(&phba->hbalock);
+			return IRQ_NONE;
+		}
 		writel((ha_copy & (HA_R0_CLR_MSK | HA_R1_CLR_MSK)),
 			phba->HAregaddr);
 		readl(phba->HAregaddr); /* flush */
@@ -5558,6 +5625,14 @@ lpfc_intr_handler(int irq, void *dev_id)
 			phba->hba_flag |= HBA_ERATT_HANDLED;
 	}
 
+	/*
+	 * If there is deferred error attention, do not check for any interrupt.
+	 */
+	if (unlikely(phba->hba_flag & DEFER_ERATT)) {
+		spin_unlock_irq(&phba->hbalock);
+		return IRQ_NONE;
+	}
+
 	/* Clear attention sources except link and error attentions */
 	writel((phba->ha_copy & ~(HA_LATT | HA_ERATT)), phba->HAregaddr);
 	readl(phba->HAregaddr); /* flush */


