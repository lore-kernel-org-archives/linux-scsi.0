From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/5] lpfc 8.1.10 : Add support for dev_loss_tmo_callbk and
	fast_io_fail_tmo_callbk
Date: Fri, 18 Aug 2006 17:47:08 -0400
Message-ID: <1155937628.12933.30.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41414 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751497AbWHRVrE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 17:47:04 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k7ILl3n6024293
	for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2006 14:47:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add support for new dev_loss_tmo callback 
  Goodness is that it removes code for a parallel nodev timer that
  existed in the driver
Add support for the new fast_io_fail callback


Signed-off-by: James Smart <James.Smart@emulex.com>


--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -285,6 +285,7 @@ #define FC_BYPASSED_MODE        0x20000	
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_lun_queue_depth;
 	uint32_t cfg_nodev_tmo;
+	uint32_t cfg_devloss_tmo;
 	uint32_t cfg_hba_queue_depth;
 	uint32_t cfg_fcp_class;
 	uint32_t cfg_use_adisc;
@@ -303,6 +304,8 @@ #define FC_BYPASSED_MODE        0x20000	
 	uint32_t cfg_sg_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
 
+	uint32_t dev_loss_tmo_changed;
+
 	lpfc_vpd_t vpd;		/* vital product data */
 
 	struct Scsi_Host *host;
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -39,6 +39,9 @@ #include "lpfc_version.h"
 #include "lpfc_compat.h"
 #include "lpfc_crtn.h"
 
+#define LPFC_DEF_DEVLOSS_TMO 30
+#define LPFC_MIN_DEVLOSS_TMO 1
+#define LPFC_MAX_DEVLOSS_TMO 255
 
 static void
 lpfc_jedec_to_ascii(int incr, char hdw[])
