From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/2] target: Don't arbitrary limit I/O size to fabric_max_sectors
Date: Wed,  7 Jan 2015 00:24:17 +0000
Message-ID: <1420590258-21122-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch avoids the arbitrary limiting of I/O size to fabric_max_sectors,
which currently has a hardcoded max of 8192 (4 MB for 512 byte sector
devices).

This is problematic because Linux initiators have only recently started
to honor block limits MAXIMUM TRANSFER LENGTH, and other non-Linux based
initiators (eg: Fibre Channel) can also generate I/Os larger than 4 MB.

Currently when this happens, the following message will appear on the
target resulting in I/Os being returned with non recoverable status:

  SCSI OP 28h with too big sectors 16384 exceeds fabric_max_sectors: 8192

Instead, use the existing hw_max_sectors value to determine the maximum
sized I/O the backend is capable of supporting.  Also, change IBLOCK
backend driver to set hw_max_sectors based on queue_max_hw_sectors(),
instead of UINT_MAX.

Reported-by: Lance Gropper <lance.gropper@qosserver.com>
Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 8 ++++----
 drivers/target/target_core_iblock.c | 2 +-
 drivers/target/target_core_sbc.c    | 7 -------
 drivers/target/target_core_spc.c    | 5 +----
 4 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7653cfb..ee4b89f 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1156,10 +1156,10 @@ int se_dev_set_optimal_sectors(struct se_device *dev, u32 optimal_sectors)
 			dev, dev->export_count);
 		return -EINVAL;
 	}
-	if (optimal_sectors > dev->dev_attrib.fabric_max_sectors) {
+	if (optimal_sectors > dev->dev_attrib.hw_max_sectors) {
 		pr_err("dev[%p]: Passed optimal_sectors %u cannot be"
-			" greater than fabric_max_sectors: %u\n", dev,
-			optimal_sectors, dev->dev_attrib.fabric_max_sectors);
+			" greater than hw_max_sectors: %u\n", dev,
+			optimal_sectors, dev->dev_attrib.hw_max_sectors);
 		return -EINVAL;
 	}
 
@@ -1554,7 +1554,6 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 				DA_UNMAP_GRANULARITY_ALIGNMENT_DEFAULT;
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
 	dev->dev_attrib.fabric_max_sectors = DA_FABRIC_MAX_SECTORS;
-	dev->dev_attrib.optimal_sectors = DA_FABRIC_MAX_SECTORS;
 
 	xcopy_lun = &dev->xcopy_lun;
 	xcopy_lun->lun_se_dev = dev;
@@ -1595,6 +1594,7 @@ int target_configure_device(struct se_device *dev)
 	dev->dev_attrib.hw_max_sectors =
 		se_dev_align_max_sectors(dev->dev_attrib.hw_max_sectors,
 					 dev->dev_attrib.hw_block_size);
+	dev->dev_attrib.optimal_sectors = dev->dev_attrib.hw_max_sectors;
 
 	dev->dev_index = scsi_get_new_index(SCSI_DEVICE_INDEX);
 	dev->creation_time = get_jiffies_64();
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 3efff94..5795cd8 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -124,7 +124,7 @@ static int iblock_configure_device(struct se_device *dev)
 	q = bdev_get_queue(bd);
 
 	dev->dev_attrib.hw_block_size = bdev_logical_block_size(bd);
-	dev->dev_attrib.hw_max_sectors = UINT_MAX;
+	dev->dev_attrib.hw_max_sectors = queue_max_hw_sectors(q);
 	dev->dev_attrib.hw_queue_depth = q->nr_requests;
 
 	/*
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 11bea19..9fe70ed 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -954,13 +954,6 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 	if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
 		unsigned long long end_lba;
 
-		if (sectors > dev->dev_attrib.fabric_max_sectors) {
-			printk_ratelimited(KERN_ERR "SCSI OP %02xh with too"
-				" big sectors %u exceeds fabric_max_sectors:"
-				" %u\n", cdb[0], sectors,
-				dev->dev_attrib.fabric_max_sectors);
-			return TCM_INVALID_CDB_FIELD;
-		}
 		if (sectors > dev->dev_attrib.hw_max_sectors) {
 			printk_ratelimited(KERN_ERR "SCSI OP %02xh with too"
 				" big sectors %u exceeds backend hw_max_sectors:"
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 1307600..4c71657 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -505,7 +505,6 @@ static sense_reason_t
 spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 {
 	struct se_device *dev = cmd->se_dev;
-	u32 max_sectors;
 	int have_tp = 0;
 	int opt, min;
 
@@ -539,9 +538,7 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	/*
 	 * Set MAXIMUM TRANSFER LENGTH
 	 */
-	max_sectors = min(dev->dev_attrib.fabric_max_sectors,
-			  dev->dev_attrib.hw_max_sectors);
-	put_unaligned_be32(max_sectors, &buf[8]);
+	put_unaligned_be32(dev->dev_attrib.hw_max_sectors, &buf[8]);
 
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH
-- 
1.9.1
