From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] SCSI fixes for 2.6.34-rc5
Date: Thu, 22 Apr 2010 10:17:05 -0400
Message-ID: <1271945825.2889.138.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47389 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab0DVORM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2010 10:17:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

This is just a small set of bug fixes, mostly around locking problems
but a few iscsi/IP related ones as well.

The fix is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Anil Veerabhadrappa (1):
      bnx2i: Bug fixes related to MTU change issue when there are active iscsi sessions

Christof Schmitt (2):
      zfcp: Fix tracing of requests with error status
      zfcp: Update MAINTAINERS entry

Dan Carpenter (2):
      wd7000: fix reset handler typo spin_unlock_irq() => spin_lock_irq()
      dpt_i2o: several use after free issues

FUJITA Tomonori (1):
      ibmvscsi: fix DMA API misuse

Jiri Slaby (3):
      qla2xxx: fix lock imbalance
      lpfc: fix lock imbalances
      be2iscsi: fix lock imbalance

Mike Christie (1):
      iscsi_tcp: fix relogin/shutdown hang

And the diffstat:

 MAINTAINERS                      |    3 +--
 drivers/s390/scsi/zfcp_fsf.c     |    6 +++---
 drivers/scsi/be2iscsi/be_mgmt.c  |    1 +
 drivers/scsi/bnx2i/bnx2i.h       |    2 ++
 drivers/scsi/bnx2i/bnx2i_init.c  |   13 ++++++++++++-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   13 ++++++++++---
 drivers/scsi/dpt_i2o.c           |   15 +++++++++------
 drivers/scsi/ibmvscsi/ibmvscsi.c |   29 ++---------------------------
 drivers/scsi/iscsi_tcp.c         |    2 +-
 drivers/scsi/lpfc/lpfc_bsg.c     |    4 ++--
 drivers/scsi/qla2xxx/qla_attr.c  |    1 +
 drivers/scsi/wd7000.c            |    2 +-
 12 files changed, 45 insertions(+), 46 deletions(-)

Full diff is below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a9ccda..e149665 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4781,12 +4781,11 @@ F:	drivers/s390/crypto/
 
 S390 ZFCP DRIVER
 M:	Christof Schmitt <christof.schmitt@de.ibm.com>
-M:	Martin Peschke <mp3@de.ibm.com>
+M:	Swen Schillig <swen@vnet.ibm.com>
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
-F:	Documentation/s390/zfcpdump.txt
 F:	drivers/s390/scsi/zfcp_*
 
 S390 IUCV NETWORK LAYER
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 1856489..b3b1d2f 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2105,7 +2105,8 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)
 	blktrc.inb_usage = req->qdio_req.qdio_inb_usage;
 	blktrc.outb_usage = req->qdio_req.qdio_outb_usage;
 