@@ -559,6 +562,123 @@ static CLASS_DEVICE_ATTR(lpfc_poll, S_IR
 			 lpfc_poll_show, lpfc_poll_store);
 
 /*
+# lpfc_nodev_tmo: If set, it will hold all I/O errors on devices that disappear
+# until the timer expires. Value range is [0,255]. Default value is 30.
+*/
+static int lpfc_nodev_tmo = LPFC_DEF_DEVLOSS_TMO;
+static int lpfc_devloss_tmo = LPFC_DEF_DEVLOSS_TMO;
+module_param(lpfc_nodev_tmo, int, 0);
+MODULE_PARM_DESC(lpfc_nodev_tmo,
+		 "Seconds driver will hold I/O waiting "
+		 "for a device to come back");
+static ssize_t
+lpfc_nodev_tmo_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata;
+	int val = 0;
+	val = phba->cfg_devloss_tmo;
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			phba->cfg_devloss_tmo);
+}
+
+static int
+lpfc_nodev_tmo_init(struct lpfc_hba *phba, int val)
+{
+	static int warned;
+	if (phba->cfg_devloss_tmo !=  LPFC_DEF_DEVLOSS_TMO) {
+		phba->cfg_nodev_tmo = phba->cfg_devloss_tmo;
+		if (!warned && val != LPFC_DEF_DEVLOSS_TMO) {
+			warned = 1;
+			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+					"%d:0402 Ignoring nodev_tmo module "
+					"parameter because devloss_tmo is"
+					" set.\n",
+					phba->brd_no);
+		}
+		return 0;
+	}
+
+	if (val >= LPFC_MIN_DEVLOSS_TMO && val <= LPFC_MAX_DEVLOSS_TMO) {
+		phba->cfg_nodev_tmo = val;
+		phba->cfg_devloss_tmo = val;
+		return 0;
+	}
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"%d:0400 lpfc_nodev_tmo attribute cannot be set to %d, "
+			"allowed range is [%d, %d]\n",
+			phba->brd_no, val,
+			LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO);
+	phba->cfg_nodev_tmo = LPFC_DEF_DEVLOSS_TMO;
+	return -EINVAL;
+}
+
+static int
+lpfc_nodev_tmo_set(struct lpfc_hba *phba, int val)
+{
+	if (phba->dev_loss_tmo_changed ||
+		(lpfc_devloss_tmo != LPFC_DEF_DEVLOSS_TMO)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"%d:0401 Ignoring change to nodev_tmo "
+				"because devloss_tmo is set.\n",
+				phba->brd_no);
+		return 0;
+	}
+
+	if (val >= LPFC_MIN_DEVLOSS_TMO && val <= LPFC_MAX_DEVLOSS_TMO) {
+		phba->cfg_nodev_tmo = val;
+		phba->cfg_devloss_tmo = val;
+		return 0;
+	}
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"%d:0403 lpfc_nodev_tmo attribute cannot be set to %d, "
+			"allowed range is [%d, %d]\n",
+			phba->brd_no, val, LPFC_MIN_DEVLOSS_TMO,
+			LPFC_MAX_DEVLOSS_TMO);
+	return -EINVAL;
+}
+
+lpfc_param_store(nodev_tmo)
+
+static CLASS_DEVICE_ATTR(lpfc_nodev_tmo, S_IRUGO | S_IWUSR,
+			 lpfc_nodev_tmo_show, lpfc_nodev_tmo_store);
+
+/*
+# lpfc_devloss_tmo: If set, it will hold all I/O errors on devices that
+# disappear until the timer expires. Value range is [0,255]. Default
+# value is 30.
+*/
+module_param(lpfc_devloss_tmo, int, 0);
+MODULE_PARM_DESC(lpfc_devloss_tmo,
+		 "Seconds driver will hold I/O waiting "
+		 "for a device to come back");
+lpfc_param_init(devloss_tmo, LPFC_DEF_DEVLOSS_TMO,
+		LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO)
+lpfc_param_show(devloss_tmo)
+static int
+lpfc_devloss_tmo_set(struct lpfc_hba *phba, int val)
+{
+	if (val >= LPFC_MIN_DEVLOSS_TMO && val <= LPFC_MAX_DEVLOSS_TMO) {
+		phba->cfg_nodev_tmo = val;
+		phba->cfg_devloss_tmo = val;
+		phba->dev_loss_tmo_changed = 1;
+		return 0;
+	}
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"%d:0404 lpfc_devloss_tmo attribute cannot be set to"
+			" %d, allowed range is [%d, %d]\n",
+			phba->brd_no, val, LPFC_MIN_DEVLOSS_TMO,
+			LPFC_MAX_DEVLOSS_TMO);
+	return -EINVAL;
+}
+
+lpfc_param_store(devloss_tmo)
+static CLASS_DEVICE_ATTR(lpfc_devloss_tmo, S_IRUGO | S_IWUSR,
+	lpfc_devloss_tmo_show, lpfc_devloss_tmo_store);
+
+/*
 # lpfc_log_verbose: Only turn this flag on if you are willing to risk being
 # deluged with LOTS of information.
 # You can set a bit mask to record specific types of verbose messages:
@@ -617,14 +737,6 @@ LPFC_ATTR_R(scan_down, 1, 0, 1,
 	     "Start scanning for devices from highest ALPA to lowest");
 
 /*
-# lpfc_nodev_tmo: If set, it will hold all I/O errors on devices that disappear
-# until the timer expires. Value range is [0,255]. Default value is 30.
-# NOTE: this MUST be less then the SCSI Layer command timeout - 1.
-*/
-LPFC_ATTR_RW(nodev_tmo, 30, 0, 255,
-	     "Seconds driver will hold I/O waiting for a device to come back");
-
-/*
 # lpfc_topology:  link topology for init link
 #            0x0  = attempt loop mode then point-to-point
 #            0x01 = internal loopback mode
@@ -737,6 +849,7 @@ struct class_device_attribute *lpfc_host
 	&class_device_attr_lpfc_lun_queue_depth,
 	&class_device_attr_lpfc_hba_queue_depth,
 	&class_device_attr_lpfc_nodev_tmo,
+	&class_device_attr_lpfc_devloss_tmo,
 	&class_device_attr_lpfc_fcp_class,
 	&class_device_attr_lpfc_use_adisc,
 	&class_device_attr_lpfc_ack0,
@@ -1450,27 +1563,12 @@ lpfc_get_starget_port_name(struct scsi_t
 }
 
 static void
-lpfc_get_rport_loss_tmo(struct fc_rport *rport)
-{
-	/*
-	 * Return the driver's global value for device loss timeout plus
-	 * five seconds to allow the driver's nodev timer to run.
-	 */
-	rport->dev_loss_tmo = lpfc_nodev_tmo + 5;
-}
-
-static void
 lpfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
