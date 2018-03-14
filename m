From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.16-rc5
Date: Wed, 14 Mar 2018 16:28:36 -0700
Message-ID: <1521070116.4508.94.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is four patches, consisting of one regression from the merge
window (qla2xxx) one lonstanding memory leak (sd_zbc) one event queue
mislabelling which we want to eliminate to discourage the pattern
(mpt3sas) and one behaviour change because re-reading the partition
table shouldn't clear the ro flag.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bill Kuzeja (1):
      scsi: qla2xxx: Fix crashes in qla2x00_probe_one on probe failure

Damien Le Moal (1):
      scsi: sd_zbc: Fix potential memory leak

Hannes Reinecke (1):
      scsi: mpt3sas: Do not mark fw_event workqueue as WQ_MEM_RECLAIM

Jeremy Cline (1):
      scsi: sd: Keep disk read-only when re-reading partition

And the diffstat:

 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  2 +-
 drivers/scsi/qla2xxx/qla_os.c        | 59 ++++++++++++++++++++++--------------
 drivers/scsi/sd.c                    |  3 +-
 drivers/scsi/sd_zbc.c                | 35 +++++++++------------
 4 files changed, 55 insertions(+), 44 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c2ea13c7e37e..a1cb0236c550 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10558,7 +10558,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
 	    "fw_event_%s%d", ioc->driver_name, ioc->id);
 	ioc->firmware_event_thread = alloc_ordered_workqueue(
-	    ioc->firmware_event_name, WQ_MEM_RECLAIM);
+	    ioc->firmware_event_name, 0);
 	if (!ioc->firmware_event_thread) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 285911e81728..5c5dcca4d1da 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -454,7 +454,7 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
 	ha->req_q_map[0] = req;
 	set_bit(0, ha->rsp_qid_map);
 	set_bit(0, ha->req_qid_map);
-	return 1;
+	return 0;
 
 fail_qpair_map:
 	kfree(ha->base_qpair);
@@ -471,6 +471,9 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
 
 static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
 {
+	if (!ha->req_q_map)
+		return;
+
 	if (IS_QLAFX00(ha)) {
 		if (req && req->ring_fx00)
 			dma_free_coherent(&ha->pdev->dev,
@@ -481,14 +484,17 @@ static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
 		(req->length + 1) * sizeof(request_t),
 		req->ring, req->dma);
 
-	if (req)
+	if (req) {
 		kfree(req->outstanding_cmds);
-
-	kfree(req);
+		kfree(req);
+	}
 }
 
 static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
+	if (!ha->rsp_q_map)
+		return;
+
 	if (IS_QLAFX00(ha)) {
 		if (rsp && rsp->ring)
 			dma_free_coherent(&ha->pdev->dev,
@@ -499,7 +505,8 @@ static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
 		(rsp->length + 1) * sizeof(response_t),
 		rsp->ring, rsp->dma);
 	}
-	kfree(rsp);
+	if (rsp)
+		kfree(rsp);
 }
 
 static void qla2x00_free_queues(struct qla_hw_data *ha)
@@ -1723,6 +1730,8 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 	struct qla_tgt_cmd *cmd;
 	uint8_t trace = 0;
 
+	if (!ha->req_q_map)
+		return;
 	spin_lock_irqsave(qp->qp_lock_ptr, flags);
 	req = qp->req;
 	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
@@ -3095,14 +3104,14 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
 	if (ret)
-		goto probe_hw_failed;
+		goto probe_failed;
 
 	/* Alloc arrays of request and response ring ptrs */
