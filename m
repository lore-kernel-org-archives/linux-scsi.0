From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 part1 3/4] sg_io: use different default filters for each device class
Date: Thu, 23 May 2013 15:58:22 +0200
Message-ID: <1369317503-4095-4-git-send-email-pbonzini@redhat.com>
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36310 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759066Ab3EWN6l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 May 2013 09:58:41 -0400
In-Reply-To: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, stable@gnu.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

Store the filters in a 256-entry array, and pick an appropriate filter
for SCSI devices.  Apart from SCSI disks, SG_IO is supported for CCISS,
ide-floppy and virtio-blk devices; TYPE_DISK (which is zero, i.e. the
default) is more appropriate for these devices than TYPE_ROM.

However, all lists are still the same, so there is no semantic change
in this patch.

Cc: stable@gnu.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c       | 14 +++++---------
 drivers/scsi/scsi_scan.c |  2 ++
 include/linux/blkdev.h   |  2 +-
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 21ddf17..6e18156 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -35,8 +35,8 @@
 #include <scsi/scsi_cmnd.h>
 
 struct blk_cmd_filter {
-	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
-	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
+	u32 read_ok[BLK_SCSI_MAX_CMDS];
+	u32 write_ok[BLK_SCSI_MAX_CMDS];
 };
 
 static struct blk_cmd_filter blk_default_cmd_filter;
@@ -117,7 +117,7 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 {
 #define sgio_bitmap_set(cmd, rw) \
-	__set_bit((cmd), filter->rw##_ok)
+	filter->rw##_ok[(cmd)] = ~0;
 
 	/* Basic read-only commands */
 	sgio_bitmap_set(TEST_UNIT_READY, read);
@@ -210,16 +210,12 @@ int blk_verify_command(struct request_queue *q,
 	if (capable(CAP_SYS_RAWIO))
 		return 0;
 
-	/* if there's no filter set, assume we're filtering everything out */
-	if (!filter)
-		return -EPERM;
-
 	/* Anybody who can open the device can do a read-safe command */
-	if (test_bit(cmd[0], filter->read_ok))
+	if (filter->read_ok[cmd[0]] & (1 << q->sgio_type))
 		return 0;
 
 	/* Write-safe commands require a writable open */
-	if (test_bit(cmd[0], filter->write_ok) && has_write_perm)
+	if (has_write_perm && filter->write_ok[cmd[0]] & (1 << q->sgio_type))
 		return 0;
 
 	return -EPERM;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..86940f3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -782,6 +782,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		sdev->removable = (inq_result[1] & 0x80) >> 7;
 	}
 
+	sdev->request_queue->sgio_type = sdev->type;
+
 	switch (sdev->type) {
 	case TYPE_RBC:
 	case TYPE_TAPE:
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4fca347..5e18969 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -257,7 +257,6 @@ struct blk_queue_tag {
 };
 
 #define BLK_SCSI_MAX_CMDS	(256)
-#define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
 
 struct queue_limits {
 	unsigned long		bounce_pfn;
@@ -410,6 +409,7 @@ struct request_queue {
 	 */
 	unsigned int		sg_timeout;
 	unsigned int		sg_reserved_size;
+	unsigned char		sgio_type;
 	int			node;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	struct blk_trace	*blk_trace;
-- 
1.8.1.4