-	/*
-	 * The driver doesn't have a per-target timeout setting.  Set
-	 * this value globally. lpfc_nodev_tmo should be greater then 0.
-	 */
 	if (timeout)
-		lpfc_nodev_tmo = timeout;
+		rport->dev_loss_tmo = timeout;
 	else
-		lpfc_nodev_tmo = 1;
-	rport->dev_loss_tmo = lpfc_nodev_tmo + 5;
+		rport->dev_loss_tmo = 1;
 }
 

@@ -1532,7 +1630,6 @@ struct fc_function_template lpfc_transpo
 	.show_rport_maxframe_size = 1,
 	.show_rport_supported_classes = 1,
 
-	.get_rport_dev_loss_tmo = lpfc_get_rport_loss_tmo,
 	.set_rport_dev_loss_tmo = lpfc_set_rport_loss_tmo,
 	.show_rport_dev_loss_tmo = 1,
 
@@ -1546,6 +1643,8 @@ struct fc_function_template lpfc_transpo
 	.show_starget_port_name = 1,
 
 	.issue_fc_host_lip = lpfc_issue_lip,
+	.dev_loss_tmo_callbk = lpfc_dev_loss_tmo_callbk,
+	.terminate_rport_io = lpfc_terminate_rport_io,
 };
 
 void
@@ -1561,13 +1660,13 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_ack0_init(phba, lpfc_ack0);
 	lpfc_topology_init(phba, lpfc_topology);
 	lpfc_scan_down_init(phba, lpfc_scan_down);
-	lpfc_nodev_tmo_init(phba, lpfc_nodev_tmo);
 	lpfc_link_speed_init(phba, lpfc_link_speed);
 	lpfc_fdmi_on_init(phba, lpfc_fdmi_on);
 	lpfc_discovery_threads_init(phba, lpfc_discovery_threads);
 	lpfc_max_luns_init(phba, lpfc_max_luns);
 	lpfc_poll_tmo_init(phba, lpfc_poll_tmo);
