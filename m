From: Christer Weinigel <christer@weinigel.se>
Subject: Re: cd burning with plextor drives.
Date: 31 Jul 2006 02:12:42 +0200
Message-ID: <m3u04yr5s5.fsf@zoo.weinigel.se>
References: <20060729045249.GA23398@redhat.com>
	<20060729111240.GG13095@suse.de>
	<1154180419.9447.61.camel@mulgrave.il.steeleye.com>
	<Pine.LNX.4.64.0607291005200.4168@g5.osdl.org>
	<1154194239.9447.89.camel@mulgrave.il.steeleye.com>
	<Pine.LNX.4.64.0607291045540.4168@g5.osdl.org>
	<m3y7ubqdwg.fsf@zoo.weinigel.se>
	<Pine.LNX.4.64.0607301245500.4168@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:53412 "EHLO
	zoo.weinigel.se") by vger.kernel.org with ESMTP id S932481AbWGaAMo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 20:12:44 -0400
In-Reply-To: <Pine.LNX.4.64.0607301245500.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Christer Weinigel <christer@weinigel.se>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org

Linus Torvalds <torvalds@osdl.org> writes:

> On Sun, 30 Jul 2006, Christer Weinigel wrote:
> > 
> > Joerg is correct about this.  I just went through the cdrecord sources
> > (from Fedora Core 5 with a DVD patch) and took a quick look at what
> > commands and mode pages were used by the different files.  I've
> > probably missed a few things, but this ought to give you and idea
> > about what is needed to burn a CD:
> 
> Umm. I suspect you are either looking at the really old drives (like over 
> a decade ago), when there were indeed lots of CD-burners that had very 
> specific commands because the standard was new or nonexistent.
>
> Or you're looking at some extended commands that cdrecord _knows_ about 
> and can use, but that aren't necessarily standard or supported on all 
> CD-ROM drives.

Yes, a lot of those CD burners are ancient.  But I like the fact that
Linux supports a lot of ancient hardware. :-)

IMHO, those extenend commands shoule be available to unprivileged
userspace, because setting the burn speed is a rather basic operation.
A lot of people who do backups to CDROM burn CDs at 4x even if the
burner supports 24x, because CDs burned at lower speeds are often more
realiable than CDs burned at the higher speeds.

Still, cdrecord could warn and say "I couldn't set the drive speed,
but do you want me to continue anyway" instead of failing
unconditionally.

What I think we ought to to is to follow Christian Iversen's
suggestion and default to allowing the MMC command set for CD-players.
Then add some kind of syscall/sysctl to modify the list of allowed
commands such as the patch Peter Jones posted.  Did you look at it?

    http://www.uwsg.iu.edu/hypermail/linux/kernel/0409.1/2109.html

I've forward ported and compile tested Peter Jones' patch to 2.6.17.7,
if you want to try it out.  No guarantees that it works though.

I also think that the filer has to be extended to filter MODE_SELECT
/MODE_SELECT_10 too, since the burn-proof/speed settings usually are
selected via vendor mode pages (although not on the Plextors which
started this thread) but there are some other mode pages that should
definitely not be user accessible.  If you think Peter Jones' patch is
acceptable in principle, it could be extended to support mode pages
too.

Another extension may be to add a bitmap for "used commands/mode
pages" that records what commands have been used by an application.
That way a distribution maker could have a simple script that enables
all commands, runs the offending program, and then looks at the
commands used and creates a rc-script that enables those commands (and
preferably also gives the user the option to mail the program name,
list of commands and /proc/ide/hdc/identify to the distribution
maker).

  /Christer

No signed-off-by line because this is Peter Jones work originally,
I've just done a trivial forward port.  

Index: linux-2.6.17.7/block/Makefile
===================================================================
--- linux-2.6.17.7.orig/block/Makefile
+++ linux-2.6.17.7/block/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel block layer
 #
 
-obj-y	:= elevator.o ll_rw_blk.o ioctl.o genhd.o scsi_ioctl.o
+obj-y	:= elevator.o ll_rw_blk.o ioctl.o genhd.o scsi_ioctl.o rcf.o
 
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_AS)	+= as-iosched.o
Index: linux-2.6.17.7/block/genhd.c
===================================================================
--- linux-2.6.17.7.orig/block/genhd.c
+++ linux-2.6.17.7/block/genhd.c
@@ -187,6 +187,7 @@ void add_disk(struct gendisk *disk)
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
+	blk_register_filter(disk);
 }
 
 EXPORT_SYMBOL(add_disk);
