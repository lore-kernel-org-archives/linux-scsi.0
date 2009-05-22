From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 15/17] lpfc 8.3.2 : Miscellaneous Changes
Date: Fri, 22 May 2009 14:53:12 -0400
Message-ID: <1243018392.7729.67.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42268 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbZEVSxO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:53:14 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIrG6P029991
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:53:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Miscellaneous Changes:
- Convert from SLI2_ACTIVE flag to more correct SLI_ACTIVE (generic) flag
- Reposition log verbose messaging definitions
- Update naming for vpi object name from vport slang name
- Handle deferred error attention condition
- Add 10G link support
- Small bug fixup


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c    |   55 ++++++++++++++++++++++++++++++-------------------------
 lpfc_ct.c      |    7 +++++--
 lpfc_disc.h    |    1 +
 lpfc_hbadisc.c |    3 +++
 lpfc_init.c    |   20 ++++++++++++++++----
 lpfc_logmsg.h  |   52 +++++++++++++++++++++++++++++-----------------------
 lpfc_sli.c     |    8 +++++---
 lpfc_sli.h     |    2 +-
 lpfc_vport.c   |    2 +-
 9 files changed, 91 insertions(+), 59 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2009-05-22 14:11:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2009-05-22 14:11:44.000000000 -0400
@@ -805,7 +805,7 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 	 */
 	if (phba->link_state < LPFC_LINK_DOWN ||
 	    !phba->mbox_mem_pool ||
-	    (phba->sli.sli_flag & LPFC_SLI2_ACTIVE) == 0)
+	    (phba->sli.sli_flag & LPFC_SLI_ACTIVE) == 0)
 		return 0;
 
 	if (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO)
@@ -822,7 +822,7 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 	pmboxq->context1 = NULL;
 
 	if ((phba->pport->fc_flag & FC_OFFLINE_MODE) ||
-		(!(psli->sli_flag & LPFC_SLI2_ACTIVE)))
+		(!(psli->sli_flag & LPFC_SLI_ACTIVE)))
 		rc = MBX_NOT_FINISHED;
 	else
 		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
