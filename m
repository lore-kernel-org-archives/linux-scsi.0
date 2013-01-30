From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target/iblock: Use backend REQ_FLUSH hint for WriteCacheEnabled status
Date: Wed, 30 Jan 2013 06:57:21 +0000
Message-ID: <1359529041-17936-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, majianpeng <majianpeng@gmail.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch allows IBLOCK to check block hints in request_queue->flush_flags
when reporting current backend device WriteCacheEnabled status to a remote
SCSI initiator port.

This is done via a se_subsystem_api->get_write_cache() call instead of a
backend se_device creation time flag, as we expect REQ_FLUSH bits to possibly
change from an underlying blk_queue_flush() by the SCSI disk driver, or
internal raw struct block_device driver usage.

Also go ahead and update iblock_execute_rw() bio I/O path code to use
REQ_FLUSH + REQ_FUA hints when determining WRITE_FUA usage, and make SPC
emulation code use a spc_check_dev_wce() helper to handle both types of
cases for virtual backend subsystem drivers.

Reported-by: majianpeng <majianpeng@gmail.com>
Cc: majianpeng <majianpeng@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c  |    6 ++++++
 drivers/target/target_core_iblock.c  |   31 +++++++++++++++++++++++--------
 drivers/target/target_core_spc.c     |   21 ++++++++++++++++++---
 include/target/target_core_backend.h |    1 +
 4 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e269510..1d71930 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -772,6 +772,12 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
 		pr_err("emulate_write_cache not supported for pSCSI\n");
 		return -EINVAL;
 	}
+	if (dev->transport->get_write_cache != NULL) {
+		pr_warn("emulate_write_cache cannot be changed when underlying"
+			" HW reports WriteCacheEnabled, ignoring request\n");
+		return 0;
+	}
+
 	dev->dev_attrib.emulate_write_cache = flag;
 	pr_debug("dev[%p]: SE Device WRITE_CACHE_EMULATION flag: %d\n",
 			dev, dev->dev_attrib.emulate_write_cache);
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index b526d23..fc45683 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -154,6 +154,7 @@ static int iblock_configure_device(struct se_device *dev)
 
 	if (blk_queue_nonrot(q))
 		dev->dev_attrib.is_nonrot = 1;
+
 	return 0;
 
 out_free_bioset:
@@ -654,20 +655,24 @@ iblock_execute_rw(struct se_cmd *cmd)
 	u32 sg_num = sgl_nents;
 	sector_t block_lba;
 	unsigned bio_cnt;
-	int rw;
+	int rw = 0;
 	int i;
 
 	if (data_direction == DMA_TO_DEVICE) {
+		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+		struct request_queue *q = bdev_get_queue(ib_dev->ibd_bd);
 		/*
-		 * Force data to disk if we pretend to not have a volatile
-		 * write cache, or the initiator set the Force Unit Access bit.
+		 * Force writethrough using WRITE_FUA if a volatile write cache
+		 * is not enabled, or if initiator set the Force Unit Access bit.
 		 */
-		if (dev->dev_attrib.emulate_write_cache == 0 ||
-		    (dev->dev_attrib.emulate_fua_write > 0 &&
-		     (cmd->se_cmd_flags & SCF_FUA)))
-			rw = WRITE_FUA;
-		else
+		if (q->flush_flags & REQ_FUA) {
+			if (cmd->se_cmd_flags & SCF_FUA)
+				rw = WRITE_FUA;
+			else if (!(q->flush_flags & REQ_FLUSH))
+				rw = WRITE_FUA;
+		} else {
 			rw = WRITE;
+		}
 	} else {
 		rw = READ;
 	}
@@ -774,6 +779,15 @@ iblock_parse_cdb(struct se_cmd *cmd)
 	return sbc_parse_cdb(cmd, &iblock_sbc_ops);
 }
 
+bool iblock_get_write_cache(struct se_device *dev)
+{
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct block_device *bd = ib_dev->ibd_bd;
+	struct request_queue *q = bdev_get_queue(bd);
+
+	return (q->flush_flags & REQ_FLUSH);
+}
+
 static struct se_subsystem_api iblock_template = {
 	.name			= "iblock",
 	.inquiry_prod		= "IBLOCK",
@@ -790,6 +804,7 @@ static struct se_subsystem_api iblock_template = {
 	.show_configfs_dev_params = iblock_show_configfs_dev_params,
 	.get_device_type	= sbc_get_device_type,
 	.get_blocks		= iblock_get_blocks,
+	.get_write_cache	= iblock_get_write_cache,
 };
 
 static int __init iblock_module_init(void)
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 1346f8a..db6d003 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -407,16 +407,31 @@ check_scsi_name:
 }
 EXPORT_SYMBOL(spc_emulate_evpd_83);
 
+static bool
+spc_check_dev_wce(struct se_device *dev)
+{
+	bool wce = false;
+
+	if (dev->transport->get_write_cache)
+		wce = dev->transport->get_write_cache(dev);
+	else if (dev->dev_attrib.emulate_write_cache > 0)
+		wce = true;
+
+	return wce;
+}
+
 /* Extended INQUIRY Data VPD Page */
 static sense_reason_t
 spc_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
 {
+	struct se_device *dev = cmd->se_dev;
+
 	buf[3] = 0x3c;
 	/* Set HEADSUP, ORDSUP, SIMPSUP */
 	buf[5] = 0x07;
 
 	/* If WriteCache emulation is enabled, set V_SUP */
-	if (cmd->se_dev->dev_attrib.emulate_write_cache > 0)
+	if (spc_check_dev_wce(dev))
 		buf[6] = 0x01;
 	return 0;
 }
@@ -767,7 +782,7 @@ static int spc_modesense_caching(struct se_device *dev, u8 pc, u8 *p)
 	if (pc == 1)
 		goto out;
 
-	if (dev->dev_attrib.emulate_write_cache > 0)
+	if (spc_check_dev_wce(dev))
 		p[2] = 0x04; /* Write Cache Enable */
 	p[12] = 0x20; /* Disabled Read Ahead */
 
@@ -897,7 +912,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	     (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)))
 		spc_modesense_write_protect(&buf[length], type);
 
-	if ((dev->dev_attrib.emulate_write_cache > 0) &&
+	if ((spc_check_dev_wce(dev)) &&
 	    (dev->dev_attrib.emulate_fua_write > 0))
 		spc_modesense_dpofua(&buf[length], type);
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 819b0fc..f9a8016 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -35,6 +35,7 @@ struct se_subsystem_api {
 	u32 (*get_device_type)(struct se_device *);
 	sector_t (*get_blocks)(struct se_device *);
 	unsigned char *(*get_sense_buffer)(struct se_cmd *);
+	bool (*get_write_cache)(struct se_device *);
 };
 
 struct sbc_ops {
-- 
1.7.2.5
