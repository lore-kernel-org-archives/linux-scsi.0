From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 5/6] lpfc 8.3.5: MIsc patch set part 4
Date: Fri, 2 Oct 2009 15:17:02 -0400
Message-ID: <1254511022.32739.25.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64015 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbZJBT7H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2009 15:59:07 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n92JxBjC026974
	for <linux-scsi@vger.kernel.org>; Fri, 2 Oct 2009 12:59:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


This patch includes the following changes:
- Fixed Panic/Hang when using polling mode for fcp commands
- Added support for Read_rev mbox bits indicating FIP mode of HBA
- Optimize performance of slow-path handling of els responses
- Add code to cleanup orphaned unsolicited receive sequences
- Fixed Devloss timeout when multiple initiators are in same zone


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    9 -
 lpfc_attr.c    |   42 +++--
 lpfc_crtn.h    |    7 
 lpfc_els.c     |    2 
 lpfc_hbadisc.c |   19 --
 lpfc_hw4.h     |    5 
 lpfc_init.c    |   11 +
 lpfc_mbox.c    |    5 
 lpfc_scsi.c    |   16 +
 lpfc_sli.c     |  464 ++++++++++++++++++++++++++++-----------------------------
 lpfc_sli.h     |    2 
 lpfc_sli4.h    |    2 
 12 files changed, 307 insertions(+), 277 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2009-10-01 17:21:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2009-10-01 17:21:58.000000000 -0400
@@ -100,6 +100,28 @@ lpfc_drvr_version_show(struct device *de
 	return snprintf(buf, PAGE_SIZE, LPFC_MODULE_DESC "\n");
 }
 
+/**
+ * lpfc_enable_fip_show - Return the fip mode of the HBA
+ * @dev: class unused variable.
+ * @attr: device attribute, not used.
+ * @buf: on return contains the module description text.
+ *
+ * Returns: size of formatted string.
+ **/
+static ssize_t
+lpfc_enable_fip_show(struct device *dev, struct device_attribute *attr,
+		       char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+
+	if (phba->hba_flag & HBA_FIP_SUPPORT)
+		return snprintf(buf, PAGE_SIZE, "1\n");
+	else
+		return snprintf(buf, PAGE_SIZE, "0\n");
+}
+
 static ssize_t
 lpfc_bg_info_show(struct device *dev, struct device_attribute *attr,
 		  char *buf)
