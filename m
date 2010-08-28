From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] tcm/iblock: Add WriteCache and Forced Unit Access WRITE emulation
Date: Fri, 27 Aug 2010 23:54:05 -0700
Message-ID: <1282978445-16968-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:26860 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752367Ab0H1GyI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2010 02:54:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <teheo@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for WriteCache emulation using a struct block_device
backend and block/blk-barrier.c:blkdev_issue_flush().  It also adds support
for Forced Unit Access WRITE emulation, and using the TCM callers, can be
configured independently via ConfigFS using generic device attributes added
in commit ab60b29471.

For the WriteCache bit, the iblock_do_sync_cache_range() caller for SYNCHRONIZE_CACHE*
ops have been added, which are called by transport_generic_synchronize_cache() using
struct se_subsystem_api->do_sync_cache_range().  For the FUA WRITE struct se_task context
case, __iblock_do_sync_cache() is called directly from iblock_do_task(), which note
currently does *not* return a failed SAM status, even if the write flush itself using
block/blk-barrier.c:blkdev_issue_flush() caller fails.

In iblock_create_virtdevice(), an explict call to __iblock_do_sync_cache() ->
blkdev_issue_flush() has been added in order to determine if a block flush operation
is supported by the struct block_device, and set ib_dev->ibd_flags |= IBDF_BDEV_ISSUE_FLUSH.
This flag is used in iblock_emulated_write_cache() and iblock_emulated_fua_write()
in order to determine the proper caching control and device TYPE_DISK specific mode page
area used for WCE=1 and DPOFUA=1.

Finally, this patch adds supports the SYNCHRONIZE_CACHE* Immed=1 bit to generate CDB
status for the struct se_cmd + struct se_task context with transport_complete_sync_cache()
before doing the actual __iblock_do_sync_cache().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |  119 +++++++++++++++++++++++++++++++++-
 drivers/target/target_core_iblock.h |    1 +
 2 files changed, 116 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 7945ca8..49a60c1 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -130,6 +130,8 @@ static void *iblock_allocate_virtdevice(struct se_hba *hba, const char *name)
 	return ib_dev;
 }
 
