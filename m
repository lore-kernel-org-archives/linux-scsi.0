From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3/3] block: add back command filter modification via sysfs
Date: Sat, 10 Nov 2018 17:35:33 +0100
Message-ID: <1541867733-7836-4-git-send-email-pbonzini@redhat.com>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

This adds two new sysfs attributes to the queue kobject.  The attributes
allow reading and writing the whitelist of unprivileged commands.

This is again a bit different from what was removed in commit 018e044
(block: get rid of queue-private command filter, 2009-06-26), but the idea
is the same.  One difference is that it does not use a separate kobject.
Also, the supported sysfs syntax is a bit more expressive: it includes
ranges, the ability to replace all of the filter with a single command,
and does not force usage of hexadecimal.

Since the names are different, and the old ones were anyway never really
enabled, the different userspace API is not a problem.

Cc: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/block/queue-sysfs.txt |  19 ++++++
 block/Kconfig                       |  10 +++
 block/blk-sysfs.c                   |  41 +++++++++++++
 block/scsi_ioctl.c                  | 117 ++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h              |   9 +++
 5 files changed, 196 insertions(+)

diff --git a/Documentation/block/queue-sysfs.txt b/Documentation/block/queue-sysfs.txt
index 2c1e67058fd3..1fe5fe5fd80a 100644
--- a/Documentation/block/queue-sysfs.txt
+++ b/Documentation/block/queue-sysfs.txt
@@ -162,6 +162,25 @@ control of this block device to that new IO scheduler. Note that writing
 an IO scheduler name to this file will attempt to load that IO scheduler
 module, if it isn't already present in the system.
 
+sgio_read_filter (RW)
+---------------------
+When read, this file will display a list of SCSI commands (i.e. values of
+the first byte of a CDB) that are always available for unprivileged users
+via /dev/bsg, /dev/sgNN, or ioctls such as SG_IO and CDROM_SEND_PACKET.
+When written, the list of commands will be modified.  The default filter
+can be restored by writing "default" to the file; otherwise the input should
+be a list of byte values or ranges such as "0x00-0xff".  In the latter case,
+instead of replacing the filter completely you can add to the commands,
+by writing a string that begins with '+', or remove them by writing a
+string that begins with '-'.
+
+sgio_write_filter (RW)
+----------------------
+When read, this file will display a list of SCSI commands (i.e. values of
+the first byte of a CDB) that are available for unprivileged users
+when the block device is open for writing.  Writing to this file behaves
+as for sgio_read_filter.
+
 write_cache (RW)
 ----------------
 When read, this file will display whether the device has write back
diff --git a/block/Kconfig b/block/Kconfig
index 1f2469a0123c..a5bc37d50e07 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -71,6 +71,16 @@ config BLK_DEV_BSG
 	  access device serial numbers, etc.
 
 	  If unsure, say Y.
+ 
+config BLK_DEV_SG_FILTER_SYSFS
+	bool "Customizable SG_IO filters in sysfs"
+	default y
+	help
+	  Saying Y here will let you use sysfs to customize the list
+	  of SCSI commands that are available (via /dev/sg, /dev/bsg or
+	  ioctls such as SG_IO) to unprivileged users.
+
+	  If unsure, say Y.
 
 config BLK_DEV_BSGLIB
 	bool "Block layer SG support v4 helper lib"
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index d1ec150a3478..ea2a47272bcf 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -703,6 +703,43 @@ static ssize_t queue_dax_show(struct request_queue *q, char *page)
 };
 #endif
 
+#ifdef CONFIG_BLK_DEV_SG_FILTER_SYSFS
+static ssize_t queue_sgio_filter_read_show(struct request_queue *q, char *page)
+{
+	return blk_filter_show(q, page, READ);
+}
+
+static ssize_t queue_sgio_filter_write_show(struct request_queue *q,
+					    char *page)
+{
+	return blk_filter_show(q, page, WRITE);
+}
+
+static ssize_t queue_sgio_filter_read_store(struct request_queue *q,
+					    const char *page, size_t count)
+{
+	return blk_filter_store(q, page, count, READ);
+}
+
+static ssize_t queue_sgio_filter_write_store(struct request_queue *q,
+					     const char *page, size_t count)
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
@@ -740,6 +777,10 @@ static ssize_t queue_dax_show(struct request_queue *q, char *page)
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
 	&throtl_sample_time_entry.attr,
 #endif
