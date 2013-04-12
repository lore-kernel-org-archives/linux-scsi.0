From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.9-rc6
Date: Fri, 12 Apr 2013 11:18:03 -0700
Message-ID: <1365790683.1934.40.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45587 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496Ab3DLSSG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Apr 2013 14:18:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a set of ten bug fixes (and two consisting of copyright year
update and version number change) pretty much all of which involve
either a crash or a hang except the removal of the random sleep from the
qla2xxx driver (which is a coding error so bad, we want it gone before
anyone has a chance to copy it).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arun Easi (1):
      qla2xxx: Fix crash during firmware dump procedure.

Brian King (1):
      ibmvscsi: Fix slave_configure deadlock

Joe Carnuccio (1):
      Revert "qla2xxx: Add setting of driver version string for vendor application."

Joe Lawrence (1):
      st: Take additional queue ref in st_probe

John Gong (1):
      libsas: use right function to alloc smp response

Kleber Sacilotto de Souza (1):
      ipr: fix addition of abort command to HRRQ free queue

Lukasz Dorau (1):
      libsas: fix handling vacant phy in sas_set_ex_phy()

Saurav Kashyap (3):
      qla2xxx: Update the driver version to 8.04.00.13-k.
      qla2xxx: Remove debug code that msleeps for random duration.
      qla2xxx: Update copyright dates information in LICENSE.qla2xxx file.

Wei Yongjun (1):
      lpfc: fix potential NULL pointer dereference in lpfc_sli4_rq_put()

wenxiong@linux.vnet.ibm.com (2):
      ipr: dlpar failed when adding an adapter back
      ipr: ipr_test_msi() fails when running with msi-x enabled adapter

and the diffstat

 Documentation/scsi/LICENSE.qla2xxx |  2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c   |  2 +-
 drivers/scsi/ipr.c                 | 13 +++++++--
 drivers/scsi/libsas/sas_expander.c | 14 ++++++++-
 drivers/scsi/lpfc/lpfc_sli.c       |  3 +-
 drivers/scsi/qla2xxx/qla_attr.c    |  5 ----
 drivers/scsi/qla2xxx/qla_dbg.c     |  3 +-
 drivers/scsi/qla2xxx/qla_def.h     |  1 -
 drivers/scsi/qla2xxx/qla_gbl.h     |  3 --
 drivers/scsi/qla2xxx/qla_init.c    |  4 +--
 drivers/scsi/qla2xxx/qla_mbx.c     | 58 --------------------------------------
 drivers/scsi/qla2xxx/qla_version.h |  2 +-
 drivers/scsi/st.c                  |  8 +++++-
 13 files changed, 38 insertions(+), 80 deletions(-)

Full diff is attached below.

James

---
diff --git a/Documentation/scsi/LICENSE.qla2xxx b/Documentation/scsi/LICENSE.qla2xxx
index 27a91cf..5020b7b 100644
--- a/Documentation/scsi/LICENSE.qla2xxx
+++ b/Documentation/scsi/LICENSE.qla2xxx
@@ -1,4 +1,4 @@
-Copyright (c) 2003-2012 QLogic Corporation
+Copyright (c) 2003-2013 QLogic Corporation
 QLogic Linux FC-FCoE Driver
 
 This program includes a device driver for Linux 3.x.
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index a044f59..d0fa4b6 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1899,8 +1899,8 @@ static int ibmvscsi_slave_configure(struct scsi_device *sdev)
 		sdev->allow_restart = 1;
 		blk_queue_rq_timeout(sdev->request_queue, 120 * HZ);
 	}
-	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
 	spin_unlock_irqrestore(shost->host_lock, lock_flags);
+	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
 	return 0;
 }
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index f328089..2197b57 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5148,7 +5148,7 @@ static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd)
 		ipr_trace;
 	}
 
-	list_add_tail(&ipr_cmd->queue, &hrrq->hrrq_free_q);
+	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 	if (!ipr_is_naca_model(res))
 		res->needs_sync_complete = 1;
 
