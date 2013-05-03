From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [PATCH v2]st: provide tape statistics via sysfs
Date: Fri, 3 May 2013 06:12:30 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3439AE6D@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:10718 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760548Ab3ECGNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 May 2013 02:13:50 -0400
Received: from G9W0364.americas.hpqcorp.net (g9w0364.houston.hp.com [16.216.193.45])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by g4t0015.houston.hp.com (Postfix) with ESMTPS id 270A0896D
	for <linux-scsi@vger.kernel.org>; Fri,  3 May 2013 06:13:50 +0000 (UTC)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

New version of statistics patch:

- Removed sysfs file containing hint for number of tape drives
- Removed disk like stat file - there is now one file per statistic as per feedback from James
- Like all other kernel stats these start at zero and keep incrementing (cannot zero them any more)
- Implemented a method where the statistics files can be frozen at a point in time to allow consistent statistics to be read from the group of statistics files (permissions on the sync file limit mean you need an euid of 0 to freeze the statistics)
- Example output of statistics directory:

# ll /sys/class/scsi_tape/st0/device/statistics
total 0
-r--r--r--. 1 root root 4096 May  3 06:32 in_flight
-r--r--r--. 1 root root 4096 May  3 06:32 io_ms
-r--r--r--. 1 root root 4096 May  3 06:32 other_cnt
-r--r--r--. 1 root root 4096 May  3 06:32 read_block_cnt
-r--r--r--. 1 root root 4096 May  3 06:32 read_byte_cnt
-r--r--r--. 1 root root 4096 May  3 06:32 read_cnt
-r--r--r--. 1 root root 4096 May  3 06:32 read_ms
-rw-rw-r--. 1 root root 4096 May  3 06:41 sync
-r--r--r--. 1 root root 4096 May  3 06:32 write_block_cnt
-r--r--r--. 1 root root 4096 May  3 06:32 write_byte_cnt
-r--r--r--. 1 root root 4096 May  3 06:32 write_cnt
-r--r--r--. 1 root root 4096 May  3 06:32 write_ms

Needs the previous patch I sent this week titled "st: clear driver data from struct device when released" to be applied before this one (the diff below is not against a vanilla 3.9 kernel it is against 3.9 with that patch applied to it to get this patch).

Signed-off-by: Shane Seymour <shane.seymour@hp.com>
Tested-by: Shane Seymour <shane.seymour@hp.com>
---
diff -uprN -X linux-3.9-vanilla/Documentation/dontdiff linux-3.9-vanilla/drivers/scsi/st.c linux-3.9/drivers/scsi/st.c
--- linux-3.9-vanilla/drivers/scsi/st.c	2013-05-03 05:46:32.000000000 +0100
+++ linux-3.9/drivers/scsi/st.c	2013-05-03 06:46:55.000000000 +0100
@@ -218,6 +218,15 @@ static DEFINE_SPINLOCK(st_index_lock);
 static DEFINE_SPINLOCK(st_use_lock);
 static DEFINE_IDR(st_index_idr);
 
+static inline void st_stats_remove_files(struct scsi_tape *);
+static inline void st_stats_create_files(struct scsi_tape *);
+static ssize_t st_tape_attr_show(struct kobject *, struct attribute *, char *);
+static ssize_t st_tape_attr_store(struct kobject *, struct attribute *,
+	const char *, size_t);
+static const struct sysfs_ops st_stats_sysfs_ops = {
+	.show   = st_tape_attr_show,
+	.store  = st_tape_attr_store,
+};
 
 

 #include "osst_detect.h"