@@ -1134,6 +1156,9 @@ lpfc_poll_store(struct device *dev, stru
 	if ((val & 0x3) != val)
 		return -EINVAL;
 
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		val = 0;
+
 	spin_lock_irq(&phba->hbalock);
 
 	old_val = phba->cfg_poll;
@@ -1597,6 +1622,7 @@ static DEVICE_ATTR(num_discovered_ports,
 static DEVICE_ATTR(menlo_mgmt_mode, S_IRUGO, lpfc_mlomgmt_show, NULL);
 static DEVICE_ATTR(nport_evt_cnt, S_IRUGO, lpfc_nport_evt_cnt_show, NULL);
 static DEVICE_ATTR(lpfc_drvr_version, S_IRUGO, lpfc_drvr_version_show, NULL);
+static DEVICE_ATTR(lpfc_enable_fip, S_IRUGO, lpfc_enable_fip_show, NULL);
 static DEVICE_ATTR(board_mode, S_IRUGO | S_IWUSR,
 		   lpfc_board_mode_show, lpfc_board_mode_store);
 static DEVICE_ATTR(issue_reset, S_IWUSR, NULL, lpfc_issue_reset);
@@ -3128,15 +3154,6 @@ LPFC_ATTR_R(enable_hba_heartbeat, 1, 0, 
 LPFC_ATTR_R(enable_bg, 0, 0, 1, "Enable BlockGuard Support");
 
 /*
-# lpfc_enable_fip: When set, FIP is required to start discovery. If not
-# set, the driver will add an FCF record manually if the port has no
-# FCF records available and start discovery.
-# Value range is [0,1]. Default value is 1 (enabled)
-*/
-LPFC_ATTR_RW(enable_fip, 0, 0, 1, "Enable FIP Discovery");
-
-
-/*
 # lpfc_prot_mask: i
 #	- Bit mask of host protection capabilities used to register with the
 #	  SCSI mid-layer
@@ -3194,6 +3211,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_num_discovered_ports,
 	&dev_attr_menlo_mgmt_mode,
 	&dev_attr_lpfc_drvr_version,
+	&dev_attr_lpfc_enable_fip,
 	&dev_attr_lpfc_temp_sensor,
 	&dev_attr_lpfc_log_verbose,
 	&dev_attr_lpfc_lun_queue_depth,
@@ -3201,7 +3219,6 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_peer_port_login,
 	&dev_attr_lpfc_nodev_tmo,
 	&dev_attr_lpfc_devloss_tmo,
-	&dev_attr_lpfc_enable_fip,
 	&dev_attr_lpfc_fcp_class,
 	&dev_attr_lpfc_use_adisc,
 	&dev_attr_lpfc_ack0,
@@ -3256,7 +3273,6 @@ struct device_attribute *lpfc_vport_attr
 	&dev_attr_lpfc_lun_queue_depth,
 	&dev_attr_lpfc_nodev_tmo,
 	&dev_attr_lpfc_devloss_tmo,
-	&dev_attr_lpfc_enable_fip,
 	&dev_attr_lpfc_hba_queue_depth,
 	&dev_attr_lpfc_peer_port_login,
 	&dev_attr_lpfc_restrict_login,
@@ -4412,13 +4428,15 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_enable_hba_reset_init(phba, lpfc_enable_hba_reset);
 	lpfc_enable_hba_heartbeat_init(phba, lpfc_enable_hba_heartbeat);
 	lpfc_enable_bg_init(phba, lpfc_enable_bg);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		phba->cfg_poll = 0;
+	else
 	phba->cfg_poll = lpfc_poll;
 	phba->cfg_soft_wwnn = 0L;
 	phba->cfg_soft_wwpn = 0L;
 	lpfc_sg_seg_cnt_init(phba, lpfc_sg_seg_cnt);
 	lpfc_prot_sg_seg_cnt_init(phba, lpfc_prot_sg_seg_cnt);
 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
-	lpfc_enable_fip_init(phba, lpfc_enable_fip);
 	lpfc_hba_log_verbose_init(phba, lpfc_log_verbose);
 	lpfc_aer_support_init(phba, lpfc_aer_support);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2009-10-01 17:20:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2009-10-01 17:21:58.000000000 -0400
@@ -49,6 +49,8 @@ void lpfc_init_link(struct lpfc_hba *, L
 void lpfc_request_features(struct lpfc_hba *, struct lpfcMboxq *);
 
 struct lpfc_vport *lpfc_find_vport_by_did(struct lpfc_hba *, uint32_t);
+void lpfc_cleanup_rcv_buffers(struct lpfc_vport *);
+void lpfc_rcv_seq_check_edtov(struct lpfc_vport *);
 void lpfc_cleanup_rpis(struct lpfc_vport *, int);
 int lpfc_linkdown(struct lpfc_hba *);
 void lpfc_linkdown_port(struct lpfc_vport *);
@@ -214,7 +216,10 @@ void lpfc_stop_vport_timers(struct lpfc_
 void lpfc_poll_timeout(unsigned long ptr);
 void lpfc_poll_start_timer(struct lpfc_hba *);
 void lpfc_poll_eratt(unsigned long);
-void lpfc_sli_poll_fcp_ring(struct lpfc_hba *);
+int
+lpfc_sli_handle_fast_ring_event(struct lpfc_hba *,
+			struct lpfc_sli_ring *, uint32_t);
+
 struct lpfc_iocbq * lpfc_sli_get_iocbq(struct lpfc_hba *);
 void lpfc_sli_release_iocbq(struct lpfc_hba *, struct lpfc_iocbq *);
 uint16_t lpfc_sli_next_iotag(struct lpfc_hba *, struct lpfc_iocbq *);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2009-10-01 17:20:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2009-10-01 17:21:58.000000000 -0400
@@ -173,7 +173,7 @@ lpfc_prep_els_iocb(struct lpfc_vport *vp
 	 * in FIP mode send FLOGI, FDISC and LOGO as FIP frames.
 	 */
 	if ((did == Fabric_DID) &&
-		bf_get(lpfc_fip_flag, &phba->sli4_hba.sli4_flags) &&
+		(phba->hba_flag & HBA_FIP_SUPPORT) &&
 		((elscmd == ELS_CMD_FLOGI) ||
 		 (elscmd == ELS_CMD_FDISC) ||
 		 (elscmd == ELS_CMD_LOGO)))
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2009-10-01 17:21:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2009-10-01 17:21:58.000000000 -0400
@@ -110,6 +110,7 @@ struct hbq_dmabuf {
 	uint32_t size;
 	uint32_t tag;
 	struct lpfc_cq_event cq_event;
+	unsigned long time_stamp;
 };
 
 /* Priority bit.  Set value to exceed low water mark in lpfc_mem. */
@@ -405,6 +406,7 @@ struct lpfc_vport {
 	uint8_t stat_data_enabled;
 	uint8_t stat_data_blocked;
 	struct list_head rcv_buffer_list;
+	unsigned long rcv_buffer_time_stamp;
 	uint32_t vport_flag;
 #define STATIC_VPORT	1
 };
@@ -527,14 +529,16 @@ struct lpfc_hba {
 #define HBA_ERATT_HANDLED	0x1 /* This flag is set when eratt handled */
 #define DEFER_ERATT		0x2 /* Deferred error attention in progress */
 #define HBA_FCOE_SUPPORT	0x4 /* HBA function supports FCOE */
-#define HBA_RECEIVE_BUFFER	0x8 /* Rcv buffer posted to worker thread */
+#define HBA_SP_QUEUE_EVT	0x8 /* Slow-path qevt posted to worker thread*/
 #define HBA_POST_RECEIVE_BUFFER 0x10 /* Rcv buffers need to be posted */
 #define FCP_XRI_ABORT_EVENT	0x20
 #define ELS_XRI_ABORT_EVENT	0x40
 #define ASYNC_EVENT		0x80
 #define LINK_DISABLED		0x100 /* Link disabled by user */
 #define FCF_DISC_INPROGRESS	0x200 /* FCF discovery in progress */
-#define HBA_AER_ENABLED         0x800 /* AER enabled with HBA */
+#define HBA_FIP_SUPPORT		0x400 /* FIP support in HBA */
+#define HBA_AER_ENABLED		0x800 /* AER enabled with HBA */
+	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
 
 	MAILBOX_t *mbox;
@@ -606,7 +610,6 @@ struct lpfc_hba {
 	uint32_t cfg_enable_hba_reset;
 	uint32_t cfg_enable_hba_heartbeat;
 	uint32_t cfg_enable_bg;
-	uint32_t cfg_enable_fip;
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_aer_support;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-10-01 17:21:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2009-10-01 17:21:58.000000000 -0400
@@ -568,7 +568,7 @@ lpfc_work_done(struct lpfc_hba *phba)
 	status >>= (4*LPFC_ELS_RING);
 	if ((status & HA_RXMASK) ||
 	    (pring->flag & LPFC_DEFERRED_RING_EVENT) ||
-	    (phba->hba_flag & HBA_RECEIVE_BUFFER)) {
+	    (phba->hba_flag & HBA_SP_QUEUE_EVT)) {
 		if (pring->flag & LPFC_STOP_IOCB_EVENT) {
 			pring->flag |= LPFC_DEFERRED_RING_EVENT;
 			/* Set the lpfc data pending flag */
@@ -706,6 +706,9 @@ lpfc_cleanup_rpis(struct lpfc_vport *vpo
 void
 lpfc_port_link_failure(struct lpfc_vport *vport)
 {
+	/* Cleanup any outstanding received buffers */
+	lpfc_cleanup_rcv_buffers(vport);
+
 	/* Cleanup any outstanding RSCN activity */
 	lpfc_els_flush_rscn(vport);
 
@@ -1282,7 +1285,7 @@ lpfc_match_fcf_conn_list(struct lpfc_hba
 		!bf_get(lpfc_fcf_record_fcf_valid, new_fcf_record))
 		return 0;
 
-	if (!phba->cfg_enable_fip) {
+	if (!(phba->hba_flag & HBA_FIP_SUPPORT)) {
 		*boot_flag = 0;
 		*addr_mode = bf_get(lpfc_fcf_record_mac_addr_prov,
 				new_fcf_record);
@@ -1997,7 +2000,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 		 * is phase 1 implementation that support FCF index 0 and driver
 		 * defaults.
 		 */
-		if (phba->cfg_enable_fip == 0) {
+		if (!(phba->hba_flag & HBA_FIP_SUPPORT)) {
 			fcf_record = kzalloc(sizeof(struct fcf_record),
 					GFP_KERNEL);
 			if (unlikely(!fcf_record)) {
@@ -4442,7 +4445,7 @@ lpfc_unregister_unused_fcf(struct lpfc_h
 	 */
 	if (!(phba->hba_flag & HBA_FCOE_SUPPORT) ||
 		!(phba->fcf.fcf_flag & FCF_REGISTERED) ||
-		(phba->cfg_enable_fip == 0)) {
+		(!(phba->hba_flag & HBA_FIP_SUPPORT))) {
 		spin_unlock_irq(&phba->hbalock);
 		return;
 	}
@@ -4615,14 +4618,6 @@ lpfc_read_fcoe_param(struct lpfc_hba *ph
 		(fcoe_param_hdr->length != FCOE_PARAM_LENGTH))
 		return;
 
-	if (bf_get(lpfc_fip_param_hdr_fipp_mode, fcoe_param_hdr) ==
-			FIPP_MODE_ON)
-		phba->cfg_enable_fip = 1;
-
-	if (bf_get(lpfc_fip_param_hdr_fipp_mode, fcoe_param_hdr) ==
-		FIPP_MODE_OFF)
-		phba->cfg_enable_fip = 0;
-
 	if (fcoe_param_hdr->parm_flags & FIPP_VLAN_VALID) {
 		phba->valid_vlan = 1;
 		phba->vlan_id = le16_to_cpu(fcoe_param->vlan_tag) &
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2009-10-01 17:20:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2009-10-01 17:21:58.000000000 -0400
@@ -1601,6 +1601,11 @@ struct lpfc_mbx_read_rev {
 #define lpfc_mbx_rd_rev_fcoe_SHIFT		20
 #define lpfc_mbx_rd_rev_fcoe_MASK		0x00000001
 #define lpfc_mbx_rd_rev_fcoe_WORD		word1
+#define lpfc_mbx_rd_rev_cee_ver_SHIFT		21
+#define lpfc_mbx_rd_rev_cee_ver_MASK		0x00000003
+#define lpfc_mbx_rd_rev_cee_ver_WORD		word1
+#define LPFC_PREDCBX_CEE_MODE	0
+#define LPFC_DCBX_CEE_MODE	1
 #define lpfc_mbx_rd_rev_vpd_SHIFT		29
 #define lpfc_mbx_rd_rev_vpd_MASK		0x00000001
 #define lpfc_mbx_rd_rev_vpd_WORD		word1
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-10-01 17:21:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-10-01 17:21:58.000000000 -0400
@@ -853,12 +853,19 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba
 void
 lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 {
+	struct lpfc_vport **vports;
 	LPFC_MBOXQ_t *pmboxq;
 	struct lpfc_dmabuf *buf_ptr;
-	int retval;
+	int retval, i;
 	struct lpfc_sli *psli = &phba->sli;
 	LIST_HEAD(completions);
 
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
+			lpfc_rcv_seq_check_edtov(vports[i]);
+	lpfc_destroy_vport_work_array(phba, vports);
+
 	if ((phba->link_state == LPFC_HBA_ERROR) ||
 		(phba->pport->load_flag & FC_UNLOADING) ||
 		(phba->pport->fc_flag & FC_OFFLINE_MODE))
@@ -3519,7 +3526,7 @@ lpfc_sli4_driver_resource_setup(struct l
 	/* Driver internel slow-path CQ Event pool */
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_cqe_event_pool);
 	/* Response IOCB work queue list */
-	INIT_LIST_HEAD(&phba->sli4_hba.sp_rspiocb_work_queue);
+	INIT_LIST_HEAD(&phba->sli4_hba.sp_queue_event);
 	/* Asynchronous event CQ Event work queue list */
 	INIT_LIST_HEAD(&phba->sli4_hba.sp_asynce_work_queue);
 	/* Fast-path XRI aborted CQ Event work queue list */
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2009-10-01 17:21:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2009-10-01 17:21:58.000000000 -0400
@@ -1759,11 +1759,6 @@ lpfc_request_features(struct lpfc_hba *p
 	/* Set up host requested features. */
 	bf_set(lpfc_mbx_rq_ftr_rq_fcpi, &mboxq->u.mqe.un.req_ftrs, 1);
 
-	if (phba->cfg_enable_fip)
-		bf_set(lpfc_mbx_rq_ftr_rq_ifip, &mboxq->u.mqe.un.req_ftrs, 0);
-	else
-		bf_set(lpfc_mbx_rq_ftr_rq_ifip, &mboxq->u.mqe.un.req_ftrs, 1);
-
 	/* Enable DIF (block guard) only if configured to do so. */
 	if (phba->cfg_enable_bg)
 		bf_set(lpfc_mbx_rq_ftr_rq_dif, &mboxq->u.mqe.un.req_ftrs, 1);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-10-01 17:21:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2009-10-01 17:21:58.000000000 -0400
@@ -2773,7 +2773,9 @@ void lpfc_poll_timeout(unsigned long ptr
 	struct lpfc_hba *phba = (struct lpfc_hba *) ptr;
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-		lpfc_sli_poll_fcp_ring (phba);
+		lpfc_sli_handle_fast_ring_event(phba,
+			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
+
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
 	}
@@ -2932,7 +2934,11 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 		goto out_host_busy_free_buf;
 	}
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-		lpfc_sli_poll_fcp_ring(phba);
+		spin_unlock(shost->host_lock);
+		lpfc_sli_handle_fast_ring_event(phba,
+			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
+
+		spin_lock(shost->host_lock);
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
 	}
@@ -3050,7 +3056,8 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	}
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT)
-		lpfc_sli_poll_fcp_ring (phba);
+		lpfc_sli_handle_fast_ring_event(phba,
+			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
 	lpfc_cmd->waitq = &waitq;
 	/* Wait for abort to complete */
@@ -3568,7 +3575,8 @@ lpfc_slave_configure(struct scsi_device 
 	rport->dev_loss_tmo = vport->cfg_devloss_tmo;
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-		lpfc_sli_poll_fcp_ring(phba);
+		lpfc_sli_handle_fast_ring_event(phba,
+			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2009-10-01 17:21:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2009-10-01 17:21:58.000000000 -0400
@@ -352,7 +352,7 @@ struct lpfc_sli4_hba {
 	unsigned long *rpi_bmask;
 	uint16_t rpi_count;
 	struct lpfc_sli4_flags sli4_flags;
-	struct list_head sp_rspiocb_work_queue;
+	struct list_head sp_queue_event;
 	struct list_head sp_cqe_event_pool;
 	struct list_head sp_asynce_work_queue;
 	struct list_head sp_fcp_xri_aborted_work_queue;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-10-01 17:21:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-10-01 17:21:58.000000000 -0400
@@ -59,7 +59,9 @@ typedef enum _lpfc_iocb_type {
 static int lpfc_sli_issue_mbox_s4(struct lpfc_hba *, LPFC_MBOXQ_t *,
 				  uint32_t);
 static int lpfc_sli4_read_rev(struct lpfc_hba *, LPFC_MBOXQ_t *,
-			    uint8_t *, uint32_t *);
+			      uint8_t *, uint32_t *);
+static struct lpfc_iocbq *lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *,
+							 struct lpfc_iocbq *);
 static void lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *,
 				      struct hbq_dmabuf *);
 static IOCB_t *
@@ -2329,168 +2331,6 @@ void lpfc_poll_eratt(unsigned long ptr)
 	return;
 }
 
-/**
- * lpfc_sli_poll_fcp_ring - Handle FCP ring completion in polling mode
- * @phba: Pointer to HBA context object.
- *
- * This function is called from lpfc_queuecommand, lpfc_poll_timeout,
- * lpfc_abort_handler and lpfc_slave_configure when FCP_RING_POLLING
- * is enabled.
- *
- * The caller does not hold any lock.
- * The function processes each response iocb in the response ring until it
- * finds an iocb with LE bit set and chains all the iocbs upto the iocb with
- * LE bit set. The function will call the completion handler of the command iocb
- * if the response iocb indicates a completion for a command iocb or it is
- * an abort completion.
- **/
-void lpfc_sli_poll_fcp_ring(struct lpfc_hba *phba)
-{
-	struct lpfc_sli      *psli  = &phba->sli;
-	struct lpfc_sli_ring *pring = &psli->ring[LPFC_FCP_RING];
-	IOCB_t *irsp = NULL;
-	IOCB_t *entry = NULL;
-	struct lpfc_iocbq *cmdiocbq = NULL;
-	struct lpfc_iocbq rspiocbq;
-	struct lpfc_pgp *pgp = &phba->port_gp[pring->ringno];
-	uint32_t status;
-	uint32_t portRspPut, portRspMax;
-	int type;
-	uint32_t rsp_cmpl = 0;
-	uint32_t ha_copy;
-	unsigned long iflags;
-
-	pring->stats.iocb_event++;
-
-	/*
-	 * The next available response entry should never exceed the maximum
-	 * entries.  If it does, treat it as an adapter hardware error.
-	 */
-	portRspMax = pring->numRiocb;
-	portRspPut = le32_to_cpu(pgp->rspPutInx);
-	if (unlikely(portRspPut >= portRspMax)) {
-		lpfc_sli_rsp_pointers_error(phba, pring);
-		return;
-	}
-
-	rmb();
-	while (pring->rspidx != portRspPut) {
-		entry = lpfc_resp_iocb(phba, pring);
-		if (++pring->rspidx >= portRspMax)
-			pring->rspidx = 0;
-
-		lpfc_sli_pcimem_bcopy((uint32_t *) entry,
-				      (uint32_t *) &rspiocbq.iocb,
-				      phba->iocb_rsp_size);
-		irsp = &rspiocbq.iocb;
-		type = lpfc_sli_iocb_cmd_type(irsp->ulpCommand & CMD_IOCB_MASK);
-		pring->stats.iocb_rsp++;
-		rsp_cmpl++;
-
-		if (unlikely(irsp->ulpStatus)) {
-			/* Rsp ring <ringno> error: IOCB */
-			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-					"0326 Rsp Ring %d error: IOCB Data: "
-					"x%x x%x x%x x%x x%x x%x x%x x%x\n",
-					pring->ringno,
-					irsp->un.ulpWord[0],
-					irsp->un.ulpWord[1],
-					irsp->un.ulpWord[2],
-					irsp->un.ulpWord[3],
-					irsp->un.ulpWord[4],
-					irsp->un.ulpWord[5],
-					*(uint32_t *)&irsp->un1,
-					*((uint32_t *)&irsp->un1 + 1));
-		}
-
-		switch (type) {
-		case LPFC_ABORT_IOCB:
-		case LPFC_SOL_IOCB:
-			/*
-			 * Idle exchange closed via ABTS from port.  No iocb
-			 * resources need to be recovered.
-			 */
-			if (unlikely(irsp->ulpCommand == CMD_XRI_ABORTED_CX)) {
-				lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-						"0314 IOCB cmd 0x%x "
-						"processed. Skipping "
-						"completion",
-						irsp->ulpCommand);
-				break;
-			}
-
-			spin_lock_irqsave(&phba->hbalock, iflags);
-			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
-							 &rspiocbq);
-			spin_unlock_irqrestore(&phba->hbalock, iflags);
-			if ((cmdiocbq) && (cmdiocbq->iocb_cmpl)) {
-				(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
-						      &rspiocbq);
-			}
-			break;
-		default:
-			if (irsp->ulpCommand == CMD_ADAPTER_MSG) {
-				char adaptermsg[LPFC_MAX_ADPTMSG];
-				memset(adaptermsg, 0, LPFC_MAX_ADPTMSG);
-				memcpy(&adaptermsg[0], (uint8_t *) irsp,
-				       MAX_MSG_DATA);
-				dev_warn(&((phba->pcidev)->dev),
-					 "lpfc%d: %s\n",
-					 phba->brd_no, adaptermsg);
-			} else {
-				/* Unknown IOCB command */
-				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-						"0321 Unknown IOCB command "
-						"Data: x%x, x%x x%x x%x x%x\n",
-						type, irsp->ulpCommand,
-						irsp->ulpStatus,
-						irsp->ulpIoTag,
-						irsp->ulpContext);
-			}
-			break;
-		}
-
-		/*
-		 * The response IOCB has been processed.  Update the ring
-		 * pointer in SLIM.  If the port response put pointer has not
-		 * been updated, sync the pgp->rspPutInx and fetch the new port
-		 * response put pointer.
-		 */
-		writel(pring->rspidx, &phba->host_gp[pring->ringno].rspGetInx);
-
-		if (pring->rspidx == portRspPut)
-			portRspPut = le32_to_cpu(pgp->rspPutInx);
-	}
-
-	ha_copy = readl(phba->HAregaddr);
-	ha_copy >>= (LPFC_FCP_RING * 4);
-
-	if ((rsp_cmpl > 0) && (ha_copy & HA_R0RE_REQ)) {
-		spin_lock_irqsave(&phba->hbalock, iflags);
-		pring->stats.iocb_rsp_full++;
-		status = ((CA_R0ATT | CA_R0RE_RSP) << (LPFC_FCP_RING * 4));
-		writel(status, phba->CAregaddr);
-		readl(phba->CAregaddr);
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
-	}
-	if ((ha_copy & HA_R0CE_RSP) &&
-	    (pring->flag & LPFC_CALL_RING_AVAILABLE)) {
-		spin_lock_irqsave(&phba->hbalock, iflags);
-		pring->flag &= ~LPFC_CALL_RING_AVAILABLE;
-		pring->stats.iocb_cmd_empty++;
-
-		/* Force update of the local copy of cmdGetInx */
-		pring->local_getidx = le32_to_cpu(pgp->cmdGetInx);
-		lpfc_sli_resume_iocb(phba, pring);
-
-		if ((pring->lpfc_sli_cmd_available))
-			(pring->lpfc_sli_cmd_available) (phba, pring);
-
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
-	}
-
-	return;
-}
 
 /**
  * lpfc_sli_handle_fast_ring_event - Handle ring events on FCP ring
@@ -2507,9 +2347,9 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
  * an abort completion. The function will call lpfc_sli_process_unsol_iocb
  * function if this is an unsolicited iocb.
  * This routine presumes LPFC_FCP_RING handling and doesn't bother
- * to check it explicitly. This function always returns 1.
- **/
-static int
+ * to check it explicitly.
+ */
+int
 lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				struct lpfc_sli_ring *pring, uint32_t mask)
 {
@@ -2539,6 +2379,11 @@ lpfc_sli_handle_fast_ring_event(struct l
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		return 1;
 	}
+	if (phba->fcp_ring_in_use) {
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		return 1;
+	} else
+		phba->fcp_ring_in_use = 1;
 
 	rmb();
 	while (pring->rspidx != portRspPut) {
@@ -2609,10 +2454,6 @@ lpfc_sli_handle_fast_ring_event(struct l
 			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
 							 &rspiocbq);
 			if ((cmdiocbq) && (cmdiocbq->iocb_cmpl)) {
-				if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-					(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
-							      &rspiocbq);
-				} else {
 					spin_unlock_irqrestore(&phba->hbalock,
 							       iflag);
 					(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
@@ -2620,7 +2461,6 @@ lpfc_sli_handle_fast_ring_event(struct l
 					spin_lock_irqsave(&phba->hbalock,
 							  iflag);
 				}
-			}
 			break;
 		case LPFC_UNSOL_IOCB:
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
@@ -2680,6 +2520,7 @@ lpfc_sli_handle_fast_ring_event(struct l
 
 	}
 
+	phba->fcp_ring_in_use = 0;
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 	return rc;
 }
@@ -3027,10 +2868,13 @@ lpfc_sli_handle_slow_ring_event_s4(struc
 	struct lpfc_cq_event *cq_event;
 	unsigned long iflag;
 
-	while (!list_empty(&phba->sli4_hba.sp_rspiocb_work_queue)) {
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	phba->hba_flag &= ~HBA_SP_QUEUE_EVT;
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	while (!list_empty(&phba->sli4_hba.sp_queue_event)) {
 		/* Get the response iocb from the head of work queue */
 		spin_lock_irqsave(&phba->hbalock, iflag);
-		list_remove_head(&phba->sli4_hba.sp_rspiocb_work_queue,
+		list_remove_head(&phba->sli4_hba.sp_queue_event,
 				 cq_event, struct lpfc_cq_event, list);
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
 
@@ -3038,7 +2882,12 @@ lpfc_sli_handle_slow_ring_event_s4(struc
 		case CQE_CODE_COMPL_WQE:
 			irspiocbq = container_of(cq_event, struct lpfc_iocbq,
 						 cq_event);
-			lpfc_sli_sp_handle_rspiocb(phba, pring, irspiocbq);
+			/* Translate ELS WCQE to response IOCBQ */
+			irspiocbq = lpfc_sli4_els_wcqe_to_rspiocbq(phba,
+								   irspiocbq);
+			if (irspiocbq)
+				lpfc_sli_sp_handle_rspiocb(phba, pring,
+							   irspiocbq);
 			break;
 		case CQE_CODE_RECEIVE:
 			dmabuf = container_of(cq_event, struct hbq_dmabuf,
@@ -4368,6 +4217,13 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	phba->sli_rev = bf_get(lpfc_mbx_rd_rev_sli_lvl, &mqe->un.read_rev);
 	if (bf_get(lpfc_mbx_rd_rev_fcoe, &mqe->un.read_rev))
 		phba->hba_flag |= HBA_FCOE_SUPPORT;
+
+	if (bf_get(lpfc_mbx_rd_rev_cee_ver, &mqe->un.read_rev) ==
+		LPFC_DCBX_CEE_MODE)
+		phba->hba_flag |= HBA_FIP_SUPPORT;
+	else
+		phba->hba_flag &= ~HBA_FIP_SUPPORT;
+
 	if (phba->sli_rev != LPFC_SLI_REV4 ||
 	    !(phba->hba_flag & HBA_FCOE_SUPPORT)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
@@ -4541,10 +4397,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 		rc = -ENODEV;
 		goto out_free_vpd;
 	}
-	if (phba->cfg_enable_fip)
-		bf_set(lpfc_fip_flag, &phba->sli4_hba.sli4_flags, 1);
-	else
-		bf_set(lpfc_fip_flag, &phba->sli4_hba.sli4_flags, 0);
 
 	/* Set up all the queues to the device */
 	rc = lpfc_sli4_queue_setup(phba);
@@ -5905,7 +5757,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 	uint16_t xritag;
 	struct ulp_bde64 *bpl = NULL;
 
-	fip = bf_get(lpfc_fip_flag, &phba->sli4_hba.sli4_flags);
+	fip = phba->hba_flag & HBA_FIP_SUPPORT;
 	/* The fcp commands will set command type */
 	if (iocbq->iocb_flag &  LPFC_IO_FCP)
 		command_type = FCP_COMMAND;
@@ -7046,8 +6898,18 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 		abort_iotag = cmdiocb->iocb.un.acxri.abortIoTag;
 
 		spin_lock_irq(&phba->hbalock);
-		if (abort_iotag != 0 && abort_iotag <= phba->sli.last_iotag)
-			abort_iocb = phba->sli.iocbq_lookup[abort_iotag];
+		if (phba->sli_rev < LPFC_SLI_REV4) {
+			if (abort_iotag != 0 &&
+				abort_iotag <= phba->sli.last_iotag)
+				abort_iocb =
+					phba->sli.iocbq_lookup[abort_iotag];
+		} else
+			/* For sli4 the abort_tag is the XRI,
+			 * so the abort routine puts the iotag  of the iocb
+			 * being aborted in the context field of the abort
+			 * IOCB.
+			 */
+			abort_iocb = phba->sli.iocbq_lookup[abort_context];
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_ELS | LOG_SLI,
 				"0327 Cannot abort els iocb %p "
@@ -7061,9 +6923,18 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 		 *  might have completed already. Do not free it again.
 		 */
 		if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
-			spin_unlock_irq(&phba->hbalock);
-			lpfc_sli_release_iocbq(phba, cmdiocb);
-			return;
+			if (irsp->un.ulpWord[4] != IOERR_NO_XRI) {
+				spin_unlock_irq(&phba->hbalock);
+				lpfc_sli_release_iocbq(phba, cmdiocb);
+				return;
+			}
+			/* For SLI4 the ulpContext field for abort IOCB
+			 * holds the iotag of the IOCB being aborted so
+			 * the local abort_context needs to be reset to
+			 * match the aborted IOCBs ulpContext.
+			 */
+			if (abort_iocb && phba->sli_rev == LPFC_SLI_REV4)
+				abort_context = abort_iocb->iocb.ulpContext;
 		}
 		/*
 		 * make sure we have the right iocbq before taking it
@@ -7182,8 +7053,10 @@ lpfc_sli_issue_abort_iotag(struct lpfc_h
 	iabt = &abtsiocbp->iocb;
 	iabt->un.acxri.abortType = ABORT_TYPE_ABTS;
 	iabt->un.acxri.abortContextTag = icmd->ulpContext;
-	if (phba->sli_rev == LPFC_SLI_REV4)
+	if (phba->sli_rev == LPFC_SLI_REV4) {
 		iabt->un.acxri.abortIoTag = cmdiocb->sli4_xritag;
+		iabt->un.acxri.abortContextTag = cmdiocb->iotag;
+	}
 	else
 		iabt->un.acxri.abortIoTag = icmd->ulpIoTag;
 	iabt->ulpLe = 1;
@@ -8421,7 +8294,6 @@ lpfc_sli4_iocb_param_transfer(struct lpf
 
 	memcpy((char *)pIocbIn + offset, (char *)pIocbOut + offset,
 	       sizeof(struct lpfc_iocbq) - offset);
-	pIocbIn->cq_event.cqe.wcqe_cmpl = *wcqe;
 	/* Map WCQE parameters into irspiocb parameters */
 	pIocbIn->iocb.ulpStatus = bf_get(lpfc_wcqe_c_status, wcqe);
 	if (pIocbOut->iocb_flag & LPFC_IO_FCP)
@@ -8436,6 +8308,49 @@ lpfc_sli4_iocb_param_transfer(struct lpf
 }
 
 /**
+ * lpfc_sli4_els_wcqe_to_rspiocbq - Get response iocbq from els wcqe
+ * @phba: Pointer to HBA context object.
+ * @wcqe: Pointer to work-queue completion queue entry.
+ *
+ * This routine handles an ELS work-queue completion event and construct
+ * a pseudo response ELS IODBQ from the SLI4 ELS WCQE for the common
+ * discovery engine to handle.
+ *
+ * Return: Pointer to the receive IOCBQ, NULL otherwise.
+ **/
+static struct lpfc_iocbq *
+lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
+			       struct lpfc_iocbq *irspiocbq)
+{
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct lpfc_iocbq *cmdiocbq;
+	struct lpfc_wcqe_complete *wcqe;
+	unsigned long iflags;
+
+	wcqe = &irspiocbq->cq_event.cqe.wcqe_cmpl;
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	pring->stats.iocb_event++;
+	/* Look up the ELS command IOCB and create pseudo response IOCB */
+	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
+				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	if (unlikely(!cmdiocbq)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+				"0386 ELS complete with no corresponding "
+				"cmdiocb: iotag (%d)\n",
+				bf_get(lpfc_wcqe_c_request_tag, wcqe));
+		lpfc_sli_release_iocbq(phba, irspiocbq);
+		return NULL;
+	}
+
+	/* Fake the irspiocbq and copy necessary response information */
+	lpfc_sli4_iocb_param_transfer(irspiocbq, cmdiocbq, wcqe);
+
+	return irspiocbq;
+}
+
+/**
  * lpfc_sli4_sp_handle_async_event - Handle an asynchroous event
  * @phba: Pointer to HBA context object.
  * @cqe: Pointer to mailbox completion queue entry.
@@ -8625,46 +8540,26 @@ static bool
 lpfc_sli4_sp_handle_els_wcqe(struct lpfc_hba *phba,
 			     struct lpfc_wcqe_complete *wcqe)
 {
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
-	struct lpfc_iocbq *cmdiocbq;
 	struct lpfc_iocbq *irspiocbq;
 	unsigned long iflags;
-	bool workposted = false;
 
-	spin_lock_irqsave(&phba->hbalock, iflags);
-	pring->stats.iocb_event++;
-	/* Look up the ELS command IOCB and create pseudo response IOCB */
-	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
-				bf_get(lpfc_wcqe_c_request_tag, wcqe));
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
-
-	if (unlikely(!cmdiocbq)) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-				"0386 ELS complete with no corresponding "
-				"cmdiocb: iotag (%d)\n",
-				bf_get(lpfc_wcqe_c_request_tag, wcqe));
-		return workposted;
-	}
-
-	/* Fake the irspiocbq and copy necessary response information */
+	/* Get an irspiocbq for later ELS response processing use */
 	irspiocbq = lpfc_sli_get_iocbq(phba);
 	if (!irspiocbq) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0387 Failed to allocate an iocbq\n");
-		return workposted;
+		return false;
 	}
-	lpfc_sli4_iocb_param_transfer(irspiocbq, cmdiocbq, wcqe);
 
-	/* Add the irspiocb to the response IOCB work list */
+	/* Save off the slow-path queue event for work thread to process */
+	memcpy(&irspiocbq->cq_event.cqe.wcqe_cmpl, wcqe, sizeof(*wcqe));
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	list_add_tail(&irspiocbq->cq_event.list,
-		      &phba->sli4_hba.sp_rspiocb_work_queue);
-	/* Indicate ELS ring attention */
-	phba->work_ha |= (HA_R0ATT << (4*LPFC_ELS_RING));
+		      &phba->sli4_hba.sp_queue_event);
+	phba->hba_flag |= HBA_SP_QUEUE_EVT;
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
-	workposted = true;
 
-	return workposted;
+	return true;
 }
 
 /**
@@ -8769,8 +8664,6 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba
 	unsigned long iflags;
 
 	lpfc_sli4_rq_release(hrq, drq);
-	if (bf_get(lpfc_rcqe_code, rcqe) != CQE_CODE_RECEIVE)
-		goto out;
 	if (bf_get(lpfc_rcqe_rq_id, rcqe) != hrq->queue_id)
 		goto out;
 
@@ -8789,9 +8682,9 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba
 		memcpy(&dma_buf->cq_event.cqe.rcqe_cmpl, rcqe, sizeof(*rcqe));
 		/* save off the frame for the word thread to process */
 		list_add_tail(&dma_buf->cq_event.list,
-			      &phba->sli4_hba.sp_rspiocb_work_queue);
+			      &phba->sli4_hba.sp_queue_event);
 		/* Frame received */
-		phba->hba_flag |= HBA_RECEIVE_BUFFER;
+		phba->hba_flag |= HBA_SP_QUEUE_EVT;
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		workposted = true;
 		break;
@@ -8806,7 +8699,6 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba
 	}
 out:
 	return workposted;
-
 }
 
 /**
@@ -8824,38 +8716,38 @@ static bool
 lpfc_sli4_sp_handle_cqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			 struct lpfc_cqe *cqe)
 {
-	struct lpfc_wcqe_complete wcqe;
+	struct lpfc_cqe cqevt;
 	bool workposted = false;
 
 	/* Copy the work queue CQE and convert endian order if needed */
-	lpfc_sli_pcimem_bcopy(cqe, &wcqe, sizeof(struct lpfc_cqe));
+	lpfc_sli_pcimem_bcopy(cqe, &cqevt, sizeof(struct lpfc_cqe));
 
 	/* Check and process for different type of WCQE and dispatch */
-	switch (bf_get(lpfc_wcqe_c_code, &wcqe)) {
+	switch (bf_get(lpfc_cqe_code, &cqevt)) {
 	case CQE_CODE_COMPL_WQE:
-		/* Process the WQ complete event */
+		/* Process the WQ/RQ complete event */
 		workposted = lpfc_sli4_sp_handle_els_wcqe(phba,
-					(struct lpfc_wcqe_complete *)&wcqe);
+				(struct lpfc_wcqe_complete *)&cqevt);
 		break;
 	case CQE_CODE_RELEASE_WQE:
 		/* Process the WQ release event */
 		lpfc_sli4_sp_handle_rel_wcqe(phba,
-					(struct lpfc_wcqe_release *)&wcqe);
+				(struct lpfc_wcqe_release *)&cqevt);
 		break;
 	case CQE_CODE_XRI_ABORTED:
 		/* Process the WQ XRI abort event */
 		workposted = lpfc_sli4_sp_handle_abort_xri_wcqe(phba, cq,
-					(struct sli4_wcqe_xri_aborted *)&wcqe);
+				(struct sli4_wcqe_xri_aborted *)&cqevt);
 		break;
 	case CQE_CODE_RECEIVE:
 		/* Process the RQ event */
 		workposted = lpfc_sli4_sp_handle_rcqe(phba,
-					(struct lpfc_rcqe *)&wcqe);
+				(struct lpfc_rcqe *)&cqevt);
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0388 Not a valid WCQE code: x%x\n",
-				bf_get(lpfc_wcqe_c_code, &wcqe));
+				bf_get(lpfc_cqe_code, &cqevt));
 		break;
 	}
 	return workposted;
@@ -10841,6 +10733,105 @@ lpfc_fc_frame_to_vport(struct lpfc_hba *
 }
 
 /**
+ * lpfc_update_rcv_time_stamp - Update vport's rcv seq time stamp
+ * @vport: The vport to work on.
+ *
+ * This function updates the receive sequence time stamp for this vport. The
+ * receive sequence time stamp indicates the time that the last frame of the
+ * the sequence that has been idle for the longest amount of time was received.
+ * the driver uses this time stamp to indicate if any received sequences have
+ * timed out.
+ **/
+void
+lpfc_update_rcv_time_stamp(struct lpfc_vport *vport)
+{
+	struct lpfc_dmabuf *h_buf;
+	struct hbq_dmabuf *dmabuf = NULL;
+
+	/* get the oldest sequence on the rcv list */
+	h_buf = list_get_first(&vport->rcv_buffer_list,
+			       struct lpfc_dmabuf, list);
+	if (!h_buf)
+		return;
+	dmabuf = container_of(h_buf, struct hbq_dmabuf, hbuf);
+	vport->rcv_buffer_time_stamp = dmabuf->time_stamp;
+}
+
+/**
+ * lpfc_cleanup_rcv_buffers - Cleans up all outstanding receive sequences.
+ * @vport: The vport that the received sequences were sent to.
+ *
+ * This function cleans up all outstanding received sequences. This is called
+ * by the driver when a link event or user action invalidates all the received
+ * sequences.
+ **/
+void
+lpfc_cleanup_rcv_buffers(struct lpfc_vport *vport)
+{
+	struct lpfc_dmabuf *h_buf, *hnext;
+	struct lpfc_dmabuf *d_buf, *dnext;
+	struct hbq_dmabuf *dmabuf = NULL;
+
+	/* start with the oldest sequence on the rcv list */
+	list_for_each_entry_safe(h_buf, hnext, &vport->rcv_buffer_list, list) {
+		dmabuf = container_of(h_buf, struct hbq_dmabuf, hbuf);
+		list_del_init(&dmabuf->hbuf.list);
+		list_for_each_entry_safe(d_buf, dnext,
+					 &dmabuf->dbuf.list, list) {
+			list_del_init(&d_buf->list);
+			lpfc_in_buf_free(vport->phba, d_buf);
+		}
+		lpfc_in_buf_free(vport->phba, &dmabuf->dbuf);
+	}
+}
+
+/**
+ * lpfc_rcv_seq_check_edtov - Cleans up timed out receive sequences.
+ * @vport: The vport that the received sequences were sent to.
+ *
+ * This function determines whether any received sequences have timed out by
+ * first checking the vport's rcv_buffer_time_stamp. If this time_stamp
+ * indicates that there is at least one timed out sequence this routine will
+ * go through the received sequences one at a time from most inactive to most
+ * active to determine which ones need to be cleaned up. Once it has determined
+ * that a sequence needs to be cleaned up it will simply free up the resources
+ * without sending an abort.
+ **/
+void
+lpfc_rcv_seq_check_edtov(struct lpfc_vport *vport)
+{
+	struct lpfc_dmabuf *h_buf, *hnext;
+	struct lpfc_dmabuf *d_buf, *dnext;
+	struct hbq_dmabuf *dmabuf = NULL;
+	unsigned long timeout;
+	int abort_count = 0;
+
+	timeout = (msecs_to_jiffies(vport->phba->fc_edtov) +
+		   vport->rcv_buffer_time_stamp);
+	if (list_empty(&vport->rcv_buffer_list) ||
+	    time_before(jiffies, timeout))
+		return;
+	/* start with the oldest sequence on the rcv list */
+	list_for_each_entry_safe(h_buf, hnext, &vport->rcv_buffer_list, list) {
+		dmabuf = container_of(h_buf, struct hbq_dmabuf, hbuf);
+		timeout = (msecs_to_jiffies(vport->phba->fc_edtov) +
+			   dmabuf->time_stamp);
+		if (time_before(jiffies, timeout))
+			break;
+		abort_count++;
+		list_del_init(&dmabuf->hbuf.list);
+		list_for_each_entry_safe(d_buf, dnext,
+					 &dmabuf->dbuf.list, list) {
+			list_del_init(&d_buf->list);
+			lpfc_in_buf_free(vport->phba, d_buf);
+		}
+		lpfc_in_buf_free(vport->phba, &dmabuf->dbuf);
+	}
+	if (abort_count)
+		lpfc_update_rcv_time_stamp(vport);
+}
+
+/**
  * lpfc_fc_frame_add - Adds a frame to the vport's list of received sequences
  * @dmabuf: pointer to a dmabuf that describes the hdr and data of the FC frame
  *
@@ -10863,6 +10854,7 @@ lpfc_fc_frame_add(struct lpfc_vport *vpo
 	struct hbq_dmabuf *temp_dmabuf = NULL;
 
 	INIT_LIST_HEAD(&dmabuf->dbuf.list);
+	dmabuf->time_stamp = jiffies;
 	new_hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
 	/* Use the hdr_buf to find the sequence that this frame belongs to */
 	list_for_each_entry(h_buf, &vport->rcv_buffer_list, list) {
@@ -10881,6 +10873,7 @@ lpfc_fc_frame_add(struct lpfc_vport *vpo
 		 * Queue the buffer on the vport's rcv_buffer_list.
 		 */
 		list_add_tail(&dmabuf->hbuf.list, &vport->rcv_buffer_list);
+		lpfc_update_rcv_time_stamp(vport);
 		return dmabuf;
 	}
 	temp_hdr = seq_dmabuf->hbuf.virt;
@@ -10888,8 +10881,13 @@ lpfc_fc_frame_add(struct lpfc_vport *vpo
 		list_del_init(&seq_dmabuf->hbuf.list);
 		list_add_tail(&dmabuf->hbuf.list, &vport->rcv_buffer_list);
 		list_add_tail(&dmabuf->dbuf.list, &seq_dmabuf->dbuf.list);
+		lpfc_update_rcv_time_stamp(vport);
 		return dmabuf;
 	}
+	/* move this sequence to the tail to indicate a young sequence */
+	list_move_tail(&seq_dmabuf->hbuf.list, &vport->rcv_buffer_list);
+	seq_dmabuf->time_stamp = jiffies;
+	lpfc_update_rcv_time_stamp(vport);
 	/* find the correct place in the sequence to insert this frame */
 	list_for_each_entry_reverse(d_buf, &seq_dmabuf->dbuf.list, list) {
 		temp_dmabuf = container_of(d_buf, struct hbq_dmabuf, dbuf);
@@ -11148,6 +11146,7 @@ lpfc_prep_seq(struct lpfc_vport *vport, 
 	fc_hdr = (struct fc_frame_header *)seq_dmabuf->hbuf.virt;
 	/* remove from receive buffer list */
 	list_del_init(&seq_dmabuf->hbuf.list);
+	lpfc_update_rcv_time_stamp(vport);
 	/* get the Remote Port's SID */
 	sid = sli4_sid_from_fc_hdr(fc_hdr);
 	/* Get an iocbq struct to fill in. */
@@ -11274,11 +11273,6 @@ lpfc_sli4_handle_received_buffer(struct 
 	struct lpfc_vport *vport;
 	uint32_t fcfi;
 
-	/* Clear hba flag and get all received buffers into the cmplq */
-	spin_lock_irq(&phba->hbalock);
-	phba->hba_flag &= ~HBA_RECEIVE_BUFFER;
-	spin_unlock_irq(&phba->hbalock);
-
 	/* Process each received buffer */
 	fc_hdr = (struct fc_frame_header *)dmabuf->hbuf.virt;
 	/* check to see if this a valid type of frame */
@@ -11309,9 +11303,9 @@ lpfc_sli4_handle_received_buffer(struct 
 	/* If not last frame in sequence continue processing frames. */
 	if (!lpfc_seq_complete(seq_dmabuf)) {
 		/*
-		* When saving off frames post a new one and mark this
-		* frame to be freed when it is finished.
-		**/
+		 * When saving off frames post a new one and mark this
+		 * frame to be freed when it is finished.
+		 **/
 		lpfc_sli_hbqbuf_fill_hbqs(phba, LPFC_ELS_HBQ, 1);
 		dmabuf->tag = -1;
 		return;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2009-10-01 17:20:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2009-10-01 17:21:58.000000000 -0400
@@ -49,6 +49,7 @@ struct lpfc_iocbq {
 	struct list_head clist;
 	uint16_t iotag;         /* pre-assigned IO tag */
 	uint16_t sli4_xritag;   /* pre-assigned XRI, (OXID) tag. */
+	struct lpfc_cq_event cq_event;
 
 	IOCB_t iocb;		/* IOCB cmd */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
@@ -79,7 +80,6 @@ struct lpfc_iocbq {
 			   struct lpfc_iocbq *);
 	void (*iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
 			   struct lpfc_iocbq *);
-	struct lpfc_cq_event cq_event;
 };
 
 #define SLI_IOCB_RET_IOCB      1	/* Return IOCB if cmd ring full */


