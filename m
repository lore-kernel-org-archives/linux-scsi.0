From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.0-rc3
Date: Fri, 25 Jan 2019 14:15:06 -0800
Message-ID: <1548454506.3212.26.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Six fixes, all of which appear to have user visible consequences.  The
DMA one is a regression fix from the merge window and of the others,
four are driver specific and one specific to the target code.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Christoph Hellwig (1):
      scsi: communicate max segment size to the DMA mapping code

Ewan D. Milne (2):
      scsi: lpfc: nvmet: avoid hang / use-after-free when destroying targetport
      scsi: lpfc: nvme: avoid hang / use-after-free when destroying localport

Marc Gonzalez (1):
      scsi: ufs: Use explicit access size in ufshcd_dump_regs

Varun Prakash (1):
      scsi: csiostor: fix NULL pointer dereference in csio_vport_set_state()

Xiubo Li (1):
      scsi: tcmu: fix use after free

And the diffstat:

 drivers/ata/pata_macio.c          |  9 ++++-----
 drivers/ata/sata_inic162x.c       | 22 +++++++++-------------
 drivers/firewire/sbp2.c           |  5 +----
 drivers/scsi/aacraid/linit.c      |  9 ++++-----
 drivers/scsi/csiostor/csio_attr.c |  2 +-
 drivers/scsi/lpfc/lpfc_nvme.c     | 16 +++++++++-------
 drivers/scsi/lpfc/lpfc_nvme.h     |  2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c    |  8 +++++---
 drivers/scsi/lpfc/lpfc_nvmet.h    |  2 +-
 drivers/scsi/scsi_lib.c           |  4 ++--
 drivers/scsi/ufs/ufshcd.c         | 10 ++++++++--
 drivers/target/target_core_user.c |  3 ++-
 12 files changed, 47 insertions(+), 45 deletions(-)

With full diff below.

James

---

diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index 8cc9c429ad95..9e7fc302430f 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -915,6 +915,10 @@ static struct scsi_host_template pata_macio_sht = {
 	.sg_tablesize		= MAX_DCMDS,
 	/* We may not need that strict one */
 	.dma_boundary		= ATA_DMA_BOUNDARY,
+	/* Not sure what the real max is but we know it's less than 64K, let's
+	 * use 64K minus 256
+	 */
+	.max_segment_size	= MAX_DBDMA_SEG,
 	.slave_configure	= pata_macio_slave_config,
 };
 
