From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/25] nvme: implement REQ_OP_WRITE_ZEROES
Date: Fri, 31 Mar 2017 18:33:03 +0200
Message-ID: <20170331163313.31821-16-hch@lst.de>
References: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

But now for the real NVMe Write Zeroes yet, just to get rid of the
discard abuse for zeroing.  Also rename the quirk flag to be a bit
more self-explanatory.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 10 +++++-----
 drivers/nvme/host/nvme.h |  6 +++---
 drivers/nvme/host/pci.c  |  6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4a6d7f408769..94b41d847b01 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -335,6 +335,8 @@ int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 	case REQ_OP_FLUSH:
 		nvme_setup_flush(ns, cmd);
 		break;
+	case REQ_OP_WRITE_ZEROES:
+		/* currently only aliased to deallocate for a few ctrls: */
 	case REQ_OP_DISCARD:
 		ret = nvme_setup_discard(ns, req, cmd);
 		break;
@@ -900,16 +902,14 @@ static void nvme_config_discard(struct nvme_ns *ns)
 	BUILD_BUG_ON(PAGE_SIZE / sizeof(struct nvme_dsm_range) <
 			NVME_DSM_MAX_RANGES);
 
-	if (ctrl->quirks & NVME_QUIRK_DISCARD_ZEROES)
-		ns->queue->limits.discard_zeroes_data = 1;
-	else
-		ns->queue->limits.discard_zeroes_data = 0;
-
 	ns->queue->limits.discard_alignment = logical_block_size;
 	ns->queue->limits.discard_granularity = logical_block_size;
 	blk_queue_max_discard_sectors(ns->queue, UINT_MAX);
 	blk_queue_max_discard_segments(ns->queue, NVME_DSM_MAX_RANGES);
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, ns->queue);
+
+	if (ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES)
+		blk_queue_max_write_zeroes_sectors(ns->queue, UINT_MAX);
 }
 
 static int nvme_revalidate_ns(struct nvme_ns *ns, struct nvme_id_ns **id)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 2aa20e3e5675..07ebc4a1c8fc 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -68,10 +68,10 @@ enum nvme_quirks {
 	NVME_QUIRK_IDENTIFY_CNS			= (1 << 1),
 
 	/*
-	 * The controller deterministically returns O's on reads to discarded
-	 * logical blocks.
+	 * The controller deterministically returns O's on reads to
+	 * logical blocks that deallocate was called on.
 	 */
-	NVME_QUIRK_DISCARD_ZEROES		= (1 << 2),
+	NVME_QUIRK_DEALLOCATE_ZEROES		= (1 << 2),
 
 	/*
 	 * The controller needs a delay before starts checking the device
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 26a5fd05fe88..0a28787267f0 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2135,13 +2135,13 @@ static const struct pci_error_handlers nvme_err_handler = {
 static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_VDEVICE(INTEL, 0x0953),
 		.driver_data = NVME_QUIRK_STRIPE_SIZE |
-				NVME_QUIRK_DISCARD_ZEROES, },
+				NVME_QUIRK_DEALLOCATE_ZEROES, },
 	{ PCI_VDEVICE(INTEL, 0x0a53),
 		.driver_data = NVME_QUIRK_STRIPE_SIZE |
-				NVME_QUIRK_DISCARD_ZEROES, },
+				NVME_QUIRK_DEALLOCATE_ZEROES, },
 	{ PCI_VDEVICE(INTEL, 0x0a54),
 		.driver_data = NVME_QUIRK_STRIPE_SIZE |
-				NVME_QUIRK_DISCARD_ZEROES, },
+				NVME_QUIRK_DEALLOCATE_ZEROES, },
 	{ PCI_VDEVICE(INTEL, 0x5845),	/* Qemu emulated controller */
 		.driver_data = NVME_QUIRK_IDENTIFY_CNS, },
 	{ PCI_DEVICE(0x1c58, 0x0003),	/* HGST adapter */
-- 
2.11.0