@@ -9349,7 +9349,10 @@ static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 	int_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-	rc = request_irq(pdev->irq, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
+	if (ioa_cfg->intr_flag == IPR_USE_MSIX)
+		rc = request_irq(ioa_cfg->vectors_info[0].vec, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
+	else
+		rc = request_irq(pdev->irq, ipr_test_intr, 0, IPR_NAME, ioa_cfg);
 	if (rc) {
 		dev_err(&pdev->dev, "Can not assign irq %d\n", pdev->irq);
 		return rc;
@@ -9371,7 +9374,10 @@ static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg, struct pci_dev *pdev)
 
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-	free_irq(pdev->irq, ioa_cfg);
+	if (ioa_cfg->intr_flag == IPR_USE_MSIX)
+		free_irq(ioa_cfg->vectors_info[0].vec, ioa_cfg);
+	else
+		free_irq(pdev->irq, ioa_cfg);
 
 	LEAVE;
 
@@ -9722,6 +9728,7 @@ static void __ipr_remove(struct pci_dev *pdev)
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 	flush_work(&ioa_cfg->work_q);
+	INIT_LIST_HEAD(&ioa_cfg->used_res_q);
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
 
 	spin_lock(&ipr_driver_lock);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index aec2e0d..55cbd01 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -235,6 +235,17 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	linkrate  = phy->linkrate;
 	memcpy(sas_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
 
+	/* Handle vacant phy - rest of dr data is not valid so skip it */
+	if (phy->phy_state == PHY_VACANT) {
+		memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+		phy->attached_dev_type = NO_DEVICE;
+		if (!test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)) {
+			phy->phy_id = phy_id;
+			goto skip;
+		} else
+			goto out;
+	}
+
 	phy->attached_dev_type = to_dev_type(dr);
 	if (test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state))
 		goto out;
@@ -272,6 +283,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	phy->phy->maximum_linkrate = dr->pmax_linkrate;
 	phy->phy->negotiated_linkrate = phy->linkrate;
 
+ skip:
 	if (new_phy)
 		if (sas_phy_add(phy->phy)) {
 			sas_phy_free(phy->phy);
@@ -388,7 +400,7 @@ int sas_ex_phy_discover(struct domain_device *dev, int single)
 	if (!disc_req)
 		return -ENOMEM;
 
-	disc_resp = alloc_smp_req(DISCOVER_RESP_SIZE);
+	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
 	if (!disc_resp) {
 		kfree(disc_req);
 		return -ENOMEM;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 74b67d9..d43faf3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -438,11 +438,12 @@ lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
 	struct lpfc_rqe *temp_hrqe;
 	struct lpfc_rqe *temp_drqe;
 	struct lpfc_register doorbell;
-	int put_index = hq->host_index;
+	int put_index;
 
 	/* sanity check on queue memory */
 	if (unlikely(!hq) || unlikely(!dq))
 		return -ENOMEM;
+	put_index = hq->host_index;
 	temp_hrqe = hq->qe[hq->host_index].rqe;
 	temp_drqe = dq->qe[dq->host_index].rqe;
 
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 1d82eef..b3db9dc 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1938,11 +1938,6 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 		    "Timer for the VP[%d] has stopped\n", vha->vp_idx);
 	}
 
-	/* No pending activities shall be there on the vha now */
-	if (ql2xextended_error_logging & ql_dbg_user)
-		msleep(random32()%10);  /* Just to see if something falls on
-					* the net we have placed below */
-
 	BUG_ON(atomic_read(&vha->vref_count));
 
 	qla2x00_free_fcports(vha);
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 1626de5..fbc305f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -15,6 +15,7 @@
  * | Mailbox commands             |       0x115b       | 0x111a-0x111b  |
  * |                              |                    | 0x112c-0x112e  |
  * |                              |                    | 0x113a         |
+ * |                              |                    | 0x1155-0x1158  |
  * | Device Discovery             |       0x2087       | 0x2020-0x2022, |
  * |                              |                    | 0x2016         |
  * | Queue Command and IO tracing |       0x3031       | 0x3006-0x300b  |
@@ -401,7 +402,7 @@ qla2xxx_copy_atioqueues(struct qla_hw_data *ha, void *ptr,
 		void *ring;
 	} aq, *aqp;
 
-	if (!ha->tgt.atio_q_length)
+	if (!ha->tgt.atio_ring)
 		return ptr;
 
 	num_queues = 1;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c650991..65c5ff7 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -863,7 +863,6 @@ typedef struct {
 #define	MBX_1		BIT_1
 #define	MBX_0		BIT_0
 
-#define RNID_TYPE_SET_VERSION	0x9
 #define RNID_TYPE_ASIC_TEMP	0xC
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index eb3ca21..b310fa9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -358,9 +358,6 @@ extern int
 qla2x00_disable_fce_trace(scsi_qla_host_t *, uint64_t *, uint64_t *);
 
 extern int
-qla2x00_set_driver_version(scsi_qla_host_t *, char *);
-
-extern int
 qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint8_t *,
 	uint16_t, uint16_t, uint16_t, uint16_t);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index edf4d14..b592033 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -619,8 +619,6 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))
 		qla24xx_read_fcp_prio_cfg(vha);
 