-
+	lpfc_devloss_tmo_init(phba, lpfc_devloss_tmo);
+	lpfc_nodev_tmo_init(phba, lpfc_nodev_tmo);
 	phba->cfg_poll = lpfc_poll;
 
 	/*
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -18,6 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
+struct fc_rport;
 void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t);
 void lpfc_read_nv(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_read_la(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb,
@@ -200,6 +201,8 @@ extern struct scsi_host_template lpfc_te
 extern struct fc_function_template lpfc_transport_functions;
 
 void lpfc_get_hba_sym_node_name(struct lpfc_hba * phba, uint8_t * symbp);
+void lpfc_terminate_rport_io(struct fc_rport *);
+void lpfc_dev_loss_tmo_callbk(struct fc_rport *rport);
 
 #define ScsiResult(host_code, scsi_code) (((host_code) << 16) | scsi_code)
 #define HBA_EVENT_RSCN                   5
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -324,7 +324,6 @@ lpfc_ns_rsp(struct lpfc_hba * phba, stru
 	struct lpfc_sli_ct_request *Response =
 		(struct lpfc_sli_ct_request *) mp->virt;
 	struct lpfc_nodelist *ndlp = NULL;
-	struct lpfc_nodelist *next_ndlp;
 	struct lpfc_dmabuf *mlast, *next_mp;
 	uint32_t *ctptr = (uint32_t *) & Response->un.gid.PortType;
 	uint32_t Did;
@@ -399,30 +398,6 @@ nsout1:
  	 * current driver state.
  	 */
 	if (phba->hba_state == LPFC_HBA_READY) {
-
-		/*
-		 * Switch ports that connect a loop of multiple targets need
-		 * special consideration.  The driver wants to unregister the
-		 * rpi only on the target that was pulled from the loop.  On
-		 * RSCN, the driver wants to rediscover an NPort only if the
-		 * driver flagged it as NLP_NPR_2B_DISC.  Provided adisc is
-		 * not enabled and the NPort is not capable of retransmissions
-		 * (FC Tape) prevent timing races with the scsi error handler by
-		 * unregistering the Nport's RPI.  This action causes all
-		 * outstanding IO to flush back to the midlayer.
-		 */
-		list_for_each_entry_safe(ndlp, next_ndlp, &phba->fc_npr_list,
-					 nlp_listp) {
-			if (!(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
-			    (lpfc_rscn_payload_check(phba, ndlp->nlp_DID))) {
-				if ((phba->cfg_use_adisc == 0) &&
-				    !(ndlp->nlp_fcp_info &
-				      NLP_FCP_2_DEVICE)) {
-					lpfc_unreg_rpi(phba, ndlp);
-					ndlp->nlp_flag &= ~NLP_NPR_ADISC;
-				}
-			}
-		}
 		lpfc_els_flush_rscn(phba);
 		spin_lock_irq(phba->host->host_lock);
 		phba->fc_flag |= FC_RSCN_MODE; /* we are still in RSCN mode */
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -30,7 +30,6 @@ #define LPFC_DISC_FLOGI_TMO  10	      /*
 
 /* worker thread events */
 enum lpfc_work_type {
-	LPFC_EVT_NODEV_TMO,
 	LPFC_EVT_ONLINE,
 	LPFC_EVT_OFFLINE,
 	LPFC_EVT_WARM_START,
@@ -74,11 +73,9 @@ #define NLP_NO_SID		0xffff
 #define NLP_FCP_2_DEVICE   0x10			/* FCP-2 device */
 
 	struct timer_list   nlp_delayfunc;	/* Used for delayed ELS cmds */
-	struct timer_list   nlp_tmofunc;	/* Used for nodev tmo */
 	struct fc_rport *rport;			/* Corresponding FC transport
 						   port structure */
 	struct lpfc_hba      *nlp_phba;
-	struct lpfc_work_evt nodev_timeout_evt;
 	struct lpfc_work_evt els_retry_evt;
 	unsigned long last_ramp_up_time;        /* jiffy of last ramp up */
 	unsigned long last_q_full_time;		/* jiffy of last queue full */
@@ -102,7 +99,6 @@ #define NLP_ADISC_SND      0x80		/* sent
 #define NLP_LOGO_SND       0x100	/* sent LOGO request for this entry */
 #define NLP_RNID_SND       0x400	/* sent RNID request for this entry */
 #define NLP_ELS_SND_MASK   0x7e0	/* sent ELS request for this entry */
-#define NLP_NODEV_TMO      0x10000	/* nodev timeout is running for node */
 #define NLP_DELAY_TMO      0x20000	/* delay timeout is running for node */
 #define NLP_NPR_2B_DISC    0x40000	/* node is included in num_disc_nodes */
 #define NLP_RCV_PLOGI      0x80000	/* Rcv'ed PLOGI from remote system */
@@ -169,7 +165,7 @@ #define NLP_STE_FREED_NODE        0xff	/
  */
 /*
  * For a Link Down, all nodes on the ADISC, PLOGI, unmapped or mapped
- * lists will receive a DEVICE_RECOVERY event. If the linkdown or nodev timers
+ * lists will receive a DEVICE_RECOVERY event. If the linkdown or devloss timers
  * expire, all effected nodes will receive a DEVICE_RM event.
  */
 /*
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -56,28 +56,63 @@ static uint8_t lpfcAlpaArray[] = {
 
 static void lpfc_disc_timeout_handler(struct lpfc_hba *);
 
-static void
-lpfc_process_nodev_timeout(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
+void
+lpfc_terminate_rport_io(struct fc_rport *rport)
 {
-	uint8_t *name = (uint8_t *)&ndlp->nlp_portname;
-	int warn_on = 0;
+	struct lpfc_rport_data *rdata;
+	struct lpfc_nodelist * ndlp;
+	struct lpfc_hba *phba;
 
-	spin_lock_irq(phba->host->host_lock);
-	if (!(ndlp->nlp_flag & NLP_NODEV_TMO)) {
-		spin_unlock_irq(phba->host->host_lock);
+	rdata = rport->dd_data;
+	ndlp = rdata->pnode;
+
+	if (!ndlp) {
+		if (rport->roles & FC_RPORT_ROLE_FCP_TARGET)
+			printk(KERN_ERR "Cannot find remote node"
+			" to terminate I/O Data x%x\n",
+			rport->port_id);
 		return;
 	}
 
-	/*
-	 * If a discovery event readded nodev_timer after timer
-	 * firing and before processing the timer, cancel the
-	 * nlp_tmofunc.
-	 */
-	spin_unlock_irq(phba->host->host_lock);
-	del_timer_sync(&ndlp->nlp_tmofunc);
+	phba = ndlp->nlp_phba;
+
 	spin_lock_irq(phba->host->host_lock);
+	if (ndlp->nlp_sid != NLP_NO_SID) {
+		lpfc_sli_abort_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
+			ndlp->nlp_sid, 0, 0, LPFC_CTX_TGT);
+	}
+	spin_unlock_irq(phba->host->host_lock);
+
+	return;
+}
+
+/*
+ * This function will be called when dev_loss_tmo fire.
+ */
+void
+lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
+{
+	struct lpfc_rport_data *rdata;
+	struct lpfc_nodelist * ndlp;
+	uint8_t *name;
+	int warn_on = 0;
+	struct lpfc_hba *phba;
+
+	rdata = rport->dd_data;
+	ndlp = rdata->pnode;
 
-	ndlp->nlp_flag &= ~NLP_NODEV_TMO;
+	if (!ndlp) {
+		if (rport->roles & FC_RPORT_ROLE_FCP_TARGET)
+			printk(KERN_ERR "Cannot find remote node"
+			" for rport in dev_loss_tmo_callbk x%x\n",
+			rport->port_id);
+		return;
+	}
+
+	name = (uint8_t *)&ndlp->nlp_portname;
+	phba = ndlp->nlp_phba;
+
+	spin_lock_irq(phba->host->host_lock);
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
 		warn_on = 1;
@@ -85,11 +120,14 @@ lpfc_process_nodev_timeout(struct lpfc_h
 		lpfc_sli_abort_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
 			ndlp->nlp_sid, 0, 0, LPFC_CTX_TGT);
 	}
+	if (phba->fc_flag & FC_UNLOADING)
+		warn_on = 0;
+
 	spin_unlock_irq(phba->host->host_lock);
 
 	if (warn_on) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-				"%d:0203 Nodev timeout on "
+				"%d:0203 Devloss timeout on "
 				"WWPN %x:%x:%x:%x:%x:%x:%x:%x "
 				"NPort x%x Data: x%x x%x x%x\n",
 				phba->brd_no,
@@ -99,7 +137,7 @@ lpfc_process_nodev_timeout(struct lpfc_h
 				ndlp->nlp_state, ndlp->nlp_rpi);
 	} else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
