From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 3/3] block: add back command filter modification via sysfs
Date: Tue, 25 Sep 2012 17:30:09 +0200
Message-ID: <1348587009-22400-4-git-send-email-pbonzini@redhat.com>
References: <1348587009-22400-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348587009-22400-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This adds two new sysfs attributes to the queue kobject.  The attributes
allow reading and writing the whitelist of unprivileged commands.

This is again a bit different from what was removed in commit 018e044
(block: get rid of queue-private command filter, 2009-06-26), but the idea
is the same.  One difference is that it does not use a separate kobject.
Also, the supported sysfs syntax is a bit more expressive: it includes
ranges, the ability to replace all of the filter with a single command,
and does not force usage of hexadecimal.

Since the names are different, and the old ones were anyway never enabled
(they were always #if 0-ed), the different API is not a problem.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v2->v3: OOM and capability check [Alan Cox]

 Documentation/block/queue-sysfs.txt |   16 ++++++
 block/Kconfig                       |   10 ++++
 block/blk-sysfs.c                   |   41 ++++++++++++++
 block/scsi_ioctl.c                  |  103 +++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h              |   21 +++++++
 5 files changed, 191 insertions(+), 0 deletions(-)

diff --git a/Documentation/block/queue-sysfs.txt b/Documentation/block/queue-sysfs.txt
index e54ac1d..1152b38 100644
--- a/Documentation/block/queue-sysfs.txt
+++ b/Documentation/block/queue-sysfs.txt
@@ -133,6 +133,22 @@ control of this block device to that new IO scheduler. Note that writing
 an IO scheduler name to this file will attempt to load that IO scheduler
 module, if it isn't already present in the system.
 
+sgio_read_filter (RW)
+---------------------
+When read, this file will display a list of SCSI commands (i.e. values of
+the first byte of a CDB) that are always available for unprivileged users
+(via /dev/bsg, /dev/sgNN, or ioctls such as SG_IO and CDROM_SEND_PACKET).
+When written, the list of commands will be modified.  By default it
+will be completely replaced; writing a string that begins with '+' will
+add new commands, and writing a string that begins with '-' will remove
+some commands.  Ranges of commands are supported, for example '0x00-0xff'.
+
+sgio_write_filter (RW)
+----------------------
+When read, this file will display a list of SCSI commands (i.e. values of
+the first byte of a CDB) that are available for unprivileged users
+when the block device is open for writing.  Writing to this file behaves
+as for sgio_read_filter.
 
 
 Jens Axboe <jens.axboe@oracle.com>, February 2009
diff --git a/block/Kconfig b/block/Kconfig
index 09acf1b..7c369d9 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -65,6 +65,16 @@ config BLK_DEV_BSG
 
 	  If unsure, say Y.
 
+config BLK_DEV_SG_FILTER_SYSFS
+	bool "Customizable SG_IO filters in sysfs"
+	default y
+	help
+	  Saying Y here will let you use sysfs to customize the list
+	  of SCSI commands that are available (via /dev/sg, /dev/bsg or
+	  ioctls such as SG_IO) to unprivileged users.
+
+	  If unsure, say Y.
+
 config BLK_DEV_BSGLIB
 	bool "Block layer SG support v4 helper lib"
 	default n
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 5a0de07..b287d62 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -394,6 +394,43 @@ static struct queue_sysfs_entry queue_random_entry = {
 	.store = queue_store_random,
 };
 
+#ifdef CONFIG_BLK_DEV_SG_FILTER_SYSFS
+static ssize_t queue_sgio_filter_read_show(struct request_queue *q, char *page)
+{
+	return blk_filter_show(q, page, READ);
+}
+
+static ssize_t queue_sgio_filter_write_show(struct request_queue *q,
+				 char *page)
+{
+	return blk_filter_show(q, page, WRITE);
+}
+
+static ssize_t queue_sgio_filter_read_store(struct request_queue *q,
+				    const char *page, size_t count)
+{
+	return blk_filter_store(q, page, count, READ);
+}
+
+static ssize_t queue_sgio_filter_write_store(struct request_queue *q,
+				     const char *page, size_t count)
+{
+	return blk_filter_store(q, page, count, WRITE);
+}
+
+static struct queue_sysfs_entry queue_sgio_filter_read_entry = {
+	.attr = { .name = "sgio_filter_read", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_sgio_filter_read_show,
+	.store = queue_sgio_filter_read_store,
+};
+
+static struct queue_sysfs_entry queue_sgio_filter_write_entry = {
+	.attr = {.name = "sgio_filter_write", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_sgio_filter_write_show,
+	.store = queue_sgio_filter_write_store,
+};
+#endif
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -416,6 +453,10 @@ static struct attribute *default_attrs[] = {
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
 	&queue_random_entry.attr,
+#ifdef CONFIG_BLK_DEV_SG_FILTER_SYSFS
+	&queue_sgio_filter_read_entry.attr,
+	&queue_sgio_filter_write_entry.attr,
+#endif
 	NULL,
 };
 
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index c8862e9..d945b2a 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -18,6 +18,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/ctype.h>
 #include <linux/string.h>
 #include <linux/module.h>
 #include <linux/blkdev.h>
@@ -110,6 +111,8 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 
 static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 {
+	memset(filter, 0, sizeof(*filter));
+
 	/* Basic read-only commands */
 	__set_bit(TEST_UNIT_READY, filter->read_ok);
 	__set_bit(REQUEST_SENSE, filter->read_ok);
@@ -738,6 +741,109 @@ int scsi_cmd_blk_ioctl(struct block_device *bd, fmode_t mode,
 }
 EXPORT_SYMBOL(scsi_cmd_blk_ioctl);
 
+#ifdef CONFIG_BLK_DEV_SG_FILTER_SYSFS
+ssize_t blk_filter_show(struct request_queue *q, char *page, int rw)
+{
+	struct blk_cmd_filter *filter;
+	char *p = page;
+	unsigned long *okbits;
+	int i;
+
+	filter = q->cmd_filter;
+	if (!filter)
+		filter = &blk_default_cmd_filter;
+
+	if (rw == READ)
+		okbits = filter->read_ok;
+	else
+		okbits = filter->write_ok;
+
+	for (i = 0; i < BLK_SCSI_MAX_CMDS; i++)
+		if (test_bit(i, okbits))
+			p += sprintf(p, "0x%02x ", i);
+
+	if (p > page)
+		p[-1] = '\n';
+
+	return p - page;
+}
+EXPORT_SYMBOL_GPL(blk_filter_show);
+
+ssize_t blk_filter_store(struct request_queue *q,
+			 const char *page, size_t count, int rw)
+{
+	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
+	bool set;
+	const char *p = page;
+	char *endp;
+	int start = -1, cmd;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!q->cmd_filter) {
+		q->cmd_filter = kmalloc(sizeof(struct blk_cmd_filter),
+					GFP_KERNEL);
+		if (!q->cmd_filter)
+			return -ENOMEM;
+
+		blk_set_cmd_filter_defaults(q->cmd_filter);
+	}
+
+	if (rw == READ)
+		target_okbits = q->cmd_filter->read_ok;
+	else
+		target_okbits = q->cmd_filter->write_ok;
+
+	set = (p[0] != '-');
+	if (p[0] != '-' && p[0] != '+')
+		memset(okbits, 0, sizeof(okbits));
+	else {
+		memcpy(okbits, target_okbits, sizeof(okbits));
+		p++;
+	}
+
+	while (p < page + count) {
+		if (start == -1 && isspace(*p)) {
+			p++;
+			continue;
+		}
+
+		cmd = simple_strtol(p, &endp, 0);
+
+		/* all of these cases means invalid input, so do nothing. */
+		if (endp == p || cmd < 0 || cmd >= BLK_SCSI_MAX_CMDS ||
+		    (start != -1 && endp < page + count && !isspace(*endp)))
+			return -EINVAL;
+
+		p = endp;
+		if (p < page + count && *p == '-') {
+			BUG_ON(start != -1);
+			start = cmd;
+			p++;
+			continue;
+		}
+
+		if (start == -1)
+			start = cmd;
+
+		for (; start <= cmd; start++)
+			if (set)
+				__set_bit(start, okbits);
+			else
+				__clear_bit(start, okbits);
+		start = -1;
+	}
+
+	if (start != -1)
+		return -EINVAL;
+
+	memcpy(target_okbits, okbits, sizeof(okbits));
+	return count;
+}
+EXPORT_SYMBOL_GPL(blk_filter_store);
+#endif
+
 static int __init blk_scsi_ioctl_init(void)
 {
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b5c5f8a..18e7c25 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1012,9 +1012,30 @@ static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
 				    gfp_mask);
 }
 
+/*
+ * command filter functions
+ */
 extern int blk_verify_command(struct blk_cmd_filter *filter,
 			      unsigned char *cmd, fmode_t has_write_perm);
 
+#ifdef CONFIG_BLK_DEV_SG_FILTER_SYSFS
+ssize_t blk_filter_show(struct request_queue *q, char *page, int rw);
+ssize_t blk_filter_store(struct request_queue *q,
+			 const char *page, size_t count, int rw);
+#else
+static inline ssize_t blk_filter_show(struct request_queue *q, char *page, int rw)
+{
+	return -EINVAL;
+}
+
+static inline ssize_t blk_filter_store(struct request_queue *q,
+				       const char *page, size_t count, int rw);
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_BLK_DEV_SG_FILTER_SYSFS */
+
+
 enum blk_default_limits {
 	BLK_MAX_SEGMENTS	= 128,
 	BLK_SAFE_MAX_SECTORS	= 255,
-- 
1.7.1