-	qla2x00_set_driver_version(vha, QLA2XXX_VERSION);
-
 	return (rval);
 }
 
@@ -1399,7 +1397,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			mq_size += ha->max_rsp_queues *
 			    (rsp->length * sizeof(response_t));
 		}
-		if (ha->tgt.atio_q_length)
+		if (ha->tgt.atio_ring)
 			mq_size += ha->tgt.atio_q_length * sizeof(request_t);
 		/* Allocate memory for Fibre Channel Event Buffer. */
 		if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha) && !IS_QLA83XX(ha))
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 186dd59..43345af 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3866,64 +3866,6 @@ qla81xx_restart_mpi_firmware(scsi_qla_host_t *vha)
 	return rval;
 }
 
-int
-qla2x00_set_driver_version(scsi_qla_host_t *vha, char *version)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-	int len;
-	uint16_t dwlen;
-	uint8_t *str;
-	dma_addr_t str_dma;
-	struct qla_hw_data *ha = vha->hw;
-
-	if (!IS_FWI2_CAPABLE(ha) || IS_QLA82XX(ha))
-		return QLA_FUNCTION_FAILED;
-
-	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1155,
-	    "Entered %s.\n", __func__);
-
-	str = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &str_dma);
-	if (!str) {
-		ql_log(ql_log_warn, vha, 0x1156,
-		    "Failed to allocate driver version param.\n");
-		return QLA_MEMORY_ALLOC_FAILED;
-	}
-
-	memcpy(str, "\x7\x3\x11\x0", 4);
-	dwlen = str[0];
-	len = dwlen * sizeof(uint32_t) - 4;
-	memset(str + 4, 0, len);
-	if (len > strlen(version))
-		len = strlen(version);
-	memcpy(str + 4, version, len);
-
-	mcp->mb[0] = MBC_SET_RNID_PARAMS;
-	mcp->mb[1] = RNID_TYPE_SET_VERSION << 8 | dwlen;
-	mcp->mb[2] = MSW(LSD(str_dma));
-	mcp->mb[3] = LSW(LSD(str_dma));
-	mcp->mb[6] = MSW(MSD(str_dma));
-	mcp->mb[7] = LSW(MSD(str_dma));
-	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
-	mcp->tov = MBX_TOV_SECONDS;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(vha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		ql_dbg(ql_dbg_mbx, vha, 0x1157,
-		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
-	} else {
-		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1158,
-		    "Done %s.\n", __func__);
-	}
-
-	dma_pool_free(ha->s_dma_pool, str, str_dma);
-
-	return rval;
-}
-
 static int
 qla2x00_read_asic_temperature(scsi_qla_host_t *vha, uint16_t *temp)
 {
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 2b6e478..ec54036 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.04.00.08-k"
+#define QLA2XXX_VERSION      "8.04.00.13-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	4
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 8697447..2a32036 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4112,6 +4112,10 @@ static int st_probe(struct device *dev)
 	tpnt->disk = disk;
 	disk->private_data = &tpnt->driver;
 	disk->queue = SDp->request_queue;
+	/* SCSI tape doesn't register this gendisk via add_disk().  Manually
+	 * take queue reference that release_disk() expects. */
+	if (!blk_get_queue(disk->queue))
+		goto out_put_disk;
 	tpnt->driver = &st_template;
 
 	tpnt->device = SDp;
@@ -4185,7 +4189,7 @@ static int st_probe(struct device *dev)
 	idr_preload_end();
 	if (error < 0) {
 		pr_warn("st: idr allocation failed: %d\n", error);
-		goto out_put_disk;
+		goto out_put_queue;
 	}
 	tpnt->index = error;
 	sprintf(disk->disk_name, "st%d", tpnt->index);
@@ -4211,6 +4215,8 @@ out_remove_devs:
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, tpnt->index);
 	spin_unlock(&st_index_lock);
+out_put_queue:
+	blk_put_queue(disk->queue);
 out_put_disk:
 	put_disk(disk);
 	kfree(tpnt);


