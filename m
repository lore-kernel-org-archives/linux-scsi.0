From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: [PATCH/RFC v3] allow userspace to modify scsi command filter on per device basis
Date: Mon, 16 Jun 2008 11:22:56 +0200
Message-ID: <6cf6b73e0806160222g19d7229dl6a650e13ab36c03b@mail.gmail.com>
References: <6cf6b73e0806132351r20fe8f91o479cd102978fa483@mail.gmail.com>
	 <20080616115952W.fujita.tomonori@lab.ntt.co.jp>
	 <6cf6b73e0806152249r19cb405ct9d5a33960e619348@mail.gmail.com>
	 <20080616151328Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:41190 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbYFPJW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jun 2008 05:22:58 -0400
Received: by fg-out-1718.google.com with SMTP id 19so3208894fgg.17
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 02:22:56 -0700 (PDT)
In-Reply-To: <20080616151328Q.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, pjones@redhat.com, jens.axboe@oracle.com, dgilbert@interlog.com

2008/6/16 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> No, sg has own command filtering mechanism, see sg_allow_access().
>
> When we discussed the per-gendisk command filter before, I think that
> we agreed that we had better to have one command filtering mechanism.

The attached patch converts sg to use the cmd_filter too.
The sg driver seems to verify commands for read access only. I have
not changed this behaviour to avoid breaking things (userspace),
but if we want to change this I can submit another patch.

--------------------------------
From: Peter Jones <pjones@redhat.com>

This patch exports the per-gendisk command filter to user space through
sysfs, so it can be changed by the system administrator.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/Makefile b/block/Makefile
index 5a43c7d..717733c 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -4,7 +4,8 @@

 obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
 			blk-barrier.o blk-settings.o blk-ioc.o blk-map.o \
-			blk-exec.o blk-merge.o ioctl.o genhd.o scsi_ioctl.o
+			blk-exec.o blk-merge.o ioctl.o genhd.o scsi_ioctl.o \
+			cmd-filter.o

 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
diff --git a/block/bsg.c b/block/bsg.c
index f0b7cd3..439940c 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -44,11 +44,12 @@ struct bsg_device {
 	char name[BUS_ID_SIZE];
 	int max_queue;
 	unsigned long flags;
+	struct blk_scsi_cmd_filter *cmd_filter;
+	mode_t *f_mode;
 };

 enum {
 	BSG_F_BLOCK		= 1,
-	BSG_F_WRITE_PERM	= 2,
 };

 #define BSG_DEFAULT_CMDS	64
@@ -172,7 +173,7 @@ unlock:
 }

 static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
-				struct sg_io_v4 *hdr, int has_write_perm)
+				struct sg_io_v4 *hdr, struct bsg_device *bd)
 {
 	if (hdr->request_len > BLK_MAX_CDB) {
 		rq->cmd = kzalloc(hdr->request_len, GFP_KERNEL);
@@ -185,7 +186,8 @@ static int blk_fill_sgv4_hdr_rq(struct
request_queue *q, struct request *rq,
 		return -EFAULT;

 	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
-		if (blk_verify_command(rq->cmd, has_write_perm))
+		if (blk_cmd_filter_verify_command(bd->cmd_filter, rq->cmd,
+						 bd->f_mode))
 			return -EPERM;
 	} else if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
@@ -263,8 +265,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 	rq = blk_get_request(q, rw, GFP_KERNEL);
 	if (!rq)
 		return ERR_PTR(-ENOMEM);
-	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, test_bit(BSG_F_WRITE_PERM,
-						       &bd->flags));
+	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd);
 	if (ret)
 		goto out;

@@ -566,12 +567,23 @@ static inline void bsg_set_block(struct
bsg_device *bd, struct file *file)
 		set_bit(BSG_F_BLOCK, &bd->flags);
 }

