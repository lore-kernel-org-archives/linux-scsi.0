From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [PATCH] st: implement sysfs based tape statistics
Date: Thu, 13 Nov 2014 02:37:51 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BEF30F3@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:37849 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbaKMCkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 21:40:03 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, James Bottomley <James.Bottomley@HansenPartnership.com>

It's been a year since my last attempt at doing this as I got distracted by some other things. Comments are appreciated and any questions will be answered.

The following implements sysfs based per device tape statistics files with one file per statistic and a method of trying to allow a consistent set of statistics to be gathered. Included this time (see very end) is also documentation about the changes. These patches should apply on top of yesterdays changes to update the struct device_driver owner field. Tested with kernel version 3.18.0-rc4-next-20141112+.
---
Signed-off-by: Shane Seymour <shane.seymour@hp.com>
--- a/drivers/scsi/st.c	2014-11-12 11:31:54.416289214 -0600
+++ b/drivers/scsi/st.c	2014-11-12 11:44:24.243238146 -0600
@@ -20,6 +20,7 @@
 static const char *verstr = "20101219";
 
 #include <linux/module.h>
+#include <linux/kobject.h>
 
 #include <linux/fs.h>
 #include <linux/kernel.h>
@@ -226,6 +227,20 @@ static DEFINE_SPINLOCK(st_index_lock);
 static DEFINE_SPINLOCK(st_use_lock);
 static DEFINE_IDR(st_index_idr);
 
+static inline void st_stats_remove_files(struct scsi_tape *);
+static inline void st_stats_create_files(struct scsi_tape *);
+static ssize_t st_tape_attr_show(struct kobject *, struct attribute *, char *);
+static ssize_t st_tape_attr_store(struct kobject *, struct attribute *,
+	const char *, size_t);
+static void st_release_stats_kobj(struct kobject *);
+static const struct sysfs_ops st_stats_sysfs_ops = {
+	.show	= st_tape_attr_show,
+	.store	= st_tape_attr_store,
+};
+static struct kobj_type st_stats_ktype = {
+	.release = st_release_stats_kobj,
+	.sysfs_ops = &st_stats_sysfs_ops,
+};
 
 

 #include "osst_detect.h"