@@ -458,10 +467,19 @@ static void st_scsi_execute_end(struct r
 	struct st_request *SRpnt = req->end_io_data;
 	struct scsi_tape *STp = SRpnt->stp;
 	struct bio *tmp;
+	u64 ticks = get_jiffies_64();
 
 	STp->buffer->cmdstat.midlevel_result = SRpnt->result = req->errors;
 	STp->buffer->cmdstat.residual = req->resid_len;
 
+	STp->in_flight--;
+	ticks -= STp->stamp;
+	STp->io_ticks += ticks;
+	if (req->cmd[0] == WRITE_6)
+		STp->write_ticks += ticks;
+	else if (req->cmd[0] == READ_6)
+		STp->read_ticks += ticks;
+
 	tmp = SRpnt->bio;
 	if (SRpnt->waiting)
 		complete(SRpnt->waiting);
@@ -478,6 +496,7 @@ static int st_scsi_execute(struct st_req
 	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
 	int err = 0;
 	int write = (data_direction == DMA_TO_DEVICE);
+	struct scsi_tape *STp = SRpnt->stp;
 
 	req = blk_get_request(SRpnt->stp->device->request_queue, write,
 			      GFP_KERNEL);
@@ -498,6 +517,18 @@ static int st_scsi_execute(struct st_req
 		}
 	}
 
+	if (cmd[0] == WRITE_6) {
+		STp->write_cnt++;
+		STp->write_byte_cnt += bufflen;
+	} else if (cmd[0] == READ_6) {
+		STp->read_cnt++;
+		STp->read_byte_cnt += bufflen;
+	} else {
+		STp->other_cnt++;
+	}
+	STp->stamp = get_jiffies_64();
+	STp->in_flight++;
+
 	SRpnt->bio = req->bio;
 	req->cmd_len = COMMAND_SIZE(cmd[0]);
 	memset(req->cmd, 0, BLK_MAX_CDB);
@@ -4048,6 +4079,14 @@ static int create_cdevs(struct scsi_tape
 		if (error)
 			return error;
 	}
+/* Create statistics directory under device, if it fails we dont
+   have statistics. */
+	tape->statistics = kobject_create_and_add("statistics",
+		&tape->device->sdev_gendev.kobj);
+	if (tape->statistics != 0) {
+		st_stats_create_files(tape);
+		tape->statistics->ktype->sysfs_ops = &st_stats_sysfs_ops;
+	}
 
 	return sysfs_create_link(&tape->device->sdev_gendev.kobj,
 				 &tape->modes[0].devs[0]->kobj, "tape");
@@ -4057,6 +4096,10 @@ static void remove_cdevs(struct scsi_tap
 {
 	int mode, rew;
 	sysfs_remove_link(&tape->device->sdev_gendev.kobj, "tape");
+	if (tape->statistics != 0) {
+		st_stats_remove_files(tape);
+		kobject_put(tape->statistics);
+	}
 	for (mode = 0; mode < ST_NBR_MODES; mode++) {
 		struct st_modedef *STm = &(tape->modes[mode]);
 		for (rew = 0; rew < 2; rew++) {
@@ -4127,6 +4170,28 @@ static int st_probe(struct device *dev)
 	tpnt->buffer = buffer;
 	tpnt->buffer->last_SRpnt = NULL;
 
+	tpnt->statistics = 0;
+	tpnt->read_byte_cnt = 0;
+	tpnt->write_byte_cnt = 0;
+	tpnt->read_cnt = 0;
+	tpnt->write_cnt = 0;
+	tpnt->other_cnt = 0;
+	tpnt->in_flight = 0;
+	tpnt->read_ticks = 0;
+	tpnt->write_ticks = 0;
+	tpnt->io_ticks = 0;
+	tpnt->stamp = 0;
+	tpnt->sync = 0;
+	tpnt->sync_read_byte_cnt = 0;
+	tpnt->sync_write_byte_cnt = 0;
+	tpnt->sync_in_flight = 0;
+	tpnt->sync_read_cnt = 0;
+	tpnt->sync_write_cnt = 0;
+	tpnt->sync_other_cnt = 0;
+	tpnt->sync_read_ticks = 0;
+	tpnt->sync_write_ticks = 0;
+	tpnt->sync_io_ticks = 0;
+
 	tpnt->inited = 0;
 	tpnt->dirty = 0;
 	tpnt->in_use = 0;
@@ -4484,6 +4549,439 @@ static struct device_attribute st_dev_at
 	__ATTR_NULL,
 };
 
+/* Support for tape stats */
+
+struct tape_stats_attr {
+	struct attribute        attr;
+	ssize_t (*show)(struct scsi_tape *, char *);
+	ssize_t (*store)(struct scsi_tape *, const char *, size_t);
+};
+
+#define TAPE_STATS_ATTR(_name, _mode, _show, _store)			\
+struct tape_stats_attr tape_stats_attr_##_name = {			\
+	.attr = {.name  = __stringify(_name) , .mode   = _mode },	\
+	.show   = _show,						\
+	.store	= _store,						\
+};
+
+/**
+ * st_stats_create_file - create sysfs tape stats attribute file
+ * @st: scsi_tape structure.
+ * @attr: device attribute descriptor.
+ */
+static inline int st_stats_create_file(struct scsi_tape *st,
+	const struct tape_stats_attr *attr)
+{
+	int error = 0;
+	if (st)
+		error = sysfs_create_file(st->statistics, &attr->attr);
+	return error;
+}
+
+/**
+ * st_stats_remove_file - remove sysfs atape stats attribute file.
+ * @st: scsi_tape structure.
+ * @attr: device attribute descriptor.
+ */
+static inline void st_stats_remove_file(struct scsi_tape *st,
+	const struct tape_stats_attr *attr)
+{
+	if (st)
+		sysfs_remove_file(st->statistics, &attr->attr);
+}
+
+/**
+ * st_stats_attr_show_read_cnt - return read count - count of reads made
+ * from tape drive
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+ssize_t st_stats_attr_show_read_cnt(struct scsi_tape *st, char *buf)
+{
+	if (st->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->read_cnt);
+	return snprintf(buf, 4096, "%llu", st->sync_read_cnt);
+}
+
+/**
+ * st_stats_attr_show_read_byte_cnt - return read byte count - tape drives
+ * may use blocks less than 512 bytes this gives the raw byte count of
+ * of data read from the tape drive.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+ssize_t st_stats_attr_show_read_byte_cnt(struct scsi_tape *st, char *buf)
+{
+	if (st->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->read_byte_cnt);
+	return snprintf(buf, 4096, "%llu", st->sync_read_byte_cnt);
+}
+
+/**
+ * st_stats_attr_show_read_block_cnt - return read block count -
+ * provides disk like data for someone expecting that instead of wanting
+ * byte counts.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+ssize_t st_stats_attr_show_read_block_cnt(struct scsi_tape *st, char *buf)
+{
+	if (st->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->read_byte_cnt >> 9);
+	return snprintf(buf, 4096, "%llu", st->sync_read_byte_cnt >> 9);
+}
+
+/**
+ * st_stats_attr_show_read_ms - return read ms - overall time spent waiting
+ * on reads in ms.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+ssize_t st_stats_attr_show_read_ms(struct scsi_tape *st, char *buf)
+{
+	if (st->sync == 0)
+		return snprintf(buf, 4096, "%u",
+			jiffies_to_msecs(st->read_ticks));
+	return snprintf(buf, 4096, "%u", jiffies_to_msecs(st->sync_read_ticks));
+}
+
+/**
+ * st_stats_attr_show_write_cnt - write count - number of user calls
+ * to write(2) that have written data to tape.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+ssize_t st_stats_attr_show_write_cnt(struct scsi_tape *st, char *buf)
+{
+	if (st->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->write_cnt);
+	return snprintf(buf, 4096, "%llu", st->sync_write_cnt);
+}
+
+/**
+ * st_stats_attr_show_write_byte_cnt - write byte count - raw count of
+ * bytes written to tape.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+ssize_t st_stats_attr_show_write_byte_cnt(struct scsi_tape *st, char *buf)
+{
+	if (st->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->write_byte_cnt);
+	return snprintf(buf, 4096, "%llu", st->sync_write_byte_cnt);
+}
+
+/**
+ * st_stats_attr_show_write_block_cnt - write block total - raw count of
+ * 512 byte blocks written to tape. This is for compatability
+ * with disk type information although it doesn't mean much for tapes since
+ * they can have a block size of less than 512 bytes.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+ssize_t st_stats_attr_show_write_block_cnt(struct scsi_tape *st, char *buf)
+{
+	if (st->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->write_byte_cnt >> 9);
+	return snprintf(buf, 4096, "%llu", st->sync_write_byte_cnt >> 9);
+}
+
+/**
+ * st_stats_attr_show_write_ms - write ms - number of milliseconds since
+ * last open waiting on write requests to complete.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+ssize_t st_stats_attr_show_write_ms(struct scsi_tape *st, char *buf)
+{
+	if (st->sync == 0)
+		return snprintf(buf, 4096, "%u",
+			jiffies_to_msecs(st->write_ticks));
+	return snprintf(buf, 4096, "%u",
+		jiffies_to_msecs(st->sync_write_ticks));
+}
+
+/**
+ * st_stats_attr_show_in_flight - number of I/Os currently in flight -
+ * in most cases this will be either 0 or 1. It may be higher if someone
+ * has also issued other SCSI commands such as via an ioctl.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+ssize_t st_stats_attr_show_in_flight(struct scsi_tape *st, char *buf)
+{
+	if (st->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->in_flight);
+	return snprintf(buf, 4096, "%llu", st->sync_in_flight);
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
+ssize_t st_stats_attr_show_io_ms(struct scsi_tape *st, char *buf)
+{
+	if (st->sync == 0)
+		return snprintf(buf, 4096, "%u",
+			jiffies_to_msecs(st->io_ticks));
+	return snprintf(buf, 4096, "%u", jiffies_to_msecs(st->sync_io_ticks));
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
+ssize_t st_stats_attr_show_other_cnt(struct scsi_tape *st, char *buf)
+{
+	if (st->sync == 0)
+		return snprintf(buf, 4096, "%llu", st->other_cnt);
+	return snprintf(buf, 4096, "%llu", st->sync_other_cnt);
+}
+/**
+ * st_stats_attr_show_sync - if 0 is returned the stats are being read
+ * directly and are not in sync. Anyone using the sync interface should
+ * chose a random value that nobody else will use. Every time you want the
+ * stats updated you write the same value into the sync file to cause
+ * them to be copied. You can read this back when done to see if someone
+ * else has changed the sync value (i.e. someone else has caused an update
+ * to happen. You can either read them again after writing your sync
+ * value back or take the stats as they are forewarned that they may not
+ * be completely in sync.
+ * If you do not care about them being in sync you need to take some
+ * action if the sync value is non-zero as someone could have left it
+ * non-zero which means the values never change. You should write a "0"
+ * to the sync file before you read the read the other stats files.
+ * @st: scsi_tape structure.
+ * @buf: buffer to return formatted data in
+ */
+ssize_t st_stats_attr_show_sync(struct scsi_tape *st, char *buf)
+{
+	return snprintf(buf, 4096, "%llu", st->sync);
+}
+
+ssize_t st_stats_attr_store_sync(struct scsi_tape *st, const char *buf,
+	size_t len)
+{
+	if (sscanf(buf, "%llu", &st->sync) != 1)
+		st->sync = 0;
+	if (st->sync == 0)
+		return len;
+	st->sync_read_byte_cnt = st->read_byte_cnt;
+	st->sync_write_byte_cnt = st->write_byte_cnt;
+	st->sync_in_flight = st->in_flight;
+	st->sync_read_cnt = st->read_cnt;
+	st->sync_write_cnt = st->write_cnt;
+	st->sync_other_cnt = st->other_cnt;
+	st->sync_read_ticks = st->read_ticks;
+	st->sync_write_ticks = st->write_ticks;
+	st->sync_io_ticks = st->io_ticks;
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
+
+/**
+ * st_stats_create_files - register files in the device
+ * statistics directory.
+ * @st: scsi_tape structure.
+ */
+static inline void st_stats_create_files(struct scsi_tape *st)
+{
+	if (st_stats_create_file(st, &tape_stats_attr_read_cnt))
+		goto error_read_cnt;
+	if (st_stats_create_file(st, &tape_stats_attr_read_byte_cnt))
+		goto error_read_byte_cnt;
+	if (st_stats_create_file(st, &tape_stats_attr_read_block_cnt))
+		goto error_read_block_cnt;
+	if (st_stats_create_file(st, &tape_stats_attr_read_ms))
+		goto error_read_ms;
+	if (st_stats_create_file(st, &tape_stats_attr_write_cnt))
+		goto error_write_cnt;
+	if (st_stats_create_file(st, &tape_stats_attr_write_byte_cnt))
+		goto error_write_byte_cnt;
+	if (st_stats_create_file(st, &tape_stats_attr_write_block_cnt))
+		goto error_write_block_cnt;
+	if (st_stats_create_file(st, &tape_stats_attr_write_ms))
+		goto error_write_ms;
+	if (st_stats_create_file(st, &tape_stats_attr_in_flight))
+		goto error_in_flight;
+	if (st_stats_create_file(st, &tape_stats_attr_io_ms))
+		goto error_io_ms;
+	if (st_stats_create_file(st, &tape_stats_attr_other_cnt))
+		goto error_other_cnt;
+	if (st_stats_create_file(st, &tape_stats_attr_sync))
+		goto error_sync;
+	return;
+error_sync:
+	st_stats_remove_file(st, &tape_stats_attr_sync);
+error_other_cnt:
+	st_stats_remove_file(st, &tape_stats_attr_other_cnt);
+error_io_ms:
+	st_stats_remove_file(st, &tape_stats_attr_io_ms);
+error_in_flight:
+	st_stats_remove_file(st, &tape_stats_attr_in_flight);
+error_write_ms:
+	st_stats_remove_file(st, &tape_stats_attr_write_ms);
+error_write_block_cnt:
+	st_stats_remove_file(st, &tape_stats_attr_write_block_cnt);
+error_write_byte_cnt:
+	st_stats_remove_file(st, &tape_stats_attr_write_byte_cnt);
+error_write_cnt:
+	st_stats_remove_file(st, &tape_stats_attr_write_cnt);
+error_read_ms:
+	st_stats_remove_file(st, &tape_stats_attr_read_ms);
+error_read_block_cnt:
+	st_stats_remove_file(st, &tape_stats_attr_read_block_cnt);
+error_read_byte_cnt:
+	st_stats_remove_file(st, &tape_stats_attr_read_byte_cnt);
+error_read_cnt:
+	st_stats_remove_file(st, &tape_stats_attr_read_cnt);
+}
+
+#define to_tape_stats_attr(ptr) container_of(ptr, struct tape_stats_attr, attr)
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
+	if (st_attr->store)
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
+ * This function makes sure that the struct scsi_tape being refered to is
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
+
+/* kobject passed in is for the statistics directory. We need to look at the
+   parent kobject (part of a struct device) and from there get the struct
+   scsi_tape. If no show function return error as well. */
+	if ((!st_attr->show) || (ktemp == 0))
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
+	if (st_attr->show)
+		ret = st_attr->show(st, buf);
+
+	mutex_lock(&st_ref_mutex);
+	kref_put(&st->kref, scsi_tape_release);
+	mutex_unlock(&st_ref_mutex);
+
+	return ret;
+}
+
+/**
+ * st_stats_remove_files - remove the files from the statistics directory.
+ * @st: struct scsi_tape
+ */
+static inline void st_stats_remove_files(struct scsi_tape *st)
+{
+	st_stats_remove_file(st, &tape_stats_attr_other_cnt);
+	st_stats_remove_file(st, &tape_stats_attr_io_ms);
+	st_stats_remove_file(st, &tape_stats_attr_in_flight);
+	st_stats_remove_file(st, &tape_stats_attr_write_ms);
+	st_stats_remove_file(st, &tape_stats_attr_write_block_cnt);
+	st_stats_remove_file(st, &tape_stats_attr_write_byte_cnt);
+	st_stats_remove_file(st, &tape_stats_attr_write_cnt);
+	st_stats_remove_file(st, &tape_stats_attr_read_ms);
+	st_stats_remove_file(st, &tape_stats_attr_read_block_cnt);
+	st_stats_remove_file(st, &tape_stats_attr_read_byte_cnt);
+	st_stats_remove_file(st, &tape_stats_attr_read_cnt);
+	st_stats_remove_file(st, &tape_stats_attr_sync);
+}
+
 /* The following functions may be useful for a larger audience. */
 static int sgl_map_user_pages(struct st_buffer *STbp,
 			      const unsigned int max_pages, unsigned long uaddr,
diff -uprN -X linux-3.9-vanilla/Documentation/dontdiff linux-3.9-vanilla/drivers/scsi/st.h linux-3.9/drivers/scsi/st.h
--- linux-3.9-vanilla/drivers/scsi/st.h	2013-04-29 01:36:01.000000000 +0100
+++ linux-3.9/drivers/scsi/st.h	2013-05-03 03:25:40.000000000 +0100
@@ -158,6 +158,29 @@ struct scsi_tape {
 	int max_block;
 	int recover_count;     /* From tape opening */
 	int recover_reg;       /* From last status call */
+/* Statistics variables */
+	struct kobject *statistics;	/* Object for statistics directory */
+	u64 read_byte_cnt;	/* bytes read */
+	u64 write_byte_cnt;	/* bytes written */
+	u64 in_flight;		/* Number of I/Os in flight */
+	u64 read_cnt;		/* Count of read requests */
+	u64 write_cnt;		/* Count of write requests */
+	u64 other_cnt;		/* Count of other requests either implicit
+				   or from user space via ioctl. */
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
 
 #if DEBUG
 	unsigned char write_pending;