@@ -2045,22 +2045,9 @@ static DEVICE_ATTR(lpfc_devloss_tmo, S_I
 # lpfc_log_verbose: Only turn this flag on if you are willing to risk being
 # deluged with LOTS of information.
 # You can set a bit mask to record specific types of verbose messages:
-#
-# LOG_ELS                       0x1        ELS events
-# LOG_DISCOVERY                 0x2        Link discovery events
-# LOG_MBOX                      0x4        Mailbox events
-# LOG_INIT                      0x8        Initialization events
-# LOG_LINK_EVENT                0x10       Link events
-# LOG_FCP                       0x40       FCP traffic history
-# LOG_NODE                      0x80       Node table events
-# LOG_BG                        0x200      BlockBuard events
-# LOG_MISC                      0x400      Miscellaneous events
-# LOG_SLI                       0x800      SLI events
-# LOG_FCP_ERROR                 0x1000     Only log FCP errors
-# LOG_LIBDFC                    0x2000     LIBDFC events
-# LOG_ALL_MSG                   0xffff     LOG all messages
+# See lpfc_logmsh.h for definitions.
 */
-LPFC_VPORT_ATTR_HEX_RW(log_verbose, 0x0, 0x0, 0xffff,
+LPFC_VPORT_ATTR_HEX_RW(log_verbose, 0x0, 0x0, 0xffffffff,
 		       "Verbose logging bit-mask");
 
 /*
@@ -2365,7 +2352,7 @@ lpfc_stat_data_ctrl_store(struct device 
 		if (vports == NULL)
 			return -ENOMEM;
 
-		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			v_shost = lpfc_shost_from_vport(vports[i]);
 			spin_lock_irq(v_shost->host_lock);
 			/* Block and reset data collection */
@@ -2380,7 +2367,7 @@ lpfc_stat_data_ctrl_store(struct device 
 		phba->bucket_base = base;
 		phba->bucket_step = step;
 
-		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			v_shost = lpfc_shost_from_vport(vports[i]);
 
 			/* Unblock data collection */
@@ -2397,7 +2384,7 @@ lpfc_stat_data_ctrl_store(struct device 
 		if (vports == NULL)
 			return -ENOMEM;
 
-		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			v_shost = lpfc_shost_from_vport(vports[i]);
 			spin_lock_irq(shost->host_lock);
 			vports[i]->stat_data_blocked = 1;
@@ -3418,7 +3405,7 @@ sysfs_mbox_read(struct kobject *kobj, st
 		}
 
 		if ((vport->fc_flag & FC_OFFLINE_MODE) ||
-		    (!(phba->sli.sli_flag & LPFC_SLI2_ACTIVE))){
+		    (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))) {
 
 			spin_unlock_irq(&phba->hbalock);
 			rc = lpfc_sli_issue_mbox (phba,
@@ -3646,6 +3633,9 @@ lpfc_get_host_speed(struct Scsi_Host *sh
 			case LA_8GHZ_LINK:
 				fc_host_speed(shost) = FC_PORTSPEED_8GBIT;
 			break;
+			case LA_10GHZ_LINK:
+				fc_host_speed(shost) = FC_PORTSPEED_10GBIT;
+			break;
 			default:
 				fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 			break;
@@ -3713,7 +3703,7 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	 */
 	if (phba->link_state < LPFC_LINK_DOWN ||
 	    !phba->mbox_mem_pool ||
-	    (phba->sli.sli_flag & LPFC_SLI2_ACTIVE) == 0)
+	    (phba->sli.sli_flag & LPFC_SLI_ACTIVE) == 0)
 		return NULL;
 
 	if (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO)
@@ -3756,7 +3746,7 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	pmboxq->vport = vport;
 
 	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
-	    (!(psli->sli_flag & LPFC_SLI2_ACTIVE)))
+	    (!(psli->sli_flag & LPFC_SLI_ACTIVE)))
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
 	else
 		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
@@ -3838,7 +3828,7 @@ lpfc_reset_stats(struct Scsi_Host *shost
 	pmboxq->vport = vport;
 
 	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
-		(!(psli->sli_flag & LPFC_SLI2_ACTIVE)))
+		(!(psli->sli_flag & LPFC_SLI_ACTIVE)))
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
 	else
 		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
@@ -3856,7 +3846,7 @@ lpfc_reset_stats(struct Scsi_Host *shost
 	pmboxq->vport = vport;
 
 	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
-	    (!(psli->sli_flag & LPFC_SLI2_ACTIVE)))
+	    (!(psli->sli_flag & LPFC_SLI_ACTIVE)))
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
 	else
 		rc = lpfc_sli_issue_mbox_wait(phba, pmboxq, phba->fc_ratov * 2);
@@ -4023,6 +4013,21 @@ lpfc_set_vport_symbolic_name(struct fc_v
 		lpfc_ns_cmd(vport, SLI_CTNS_RSPN_ID, 0, 0);
 }
 
+/**
+ * lpfc_hba_log_verbose_init - Set hba's log verbose level
+ * @phba: Pointer to lpfc_hba struct.
+ *
+ * This function is called by the lpfc_get_cfgparam() routine to set the
+ * module lpfc_log_verbose into the @phba cfg_log_verbose for use with
+ * log messsage according to the module's lpfc_log_verbose parameter setting
+ * before hba port or vport created.
+ **/
+static void
+lpfc_hba_log_verbose_init(struct lpfc_hba *phba, uint32_t verbose)
+{
+	phba->cfg_log_verbose = verbose;
+}
+
 struct fc_function_template lpfc_transport_functions = {
 	/* fixed attributes the driver supports */
 	.show_host_node_name = 1,
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2009-05-22 14:11:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2009-05-22 14:11:44.000000000 -0400
@@ -1578,6 +1578,9 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, 
 				case LA_8GHZ_LINK:
 					ae->un.PortSpeed = HBA_PORTSPEED_8GBIT;
 				break;
+				case LA_10GHZ_LINK:
+					ae->un.PortSpeed = HBA_PORTSPEED_10GBIT;
+				break;
 				default:
 					ae->un.PortSpeed =
 						HBA_PORTSPEED_UNKNOWN;
@@ -1730,7 +1733,7 @@ lpfc_decode_firmware_rev(struct lpfc_hba
 	uint8_t *fwname;
 
 	if (vp->rev.rBit) {
-		if (psli->sli_flag & LPFC_SLI2_ACTIVE)
+		if (psli->sli_flag & LPFC_SLI_ACTIVE)
 			rev = vp->rev.sli2FwRev;
 		else
 			rev = vp->rev.sli1FwRev;
@@ -1756,7 +1759,7 @@ lpfc_decode_firmware_rev(struct lpfc_hba
 		}
 		b4 = (rev & 0x0000000f);
 
-		if (psli->sli_flag & LPFC_SLI2_ACTIVE)
+		if (psli->sli_flag & LPFC_SLI_ACTIVE)
 			fwname = vp->rev.sli2FwName;
 		else
 			fwname = vp->rev.sli1FwName;
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2009-05-19 09:39:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2009-05-22 14:11:44.000000000 -0400
@@ -135,6 +135,7 @@ struct lpfc_nodelist {
 #define NLP_NODEV_REMOVE   0x08000000	/* Defer removal till discovery ends */
 #define NLP_TARGET_REMOVE  0x10000000   /* Target remove in process */
 #define NLP_SC_REQ         0x20000000	/* Target requires authentication */
+#define NLP_RPI_VALID      0x80000000	/* nlp_rpi is valid */
 
 /* ndlp usage management macros */
 #define NLP_CHK_NODE_ACT(ndlp)		(((ndlp)->nlp_usg_map \
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-05-22 14:11:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-05-22 14:11:44.000000000 -0400
@@ -1647,6 +1647,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 	case LA_8GHZ_LINK:
 		phba->fc_linkspeed = LA_8GHZ_LINK;
 		break;
+	case LA_10GHZ_LINK:
+		phba->fc_linkspeed = LA_10GHZ_LINK;
+		break;
 	default:
 		phba->fc_linkspeed = LA_UNKNW_LINK;
 		break;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 14:11:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-05-22 14:11:44.000000000 -0400
@@ -906,7 +906,7 @@ lpfc_hb_timeout_handler(struct lpfc_hba 
 					"taking this port offline.\n");
 
 			spin_lock_irq(&phba->hbalock);
-			psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+			psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 			spin_unlock_irq(&phba->hbalock);
 
 			lpfc_offline_prep(phba);
@@ -931,13 +931,15 @@ lpfc_offline_eratt(struct lpfc_hba *phba
 	struct lpfc_sli   *psli = &phba->sli;
 
 	spin_lock_irq(&phba->hbalock);
-	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 	lpfc_offline_prep(phba);
 
 	lpfc_offline(phba);
 	lpfc_reset_barrier(phba);
+	spin_lock_irq(&phba->hbalock);
 	lpfc_sli_brdreset(phba);
+	spin_unlock_irq(&phba->hbalock);
 	lpfc_hba_down_post(phba);
 	lpfc_sli_brdready(phba, HS_MBRDY);
 	lpfc_unblock_mgmt_io(phba);
@@ -980,6 +982,16 @@ lpfc_handle_deferred_eratt(struct lpfc_h
 	struct lpfc_sli_ring  *pring;
 	struct lpfc_sli *psli = &phba->sli;
 
+	/* If the pci channel is offline, ignore possible errors,
+	 * since we cannot communicate with the pci card anyway.
+	 */
+	if (pci_channel_offline(phba->pcidev)) {
+		spin_lock_irq(&phba->hbalock);
+		phba->hba_flag &= ~DEFER_ERATT;
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
+
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 		"0479 Deferred Adapter Hardware Error "
 		"Data: x%x x%x x%x\n",
@@ -987,7 +999,7 @@ lpfc_handle_deferred_eratt(struct lpfc_h
 		phba->work_status[0], phba->work_status[1]);
 
 	spin_lock_irq(&phba->hbalock);
-	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 

@@ -1097,7 +1109,7 @@ lpfc_handle_eratt_s3(struct lpfc_hba *ph
 				phba->work_status[0], phba->work_status[1]);
 
 		spin_lock_irq(&phba->hbalock);
-		psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+		psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 		spin_unlock_irq(&phba->hbalock);
 
 		/*
diff -upNr a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
--- a/drivers/scsi/lpfc/lpfc_logmsg.h	2009-05-22 14:11:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h	2009-05-22 14:11:44.000000000 -0400
@@ -18,33 +18,39 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LOG_ELS                       0x1	/* ELS events */
-#define LOG_DISCOVERY                 0x2	/* Link discovery events */
-#define LOG_MBOX                      0x4	/* Mailbox events */
-#define LOG_INIT                      0x8	/* Initialization events */
-#define LOG_LINK_EVENT                0x10	/* Link events */
-#define LOG_IP                        0x20	/* IP traffic history */
-#define LOG_FCP                       0x40	/* FCP traffic history */
-#define LOG_NODE                      0x80	/* Node table events */
-#define LOG_TEMP                      0x100	/* Temperature sensor events */
-#define LOG_BG			      0x200	/* BlockGuard events */
-#define LOG_MISC                      0x400	/* Miscellaneous events */
-#define LOG_SLI                       0x800	/* SLI events */
-#define LOG_FCP_ERROR                 0x1000	/* log errors, not underruns */
-#define LOG_LIBDFC                    0x2000	/* Libdfc events */
-#define LOG_VPORT                     0x4000	/* NPIV events */
-#define LOG_ALL_MSG                   0xffff	/* LOG all messages */
+#define LOG_ELS		0x00000001	/* ELS events */
+#define LOG_DISCOVERY	0x00000002	/* Link discovery events */
+#define LOG_MBOX	0x00000004	/* Mailbox events */
+#define LOG_INIT	0x00000008	/* Initialization events */
+#define LOG_LINK_EVENT	0x00000010	/* Link events */
+#define LOG_IP		0x00000020	/* IP traffic history */
+#define LOG_FCP		0x00000040	/* FCP traffic history */
+#define LOG_NODE	0x00000080	/* Node table events */
+#define LOG_TEMP	0x00000100	/* Temperature sensor events */
+#define LOG_BG		0x00000200	/* BlockGuard events */
+#define LOG_MISC	0x00000400	/* Miscellaneous events */
+#define LOG_SLI		0x00000800	/* SLI events */
+#define LOG_FCP_ERROR	0x00001000	/* log errors, not underruns */
+#define LOG_LIBDFC	0x00002000	/* Libdfc events */
+#define LOG_VPORT	0x00004000	/* NPIV events */
+#define LOF_SECURITY	0x00008000	/* Security events */
+#define LOG_EVENT	0x00010000	/* CT,TEMP,DUMP, logging */
+#define LOG_ALL_MSG	0xffffffff	/* LOG all messages */
 
 #define lpfc_printf_vlog(vport, level, mask, fmt, arg...) \
-	do { \
-	{ if (((mask) &(vport)->cfg_log_verbose) || (level[1] <= '3')) \
+do { \
+	{ if (((mask) & (vport)->cfg_log_verbose) || (level[1] <= '3')) \
 		dev_printk(level, &((vport)->phba->pcidev)->dev, "%d:(%d):" \
 			   fmt, (vport)->phba->brd_no, vport->vpi, ##arg); } \
-	} while (0)
+} while (0)
 
 #define lpfc_printf_log(phba, level, mask, fmt, arg...) \
-	do { \
-	{ if (((mask) &(phba)->pport->cfg_log_verbose) || (level[1] <= '3')) \
+do { \
+	{ uint32_t log_verbose = (phba)->pport ? \
+				 (phba)->pport->cfg_log_verbose : \
+				 (phba)->cfg_log_verbose; \
+	  if (((mask) & log_verbose) || (level[1] <= '3')) \
 		dev_printk(level, &((phba)->pcidev)->dev, "%d:" \
-			   fmt, phba->brd_no, ##arg); } \
-	} while (0)
+			   fmt, phba->brd_no, ##arg); \
+	} \
+} while (0)
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 14:11:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-05-22 14:11:44.000000000 -0400
@@ -3272,7 +3272,7 @@ void lpfc_reset_barrier(struct lpfc_hba 
 		mdelay(1);
 
 	if (readl(resp_buf + 1) != ~(BARRIER_TEST_PATTERN)) {
-		if (phba->sli.sli_flag & LPFC_SLI2_ACTIVE ||
+		if (phba->sli.sli_flag & LPFC_SLI_ACTIVE ||
 		    phba->pport->stopped)
 			goto restore_hc;
 		else
@@ -3353,7 +3353,9 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 		return 1;
 	}
 
-	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+	spin_lock_irq(&phba->hbalock);
+	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
+	spin_unlock_irq(&phba->hbalock);
 
 	mempool_free(pmb, phba->mbox_mem_pool);
 
@@ -4643,7 +4645,7 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 	spin_unlock_irq(&phba->pport->work_port_lock);
 	spin_lock_irq(&phba->hbalock);
 	phba->link_state = LPFC_LINK_UNKNOWN;
-	psli->sli_flag &= ~LPFC_SLI2_ACTIVE;
+	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 
 	pring = &psli->ring[psli->fcp_ring];
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2009-05-22 14:11:09.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2009-05-22 14:11:44.000000000 -0400
@@ -244,7 +244,7 @@ struct lpfc_sli {
 
 	/* Additional sli_flags */
 #define LPFC_SLI_MBOX_ACTIVE      0x100	/* HBA mailbox is currently active */
-#define LPFC_SLI2_ACTIVE          0x200	/* SLI2 overlay in firmware is active */
+#define LPFC_SLI_ACTIVE           0x200	/* SLI in firmware is active */
 #define LPFC_PROCESS_LA           0x400	/* Able to process link attention */
 #define LPFC_BLOCK_MGMT_IO        0x800	/* Don't allow mgmt mbx or iocb cmds */
 #define LPFC_MENLO_MAINT          0x1000 /* need for menl fw download */
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2009-05-22 14:11:09.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2009-05-22 14:11:44.000000000 -0400
@@ -121,7 +121,7 @@ lpfc_vport_sparm(struct lpfc_hba *phba, 
 	if (!pmb) {
 		return -ENOMEM;
 	}
-	mb = &pmb->mb;
+	mb = &pmb->u.mb;
 
 	lpfc_read_sparam(phba, pmb, vport->vpi);
 	/*