+static int __iblock_do_sync_cache(struct se_device *);
+
 static struct se_device *iblock_create_virtdevice(
 	struct se_hba *hba,
 	struct se_subsystem_dev *se_dev,
@@ -211,6 +213,14 @@ static struct se_device *iblock_create_virtdevice(
 		goto failed;
 
 	ib_dev->ibd_depth = dev->queue_depth;
+	/*
+	 * Check if the underlying struct block_device supports the
+	 * block/blk-barrier.c:blkdev_issue_flush() call, depending upon
+	 * which the SCSI mode page bits for WriteCache=1 and DPOFUA=1
+	 * will be enabled by TCM Core.
+	 */
+	if (__iblock_do_sync_cache(dev) == 0)
+		ib_dev->ibd_flags |= IBDF_BDEV_ISSUE_FLUSH;
 
 	return dev;
 
@@ -507,12 +517,94 @@ static int iblock_emulate_scsi_cdb(struct se_task *task)
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
 
+static int __iblock_do_sync_cache(struct se_device *dev)
+{
+	struct iblock_dev *ib_dev = (struct iblock_dev *)dev->dev_ptr;
+	int ret;
+
+	ret = blkdev_issue_flush(ib_dev->ibd_bd, GFP_KERNEL, NULL,
+				BLKDEV_IFL_WAIT);
+	if (ret != 0) {
+		printk(KERN_ERR "IBLOCK: block_issue_flush() failed: %d\n", ret);
+		return -1;
+	}
+	DEBUG_IBLOCK("IBLOCK: Called block_issue_flush()\n");
+	return 0;
+}
+
+void iblock_do_sync_cache_range(
+	struct se_cmd *cmd,
+	unsigned long long lba,
+	u32 size_in_bytes)
+{
+	int ret, immed = (T_TASK(cmd)->t_task_cdb[1] & 0x2);
+	/*
+	 * If the Immediate bit is set, queue up the GOOD response
+	 * for this SYNCHRONIZE_CACHE op
+	 */
+	if (immed)
+		transport_complete_sync_cache(cmd, 1);
+	/*
+	 * block/blk-barrier.c:block_issue_flush() does not support a
+	 * LBA + Range synchronization method, so for this case we
+	 * have to flush the entire cache.
+	 */
+	ret = __iblock_do_sync_cache(cmd->se_dev);
+	if (ret < 0) {
+		if (!(immed))
+			transport_complete_sync_cache(cmd, 0);
+		return;
+	}
+
+	if (!(immed))
+		transport_complete_sync_cache(cmd, 1);
+}
+
+/*
+ * Tell TCM Core that we are capable of WriteCache emulation for
+ * an underlying struct se_device.
+ */
+int iblock_emulated_write_cache(struct se_device *dev)
+{
+	struct iblock_dev *ib_dev = (struct iblock_dev *)dev->dev_ptr;
+	/*
+	 * Only return WCE if ISSUE_FLUSH is supported
+	 */	
+	return (ib_dev->ibd_flags & IBDF_BDEV_ISSUE_FLUSH) ? 1 : 0;
+}
+
+int iblock_emulated_dpo(struct se_device *dev)
+{
+	return 0;
+}
+
+/*
+ * Tell TCM Core that we will be emulating Forced Unit Access (FUA) for WRITEs
+ * for TYPE_DISK.
+ */
+int iblock_emulated_fua_write(struct se_device *dev)
+{
+	struct iblock_dev *ib_dev = (struct iblock_dev *)dev->dev_ptr;
+	/*
+	 * Only return FUA WRITE if ISSUE_FLUSH is supported
+	 */
+	return (ib_dev->ibd_flags & IBDF_BDEV_ISSUE_FLUSH) ? 1 : 0;
+}
+
+int iblock_emulated_fua_read(struct se_device *dev)
+{
+	return 0;
+}
+
 static int iblock_do_task(struct se_task *task)
 {
+	struct se_device *dev = task->task_se_cmd->se_dev;
 	struct iblock_req *req = (struct iblock_req *)task->transport_req;
 	struct iblock_dev *ibd = (struct iblock_dev *)req->ib_dev;
 	struct request_queue *q = bdev_get_queue(ibd->ibd_bd);
 	struct bio *bio = req->ib_bio, *nbio = NULL;
+	int write = (TASK_CMD(task)->data_direction == SE_DIRECTION_WRITE);
+	int ret;
 
 	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
 		return iblock_emulate_scsi_cdb(task);
@@ -523,15 +615,29 @@ static int iblock_do_task(struct se_task *task)
 		DEBUG_IBLOCK("Calling submit_bio() task: %p bio: %p"
 			" bio->bi_sector: %llu\n", task, bio, bio->bi_sector);
 
-		submit_bio(
-			(TASK_CMD(task)->data_direction == SE_DIRECTION_WRITE),
-			bio);
-
+		submit_bio(write, bio);
 		bio = nbio;
 	}
 
 	if (q->unplug_fn)
 		q->unplug_fn(q);
+	/*
+	 * Check for Forced Unit Access WRITE emulation
+	 */
+	if ((DEV_ATTRIB(dev)->emulate_write_cache > 0) &&
+	    (DEV_ATTRIB(dev)->emulate_fua_write > 0) &&
+	    write && T_TASK(task->task_se_cmd)->t_task_fua) {
+		/*
+		 * We might need to be a bit smarter here
+		 * and return some sense data to let the initiator
+		 * know the FUA WRITE cache sync failed..?
+		 */
+		ret = __iblock_do_sync_cache(dev);
+		if (ret < 0) {
+			printk(KERN_ERR "__iblock_do_sync_cache()"
+				" failed for FUA Write\n");
+		}
+	}
 
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
@@ -1012,6 +1118,11 @@ static struct se_subsystem_api iblock_template = {
 	.activate_device	= iblock_activate_device,
 	.deactivate_device	= iblock_deactivate_device,
 	.free_device		= iblock_free_device,
+	.do_sync_cache_range	= iblock_do_sync_cache_range,
+	.dpo_emulated		= iblock_emulated_dpo,
+	.fua_write_emulated	= iblock_emulated_fua_write,
+	.fua_read_emulated	= iblock_emulated_fua_read,
+	.write_cache_emulated	= iblock_emulated_write_cache,
 	.transport_complete	= iblock_transport_complete,
 	.allocate_request	= iblock_allocate_request,
 	.do_task		= iblock_do_task,
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index fc8793d..741a080 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -50,6 +50,7 @@ struct iblock_req {
 #define IBDF_HAS_UDEV_PATH		0x01
 #define IBDF_HAS_FORCE			0x02
 #define IBDF_BDEV_EXCLUSIVE		0x04
+#define IBDF_BDEV_ISSUE_FLUSH		0x08
 
 struct iblock_dev {
 	unsigned char ibd_udev_path[SE_UDEV_PATH_LEN];
-- 
1.5.6.5