-static inline void bsg_set_write_perm(struct bsg_device *bd, struct file *file)
+static void bsg_set_cmd_filter(struct bsg_device *bd,
+			   struct file *file)
 {
-	if (file->f_mode & FMODE_WRITE)
-		set_bit(BSG_F_WRITE_PERM, &bd->flags);
-	else
-		clear_bit(BSG_F_WRITE_PERM, &bd->flags);
+	struct inode *inode;
+	struct gendisk *disk;
+
+	if (!file)
+		return;
+
+	inode = file->f_dentry->d_inode;
+	if (!inode)
+		return;
+
+	disk = inode->i_bdev->bd_disk;
+
+	bd->cmd_filter = &disk->cmd_filter;
+	bd->f_mode = &file->f_mode;
 }

 /*
@@ -595,6 +607,8 @@ bsg_read(struct file *file, char __user *buf,
size_t count, loff_t *ppos)
 	dprintk("%s: read %Zd bytes\n", bd->name, count);

 	bsg_set_block(bd, file);
+	bsg_set_cmd_filter(bd, file);
+
 	bytes_read = 0;
 	ret = __bsg_read(buf, count, bd, NULL, &bytes_read);
 	*ppos = bytes_read;
@@ -668,7 +682,7 @@ bsg_write(struct file *file, const char __user
*buf, size_t count, loff_t *ppos)
 	dprintk("%s: write %Zd bytes\n", bd->name, count);

 	bsg_set_block(bd, file);
-	bsg_set_write_perm(bd, file);
+	bsg_set_cmd_filter(bd, file);

 	bytes_written = 0;
 	ret = __bsg_write(bd, buf, count, &bytes_written);
@@ -771,7 +785,9 @@ static struct bsg_device *bsg_add_device(struct
inode *inode,
 	}

 	bd->queue = rq;
+
 	bsg_set_block(bd, file);
+	bsg_set_cmd_filter(bd, file);

 	atomic_set(&bd->ref_count, 1);
 	mutex_lock(&bsg_mutex);
diff --git a/block/cmd-filter.c b/block/cmd-filter.c
new file mode 100644
index 0000000..2121453
--- /dev/null
+++ b/block/cmd-filter.c
@@ -0,0 +1,325 @@
+/*
+ * Copyright 2004 Peter M. Jones <pjones@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public Licens
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-
+ *
+ */
+
+#include <linux/list.h>
+#include <linux/genhd.h>
+#include <linux/spinlock.h>
+#include <linux/parser.h>
+#include <linux/capability.h>
+#include <linux/bitops.h>
+
+#include <scsi/scsi.h>
+#include <linux/cdrom.h>
+
+int blk_cmd_filter_verify_command(struct blk_scsi_cmd_filter *filter,
+				  unsigned char *cmd, mode_t *f_mode)
+{
+	/* root can do any command. */
+	if (capable(CAP_SYS_RAWIO))
+		return 0;
+
+	/* if there's no filter set, assume we're filtering everything out */
+	if (!filter)
+		return -EPERM;
+
+	/* Anybody who can open the device can do a read-safe command */
+	if (test_bit(cmd[0], filter->read_ok))
+		return 0;
+
+	/* Write-safe commands require a writable open */
+	if (test_bit(cmd[0], filter->write_ok) && (*f_mode & FMODE_WRITE))
+		return 0;
+
+	return -EPERM;
+}
+EXPORT_SYMBOL(blk_cmd_filter_verify_command);
+
+int blk_verify_command(struct file *file, unsigned char *cmd)
+{
+	struct gendisk *disk;
+	struct inode *inode;
+
+	if (!file)
+		return -EINVAL;
+
+	inode = file->f_dentry->d_inode;
+	if (!inode)
+		return -EINVAL;
+
+	disk = inode->i_bdev->bd_disk;
+
+	return  blk_cmd_filter_verify_command(&disk->cmd_filter,
+						 cmd, &file->f_mode);
+}
+EXPORT_SYMBOL(blk_verify_command);
+
+/* and now, the sysfs stuff */
+static ssize_t rcf_cmds_show(struct blk_scsi_cmd_filter *filter, char *page,
+			     int rw)
+{
+	char *npage = page;
+	unsigned long *okbits;
+	int i;
+
+	if (rw == READ)
+		okbits = filter->read_ok;
+	else
+		okbits = filter->write_ok;
+
+	for (i = 0; i < BLK_SCSI_MAX_CMDS; i++) {
+		if (test_bit(i, okbits)) {
+			sprintf(npage, "%02x", i);
+			npage += 2;
+			if (i < BLK_SCSI_MAX_CMDS - 1)
+				sprintf(npage++, " ");
+		}
+	}
+
+	if (npage != page)
+		npage += sprintf(npage, "\n");
+
+	return npage - page;
+}
+
+static ssize_t rcf_readcmds_show(struct blk_scsi_cmd_filter *filter,
char *page)
+{
+	return rcf_cmds_show(filter, page, READ);
+}
+
+static ssize_t rcf_writecmds_show(struct blk_scsi_cmd_filter *filter,
+				 char *page)
+{
+	return rcf_cmds_show(filter, page, WRITE);
+}
+
+static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
+			      const char *page, size_t count, int rw)
+{
+	ssize_t ret = 0;
+	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
+	int cmd, status, len;
+	substring_t ss;
+
+	memset(&okbits, 0, sizeof(okbits));
+
+	for (len = strlen(page); len > 0; len -= 3) {
+		if (len < 2)
+			break;
+		ss.from = (char *) page + ret;
+		ss.to = (char *) page + ret + 2;
+		ret += 3;
+		status = match_hex(&ss, &cmd);
+		/* either of these cases means invalid input, so do nothing. */
+		if (status || cmd >= BLK_SCSI_MAX_CMDS)
+			return -EINVAL;
+
+		__set_bit(cmd, okbits);
+	}
+
+	if (rw == READ)
+		target_okbits = filter->read_ok;
+	else
+		target_okbits = filter->write_ok;
+
+	memmove(target_okbits, okbits, sizeof(okbits));
+	return count;
+}
+
+static ssize_t rcf_readcmds_store(struct blk_scsi_cmd_filter *filter,
+				  const char *page, size_t count)
+{
+	return rcf_cmds_store(filter, page, count, READ);
+}
+
+static ssize_t rcf_writecmds_store(struct blk_scsi_cmd_filter *filter,
+				   const char *page, size_t count)
+{
+	return rcf_cmds_store(filter, page, count, WRITE);
+}
+
+struct rcf_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct blk_scsi_cmd_filter *, char *);
+	ssize_t (*store)(struct blk_scsi_cmd_filter *, const char *, size_t);
+};
+
+static struct rcf_sysfs_entry rcf_readcmds_entry = {
+	.attr = { .name = "read_table", .mode = S_IRUGO | S_IWUSR },
+	.show = rcf_readcmds_show,
+	.store = rcf_readcmds_store,
+};
+
+static struct rcf_sysfs_entry rcf_writecmds_entry = {
+	.attr = {.name = "write_table", .mode = S_IRUGO | S_IWUSR },
+	.show = rcf_writecmds_show,
+	.store = rcf_writecmds_store,
+};
+
+static struct attribute *default_attrs[] = {
+	&rcf_readcmds_entry.attr,
+	&rcf_writecmds_entry.attr,
+	NULL,
+};
+
+#define to_rcf(atr) container_of((atr), struct rcf_sysfs_entry, attr)
+
+static ssize_t
+rcf_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
+{
+	struct rcf_sysfs_entry *entry = to_rcf(attr);
+	struct blk_scsi_cmd_filter *filter;
+
+	filter = container_of(kobj, struct blk_scsi_cmd_filter, kobj);
+	if (entry->show)
+		return entry->show(filter, page);
+
+	return 0;
+}
+
+static ssize_t
+rcf_attr_store(struct kobject *kobj, struct attribute *attr,
+			const char *page, size_t length)
+{
+	struct rcf_sysfs_entry *entry = to_rcf(attr);
+	struct blk_scsi_cmd_filter *filter;
+
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
+	if (!entry->store)
+		return -EINVAL;
+
+	filter = container_of(kobj, struct blk_scsi_cmd_filter, kobj);
+	return entry->store(filter, page, length);
+}
+
+static struct sysfs_ops rcf_sysfs_ops = {
+	.show = rcf_attr_show,
+	.store = rcf_attr_store,
+};
+
+static struct kobj_type rcf_ktype = {
+	.sysfs_ops = &rcf_sysfs_ops,
+	.default_attrs = default_attrs,
+};
+
+static void rcf_set_defaults(struct blk_scsi_cmd_filter *filter)
+{
+	/* Basic read-only commands */
+	__set_bit(TEST_UNIT_READY, filter->read_ok);
+	__set_bit(REQUEST_SENSE, filter->read_ok);
+	__set_bit(READ_6, filter->read_ok);
+	__set_bit(READ_10, filter->read_ok);
+	__set_bit(READ_12, filter->read_ok);
+	__set_bit(READ_16, filter->read_ok);
+	__set_bit(READ_BUFFER, filter->read_ok);
+	__set_bit(READ_DEFECT_DATA, filter->read_ok);
+	__set_bit(READ_LONG, filter->read_ok);
+	__set_bit(INQUIRY, filter->read_ok);
+	__set_bit(MODE_SENSE, filter->read_ok);
+	__set_bit(MODE_SENSE_10, filter->read_ok);
+	__set_bit(LOG_SENSE, filter->read_ok);
+	__set_bit(START_STOP, filter->read_ok);
+	__set_bit(GPCMD_VERIFY_10, filter->read_ok);
+	__set_bit(VERIFY_16, filter->read_ok);
+	__set_bit(GPCMD_READ_BUFFER_CAPACITY, filter->read_ok);
+
+	/* Audio CD commands */
+	__set_bit(GPCMD_PLAY_CD, filter->read_ok);
+	__set_bit(GPCMD_PLAY_AUDIO_10, filter->read_ok);
+	__set_bit(GPCMD_PLAY_AUDIO_MSF, filter->read_ok);
+	__set_bit(GPCMD_PLAY_AUDIO_TI, filter->read_ok);
+	__set_bit(GPCMD_PAUSE_RESUME, filter->read_ok);
+
+	/* CD/DVD data reading */
+	__set_bit(GPCMD_READ_CD, filter->read_ok);
+	__set_bit(GPCMD_READ_CD_MSF, filter->read_ok);
+	__set_bit(GPCMD_READ_DISC_INFO, filter->read_ok);
+	__set_bit(GPCMD_READ_CDVD_CAPACITY, filter->read_ok);
+	__set_bit(GPCMD_READ_DVD_STRUCTURE, filter->read_ok);
+	__set_bit(GPCMD_READ_HEADER, filter->read_ok);
+	__set_bit(GPCMD_READ_TRACK_RZONE_INFO, filter->read_ok);
+	__set_bit(GPCMD_READ_SUBCHANNEL, filter->read_ok);
+	__set_bit(GPCMD_READ_TOC_PMA_ATIP, filter->read_ok);
+	__set_bit(GPCMD_REPORT_KEY, filter->read_ok);
+	__set_bit(GPCMD_SCAN, filter->read_ok);
+	__set_bit(GPCMD_GET_CONFIGURATION, filter->read_ok);
+	__set_bit(GPCMD_READ_FORMAT_CAPACITIES, filter->read_ok);
+	__set_bit(GPCMD_GET_EVENT_STATUS_NOTIFICATION, filter->read_ok);
+	__set_bit(GPCMD_GET_PERFORMANCE, filter->read_ok);
+	__set_bit(GPCMD_SEEK, filter->read_ok);
+	__set_bit(GPCMD_STOP_PLAY_SCAN, filter->read_ok);
+
+	/* Basic writing commands */
+	__set_bit(WRITE_6, filter->write_ok);
+	__set_bit(WRITE_10, filter->write_ok);
+	__set_bit(WRITE_VERIFY, filter->write_ok);
+	__set_bit(WRITE_12, filter->write_ok);
+	__set_bit(WRITE_VERIFY_12, filter->write_ok);
+	__set_bit(WRITE_16, filter->write_ok);
+	__set_bit(WRITE_LONG, filter->write_ok);
+	__set_bit(WRITE_LONG_2, filter->write_ok);
+	__set_bit(ERASE, filter->write_ok);
+	__set_bit(GPCMD_MODE_SELECT_10, filter->write_ok);
+	__set_bit(MODE_SELECT, filter->write_ok);
+	__set_bit(LOG_SELECT, filter->write_ok);
+	__set_bit(GPCMD_BLANK, filter->write_ok);
+	__set_bit(GPCMD_CLOSE_TRACK, filter->write_ok);
+	__set_bit(GPCMD_FLUSH_CACHE, filter->write_ok);
+	__set_bit(GPCMD_FORMAT_UNIT, filter->write_ok);
+	__set_bit(GPCMD_REPAIR_RZONE_TRACK, filter->write_ok);
+	__set_bit(GPCMD_RESERVE_RZONE_TRACK, filter->write_ok);
+	__set_bit(GPCMD_SEND_DVD_STRUCTURE, filter->write_ok);
+	__set_bit(GPCMD_SEND_EVENT, filter->write_ok);
+	__set_bit(GPCMD_SEND_KEY, filter->write_ok);
+	__set_bit(GPCMD_SEND_OPC, filter->write_ok);
+	__set_bit(GPCMD_SEND_CUE_SHEET, filter->write_ok);
+	__set_bit(GPCMD_SET_SPEED, filter->write_ok);
+	__set_bit(GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL, filter->write_ok);
+	__set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);
+	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);
+}
+
+int blk_register_filter(struct gendisk *disk)
+{
+	int ret;
+	struct blk_scsi_cmd_filter *filter = &disk->cmd_filter;
+	struct kobject *parent = kobject_get(disk->holder_dir->parent);
+
+	if (!parent)
+		return -ENODEV;
+
+	ret = kobject_init_and_add(&filter->kobj, &rcf_ktype, parent,
+				 "%s", "cmd_filter");
+
+	if (ret < 0)
+		return ret;
+
+	rcf_set_defaults(filter);
+	return 0;
+}
+
+void blk_unregister_filter(struct gendisk *disk)
+{
+	struct blk_scsi_cmd_filter *filter = &disk->cmd_filter;
+
+	kobject_put(&filter->kobj);
+	kobject_put(disk->holder_dir->parent);
+}
+
diff --git a/block/genhd.c b/block/genhd.c
index b922d48..6f45845 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -189,6 +189,7 @@ void add_disk(struct gendisk *disk)
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
+	blk_register_filter(disk);

 	bdi = &disk->queue->backing_dev_info;
 	bdi_register_dev(bdi, MKDEV(disk->major, disk->first_minor));