@@ -194,6 +195,7 @@ EXPORT_SYMBOL(del_gendisk);	/* in partit
 
 void unlink_gendisk(struct gendisk *disk)
 {
+	blk_unregister_filter(disk);
 	blk_unregister_queue(disk);
 	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
 			      disk->minors);
@@ -389,6 +391,12 @@ static ssize_t disk_stats_read(struct ge
 		jiffies_to_msecs(disk_stat_read(disk, io_ticks)),
 		jiffies_to_msecs(disk_stat_read(disk, time_in_queue)));
 }
+
+static ssize_t disk_driver_read(struct gendisk * disk, char *page)
+{
+	return sprintf(page, "%s\n", disk->disk_name);
+}
+
 static struct disk_attribute disk_attr_uevent = {
 	.attr = {.name = "uevent", .mode = S_IWUSR },
 	.store	= disk_uevent_store
@@ -413,6 +421,10 @@ static struct disk_attribute disk_attr_s
 	.attr = {.name = "stat", .mode = S_IRUGO },
 	.show	= disk_stats_read
 };
+static struct disk_attribute disk_attr_driver = {
+	.attr = {.name = "driver", .mode = S_IRUGO },
+	.show	= disk_driver_read
+};
 
 static struct attribute * default_attrs[] = {
 	&disk_attr_uevent.attr,
@@ -421,6 +433,7 @@ static struct attribute * default_attrs[
 	&disk_attr_removable.attr,
 	&disk_attr_size.attr,
 	&disk_attr_stat.attr,
+	&disk_attr_driver.attr,
 	NULL,
 };
 
Index: linux-2.6.17.7/block/rcf.c
===================================================================
--- /dev/null
+++ linux-2.6.17.7/block/rcf.c
@@ -0,0 +1,322 @@
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
+#include <asm/bitops.h>
+
+#include <scsi/scsi.h>
+#include <linux/cdrom.h>
+
+int rcf_verify_command(struct file *file, unsigned char *cmd)
+{
+	struct rawio_cmd_filter *rcf;
+	struct inode *inode;
+
+	inode = file->f_dentry->d_inode;
+	if (!inode)
+		return -EINVAL;
+
+	rcf = &inode->i_bdev->bd_disk->filter;
+
+	/* root can do any command. */
+	if (capable(CAP_SYS_RAWIO))
+		return 0;
+
+	/* if there's no filter allocated, bail out. */
+	if (unlikely(!rcf))
+		return -EPERM;
+
+	/* Anybody who can open the device can do a read-safe command */
+	if (test_bit(cmd[0], rcf->read_ok))
+		return 0;
+
+	/* Write-safe commands require a writable open */
+	if (test_bit(cmd[0], rcf->write_ok))
+		if (file->f_mode & FMODE_WRITE)
+			return 0;
+
+	/* Or else the user has no perms */
+	return -EPERM;
+}
+
+EXPORT_SYMBOL(rcf_verify_command);
+
+/* and now, the sysfs stuff */
+static ssize_t rcf_readcmds_show(struct rawio_cmd_filter *rcf, char *page)
+{
+	char *npage = page;
+	int x;
+	
+	for (x=0; x < RCF_MAX_NR_CMDS; x++)
+		if (test_bit(x, rcf->read_ok)) {
+			sprintf(npage, "%02x", x);
+			npage += 2;
+			if (x < RCF_MAX_NR_CMDS-1)
+				sprintf(npage++, " ");
+		}
+	if (npage != page)
+		npage += sprintf(npage, "\n");
+	
+	return (npage - page);
+}
+
+static ssize_t rcf_writecmds_show(struct rawio_cmd_filter *rcf, char *page)
+{
+	char *npage = page;
+	int x;
+	
+	for (x=0; x < RCF_MAX_NR_CMDS; x++)
+		if (test_bit(x, rcf->write_ok)) {
+			sprintf(npage, "%02x", x);
+			npage += 2;
+			if (x < RCF_MAX_NR_CMDS-1)
+				sprintf(npage++, " ");
+		}
+	if (npage != page)
+		npage += sprintf(npage, "\n");
+	
+	return (npage - page);
+}
+
+#define RCF_ADD	0
+#define RCF_DEL	1
+
+static ssize_t rcf_store(struct rawio_cmd_filter *rcf, const char *page,
+			size_t count)
+{
+	ssize_t ret=0;
+	int ad,rw;
+	int cmd, status;
+
+	substring_t ss;
+
+	if (!strncmp(page+ret, "add", 3)) {
+		ret += 3;
+		ad = RCF_ADD;
+	} else if (!strncmp(page+ret, "del", 3)) {
+		ret += 3;
+		ad = RCF_DEL;
+	} else 
+		return -EINVAL;
+	if (page[ret++] == 0)
+		return -EINVAL;
+
+	if (!strncmp(page+ret, "read", 4)) {
+		ret += 4;
+		rw = READ;
+	} else if (!strncmp(page+ret, "write", 5)) {
+		ret += 5;
+		rw = WRITE;
+	} else
+		return -EINVAL;
+	if (page[ret++] == 0)
+		return -EINVAL;
+
+	ss.from = (char *)page+ret;
+	ss.to = ss.from + count - ret;
+	ret += count - ret;
+
+	status = match_hex(&ss, &cmd);
+	if (status)
+		return status;
+	if (cmd > 256)
+		return -EINVAL;
+
+	if (ad == RCF_ADD) {
+		if (rw == READ)
+			set_bit(cmd, rcf->read_ok);
+		else
+			set_bit(cmd, rcf->write_ok);
+	} else {
+		if (rw == READ)
+			clear_bit(cmd, rcf->read_ok);
+		else
+			clear_bit(cmd, rcf->write_ok);
+	}
+
+	return count;
+}
+
+struct rcf_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct rawio_cmd_filter *, char *);
+	ssize_t (*store)(struct rawio_cmd_filter *, const char *, size_t);
+};
+
+static struct rcf_sysfs_entry rcf_readcmds_entry = {
+	.attr = {.name = "ok_read_commands", .mode = S_IRUGO | S_IWUSR },
+	.show = rcf_readcmds_show,
+	.store = rcf_store,
+};
+
+static struct rcf_sysfs_entry rcf_writecmds_entry = {
+	.attr = {.name = "ok_write_commands", .mode = S_IRUGO | S_IWUSR },
+	.show = rcf_writecmds_show,
+	.store = rcf_store,
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
+	struct rawio_cmd_filter *rcf;
+
+	rcf = container_of(kobj, struct rawio_cmd_filter, kobj);
+	if (!entry->show)
+		return 0;
+	
+	return entry->show(rcf, page);
+}
+
+static ssize_t
+rcf_attr_store(struct kobject *kobj, struct attribute *attr,
+			const char *page, size_t length)
+{
+	struct rcf_sysfs_entry *entry = to_rcf(attr);
+	struct rawio_cmd_filter *rcf;
+
+	rcf = container_of(kobj, struct rawio_cmd_filter, kobj);
+	if (!entry->store)
+		return -EINVAL;
+	
+	return entry->store(rcf, page, length);
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
+static void rcf_set_defaults(struct rawio_cmd_filter *rcf)
+{
+	/* Basic read-only commands */
+	set_bit(TEST_UNIT_READY, rcf->read_ok);
+	set_bit(REQUEST_SENSE, rcf->read_ok);
+	set_bit(READ_6, rcf->read_ok);
+	set_bit(READ_10, rcf->read_ok);
+	set_bit(READ_12, rcf->read_ok);
+	set_bit(READ_16, rcf->read_ok);
+	set_bit(READ_BUFFER, rcf->read_ok);
+	set_bit(READ_LONG, rcf->read_ok);
+	set_bit(INQUIRY, rcf->read_ok);
+	set_bit(MODE_SENSE, rcf->read_ok);
+	set_bit(MODE_SENSE_10, rcf->read_ok);
+	set_bit(START_STOP, rcf->read_ok);
+	set_bit(GPCMD_VERIFY_10, rcf->read_ok);
+	set_bit(VERIFY_16, rcf->read_ok);
+	set_bit(READ_BUFFER, rcf->read_ok);
+	
+	/* Audio CD commands */
+	set_bit(GPCMD_PLAY_CD, rcf->read_ok);
+	set_bit(GPCMD_PLAY_AUDIO_10, rcf->read_ok);
+	set_bit(GPCMD_PLAY_AUDIO_MSF, rcf->read_ok);
+	set_bit(GPCMD_PLAY_AUDIO_TI, rcf->read_ok);
+	set_bit(GPCMD_PAUSE_RESUME, rcf->read_ok);
+	
+	/* CD/DVD data reading */
+	set_bit(GPCMD_READ_CD, rcf->read_ok);
+	set_bit(GPCMD_READ_CD_MSF, rcf->read_ok);
+	set_bit(GPCMD_READ_DISC_INFO, rcf->read_ok);
+	set_bit(GPCMD_READ_CDVD_CAPACITY, rcf->read_ok);
+	set_bit(GPCMD_READ_DVD_STRUCTURE, rcf->read_ok);
+	set_bit(GPCMD_READ_HEADER, rcf->read_ok);
+	set_bit(GPCMD_READ_TRACK_RZONE_INFO, rcf->read_ok);
+	set_bit(GPCMD_READ_SUBCHANNEL, rcf->read_ok);
+	set_bit(GPCMD_READ_TOC_PMA_ATIP, rcf->read_ok);
+	set_bit(GPCMD_REPORT_KEY, rcf->read_ok);
+	set_bit(GPCMD_SCAN, rcf->read_ok);
+	set_bit(GPCMD_GET_CONFIGURATION, rcf->read_ok);
+	set_bit(GPCMD_READ_FORMAT_CAPACITIES, rcf->read_ok);
+	set_bit(GPCMD_GET_EVENT_STATUS_NOTIFICATION, rcf->read_ok);
+	set_bit(GPCMD_GET_PERFORMANCE, rcf->read_ok);
+	set_bit(GPCMD_SEEK, rcf->read_ok);
+	set_bit(GPCMD_STOP_PLAY_SCAN, rcf->read_ok);
+	
+	/* Basic writing commands */
+	set_bit(WRITE_6, rcf->write_ok);
+	set_bit(WRITE_10, rcf->write_ok);
+	set_bit(WRITE_VERIFY, rcf->write_ok);
+	set_bit(WRITE_12, rcf->write_ok);
+	set_bit(WRITE_VERIFY_12, rcf->write_ok);
+	set_bit(WRITE_16, rcf->write_ok);
+	set_bit(WRITE_LONG, rcf->write_ok);
+	set_bit(ERASE, rcf->write_ok);
+	set_bit(GPCMD_MODE_SELECT_10, rcf->write_ok);
+	set_bit(MODE_SELECT, rcf->write_ok);
+	set_bit(GPCMD_BLANK, rcf->write_ok);
+	set_bit(GPCMD_CLOSE_TRACK, rcf->write_ok);
+	set_bit(GPCMD_FLUSH_CACHE, rcf->write_ok);
+	set_bit(GPCMD_FORMAT_UNIT, rcf->write_ok);
+	set_bit(GPCMD_REPAIR_RZONE_TRACK, rcf->write_ok);
+	set_bit(GPCMD_RESERVE_RZONE_TRACK, rcf->write_ok);
+	set_bit(GPCMD_SEND_DVD_STRUCTURE, rcf->write_ok);
+	set_bit(GPCMD_SEND_EVENT, rcf->write_ok);
+	set_bit(GPCMD_SEND_KEY, rcf->write_ok);
+	set_bit(GPCMD_SEND_OPC, rcf->write_ok);
+	set_bit(GPCMD_SEND_CUE_SHEET, rcf->write_ok);
+	set_bit(GPCMD_SET_SPEED, rcf->write_ok);
+	set_bit(GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL, rcf->write_ok);
+	set_bit(GPCMD_LOAD_UNLOAD, rcf->write_ok);
+	set_bit(GPCMD_SET_STREAMING, rcf->write_ok);
+}
+
+int blk_register_filter(struct gendisk *disk)
+{
+	int ret;
+	struct rawio_cmd_filter *rcf = &disk->filter;
+
+	rcf->kobj.parent = kobject_get(&disk->kobj);
+	if (!rcf->kobj.parent)
+		return -EBUSY;
+
+	snprintf(rcf->kobj.name, KOBJ_NAME_LEN, "%s", "filter");
+	rcf->kobj.ktype = &rcf_ktype;
+
+	ret = kobject_register(&rcf->kobj);
+	if (ret < 0)
+		return ret;
+
+	rcf_set_defaults(&disk->filter);
+	
+	return 0;
+}
+
+void blk_unregister_filter(struct gendisk *disk)
+{
+	struct rawio_cmd_filter *rcf = &disk->filter;
+
+	kobject_unregister(&rcf->kobj);
+	kobject_put(&disk->kobj);
+}
Index: linux-2.6.17.7/block/scsi_ioctl.c
===================================================================
--- linux-2.6.17.7.orig/block/scsi_ioctl.c
+++ linux-2.6.17.7/block/scsi_ioctl.c
@@ -106,120 +106,6 @@ static int sg_emulated_host(request_queu
 	return put_user(1, p);
 }
 
-#define CMD_READ_SAFE	0x01
-#define CMD_WRITE_SAFE	0x02
-#define CMD_WARNED	0x04
-#define safe_for_read(cmd)	[cmd] = CMD_READ_SAFE
-#define safe_for_write(cmd)	[cmd] = CMD_WRITE_SAFE
-
-static int verify_command(struct file *file, unsigned char *cmd)
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
-	int has_write_perm = 0;
-
-	/* Anybody who can open the device can do a read-safe command */
-	if (type & CMD_READ_SAFE)
-		return 0;
-
-	/*
-	 * file can be NULL from ioctl_by_bdev()...
-	 */
-	if (file)
-		has_write_perm = file->f_mode & FMODE_WRITE;
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
-
 static int sg_io(struct file *file, request_queue_t *q,
 		struct gendisk *bd_disk, struct sg_io_hdr *hdr)
 {
@@ -236,7 +122,7 @@ static int sg_io(struct file *file, requ
 		return -EINVAL;
 	if (copy_from_user(cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
-	if (verify_command(file, cmd))
+	if (rcf_verify_command(file, cmd))
 		return -EPERM;
 
 	if (hdr->dxfer_len > (q->max_hw_sectors << 9))
@@ -431,7 +317,7 @@ int sg_scsi_ioctl(struct file *file, str
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
-	err = verify_command(file, rq->cmd);
+	err = rcf_verify_command(file, rq->cmd);
 	if (err)
 		goto error;
 
Index: linux-2.6.17.7/include/linux/blkdev.h
===================================================================
--- linux-2.6.17.7.orig/include/linux/blkdev.h
+++ linux-2.6.17.7/include/linux/blkdev.h
@@ -599,6 +599,9 @@ struct sec_size {
 	unsigned block_size_bits;
 };
 
+extern int blk_register_filter(struct gendisk *disk);
+extern void blk_unregister_filter(struct gendisk *disk);
+extern int rcf_verify_command(struct file *file, unsigned char *cmd);
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 extern void register_disk(struct gendisk *dev);
Index: linux-2.6.17.7/include/linux/genhd.h
===================================================================
--- linux-2.6.17.7.orig/include/linux/genhd.h
+++ linux-2.6.17.7/include/linux/genhd.h
@@ -97,6 +97,15 @@ struct disk_stats {
 	unsigned long io_ticks;
 	unsigned long time_in_queue;
 };
+
+#define RCF_MAX_NR_CMDS	256
+#define	RCF_CMD_BYTES	(RCF_MAX_NR_CMDS / (sizeof (unsigned long) * 8))
+
+struct rawio_cmd_filter {
+	unsigned long read_ok[RCF_CMD_BYTES];
+	unsigned long write_ok[RCF_CMD_BYTES];
+	struct kobject kobj;
+};
 	
 struct gendisk {
 	int major;			/* major number of driver */
@@ -108,6 +117,7 @@ struct gendisk {
 	int part_uevent_suppress;
 	struct block_device_operations *fops;
 	struct request_queue *queue;
+	struct rawio_cmd_filter filter;
 	void *private_data;
 	sector_t capacity;

-- 
"Just how much can I get away with and still go to heaven?"

Freelance consultant specializing in device driver programming for Linux 
Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
