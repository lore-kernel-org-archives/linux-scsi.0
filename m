From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 1/2] target: Drop arbitrary maximum I/O size limit
Date: Fri,  9 Jan 2015 22:52:19 +0000
Message-ID: <1420843940-16679-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch drops the arbitrary maximum I/O size limit in sbc_parse_cdb(),
which currently for fabric_max_sectors is hardcoded to 8192 (4 MB for 512
byte sector devices), and for hw_max_sectors is a backend driver dependent
value.

This limit is problematic because Linux initiators have only recently
started to honor block limits MAXIMUM TRANSFER LENGTH, and other non-Linux
based initiators (eg: MSFT Fibre Channel) can also generate I/Os larger
than 4 MB in size.

Currently when this happens, the following message will appear on the
target resulting in I/Os being returned with non recoverable status:

  SCSI OP 28h with too big sectors 16384 exceeds fabric_max_sectors: 8192

Instead, drop both [fabric,hw]_max_sector checks in sbc_parse_cdb(),
and convert the existing hw_max_sectors into a purely informational
attribute used to represent the granuality that backend driver and/or
subsystem code is splitting I/Os upon.

Also, update FILEIO with an explicit FD_MAX_BYTES check in fd_execute_rw()
to deal with the one special iovec limitiation case.

v2 changes:
  - Drop hw_max_sectors check in sbc_parse_cdb()

Reported-by: Lance Gropper <lance.gropper@qosserver.com>
Reported-by: Stefan Priebe <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |  8 ++++----
 drivers/target/target_core_file.c   | 11 ++++++++++-
 drivers/target/target_core_iblock.c |  2 +-
 drivers/target/target_core_sbc.c    | 15 ---------------
 drivers/target/target_core_spc.c    |  5 +----
 5 files changed, 16 insertions(+), 25 deletions(-)

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
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index c2aea09..b090211 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -621,7 +621,16 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	struct fd_prot fd_prot;
 	sense_reason_t rc;
 	int ret = 0;
-
+	/*
+	 * We are currently limited by the number of iovecs (2048) per
+	 * single vfs_[writev,readv] call.
+	 */
+	if (cmd->data_length > FD_MAX_BYTES) {
+		pr_err("FILEIO: Not able to process I/O of %u bytes due to"
+		       "FD_MAX_BYTES: %u iovec count limitiation\n",
+			cmd->data_length, FD_MAX_BYTES);
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
 	/*
 	 * Call vectorized fileio functions to map struct scatterlist
 	 * physical memory addresses to struct iovec virtual memory.
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
index 11bea19..cd4bed7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -953,21 +953,6 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 
 	if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
 		unsigned long long end_lba;
-
-		if (sectors > dev->dev_attrib.fabric_max_sectors) {
-			printk_ratelimited(KERN_ERR "SCSI OP %02xh with too"
-				" big sectors %u exceeds fabric_max_sectors:"
-				" %u\n", cdb[0], sectors,
-				dev->dev_attrib.fabric_max_sectors);
-			return TCM_INVALID_CDB_FIELD;
-		}
-		if (sectors > dev->dev_attrib.hw_max_sectors) {
-			printk_ratelimited(KERN_ERR "SCSI OP %02xh with too"
-				" big sectors %u exceeds backend hw_max_sectors:"
-				" %u\n", cdb[0], sectors,
-				dev->dev_attrib.hw_max_sectors);
-			return TCM_INVALID_CDB_FIELD;
-		}
 check_lba:
 		end_lba = dev->transport->get_blocks(dev) + 1;
 		if (cmd->t_task_lba + sectors > end_lba) {
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