@@ -200,6 +201,7 @@ EXPORT_SYMBOL(del_gendisk);	/* in partitions/check.c */

 void unlink_gendisk(struct gendisk *disk)
 {
+	blk_unregister_filter(disk);
 	sysfs_remove_link(&disk->dev.kobj, "bdi");
 	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_queue(disk);
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 78199c0..c5b9bcf 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -105,120 +105,12 @@ static int sg_emulated_host(struct
request_queue *q, int __user *p)
 	return put_user(1, p);
 }

-#define CMD_READ_SAFE	0x01
-#define CMD_WRITE_SAFE	0x02
-#define CMD_WARNED	0x04
-#define safe_for_read(cmd)	[cmd] = CMD_READ_SAFE
-#define safe_for_write(cmd)	[cmd] = CMD_WRITE_SAFE
-
-int blk_verify_command(unsigned char *cmd, int has_write_perm)
-{
-	static unsigned char cmd_type[256] = {
-
-		/* Basic read-only commands */
-		safe_for_read(TEST_UNIT_READY),
-		safe_for_read(REQUEST_SENSE),
-		safe_for_read(READ_6),
-		safe_for_read(READ_10),
-		safe_for_read(READ_12),
-		safe_for_read(READ_16),
-		safe_for_read(READ_BUFFER),
-		safe_for_read(READ_DEFECT_DATA),
-		safe_for_read(READ_LONG),
-		safe_for_read(INQUIRY),
-		safe_for_read(MODE_SENSE),
-		safe_for_read(MODE_SENSE_10),
-		safe_for_read(LOG_SENSE),
-		safe_for_read(START_STOP),
-		safe_for_read(GPCMD_VERIFY_10),
-		safe_for_read(VERIFY_16),
-
-		/* Audio CD commands */
-		safe_for_read(GPCMD_PLAY_CD),
-		safe_for_read(GPCMD_PLAY_AUDIO_10),
-		safe_for_read(GPCMD_PLAY_AUDIO_MSF),
-		safe_for_read(GPCMD_PLAY_AUDIO_TI),
-		safe_for_read(GPCMD_PAUSE_RESUME),
-
-		/* CD/DVD data reading */
-		safe_for_read(GPCMD_READ_BUFFER_CAPACITY),
-		safe_for_read(GPCMD_READ_CD),
-		safe_for_read(GPCMD_READ_CD_MSF),
-		safe_for_read(GPCMD_READ_DISC_INFO),
-		safe_for_read(GPCMD_READ_CDVD_CAPACITY),
-		safe_for_read(GPCMD_READ_DVD_STRUCTURE),
-		safe_for_read(GPCMD_READ_HEADER),
-		safe_for_read(GPCMD_READ_TRACK_RZONE_INFO),
-		safe_for_read(GPCMD_READ_SUBCHANNEL),
-		safe_for_read(GPCMD_READ_TOC_PMA_ATIP),
-		safe_for_read(GPCMD_REPORT_KEY),
-		safe_for_read(GPCMD_SCAN),
-		safe_for_read(GPCMD_GET_CONFIGURATION),
-		safe_for_read(GPCMD_READ_FORMAT_CAPACITIES),
-		safe_for_read(GPCMD_GET_EVENT_STATUS_NOTIFICATION),
-		safe_for_read(GPCMD_GET_PERFORMANCE),
-		safe_for_read(GPCMD_SEEK),
-		safe_for_read(GPCMD_STOP_PLAY_SCAN),
-
-		/* Basic writing commands */
-		safe_for_write(WRITE_6),
-		safe_for_write(WRITE_10),
-		safe_for_write(WRITE_VERIFY),
-		safe_for_write(WRITE_12),
-		safe_for_write(WRITE_VERIFY_12),
-		safe_for_write(WRITE_16),
-		safe_for_write(WRITE_LONG),
-		safe_for_write(WRITE_LONG_2),
-		safe_for_write(ERASE),
-		safe_for_write(GPCMD_MODE_SELECT_10),
-		safe_for_write(MODE_SELECT),
-		safe_for_write(LOG_SELECT),
-		safe_for_write(GPCMD_BLANK),
-		safe_for_write(GPCMD_CLOSE_TRACK),
-		safe_for_write(GPCMD_FLUSH_CACHE),
-		safe_for_write(GPCMD_FORMAT_UNIT),
-		safe_for_write(GPCMD_REPAIR_RZONE_TRACK),
-		safe_for_write(GPCMD_RESERVE_RZONE_TRACK),
-		safe_for_write(GPCMD_SEND_DVD_STRUCTURE),
-		safe_for_write(GPCMD_SEND_EVENT),
-		safe_for_write(GPCMD_SEND_KEY),
-		safe_for_write(GPCMD_SEND_OPC),
-		safe_for_write(GPCMD_SEND_CUE_SHEET),
-		safe_for_write(GPCMD_SET_SPEED),
-		safe_for_write(GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL),
-		safe_for_write(GPCMD_LOAD_UNLOAD),
-		safe_for_write(GPCMD_SET_STREAMING),
-	};
-	unsigned char type = cmd_type[cmd[0]];
-
-	/* Anybody who can open the device can do a read-safe command */
-	if (type & CMD_READ_SAFE)
-		return 0;
-
-	/* Write-safe commands just require a writable open.. */
-	if ((type & CMD_WRITE_SAFE) && has_write_perm)
-		return 0;
-
-	/* And root can do any command.. */
-	if (capable(CAP_SYS_RAWIO))
-		return 0;
-
-	if (!type) {
-		cmd_type[cmd[0]] = CMD_WARNED;
-		printk(KERN_WARNING "scsi: unknown opcode 0x%02x\n", cmd[0]);
-	}
-
-	/* Otherwise fail it with an "Operation not permitted" */
-	return -EPERM;
-}
-EXPORT_SYMBOL_GPL(blk_verify_command);
-
 static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