-	if (req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA) {
+	if (req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA &&
+	    !(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
 		blktrc.flags |= ZFCP_BLK_LAT_VALID;
 		blktrc.channel_lat = lat_in->channel_lat * ticks;
 		blktrc.fabric_lat = lat_in->fabric_lat * ticks;
@@ -2157,9 +2158,8 @@ static void zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *req)
 	fcp_rsp = (struct fcp_resp_with_ext *) &req->qtcb->bottom.io.fcp_rsp;
 	zfcp_fc_eval_fcp_rsp(fcp_rsp, scpnt);
 
-	zfcp_fsf_req_trace(req, scpnt);
-
 skip_fsfstatus:
+	zfcp_fsf_req_trace(req, scpnt);
 	zfcp_dbf_scsi_result(req->adapter->dbf, scpnt, req);
 
 	scpnt->host_scribble = NULL;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 72617b6..e641922 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -169,6 +169,7 @@ unsigned char mgmt_invalidate_icds(struct beiscsi_hba *phba,
 		SE_DEBUG(DBG_LVL_1,
 			 "Failed to allocate memory for"
 			 "mgmt_invalidate_icds \n");
+		spin_unlock(&ctrl->mbox_lock);
 		return -1;
 	}
 	nonemb_cmd.size = sizeof(struct invalidate_commands_params_in);
diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 6cf9dc3..6b624e7 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -362,6 +362,7 @@ struct bnx2i_hba {
 	u32 num_ccell;
 
 	int ofld_conns_active;
+	wait_queue_head_t eh_wait;
 
 	int max_active_conns;
 	struct iscsi_cid_queue cid_que;
@@ -381,6 +382,7 @@ struct bnx2i_hba {
 	spinlock_t lock;	/* protects hba structure access */
 	struct mutex net_dev_lock;/* sync net device access */
 
+	int hba_shutdown_tmo;
 	/*
 	 * PCI related info.
 	 */
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 6d8172e..5d9296c 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -177,11 +177,22 @@ void bnx2i_stop(void *handle)
 	struct bnx2i_hba *hba = handle;
 
 	/* check if cleanup happened in GOING_DOWN context */
-	clear_bit(ADAPTER_STATE_UP, &hba->adapter_state);
 	if (!test_and_clear_bit(ADAPTER_STATE_GOING_DOWN,
 				&hba->adapter_state))
 		iscsi_host_for_each_session(hba->shost,
 					    bnx2i_drop_session);
+
+	/* Wait for all endpoints to be torn down, Chip will be reset once
+	 *  control returns to network driver. So it is required to cleanup and
+	 * release all connection resources before returning from this routine.
+	 */
+	wait_event_interruptible_timeout(hba->eh_wait,
+					 (hba->ofld_conns_active == 0),
+					 hba->hba_shutdown_tmo);
+	/* This flag should be cleared last so that ep_disconnect() gracefully
+	 * cleans up connection context
+	 */
+	clear_bit(ADAPTER_STATE_UP, &hba->adapter_state);
 }
 
 /**
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f2e9b18..fa68ab3 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -820,6 +820,11 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 
 	spin_lock_init(&hba->lock);
 	mutex_init(&hba->net_dev_lock);
+	init_waitqueue_head(&hba->eh_wait);
+	if (test_bit(BNX2I_NX2_DEV_57710, &hba->cnic_dev_type))
+		hba->hba_shutdown_tmo = 240 * HZ;
+	else	/* 5706/5708/5709 */
+		hba->hba_shutdown_tmo = 30 * HZ;
 
 	if (iscsi_host_add(shost, &hba->pcidev->dev))
 		goto free_dump_mem;
@@ -1658,8 +1663,8 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 		 */
 		hba = bnx2i_check_route(dst_addr);
 
-	if (!hba) {
-		rc = -ENOMEM;
+	if (!hba || test_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state)) {
+		rc = -EINVAL;
 		goto check_busy;
 	}
 
@@ -1804,7 +1809,7 @@ static int bnx2i_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 					       (bnx2i_ep->state ==
 						EP_STATE_CONNECT_COMPL)),
 					      msecs_to_jiffies(timeout_ms));
-	if (!rc || (bnx2i_ep->state == EP_STATE_OFLD_FAILED))
+	if (bnx2i_ep->state == EP_STATE_OFLD_FAILED)
 		rc = -1;
 
 	if (rc > 0)
@@ -1957,6 +1962,8 @@ return_bnx2i_ep:
 
 	if (!hba->ofld_conns_active)
 		bnx2i_unreg_dev_all();
+
+	wake_up_interruptible(&hba->eh_wait);
 }
 
 
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 4967643..0435d04 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -188,7 +188,8 @@ MODULE_DEVICE_TABLE(pci,dptids);
 static int adpt_detect(struct scsi_host_template* sht)
 {
 	struct pci_dev *pDev = NULL;
-	adpt_hba* pHba;
+	adpt_hba *pHba;
+	adpt_hba *next;
 
 	PINFO("Detecting Adaptec I2O RAID controllers...\n");
 
@@ -206,7 +207,8 @@ static int adpt_detect(struct scsi_host_template* sht)
 	}
 
 	/* In INIT state, Activate IOPs */
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
 		// Activate does get status , init outbound, and get hrt
 		if (adpt_i2o_activate_hba(pHba) < 0) {
 			adpt_i2o_delete_hba(pHba);
@@ -243,7 +245,8 @@ rebuild_sys_tab:
 	PDEBUG("HBA's in OPERATIONAL state\n");
 
 	printk("dpti: If you have a lot of devices this could take a few minutes.\n");
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
 		printk(KERN_INFO"%s: Reading the hardware resource table.\n", pHba->name);
 		if (adpt_i2o_lct_get(pHba) < 0){
 			adpt_i2o_delete_hba(pHba);
@@ -263,7 +266,8 @@ rebuild_sys_tab:
 		adpt_sysfs_class = NULL;
 	}
 
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
 		if (adpt_scsi_host_alloc(pHba, sht) < 0){
 			adpt_i2o_delete_hba(pHba);
 			continue;
@@ -1229,11 +1233,10 @@ static void adpt_i2o_delete_hba(adpt_hba* pHba)
 		}
 	}
 	pci_dev_put(pHba->pDev);