-				"%d:0204 Nodev timeout on "
+				"%d:0204 Devloss timeout on "
 				"WWPN %x:%x:%x:%x:%x:%x:%x:%x "
 				"NPort x%x Data: x%x x%x x%x\n",
 				phba->brd_no,
@@ -109,7 +147,12 @@ lpfc_process_nodev_timeout(struct lpfc_h
 				ndlp->nlp_state, ndlp->nlp_rpi);
 	}
 
-	lpfc_disc_state_machine(phba, ndlp, NULL, NLP_EVT_DEVICE_RM);
+	ndlp->rport = NULL;
+	rdata->pnode = NULL;
+
+	if (!(phba->fc_flag & FC_UNLOADING))
+		lpfc_disc_state_machine(phba, ndlp, NULL, NLP_EVT_DEVICE_RM);
+
 	return;
 }
 
@@ -127,11 +170,6 @@ lpfc_work_list_done(struct lpfc_hba * ph
 		spin_unlock_irq(phba->host->host_lock);
 		free_evt = 1;
 		switch (evtp->evt) {
-		case LPFC_EVT_NODEV_TMO:
-			ndlp = (struct lpfc_nodelist *)(evtp->evt_arg1);
-			lpfc_process_nodev_timeout(phba, ndlp);
-			free_evt = 0;
-			break;
 		case LPFC_EVT_ELS_RETRY:
 			ndlp = (struct lpfc_nodelist *)(evtp->evt_arg1);
 			lpfc_els_retry_delay_handler(ndlp);
@@ -377,16 +415,6 @@ lpfc_linkdown(struct lpfc_hba * phba)
 			rc = lpfc_disc_state_machine(phba, ndlp, NULL,
 					     NLP_EVT_DEVICE_RECOVERY);
 
-			/* Check config parameter use-adisc or FCP-2 */
-			if ((rc != NLP_STE_FREED_NODE) &&
-				(phba->cfg_use_adisc == 0) &&
-				!(ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE)) {
-				/* We know we will have to relogin, so
-				 * unreglogin the rpi right now to fail
-				 * any outstanding I/Os quickly.
-				 */
-				lpfc_unreg_rpi(phba, ndlp);
-			}
 		}
 	}
 