-			     struct sg_io_hdr *hdr, int has_write_perm)
+			     struct sg_io_hdr *hdr, struct file *file)
 {
 	if (copy_from_user(rq->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
-	if (blk_verify_command(rq->cmd, has_write_perm))
+	if (blk_verify_command(file, rq->cmd))
 		return -EPERM;

 	/*
@@ -287,7 +179,7 @@ static int sg_io(struct file *file, struct request_queue *q,
 		struct gendisk *bd_disk, struct sg_io_hdr *hdr)
 {
 	unsigned long start_time;
-	int writing = 0, ret = 0, has_write_perm = 0;
+	int writing = 0, ret = 0;
 	struct request *rq;
 	char sense[SCSI_SENSE_BUFFERSIZE];
 	struct bio *bio;
@@ -316,10 +208,7 @@ static int sg_io(struct file *file, struct
request_queue *q,
 	if (!rq)
 		return -ENOMEM;

-	if (file)
-		has_write_perm = file->f_mode & FMODE_WRITE;
-
-	if (blk_fill_sghdr_rq(q, rq, hdr, has_write_perm)) {
+	if (blk_fill_sghdr_rq(q, rq, hdr, file)) {
 		blk_put_request(rq);
 		return -EFAULT;
 	}
@@ -451,7 +340,7 @@ int sg_scsi_ioctl(struct file *file, struct
request_queue *q,
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;

-	err = blk_verify_command(rq->cmd, file->f_mode & FMODE_WRITE);
+	err = blk_verify_command(file, rq->cmd);
 	if (err)
 		goto error;

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ea0edd1..f7abcca 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -182,8 +182,9 @@ static int sg_build_sgat(Sg_scatter_hold * schp,
const Sg_fd * sfp,
 			 int tablesize);
 static ssize_t sg_new_read(Sg_fd * sfp, char __user *buf, size_t count,
 			   Sg_request * srp);
-static ssize_t sg_new_write(Sg_fd * sfp, const char __user *buf, size_t count,
-			    int blocking, int read_only, Sg_request ** o_srp);
+static ssize_t sg_new_write(Sg_fd *sfp, struct file *file,
+			const char __user *buf, size_t count, int blocking,
+			int read_only, Sg_request **o_srp);
 static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			   unsigned char *cmnd, int timeout, int blocking);
 static int sg_u_iovec(sg_io_hdr_t * hp, int sg_num, int ind,
@@ -204,7 +205,6 @@ static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
 static int sg_res_in_use(Sg_fd * sfp);
-static int sg_allow_access(unsigned char opcode, char dev_type);
 static int sg_build_direct(Sg_request * srp, Sg_fd * sfp, int dxfer_len);
 static Sg_device *sg_get_dev(int dev);
 #ifdef CONFIG_SCSI_PROC_FS
@@ -544,7 +544,7 @@ sg_write(struct file *filp, const char __user
*buf, size_t count, loff_t * ppos)
 		return -EFAULT;
 	blocking = !(filp->f_flags & O_NONBLOCK);
 	if (old_hdr.reply_len < 0)
-		return sg_new_write(sfp, buf, count, blocking, 0, NULL);
+		return sg_new_write(sfp, filp, buf, count, blocking, 0, NULL);
 	if (count < (SZ_SG_HEADER + 6))
 		return -EIO;	/* The minimum scsi command length is 6 bytes. */

@@ -621,8 +621,9 @@ sg_write(struct file *filp, const char __user
*buf, size_t count, loff_t * ppos)
 }

 static ssize_t
-sg_new_write(Sg_fd * sfp, const char __user *buf, size_t count,
-	     int blocking, int read_only, Sg_request ** o_srp)
+sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
+		 size_t count, int blocking, int read_only,
+		 Sg_request **o_srp)
 {
 	int k;
 	Sg_request *srp;
@@ -678,8 +679,7 @@ sg_new_write(Sg_fd * sfp, const char __user *buf,
size_t count,
 		sg_remove_request(sfp, srp);
 		return -EFAULT;
 	}
-	if (read_only &&
-	    (!sg_allow_access(cmnd[0], sfp->parentdp->device->type))) {
+	if (read_only && (!blk_verify_command(file, cmnd))) {
 		sg_remove_request(sfp, srp);
 		return -EPERM;
 	}
@@ -799,7 +799,7 @@ sg_ioctl(struct inode *inode, struct file *filp,
 			if (!access_ok(VERIFY_WRITE, p, SZ_SG_IO_HDR))
 				return -EFAULT;
 			result =
-			    sg_new_write(sfp, p, SZ_SG_IO_HDR,
+			    sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,
 					 blocking, read_only, &srp);
 			if (result < 0)
 				return result;
@@ -1048,7 +1048,7 @@ sg_ioctl(struct inode *inode, struct file *filp,

 			if (copy_from_user(&opcode, siocp->data, 1))
 				return -EFAULT;
-			if (!sg_allow_access(opcode, sdp->device->type))
+			if (!blk_verify_command(filp, &opcode))
 				return -EPERM;
 		}
 		return sg_scsi_ioctl(filp, sdp->device->request_queue, NULL, p);
@@ -2506,26 +2506,6 @@ sg_page_free(struct page *page, int size)
 #define MAINTENANCE_IN_CMD 0xa3
 #endif

-static unsigned char allow_ops[] = { TEST_UNIT_READY, REQUEST_SENSE,
-	INQUIRY, READ_CAPACITY, READ_BUFFER, READ_6, READ_10, READ_12,
-	READ_16, MODE_SENSE, MODE_SENSE_10, LOG_SENSE, REPORT_LUNS,
-	SERVICE_ACTION_IN, RECEIVE_DIAGNOSTIC, READ_LONG, MAINTENANCE_IN_CMD
-};
-
-static int
-sg_allow_access(unsigned char opcode, char dev_type)
-{
-	int k;
-
-	if (TYPE_SCANNER == dev_type)	/* TYPE_ROM maybe burner */
-		return 1;
-	for (k = 0; k < sizeof (allow_ops); ++k) {
-		if (opcode == allow_ops[k])
-			return 1;
-	}
-	return 0;
-}
-
 #ifdef CONFIG_SCSI_PROC_FS
 static int
 sg_idr_max_id(int id, void *p, void *data)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d2a1b71..b4e539b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -676,7 +676,6 @@ extern int blk_execute_rq(struct request_queue *,
struct gendisk *,
 			  struct request *, int);
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 				  struct request *, int, rq_end_io_fn *);
-extern int blk_verify_command(unsigned char *, int);
 extern void blk_unplug(struct request_queue *q);

 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
@@ -802,6 +801,15 @@ static inline struct request
*blk_map_queue_find_tag(struct blk_queue_tag *bqt,

 extern int blkdev_issue_flush(struct block_device *, sector_t *);

+/*
+* command filter functions
+*/
+extern int blk_verify_command(struct file *file, unsigned char *cmd);
+extern int blk_cmd_filter_verify_command(struct blk_scsi_cmd_filter *filter,
+					 unsigned char *cmd, mode_t *f_mode);
+extern int blk_register_filter(struct gendisk *disk);
+extern void blk_unregister_filter(struct gendisk *disk);
+
 #define MAX_PHYS_SEGMENTS 128
 #define MAX_HW_SEGMENTS 128
 #define SAFE_MAX_SECTORS 255
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index ae7aec3..ab49a77 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -110,6 +110,14 @@ struct hd_struct {
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
 #define GENHD_FL_FAIL				64

+#define BLK_SCSI_MAX_CMDS	(256)
+#define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
+
+struct blk_scsi_cmd_filter {
+	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
+	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
+	struct kobject kobj;
+};

 struct gendisk {
 	int major;			/* major number of driver */
@@ -120,6 +128,7 @@ struct gendisk {
 	struct hd_struct **part;	/* [indexed by minor] */
 	struct block_device_operations *fops;
 	struct request_queue *queue;
+	struct blk_scsi_cmd_filter cmd_filter;
 	void *private_data;
 	sector_t capacity;