-	if (!qla2x00_alloc_queues(ha, req, rsp)) {
+	if (qla2x00_alloc_queues(ha, req, rsp)) {
 		ql_log(ql_log_fatal, base_vha, 0x003d,
 		    "Failed to allocate memory for queue pointers..."
 		    "aborting.\n");
-		goto probe_init_failed;
+		goto probe_failed;
 	}
 
 	if (ha->mqenable && shost_use_blk_mq(host)) {
@@ -3387,15 +3396,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
-probe_init_failed:
-	qla2x00_free_req_que(ha, req);
-	ha->req_q_map[0] = NULL;
-	clear_bit(0, ha->req_qid_map);
-	qla2x00_free_rsp_que(ha, rsp);
-	ha->rsp_q_map[0] = NULL;
-	clear_bit(0, ha->rsp_qid_map);
-	ha->max_req_queues = ha->max_rsp_queues = 0;
-
 probe_failed:
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
@@ -4508,11 +4508,17 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	if (ha->init_cb)
 		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
 			ha->init_cb, ha->init_cb_dma);
-	vfree(ha->optrom_buffer);
-	kfree(ha->nvram);
-	kfree(ha->npiv_info);
-	kfree(ha->swl);
-	kfree(ha->loop_id_map);
+
+	if (ha->optrom_buffer)
+		vfree(ha->optrom_buffer);
+	if (ha->nvram)
+		kfree(ha->nvram);
+	if (ha->npiv_info)
+		kfree(ha->npiv_info);
+	if (ha->swl)
+		kfree(ha->swl);
+	if (ha->loop_id_map)
+		kfree(ha->loop_id_map);
 
 	ha->srb_mempool = NULL;
 	ha->ctx_mempool = NULL;
@@ -4528,6 +4534,15 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->ex_init_cb_dma = 0;
 	ha->async_pd = NULL;
 	ha->async_pd_dma = 0;
+	ha->loop_id_map = NULL;
+	ha->npiv_info = NULL;
+	ha->optrom_buffer = NULL;
+	ha->swl = NULL;
+	ha->nvram = NULL;
+	ha->mctp_dump = NULL;
+	ha->dcbx_tlv = NULL;
+	ha->xgmac_data = NULL;
+	ha->sfp_data = NULL;
 
 	ha->s_dma_pool = NULL;
 	ha->dl_dma_pool = NULL;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ab75ebd518a7..3b45f7fc5620 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2624,6 +2624,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 	int res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
+	int disk_ro = get_disk_ro(sdkp->disk);
 	int old_wp = sdkp->write_prot;
 
 	set_disk_ro(sdkp->disk, 0);
@@ -2664,7 +2665,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 			  "Test WP failed, assume Write Enabled\n");
 	} else {
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
-		set_disk_ro(sdkp->disk, sdkp->write_prot);
+		set_disk_ro(sdkp->disk, sdkp->write_prot || disk_ro);
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
 			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
 				  sdkp->write_prot ? "on" : "off");
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 27793b9f54c0..9049a189c8e5 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -486,7 +486,7 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf)
  */
 static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 {
-	u64 zone_blocks;
+	u64 zone_blocks = 0;
 	sector_t block = 0;
 	unsigned char *buf;
 	unsigned char *rec;
@@ -504,10 +504,8 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 
 	/* Do a report zone to get the same field */
 	ret = sd_zbc_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, 0);
-	if (ret) {
-		zone_blocks = 0;
-		goto out;
-	}
+	if (ret)
+		goto out_free;
 
 	same = buf[4] & 0x0f;
 	if (same > 0) {
@@ -547,7 +545,7 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 			ret = sd_zbc_report_zones(sdkp, buf,
 						  SD_ZBC_BUF_SIZE, block);
 			if (ret)
-				return ret;
+				goto out_free;
 		}
 
 	} while (block < sdkp->capacity);
@@ -555,35 +553,32 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 	zone_blocks = sdkp->zone_blocks;
 
 out:
-	kfree(buf);
-
 	if (!zone_blocks) {
 		if (sdkp->first_scan)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Devices with non constant zone "
 				  "size are not supported\n");
-		return -ENODEV;
-	}
-
-	if (!is_power_of_2(zone_blocks)) {
+		ret = -ENODEV;
+	} else if (!is_power_of_2(zone_blocks)) {
 		if (sdkp->first_scan)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Devices with non power of 2 zone "
 				  "size are not supported\n");
-		return -ENODEV;
-	}
-
-	if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {
+		ret = -ENODEV;
+	} else if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {
 		if (sdkp->first_scan)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Zone size too large\n");
-		return -ENODEV;
+		ret = -ENODEV;
+	} else {
+		sdkp->zone_blocks = zone_blocks;
+		sdkp->zone_shift = ilog2(zone_blocks);
 	}
 
-	sdkp->zone_blocks = zone_blocks;
-	sdkp->zone_shift = ilog2(zone_blocks);
+out_free:
+	kfree(buf);
 
-	return 0;
+	return ret;
 }
 
 static int sd_zbc_setup(struct scsi_disk *sdkp)