@@ -1104,8 +1132,11 @@ lpfc_unregister_remote_port(struct lpfc_
 	struct fc_rport *rport = ndlp->rport;
 	struct lpfc_rport_data *rdata = rport->dd_data;
 
-	ndlp->rport = NULL;
-	rdata->pnode = NULL;
+	if (rport->scsi_target_id == -1) {
+		ndlp->rport = NULL;
+		rdata->pnode = NULL;
+	}
+
 	fc_remote_port_delete(rport);
 
 	return;
@@ -1233,17 +1264,6 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		list_add_tail(&nlp->nlp_listp, &phba->fc_nlpunmap_list);
 		phba->fc_unmap_cnt++;
 		phba->nport_event_cnt++;
-		/* stop nodev tmo if running */
-		if (nlp->nlp_flag & NLP_NODEV_TMO) {
-			nlp->nlp_flag &= ~NLP_NODEV_TMO;
-			spin_unlock_irq(phba->host->host_lock);
-			del_timer_sync(&nlp->nlp_tmofunc);
-			spin_lock_irq(phba->host->host_lock);
-			if (!list_empty(&nlp->nodev_timeout_evt.evt_listp))
-				list_del_init(&nlp->nodev_timeout_evt.
-						evt_listp);
-
-		}
 		nlp->nlp_flag &= ~NLP_NODEV_REMOVE;
 		nlp->nlp_type |= NLP_FC_NODE;
 		break;
@@ -1254,17 +1274,6 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		list_add_tail(&nlp->nlp_listp, &phba->fc_nlpmap_list);
 		phba->fc_map_cnt++;
 		phba->nport_event_cnt++;
-		/* stop nodev tmo if running */
-		if (nlp->nlp_flag & NLP_NODEV_TMO) {
-			nlp->nlp_flag &= ~NLP_NODEV_TMO;
-			spin_unlock_irq(phba->host->host_lock);
-			del_timer_sync(&nlp->nlp_tmofunc);
-			spin_lock_irq(phba->host->host_lock);
-			if (!list_empty(&nlp->nodev_timeout_evt.evt_listp))
-				list_del_init(&nlp->nodev_timeout_evt.
-						evt_listp);
-
-		}
 		nlp->nlp_flag &= ~NLP_NODEV_REMOVE;
 		break;
 	case NLP_NPR_LIST:
@@ -1273,11 +1282,6 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 		list_add_tail(&nlp->nlp_listp, &phba->fc_npr_list);
 		phba->fc_npr_cnt++;
 
-		if (!(nlp->nlp_flag & NLP_NODEV_TMO))
-			mod_timer(&nlp->nlp_tmofunc,
-		 			jiffies + HZ * phba->cfg_nodev_tmo);
-
-		nlp->nlp_flag |= NLP_NODEV_TMO;
 		nlp->nlp_flag &= ~NLP_RCV_PLOGI;
 		break;
 	case NLP_JUST_DQ:
@@ -1307,7 +1311,8 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 			 * already. If we have, and it's a scsi entity, be
 			 * sure to unblock any attached scsi devices
 			 */
-			if (!nlp->rport)
+			if ((!nlp->rport) || (nlp->rport->port_state ==
+					FC_PORTSTATE_BLOCKED))
 				lpfc_register_remote_port(phba, nlp);
 
 			/*
@@ -1581,15 +1586,12 @@ lpfc_freenode(struct lpfc_hba * phba, st
 
 	lpfc_els_abort(phba,ndlp,0);
 	spin_lock_irq(phba->host->host_lock);
-	ndlp->nlp_flag &= ~(NLP_NODEV_TMO|NLP_DELAY_TMO);
+	ndlp->nlp_flag &= ~NLP_DELAY_TMO;
 	spin_unlock_irq(phba->host->host_lock);
-	del_timer_sync(&ndlp->nlp_tmofunc);
 
 	ndlp->nlp_last_elscmd = 0;
 	del_timer_sync(&ndlp->nlp_delayfunc);
 
-	if (!list_empty(&ndlp->nodev_timeout_evt.evt_listp))
-		list_del_init(&ndlp->nodev_timeout_evt.evt_listp);
 	if (!list_empty(&ndlp->els_retry_evt.evt_listp))
 		list_del_init(&ndlp->els_retry_evt.evt_listp);
 
@@ -1606,16 +1608,6 @@ lpfc_freenode(struct lpfc_hba * phba, st
 int
 lpfc_nlp_remove(struct lpfc_hba * phba, struct lpfc_nodelist * ndlp)
 {
-	if (ndlp->nlp_flag & NLP_NODEV_TMO) {
-		spin_lock_irq(phba->host->host_lock);
-		ndlp->nlp_flag &= ~NLP_NODEV_TMO;
-		spin_unlock_irq(phba->host->host_lock);
-		del_timer_sync(&ndlp->nlp_tmofunc);
-		if (!list_empty(&ndlp->nodev_timeout_evt.evt_listp))
-			list_del_init(&ndlp->nodev_timeout_evt.evt_listp);
-
-	}
-
 
 	if (ndlp->nlp_flag & NLP_DELAY_TMO) {
 		lpfc_cancel_retry_delay_tmo(phba, ndlp);
@@ -2430,34 +2422,6 @@ lpfc_disc_timeout_handler(struct lpfc_hb
 	return;
 }
 
-static void
-lpfc_nodev_timeout(unsigned long ptr)
-{
-	struct lpfc_hba *phba;
-	struct lpfc_nodelist *ndlp;
-	unsigned long iflag;
-	struct lpfc_work_evt  *evtp;
-
-	ndlp = (struct lpfc_nodelist *)ptr;
-	phba = ndlp->nlp_phba;
-	evtp = &ndlp->nodev_timeout_evt;
-	spin_lock_irqsave(phba->host->host_lock, iflag);
-
-	if (!list_empty(&evtp->evt_listp)) {
-		spin_unlock_irqrestore(phba->host->host_lock, iflag);
-		return;
-	}
-	evtp->evt_arg1  = ndlp;
-	evtp->evt       = LPFC_EVT_NODEV_TMO;
-	list_add_tail(&evtp->evt_listp, &phba->work_list);
-	if (phba->work_wait)
-		wake_up(phba->work_wait);
-
-	spin_unlock_irqrestore(phba->host->host_lock, iflag);
-	return;
-}
-
-
 /*
  * This routine handles processing a NameServer REG_LOGIN mailbox
  * command upon completion. It is setup in the LPFC_MBOXQ
@@ -2581,11 +2545,7 @@ lpfc_nlp_init(struct lpfc_hba * phba, st
 		 uint32_t did)
 {
 	memset(ndlp, 0, sizeof (struct lpfc_nodelist));
-	INIT_LIST_HEAD(&ndlp->nodev_timeout_evt.evt_listp);
 	INIT_LIST_HEAD(&ndlp->els_retry_evt.evt_listp);
-	init_timer(&ndlp->nlp_tmofunc);
-	ndlp->nlp_tmofunc.function = lpfc_nodev_timeout;
-	ndlp->nlp_tmofunc.data = (unsigned long)ndlp;
 	init_timer(&ndlp->nlp_delayfunc);
 	ndlp->nlp_delayfunc.function = lpfc_els_retry_delay;
 	ndlp->nlp_delayfunc.data = (unsigned long)ndlp;
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1813,7 +1813,7 @@ lpfc_device_recov_npr_node(struct lpfc_h
  */
 /*
  * For a Link Down, all nodes on the ADISC, PLOGI, unmapped or mapped
- * lists will receive a DEVICE_RECOVERY event. If the linkdown or nodev timers
+ * lists will receive a DEVICE_RECOVERY event. If the linkdown or devloss timers
  * expire, all effected nodes will receive a DEVICE_RM event.
  */
 /*
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -935,7 +935,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 			schedule_timeout_uninterruptible(LPFC_ABORT_WAIT*HZ);
 		spin_lock_irq(phba->host->host_lock);
 		if (++loop_count
-		    > (2 * phba->cfg_nodev_tmo)/LPFC_ABORT_WAIT)
+		    > (2 * phba->cfg_devloss_tmo)/LPFC_ABORT_WAIT)
 			break;
 	}
 
@@ -978,7 +978,7 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	spin_lock_irq(shost->host_lock);
 	/*
 	 * If target is not in a MAPPED state, delay the reset until
-	 * target is rediscovered or nodev timeout expires.
+	 * target is rediscovered or devloss timeout expires.
 	 */
 	while ( 1 ) {
 		if (!pnode)
@@ -1050,7 +1050,7 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 		spin_lock_irq(phba->host->host_lock);
 
 		if (++loopcnt
-		    > (2 * phba->cfg_nodev_tmo)/LPFC_RESET_WAIT)
+		    > (2 * phba->cfg_devloss_tmo)/LPFC_RESET_WAIT)
 			break;
 
 		cnt = lpfc_sli_sum_iocb(phba,
@@ -1151,7 +1151,7 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 		spin_lock_irq(phba->host->host_lock);
 
 		if (++loopcnt
-		    > (2 * phba->cfg_nodev_tmo)/LPFC_RESET_WAIT)
+		    > (2 * phba->cfg_devloss_tmo)/LPFC_RESET_WAIT)
 			break;
 
 		cnt = lpfc_sli_sum_iocb(phba,
@@ -1249,7 +1249,7 @@ lpfc_slave_configure(struct scsi_device 
 	 * target pointer is stored in the starget_data for the
 	 * driver's sysfs entry point functions.
 	 */
-	rport->dev_loss_tmo = phba->cfg_nodev_tmo + 5;
+	rport->dev_loss_tmo = phba->cfg_devloss_tmo;
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_poll_fcp_ring(phba);


