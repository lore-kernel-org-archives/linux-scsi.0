From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 03/14] sg_io: use different default filters for each device class
Date: Wed,  6 Feb 2013 16:15:50 +0100
Message-ID: <1360163761-8541-4-git-send-email-pbonzini@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Store the filters in a 256-entry array, and pick an appropriate filter
for SCSI devices.  Apart from SCSI disks, SG_IO is supported for CCISS,
ide-floppy and virtio-blk devices; TYPE_DISK (which is zero, i.e. the
default) is more appropriate for these devices than TYPE_ROM.

This patch already introduces some semantic change, albeit very limited;
in addition to the above change for CCISS/ide-floppy/virtio-blk, a few
commands are now forbidden for devices of type other than TYPE_ROM,
where they are reserved or vendor-specific.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/scsi_ioctl.c       |   14 +++++---------
 drivers/scsi/scsi_scan.c |    2 ++
 include/linux/blkdev.h   |    2 +-
 include/scsi/scsi.h      |    1 +
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 9e15784..c4c42dd 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -34,8 +34,8 @@
 #include <scsi/scsi_cmnd.h>
 
 struct blk_cmd_filter {
-	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
-	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
+	u32 read_ok[BLK_SCSI_MAX_CMDS];
+	u32 write_ok[BLK_SCSI_MAX_CMDS];
 };
 
 static struct blk_cmd_filter blk_default_cmd_filter;
@@ -116,7 +116,7 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 {
 #define sgio_bitmap_set(cmd, mask, rw) \
-	if ((mask) != 0) __set_bit((cmd), filter->rw##_ok)
+	filter->rw##_ok[(cmd)] |= (mask);
 
 #define D (1u << TYPE_DISK)           /* Direct Access Block Device (SBC-3) */
 #define T (1u << TYPE_TAPE)           /* Sequential Access Device (SSC-3) */
@@ -257,16 +257,12 @@ int blk_verify_command(struct request_queue *q,
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
index 0782336..b376d37 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -256,7 +256,6 @@ struct blk_queue_tag {
 };
 
 #define BLK_SCSI_MAX_CMDS	(256)
-#define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
 
 struct queue_limits {
 	unsigned long		bounce_pfn;
@@ -403,6 +402,7 @@ struct request_queue {
 	 */
 	unsigned int		sg_timeout;
 	unsigned int		sg_reserved_size;
+	unsigned char		sgio_type;
 	int			node;
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	struct blk_trace	*blk_trace;
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index b67553f..06cc93e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -327,6 +327,7 @@ static inline int scsi_status_is_good(int status)
 #define TYPE_OCRW           0x0f
 #define TYPE_ADC            0x10
 #define TYPE_OSD            0x11
+#define TYPE_MAX            0x1f
 #define TYPE_NO_LUN         0x7f
 
 /* SCSI protocols; these are taken from SPC-3 section 7.5 */
-- 
1.7.1