+#ifdef CONFIG_BLK_DEV_SG_FILTER_SYSFS
+	&queue_sgio_filter_read_entry.attr,
+	&queue_sgio_filter_write_entry.attr,
+#endif
 	NULL,
 };
 
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 5d577c89f9e6..c5f089e7d869 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/string.h>
+#include <linux/ctype.h>
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/capability.h>
@@ -725,6 +726,125 @@ void scsi_req_init(struct scsi_request *req)
 }
 EXPORT_SYMBOL(scsi_req_init);
 
+
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
+	unsigned long bits[BLK_SCSI_CMD_PER_LONG], *target_bits;
+	bool set;
+	const char *p = page;
+	char *endp;
+	int start = -1, cmd;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (sysfs_streq(p, "default")) {
+		if (!q->cmd_filter)
+			return 0;
+		if (rw == READ)
+			memcpy(q->cmd_filter->read_ok,
+			       blk_default_cmd_filter.read_ok,
+			       sizeof(blk_default_cmd_filter.read_ok));
+		else
+			memcpy(q->cmd_filter->write_ok,
+			       blk_default_cmd_filter.write_ok,
+			       sizeof(blk_default_cmd_filter.write_ok));
+		return count;
+	}
+
+	if (!q->cmd_filter) {
+		q->cmd_filter = kmemdup(&blk_default_cmd_filter,
+					sizeof(struct blk_cmd_filter),
+					GFP_KERNEL);
+		if (!q->cmd_filter)
+			return -ENOMEM;
+	}
+
+	if (rw == READ)
+		target_bits = q->cmd_filter->read_ok;
+	else
+		target_bits = q->cmd_filter->write_ok;
+
+	set = (p[0] != '-');
+	if (p[0] != '-' && p[0] != '+')
+		memset(bits, 0, sizeof(bits));
+	else {
+		memcpy(bits, target_bits, sizeof(bits));
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
+		if (endp == p || cmd < 0 || cmd >= BLK_SCSI_MAX_CMDS)
+			return -EINVAL;
+
+		/* Verify the character immediately after the number, if any */
+		p = endp;
+		if (p < page + count) {
+			if (start == -1 && *p == '-') {
+				start = cmd;
+				p++;
+				continue;
+			}
+			if (!isspace(*p))
+				return -EINVAL;
+		}
+
+		if (start == -1)
+			start = cmd;
+
+		for (; start <= cmd; start++)
+			if (set)
+				__set_bit(start, bits);
+			else
+				__clear_bit(start, bits);
+		start = -1;
+	}
+
+	/* Did the string end with a dash?  */
+	if (start != -1)
+		return -EINVAL;
+
+	memcpy(target_bits, bits, sizeof(bits));
+	return count;
+}
+EXPORT_SYMBOL_GPL(blk_filter_store);
+#endif
+
 static int __init blk_scsi_ioctl_init(void)
 {
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index df46a36c9467..5110cd6d0d16 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1430,9 +1430,18 @@ static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
 				    gfp_mask, 0);
 }
 
+/*
+ * Command filter functions
+ */
 extern int blk_verify_command(struct request_queue *q, unsigned char *cmd,
 			      fmode_t mode);
 
+#ifdef CONFIG_BLK_DEV_SG_FILTER_SYSFS
+ssize_t blk_filter_show(struct request_queue *q, char *page, int rw);
+ssize_t blk_filter_store(struct request_queue *q,
+			 const char *page, size_t count, int rw);
+#endif /* CONFIG_BLK_DEV_SG_FILTER_SYSFS */
+
 enum blk_default_limits {
 	BLK_MAX_SEGMENTS	= 128,
 	BLK_SAFE_MAX_SECTORS	= 255,
-- 
1.8.3.1