@@ -476,10 +491,21 @@ static void st_scsi_execute_end(struct r
 	struct st_request *SRpnt = req->end_io_data;
 	struct scsi_tape *STp = SRpnt->stp;
 	struct bio *tmp;
+	u64 ticks = get_jiffies_64();
 
 	STp->buffer->cmdstat.midlevel_result = SRpnt->result = req->errors;
 	STp->buffer->cmdstat.residual = req->resid_len;
 
+	if (STp->stats != NULL) {
+		STp->stats->in_flight--;
+		ticks -= STp->stats->stamp;
+		STp->stats->io_ticks += ticks;
+		if (req->cmd[0] == WRITE_6)
+			STp->stats->write_ticks += ticks;
+		else if (req->cmd[0] == READ_6)
+			STp->stats->read_ticks += ticks;
+	}
+
 	tmp = SRpnt->bio;
 	if (SRpnt->waiting)
 		complete(SRpnt->waiting);
@@ -496,6 +522,7 @@ static int st_scsi_execute(struct st_req
 	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
 	int err = 0;
 	int write = (data_direction == DMA_TO_DEVICE);
+	struct scsi_tape *STp = SRpnt->stp;
 
 	req = blk_get_request(SRpnt->stp->device->request_queue, write,
 			      GFP_KERNEL);
@@ -516,6 +543,20 @@ static int st_scsi_execute(struct st_req
 		}
 	}
 
+	if (STp->stats != NULL) {
+		if (cmd[0] == WRITE_6) {
+			STp->stats->write_cnt++;
+			STp->stats->write_byte_cnt += bufflen;
+		} else if (cmd[0] == READ_6) {
+			STp->stats->read_cnt++;
+			STp->stats->read_byte_cnt += bufflen;
+		} else {
+			STp->stats->other_cnt++;
+		}
+		STp->stats->stamp = get_jiffies_64();
+		STp->stats->in_flight++;
+	}
+
 	SRpnt->bio = req->bio;
 	req->cmd_len = COMMAND_SIZE(cmd[0]);
 	memset(req->cmd, 0, BLK_MAX_CDB);
@@ -4064,6 +4105,8 @@ out:
 static int create_cdevs(struct scsi_tape *tape)
 {
 	int mode, error;
+	struct scsi_tape_stats *tmp;
+
 	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
 		error = create_one_cdev(tape, mode, 0);
 		if (error)
@@ -4072,6 +4115,26 @@ static int create_cdevs(struct scsi_tape
 		if (error)
 			return error;
 	}
+/* Create statistics directory under device, if it fails we dont
+   have statistics. */
+	if (tape->stats != NULL) {
+		kobject_init(&tape->stats->statistics, &st_stats_ktype);
+		error = kobject_add(&tape->stats->statistics,
+			&tape->device->sdev_gendev.kobj,
+			"statistics");
+		if (error) {
+			kobject_del(&tape->stats->statistics);
+			tmp = tape->stats;
+			tape->stats = NULL;
+			kfree(tmp);
+		} else {
+			st_stats_create_files(tape);
+		}
+	} else {
+		tmp = tape->stats;
+		tape->stats = NULL;
+		kfree(tmp);
+	}
 
 	return sysfs_create_link(&tape->device->sdev_gendev.kobj,
 				 &tape->modes[0].devs[0]->kobj, "tape");
@@ -4081,6 +4144,10 @@ static void remove_cdevs(struct scsi_tap
 {
 	int mode, rew;
 	sysfs_remove_link(&tape->device->sdev_gendev.kobj, "tape");
+	if (tape->stats != NULL) {
+		st_stats_remove_files(tape);
+		kobject_del(&tape->stats->statistics);
+	}
 	for (mode = 0; mode < ST_NBR_MODES; mode++) {
 		struct st_modedef *STm = &(tape->modes[mode]);
 		for (rew = 0; rew < 2; rew++) {
@@ -4222,6 +4289,8 @@ static int st_probe(struct device *dev)
 	}
 	tpnt->index = error;
 	sprintf(disk->disk_name, "st%d", tpnt->index);
+/* Allocate stats structure */
+	tpnt->stats = kzalloc(sizeof(struct scsi_tape_stats), GFP_ATOMIC);
 
 	dev_set_drvdata(dev, tpnt);
 
@@ -4241,6 +4310,7 @@ static int st_probe(struct device *dev)
 
 out_remove_devs:
 	remove_cdevs(tpnt);
+	dev_set_drvdata(dev, NULL);
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, tpnt->index);
 	spin_unlock(&st_index_lock);
@@ -4248,6 +4318,8 @@ out_put_queue:
 	blk_put_queue(disk->queue);
 out_put_disk:
 	put_disk(disk);
+	if (tpnt->stats != NULL)
+		kfree(tpnt->stats);
 	kfree(tpnt);
 out_buffer_free:
 	kfree(buffer);
@@ -4288,6 +4360,7 @@ static void scsi_tape_release(struct kre
 	struct scsi_tape *tpnt = to_scsi_tape(kref);
 	struct gendisk *disk = tpnt->disk;
 
+	dev_set_drvdata(&tpnt->device->sdev_gendev, NULL);
 	tpnt->device = NULL;
 
 	if (tpnt->buffer) {
@@ -4298,6 +4371,10 @@ static void scsi_tape_release(struct kre
 
 	disk->private_data = NULL;
 	put_disk(disk);
+	if (tpnt->stats != NULL) {
+		kfree(tpnt->stats);
+		tpnt->stats = NULL;
+	}
 	kfree(tpnt);
 	return;
 }
@@ -4523,6 +4600,452 @@ static struct attribute *st_dev_attrs[]
 };
 ATTRIBUTE_GROUPS(st_dev);
 
+/* Support for tape stats */
+
+struct tape_stats_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct scsi_tape *, char *);
+	ssize_t (*store)(struct scsi_tape *, const char *, size_t);
+};
+
+#define TAPE_STATS_ATTR(_name, _mode, _show, _store)			\
+const struct tape_stats_attr tape_stats_attr_##_name = {		\
+	.attr = {.name  = __stringify(_name), .mode   = _mode },	\
+	.show   = _show,						\
+	.store  = _store,						\
+}
+
+void st_release_stats_kobj(struct kobject *dummy)
+{
+}
+
+/**
+ * st_stats_attr_show_read_cnt - return read count - count of reads made
+ * from tape drive
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t st_stats_attr_show_read_cnt(struct scsi_tape *st, char *buf)
+{
+	if (st->stats->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->stats->read_cnt);
+	return snprintf(buf, 4096, "%llu", st->stats->sync_read_cnt);
+}
+
+/**
+ * st_stats_attr_show_read_byte_cnt - return read byte count - tape drives
+ * may use blocks less than 512 bytes this gives the raw byte count of
+ * of data read from the tape drive.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t st_stats_attr_show_read_byte_cnt(struct scsi_tape *st, char *buf)
+{
+	if (st->stats->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->stats->read_byte_cnt);
+	return snprintf(buf, 4096, "%llu", st->stats->sync_read_byte_cnt);
+}
+
+/**
+ * st_stats_attr_show_read_block_cnt - return read block count -
+ * provides disk like data for someone expecting that instead of wanting
+ * byte counts.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+#define FROM_B_TO_512B_BLOCKS(A)	(A>>9)
+static ssize_t st_stats_attr_show_read_block_cnt(struct scsi_tape *st,
+	char *buf)
+{
+	if (st->stats->sync == 0)
+		return snprintf(buf, 4096, "%llu",
+			FROM_B_TO_512B_BLOCKS(st->stats->read_byte_cnt));
+	return snprintf(buf, 4096, "%llu",
+		FROM_B_TO_512B_BLOCKS(st->stats->sync_read_byte_cnt));
+}
+
+/**
+ * st_stats_attr_show_read_ms - return read ms - overall time spent waiting
+ * on reads in ms.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t st_stats_attr_show_read_ms(struct scsi_tape *st, char *buf)
+{
+	if (st->stats->sync == 0)
+		return snprintf(buf, 4096, "%u",
+			jiffies_to_msecs(st->stats->read_ticks));
+	return snprintf(buf, 4096, "%u",
+		jiffies_to_msecs(st->stats->sync_read_ticks));
+}
+
+/**
+ * st_stats_attr_show_write_cnt - write count - number of user calls
+ * to write(2) that have written data to tape.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t st_stats_attr_show_write_cnt(struct scsi_tape *st, char *buf)
+{
+	if (st->stats->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->stats->write_cnt);
+	return snprintf(buf, 4096, "%llu", st->stats->sync_write_cnt);
+}
+
+/**
+ * st_stats_attr_show_write_byte_cnt - write byte count - raw count of
+ * bytes written to tape.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t st_stats_attr_show_write_byte_cnt(struct scsi_tape *st,
+	char *buf)
+{
+	if (st->stats->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->stats->write_byte_cnt);
+	return snprintf(buf, 4096, "%llu", st->stats->sync_write_byte_cnt);
+}
+
+/**
+ * st_stats_attr_show_write_block_cnt - write block total - raw count of
+ * 512 byte blocks written to tape. This is for compatibility
+ * with disk type information although it doesn't mean much for tapes since
+ * they can have a block size of less than 512 bytes.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t st_stats_attr_show_write_block_cnt(struct scsi_tape *st,
+	char *buf)
+{
+	if (st->stats->sync == 0)
+		return snprintf(buf, 4096, "%llu",
+			FROM_B_TO_512B_BLOCKS(st->stats->write_byte_cnt));
+	return snprintf(buf, 4096, "%llu",
+		FROM_B_TO_512B_BLOCKS(st->stats->sync_write_byte_cnt));
+}
+
+/**
+ * st_stats_attr_show_write_ms - write ms - number of milliseconds since
+ * last open waiting on write requests to complete.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t st_stats_attr_show_write_ms(struct scsi_tape *st, char *buf)
+{
+	if (st->stats->sync == 0)
+		return snprintf(buf, 4096, "%u",
+			jiffies_to_msecs(st->stats->write_ticks));
+	return snprintf(buf, 4096, "%u",
+		jiffies_to_msecs(st->stats->sync_write_ticks));
+}
+
+/**
+ * st_stats_attr_show_in_flight - number of I/Os currently in flight -
+ * in most cases this will be either 0 or 1. It may be higher if someone
+ * has also issued other SCSI commands such as via an ioctl.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t st_stats_attr_show_in_flight(struct scsi_tape *st, char *buf)
+{
+	if (st->stats->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->stats->in_flight);
+	return snprintf(buf, 4096, "%llu", st->stats->sync_in_flight);
+}
+
+/**
+ * st_stats_attr_show_io_ms - io wait ms - this is the number of ms spent
+ * waiting on other I/O to complete. This includes tape movement commands
+ * such as rewinding, seeking to end of file or tape, etc. Except in
+ * complex tape management programs these will be indirect commands issued
+ * by the driver - e.g. rewind on close.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t st_stats_attr_show_io_ms(struct scsi_tape *st, char *buf)
+{
+	if (st->stats->sync == 0)
+		return snprintf(buf, 4096, "%u",
+			jiffies_to_msecs(st->stats->io_ticks));
+	return snprintf(buf, 4096, "%u",
+		jiffies_to_msecs(st->stats->sync_io_ticks));
+}
+
+/**
+ * st_stats_attr_show_other_cnt - other io count - this is the number of
+ * I/O requests that make up the time returned from st_stats_attr_show_io_ms.
+ * Typically these are tape movement requests but will include driver
+ * tape movement. This includes on requests seen by the st driver.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t st_stats_attr_show_other_cnt(struct scsi_tape *st, char *buf)
+{
+	if (st->stats->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->stats->other_cnt);
+	return snprintf(buf, 4096, "%llu", st->stats->sync_other_cnt);
+}
+
+/**
+ * st_stats_attr_show_sync - if 0 is returned the stats are being read
+ * process holding the stats in sync. The value of the sync file should not
+ * be non-zero for long. You should be making sure that it is left non-zero
+ * for the shortest possible time.
+ * If you do not care about them being in sync you need to take some
+ * action if the sync value is non-zero as someone could have left it
+ * non-zero which means the values never change. You should write a "0"
+ * to the sync file before you read the other stats files if you have
+ * permission to so.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t st_stats_attr_show_sync(struct scsi_tape *st, char *buf)
+{
+	return snprintf(buf, 4096, "%llu", st->stats->sync);
+}
+
+/**
+ * st_stats_attr_store_sync - store the sync value this causes the current
+ * stats to be saved to their save variables and values are then read from
+ * them to get a consistent set of values. You must read back the sync value
+ * after you have read all the values required and check if it has changed
+ * and decide if you will resync and reread the values if it has been changed.
+ * Any program writing a sync value must set it back to 0 once they are done.
+ * You should write your current pid into the sync so you can determine if
+ * someone else is changing the sync value. There is still a chance for a race
+ * but the sync file is the only method I could think of when writing this to
+ * get a best approximation of a set of in sync statistics.
+ * @st: scsi_tape structure.
+ * @buf: buffer to containing sync value
+ * @len length of data
+ **/
+static ssize_t st_stats_attr_store_sync(struct scsi_tape *st, const char *buf,
+	size_t len)
+{
+	if (kstrtoull(buf, 0, &st->stats->sync) != 0)
+		st->stats->sync = 0;
+	if (st->stats->sync == 0)
+		return len;
+	st->stats->sync_read_byte_cnt = st->stats->read_byte_cnt;
+	st->stats->sync_write_byte_cnt = st->stats->write_byte_cnt;
+	st->stats->sync_in_flight = st->stats->in_flight;
+	st->stats->sync_read_cnt = st->stats->read_cnt;
+	st->stats->sync_write_cnt = st->stats->write_cnt;
+	st->stats->sync_other_cnt = st->stats->other_cnt;
+	st->stats->sync_read_ticks = st->stats->read_ticks;
+	st->stats->sync_write_ticks = st->stats->write_ticks;
+	st->stats->sync_io_ticks = st->stats->io_ticks;
+	return len;
+}
+
+TAPE_STATS_ATTR(read_cnt, S_IRUSR | S_IRGRP | S_IROTH,
+	st_stats_attr_show_read_cnt, NULL);
+TAPE_STATS_ATTR(read_byte_cnt, S_IRUSR | S_IRGRP | S_IROTH,
+	st_stats_attr_show_read_byte_cnt, NULL);
+TAPE_STATS_ATTR(read_block_cnt, S_IRUSR | S_IRGRP | S_IROTH,
+	st_stats_attr_show_read_block_cnt, NULL);
+TAPE_STATS_ATTR(read_ms, S_IRUSR | S_IRGRP | S_IROTH,
+	st_stats_attr_show_read_ms, NULL);
+TAPE_STATS_ATTR(write_cnt, S_IRUSR | S_IRGRP | S_IROTH,
+	st_stats_attr_show_write_cnt, NULL);
+TAPE_STATS_ATTR(write_byte_cnt, S_IRUSR | S_IRGRP | S_IROTH,
+	st_stats_attr_show_write_byte_cnt, NULL);
+TAPE_STATS_ATTR(write_block_cnt, S_IRUSR | S_IRGRP | S_IROTH,
+	st_stats_attr_show_write_block_cnt, NULL);
+TAPE_STATS_ATTR(write_ms, S_IRUSR | S_IRGRP | S_IROTH,
+	st_stats_attr_show_write_ms, NULL);
+TAPE_STATS_ATTR(in_flight, S_IRUSR | S_IRGRP | S_IROTH,
+	st_stats_attr_show_in_flight, NULL);
+TAPE_STATS_ATTR(io_ms, S_IRUSR | S_IRGRP | S_IROTH,
+	st_stats_attr_show_io_ms, NULL);
+TAPE_STATS_ATTR(other_cnt, S_IRUSR | S_IRGRP | S_IROTH,
+	st_stats_attr_show_other_cnt, NULL);
+TAPE_STATS_ATTR(sync, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH,
+	st_stats_attr_show_sync, st_stats_attr_store_sync);
+#define to_tape_stats_attr(ptr) container_of(ptr, struct tape_stats_attr, attr)
+
+static const struct tape_stats_attr *tape_stats_attr_group[] = {
+	&tape_stats_attr_read_cnt,
+	&tape_stats_attr_read_byte_cnt,
+	&tape_stats_attr_read_block_cnt,
+	&tape_stats_attr_read_ms,
+	&tape_stats_attr_write_cnt,
+	&tape_stats_attr_write_byte_cnt,
+	&tape_stats_attr_write_block_cnt,
+	&tape_stats_attr_write_ms,
+	&tape_stats_attr_in_flight,
+	&tape_stats_attr_io_ms,
+	&tape_stats_attr_other_cnt,
+	&tape_stats_attr_sync,
+	NULL
+};
+
+/**
+ * st_stats_remove_file - remove sysfs atape stats attribute file.
+ * @st: scsi_tape structure.
+ * @attr: device attribute descriptor.
+ */
+static void st_stats_remove_file(struct scsi_tape *st,
+	const struct tape_stats_attr *attr)
+{
+	if (st && st->stats)
+		sysfs_remove_file(&st->stats->statistics, &attr->attr);
+}
+
+/**
+ * st_stats_create_file - create sysfs tape stats attribute file
+ * @st: scsi_tape structure.
+ * @attr: device attribute descriptor.
+ */
+static int st_stats_create_file(struct scsi_tape *st,
+	const struct tape_stats_attr *attr)
+{
+	int error = 0;
+
+	if (st && st->stats)
+		error = sysfs_create_file(&st->stats->statistics, &attr->attr);
+	return error;
+}
+
+/**
+ * st_stats_create_files - register files in the device
+ * statistics directory.
+ * @st: scsi_tape structure.
+ */
+static void st_stats_create_files(struct scsi_tape *st)
+{
+	int i = 0, rval = 0;
+
+	while (tape_stats_attr_group[i] != NULL) {
+		rval = st_stats_create_file(st, tape_stats_attr_group[i]);
+		if (rval != 0)
+			st_stats_remove_file(st, tape_stats_attr_group[i]);
+		i++;
+	}
+}
+
+/**
+ * st_stats_remove_files - remove the files from the statistics directory.
+ * @st: struct scsi_tape
+ */
+
+static void st_stats_remove_files(struct scsi_tape *st)
+{
+	int i = 0;
+
+	while (tape_stats_attr_group[i] != NULL) {
+		st_stats_remove_file(st, tape_stats_attr_group[i]);
+		i++;
+	}
+}
+
+/**
+ * st_tape_attr_store - call functions required to implement the store
+ * functionality. Works similar to show function.
+ * @kobj: struct kobject
+ * @attr: struct attribute
+ * @buf: data provided by caller
+ * @len: length of data provided
+ */
+static ssize_t st_tape_attr_store(struct kobject *kobj, struct attribute *attr,
+	const char *buf, size_t len)
+{
+	struct kobject *ktemp = kobj->parent;
+	struct device *dev;
+	struct scsi_tape *st;
+	struct tape_stats_attr *st_attr = to_tape_stats_attr(attr);
+	ssize_t ret = -EIO;
+	int i = 0;
+/* Make sure that we are being asked for an attribute we created */
+	while (tape_stats_attr_group[i] != NULL) {
+		if (tape_stats_attr_group[i] == st_attr)
+			break;
+		i++;
+	}
+	if (tape_stats_attr_group[i] == NULL)
+		return ret;
+
+	if ((!st_attr->store) || (ktemp == 0))
+		return ret;
+	dev = kobj_to_dev(ktemp);
+	if (dev == 0)
+		return ret;
+
+	mutex_lock(&st_ref_mutex);
+	st = dev_get_drvdata(dev);
+	if (st == 0) {
+		mutex_unlock(&st_ref_mutex);
+		return ret;
+	}
+	kref_get(&st->kref);
+	mutex_unlock(&st_ref_mutex);
+
+	if ((st->stats != NULL) && (st_attr->store))
+		ret = st_attr->store(st, buf, len);
+
+	mutex_lock(&st_ref_mutex);
+	kref_put(&st->kref, scsi_tape_release);
+	mutex_unlock(&st_ref_mutex);
+
+	return ret;
+}
+
+/**
+ * st_tape_attr_show - call the functions that provide the statistics.
+ * This function makes sure that the struct scsi_tape being referred to is
+ * current and has not been deleted (e.g. during an unload of the st
+ * driver or the tape drive disappearing).
+ * @kobj: struct kobject
+ * @attr: struct attribute
+ * @buf: data being returned to caller
+ */
+static ssize_t st_tape_attr_show(struct kobject *kobj, struct attribute *attr,
+	char *buf)
+{
+	struct kobject *ktemp = kobj->parent;
+	struct device *dev;
+	struct scsi_tape *st;
+	struct tape_stats_attr *st_attr = to_tape_stats_attr(attr);
+	ssize_t ret = -EIO;
+	int i = 0;
+/* Make sure that we are being asked for an attribute we created */
+	while (tape_stats_attr_group[i] != NULL) {
+		if (tape_stats_attr_group[i] == st_attr)
+			break;
+		i++;
+	}
+	if (tape_stats_attr_group[i] == NULL)
+		return ret;
+/* kobject passed in is for the statistics directory. We need to look at the
+   parent kobject (part of a struct device) and from there get the struct
+   scsi_tape. If no show function return error as well. */
+	if ((!st_attr->show) || (ktemp == 0) || (buf == 0))
+		return ret;
+	dev = kobj_to_dev(ktemp);
+	if (dev == 0)
+		return ret;
+/* dev_get_drvdata must return 0 if the struct scsi_tape has been freed.
+   Holding st_ref_mutex means it cannot be freed while we check and we
+   grab a reference to the struct scsi_tape before unlocking. */
+	mutex_lock(&st_ref_mutex);
+	st = dev_get_drvdata(dev);
+	if (st == 0) {
+		mutex_unlock(&st_ref_mutex);
+		return ret;
+	}
+	kref_get(&st->kref);
+	mutex_unlock(&st_ref_mutex);
+
+	if ((st->stats != NULL) && (st_attr->show))
+		ret = st_attr->show(st, buf);
+
+	mutex_lock(&st_ref_mutex);
+	kref_put(&st->kref, scsi_tape_release);
+	mutex_unlock(&st_ref_mutex);
+
+	return ret;
+}
+
 /* The following functions may be useful for a larger audience. */
 static int sgl_map_user_pages(struct st_buffer *STbp,
 			      const unsigned int max_pages, unsigned long uaddr,
--- a/drivers/scsi/st.h	2014-11-12 11:26:53.327309720 -0600
+++ b/drivers/scsi/st.h	2014-11-12 11:44:25.442238064 -0600
@@ -92,6 +92,32 @@ struct st_partstat {
 	int drv_file;
 };
 
+/* Tape statistics */
+struct scsi_tape_stats {
+	struct kobject statistics; /* Object for statistics directory */
+	u64 read_byte_cnt;	/* bytes read */
+	u64 write_byte_cnt;	/* bytes written */
+	u64 in_flight;		/* Number of I/Os in flight */
+	u64 read_cnt;		/* Count of read requests */
+	u64 write_cnt;		/* Count of write requests */
+	u64 other_cnt;		/* Count of other requests either implicit
+					or from user space via ioctl. */
+	u64 read_ticks;		/* Ticks spent completing read requests */
+	u64 write_ticks;	/* Ticks spent completing write requests */
+	u64 io_ticks;		/* Ticks spent doing any I/O */
+	u64 stamp;		/* holds time request was queued */
+	u64 sync;		/* Are stats read in sync */
+	u64 sync_read_byte_cnt;
+	u64 sync_write_byte_cnt;
+	u64 sync_in_flight;
+	u64 sync_read_cnt;
+	u64 sync_write_cnt;
+	u64 sync_other_cnt;
+	u64 sync_read_ticks;
+	u64 sync_write_ticks;
+	u64 sync_io_ticks;
+};
+
 #define ST_NBR_PARTITIONS 4
 
 /* The tape drive descriptor */
@@ -171,6 +197,7 @@ struct scsi_tape {
 #endif
 	struct gendisk *disk;
 	struct kref     kref;
+	struct scsi_tape_stats *stats;
 };
 
 /* Bit masks for use_pf */
--- a/Documentation/scsi/st.txt	2014-11-12 11:28:19.320303863 -0600
+++ b/Documentation/scsi/st.txt	2014-11-12 14:36:49.117437127 -0600
@@ -151,6 +151,108 @@ A link named 'tape' is made from the SCS
 directory corresponding to the mode 0 auto-rewind device (e.g., st0). 
 
 
+SYSFS AND STATISTICS FOR TAPE DEVICES
+
+The st driver maintains statistics for tape drives inside the sysfs filesystem.
+The following method can be used to locate the statistics directories that are
+available (assuming that sysfs is mounted at /sys):
+
+1. Use opendir(3) on the directory /sys/class/scsi_tape
+2. Use readdir(3) to read the directory contents
+3. Use regcomp(3)/regexec(3) to match directory entries to the extended
+	regular expression "^st[0-9]+$"
+4. Access the statistics from the /sys/class/scsi_tape/<match>/device/statistics
+	directory (where <match> is a directory entry from /sys/class/scsi_tape
+	that matched the extended regular expression)
+
+An example of a matching directory with the full path to the statistics
+directory would be:
+
+/sys/class/scsi_tape/st0/device/statistics
+
+This is not the real path to the statistics directory but it does represent a
+path which makes the directories easiest to find. The statistics directory is
+common to all tape devices associated with a SCSI tape drive the statistics
+will be the same for the st0, nst0, etc.
+
+The statistics directory contains the following files:
+
+1.  in_flight - The number of I/Os currently outstanding to this device.
+2.  io_ms - The amount of time spent waiting (in milliseconds) for other I/O
+	to complete (I/O other than read or write). This includes tape movement
+	commands such as seeking between file or set marks and implicit tape
+	movement such as when rewind on close tape devices are used.
+3.  other_cnt - The number of I/Os issued to the tape drive other than read or
+	write commands. The time taken to complete these commands is tracked
+	in io_ms.
+4.  read_block_cnt - The number of 512 byte blocks of data read from the
+	device. Note that this statistic is not related to the block size in
+	use by any tape I/O it is read_byte_cnt represented as a count of 512
+	byte blocks.
+5.  read_byte_cnt - The number of bytes read from the tape drive.
+6.  read_cnt - The number of read requests issued to the tape drive.
+7.  read_ms - The amount of time (in milliseconds) spent waiting for read
+	requests to complete.
+8.  sync - Described below
+9.  write_block_cnt - The number of 512 byte blocks of data written to the
+	device. Note that this statistic is not related to the block size in
+	use by any tape I/O it is write_byte_cnt represented as a count of 512
+	byte blocks.
+10. write_byte_cnt - The number of bytes written to the tape drive.
+11. write_cnt - The number of write requests issued to the tape drive.
+12. write_ms - The amount of time (in milliseconds) spent waiting for write
+	requests to complete.
+
+Note: The count statistics are incrememented at the start of an I/O but the
+time they take to complete is not added to the statistics until they complete.
+
+When read all of the statistics may be out of sync. That is they may not be
+on consistent set of statistics because of the amount of time taken to
+open/read/close each statistics file if the tape drive is in use.
+To alleviate that issue and try to make a set of consistent statistics
+the sync file was created.
+
+When a non-zero value is written into the sync file all of the statistics
+are saved. Until a new value is written into the sync file accesses to the
+statistics files will return the saved values instead of the current values
+(writing the same value as previously written causes the statistics to be
+saved again). Writing 0 makes the statistics files provides access to the
+current instead of the saved values.
+
+The following is the suggested way to access the statistics when you require
+a consistent set of statistics:
+
+1. Determine the location of the statistics directory
+2. Open the sync file and write a set value into the file (choose one value
+	that your application uses always - doing so will allow someone else
+	to determine who else is using the sync file)
+3. Open, read, then close the individual statistics files
+4. Read back the sync value and ensure you read back the value that you wrote.
+If the value read back is not the same write your chosen value back into the
+sync file and then re-read the statistics. If the sync value has changed again
+stop after 3 attempts and just use the values you gathered. There should not
+be that many users of the statistics that a collision is likely to happen.
+5. Always write 0 back into the sync file when you are done then close it.
+
+If you wish to manually view the statistics you can do so in the following
+manner:
+
+$ cd /sys/class/scsi_tape/st0/device/statistics
+$ grep [0-9] *
+in_flight:0
+io_ms:33263
+other_cnt:5
+read_block_cnt:0
+read_byte_cnt:0
+read_cnt:0
+read_ms:0
+sync:0
+write_block_cnt:204800
+write_byte_cnt:104857600
+write_cnt:102400
+write_ms:24069
+
+
 BSD AND SYS V SEMANTICS
 
 The user can choose between these two behaviours of the tape driver by