@@ -1044,11 +1048,6 @@ static int pata_macio_common_init(struct pata_macio_priv *priv,
 	/* Make sure we have sane initial timings in the cache */
 	pata_macio_default_timings(priv);
 
-	/* Not sure what the real max is but we know it's less than 64K, let's
-	 * use 64K minus 256
-	 */
-	dma_set_max_seg_size(priv->dev, MAX_DBDMA_SEG);
-
 	/* Allocate libata host for 1 port */
 	memset(&pinfo, 0, sizeof(struct ata_port_info));
 	pmac_macio_calc_timing_masks(priv, &pinfo);
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index e0bcf9b2dab0..174e84ce4379 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -245,8 +245,15 @@ struct inic_port_priv {
 
 static struct scsi_host_template inic_sht = {
 	ATA_BASE_SHT(DRV_NAME),
-	.sg_tablesize	= LIBATA_MAX_PRD,	/* maybe it can be larger? */
-	.dma_boundary	= INIC_DMA_BOUNDARY,
+	.sg_tablesize		= LIBATA_MAX_PRD, /* maybe it can be larger? */
+
+	/*
+	 * This controller is braindamaged.  dma_boundary is 0xffff like others
+	 * but it will lock up the whole machine HARD if 65536 byte PRD entry
+	 * is fed.  Reduce maximum segment size.
+	 */
+	.dma_boundary		= INIC_DMA_BOUNDARY,
+	.max_segment_size	= 65536 - 512,
 };
 
 static const int scr_map[] = {
@@ -868,17 +875,6 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 	}
 
-	/*
-	 * This controller is braindamaged.  dma_boundary is 0xffff
-	 * like others but it will lock up the whole machine HARD if
-	 * 65536 byte PRD entry is fed. Reduce maximum segment size.
-	 */
-	rc = dma_set_max_seg_size(&pdev->dev, 65536 - 512);
-	if (rc) {
-		dev_err(&pdev->dev, "failed to set the maximum segment size\n");
-		return rc;
-	}
-
 	rc = init_controller(hpriv->mmio_base, hpriv->cached_hctl);
 	if (rc) {
 		dev_err(&pdev->dev, "failed to initialize controller\n");
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 09b845e90114..a785ffd5af89 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1144,10 +1144,6 @@ static int sbp2_probe(struct fw_unit *unit, const struct ieee1394_device_id *id)
 	if (device->is_local)
 		return -ENODEV;
 
-	if (dma_get_max_seg_size(device->card->device) > SBP2_MAX_SEG_SIZE)
-		WARN_ON(dma_set_max_seg_size(device->card->device,
-					     SBP2_MAX_SEG_SIZE));
-
 	shost = scsi_host_alloc(&scsi_driver_template, sizeof(*tgt));
 	if (shost == NULL)
 		return -ENOMEM;
@@ -1610,6 +1606,7 @@ static struct scsi_host_template scsi_driver_template = {
 	.eh_abort_handler	= sbp2_scsi_abort,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
+	.max_segment_size	= SBP2_MAX_SEG_SIZE,
 	.can_queue		= 1,
 	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
 };
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 634ddb90e7aa..7e56a11836c1 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1747,11 +1747,10 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		shost->max_sectors = (shost->sg_tablesize * 8) + 112;
 	}
 
-	error = dma_set_max_seg_size(&pdev->dev,
-		(aac->adapter_info.options & AAC_OPT_NEW_COMM) ?
-			(shost->max_sectors << 9) : 65536);
-	if (error)
-		goto out_deinit;
+	if (aac->adapter_info.options & AAC_OPT_NEW_COMM)
+		shost->max_segment_size = shost->max_sectors << 9;
+	else
+		shost->max_segment_size = 65536;
 
 	/*
 	 * Firmware printf works only with older firmware.
diff --git a/drivers/scsi/csiostor/csio_attr.c b/drivers/scsi/csiostor/csio_attr.c
index 8a004036e3d7..9bd2bd8dc2be 100644
--- a/drivers/scsi/csiostor/csio_attr.c
+++ b/drivers/scsi/csiostor/csio_attr.c
@@ -594,12 +594,12 @@ csio_vport_create(struct fc_vport *fc_vport, bool disable)
 	}
 
 	fc_vport_set_state(fc_vport, FC_VPORT_INITIALIZING);
+	ln->fc_vport = fc_vport;
 
 	if (csio_fcoe_alloc_vnp(hw, ln))
 		goto error;
 
 	*(struct csio_lnode **)fc_vport->dd_data = ln;
-	ln->fc_vport = fc_vport;
 	if (!fc_vport->node_name)
 		fc_vport->node_name = wwn_to_u64(csio_ln_wwnn(ln));
 	if (!fc_vport->port_name)
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 4c66b19e6199..8c9f79042228 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -297,7 +297,8 @@ lpfc_nvme_localport_delete(struct nvme_fc_local_port *localport)
 			 lport);
 
 	/* release any threads waiting for the unreg to complete */
-	complete(&lport->lport_unreg_done);
+	if (lport->vport->localport)
+		complete(lport->lport_unreg_cmp);
 }
 
 /* lpfc_nvme_remoteport_delete
@@ -2545,7 +2546,8 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
  */
 void
 lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
-			   struct lpfc_nvme_lport *lport)
+			   struct lpfc_nvme_lport *lport,
+			   struct completion *lport_unreg_cmp)
 {
 #if (IS_ENABLED(CONFIG_NVME_FC))
 	u32 wait_tmo;
@@ -2557,8 +2559,7 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
 	 */
 	wait_tmo = msecs_to_jiffies(LPFC_NVME_WAIT_TMO * 1000);
 	while (true) {
-		ret = wait_for_completion_timeout(&lport->lport_unreg_done,
-						  wait_tmo);
+		ret = wait_for_completion_timeout(lport_unreg_cmp, wait_tmo);
 		if (unlikely(!ret)) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_IOERR,
 					 "6176 Lport %p Localport %p wait "
@@ -2592,12 +2593,12 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 	struct lpfc_nvme_lport *lport;
 	struct lpfc_nvme_ctrl_stat *cstat;
 	int ret;
+	DECLARE_COMPLETION_ONSTACK(lport_unreg_cmp);
 
 	if (vport->nvmei_support == 0)
 		return;
 
 	localport = vport->localport;
-	vport->localport = NULL;
 	lport = (struct lpfc_nvme_lport *)localport->private;
 	cstat = lport->cstat;
 
@@ -2608,13 +2609,14 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 	/* lport's rport list is clear.  Unregister
 	 * lport and release resources.
 	 */
-	init_completion(&lport->lport_unreg_done);
+	lport->lport_unreg_cmp = &lport_unreg_cmp;
 	ret = nvme_fc_unregister_localport(localport);
 
 	/* Wait for completion.  This either blocks
 	 * indefinitely or succeeds
 	 */
-	lpfc_nvme_lport_unreg_wait(vport, lport);
+	lpfc_nvme_lport_unreg_wait(vport, lport, &lport_unreg_cmp);
+	vport->localport = NULL;
 	kfree(cstat);
 
 	/* Regardless of the unregister upcall response, clear
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index cfd4719be25c..b234d0298994 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -50,7 +50,7 @@ struct lpfc_nvme_ctrl_stat {
 /* Declare nvme-based local and remote port definitions. */
 struct lpfc_nvme_lport {
 	struct lpfc_vport *vport;
-	struct completion lport_unreg_done;
+	struct completion *lport_unreg_cmp;
 	/* Add stats counters here */
 	struct lpfc_nvme_ctrl_stat *cstat;
 	atomic_t fc4NvmeLsRequests;
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 6245f442d784..95fee83090eb 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1003,7 +1003,8 @@ lpfc_nvmet_targetport_delete(struct nvmet_fc_target_port *targetport)
 	struct lpfc_nvmet_tgtport *tport = targetport->private;
 
 	/* release any threads waiting for the unreg to complete */
-	complete(&tport->tport_unreg_done);
+	if (tport->phba->targetport)
+		complete(tport->tport_unreg_cmp);
 }
 
 static void
@@ -1692,6 +1693,7 @@ lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct lpfc_queue *wq;
 	uint32_t qidx;
+	DECLARE_COMPLETION_ONSTACK(tport_unreg_cmp);
 
 	if (phba->nvmet_support == 0)
 		return;
@@ -1701,9 +1703,9 @@ lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 			wq = phba->sli4_hba.nvme_wq[qidx];
 			lpfc_nvmet_wqfull_flush(phba, wq, NULL);
 		}
-		init_completion(&tgtp->tport_unreg_done);
+		tgtp->tport_unreg_cmp = &tport_unreg_cmp;
 		nvmet_fc_unregister_targetport(phba->targetport);
-		wait_for_completion_timeout(&tgtp->tport_unreg_done, 5);
+		wait_for_completion_timeout(&tport_unreg_cmp, 5);
 		lpfc_nvmet_cleanup_io_context(phba);
 	}
 	phba->targetport = NULL;
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index 1aaff63f1f41..0ec1082ce7ef 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -34,7 +34,7 @@
 /* Used for NVME Target */
 struct lpfc_nvmet_tgtport {
 	struct lpfc_hba *phba;
-	struct completion tport_unreg_done;
+	struct completion *tport_unreg_cmp;
 
 	/* Stats counters - lpfc_nvmet_unsol_ls_buffer */
 	atomic_t rcv_ls_req_in;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b13cc9288ba0..6d65ac584eba 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1842,8 +1842,8 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 	dma_set_seg_boundary(dev, shost->dma_boundary);
 
-	blk_queue_max_segment_size(q,
-		min(shost->max_segment_size, dma_get_max_seg_size(dev)));
+	blk_queue_max_segment_size(q, shost->max_segment_size);
+	dma_set_max_seg_size(dev, shost->max_segment_size);
 
 	/*
 	 * Set a reasonable default alignment:  The larger of 32-byte (dword),
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 71334aaf1447..2ddf24466a62 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -108,13 +108,19 @@
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix)
 {
-	u8 *regs;
+	u32 *regs;
+	size_t pos;
+
+	if (offset % 4 != 0 || len % 4 != 0) /* keep readl happy */
+		return -EINVAL;
 
 	regs = kzalloc(len, GFP_KERNEL);
 	if (!regs)
 		return -ENOMEM;
 
-	memcpy_fromio(regs, hba->mmio_base + offset, len);
+	for (pos = 0; pos < len; pos += 4)
+		regs[pos / 4] = ufshcd_readl(hba, offset + pos);
+
 	ufshcd_hex_dump(prefix, regs, len);
 	kfree(regs);
 
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index c34c88ef3319..5831e0eecea1 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1317,12 +1317,13 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 		 * target_complete_cmd will translate this to LUN COMM FAILURE
 		 */
 		scsi_status = SAM_STAT_CHECK_CONDITION;
+		list_del_init(&cmd->queue_entry);
 	} else {
+		list_del_init(&cmd->queue_entry);
 		idr_remove(&udev->commands, id);
 		tcmu_free_cmd(cmd);
 		scsi_status = SAM_STAT_TASK_SET_FULL;
 	}
-	list_del_init(&cmd->queue_entry);
 
 	pr_debug("Timing out cmd %u on dev %s that is %s.\n",
 		 id, udev->name, is_running ? "inflight" : "queued");