-	kfree(pHba);
-
 	if (adpt_sysfs_class)
 		device_destroy(adpt_sysfs_class,
 				MKDEV(DPTI_I2O_MAJOR, pHba->unit));
+	kfree(pHba);
 
 	if(hba_count <= 0){
 		unregister_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER);   
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index ff5ec5a..88bad0e 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -323,16 +323,6 @@ static void set_srp_direction(struct scsi_cmnd *cmd,
 		srp_cmd->buf_fmt = fmt;
 }
 
-static void unmap_sg_list(int num_entries,
-		struct device *dev,
-		struct srp_direct_buf *md)
-{
-	int i;
-
-	for (i = 0; i < num_entries; ++i)
-		dma_unmap_single(dev, md[i].va, md[i].len, DMA_BIDIRECTIONAL);
-}
-
 /**
  * unmap_cmd_data: - Unmap data pointed in srp_cmd based on the format
  * @cmd:	srp_cmd whose additional_data member will be unmapped
@@ -350,24 +340,9 @@ static void unmap_cmd_data(struct srp_cmd *cmd,
 
 	if (out_fmt == SRP_NO_DATA_DESC && in_fmt == SRP_NO_DATA_DESC)
 		return;
-	else if (out_fmt == SRP_DATA_DESC_DIRECT ||
-		 in_fmt == SRP_DATA_DESC_DIRECT) {
-		struct srp_direct_buf *data =
-			(struct srp_direct_buf *) cmd->add_data;
-		dma_unmap_single(dev, data->va, data->len, DMA_BIDIRECTIONAL);
-	} else {
-		struct srp_indirect_buf *indirect =
-			(struct srp_indirect_buf *) cmd->add_data;
-		int num_mapped = indirect->table_desc.len /
-			sizeof(struct srp_direct_buf);
 
-		if (num_mapped <= MAX_INDIRECT_BUFS) {
-			unmap_sg_list(num_mapped, dev, &indirect->desc_list[0]);
-			return;
-		}
-
-		unmap_sg_list(num_mapped, dev, evt_struct->ext_list);
-	}
+	if (evt_struct->cmnd)
+		scsi_dma_unmap(evt_struct->cmnd);
 }
 
 static int map_sg_list(struct scsi_cmnd *cmd, int nseg,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 0ee725c..02143af 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -599,7 +599,7 @@ static void iscsi_sw_tcp_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
 	write_unlock_bh(&tcp_sw_conn->sock->sk->sk_callback_lock);
 
-	if (sock->sk->sk_sleep && waitqueue_active(sock->sk->sk_sleep)) {
+	if (sock->sk->sk_sleep) {
 		sock->sk->sk_err = EIO;
 		wake_up_interruptible(sock->sk->sk_sleep);
 	}
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index ec37238..d62b3e4 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -433,7 +433,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
 	dd_data = cmdiocbq->context1;
 	/* normal completion and timeout crossed paths, already done */
 	if (!dd_data) {
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		return;
 	}
 
@@ -1196,7 +1196,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
 	dd_data = cmdiocbq->context1;
 	/* normal completion and timeout crossed paths, already done */
 	if (!dd_data) {
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		return;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 359e9a7..1c7ef55 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2393,6 +2393,7 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 	return 0;
 
 done:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	if (bsg_job->request->msgcode == FC_BSG_HST_CT)
 		kfree(sp->fcport);
 	kfree(sp->ctx);
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index d0b7d2f..333580b 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1587,7 +1587,7 @@ static int wd7000_host_reset(struct scsi_cmnd *SCpnt)
 {
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(SCpnt->device->host->host_lock);
 
 	if (wd7000_adapter_reset(host) < 0) {
 		spin_unlock_irq(SCpnt->device->host->host_lock);


