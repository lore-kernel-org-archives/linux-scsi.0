From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [PATCH v8] st: implement tape statistics
Date: Wed, 6 May 2015 01:37:20 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BFA971B@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:53022 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbbEFBi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 21:38:56 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>

This patch implements tape statistics in the st module via
sysfs. Current no statistics are available for tape I/O and there
is no easy way to reuse the block layer statistics for tape
as tape is a character device and does not have perform I/O in
sector sized chunks (the size of the data written to tape
can change). For tapes we also need extra stats related to
things like tape movement (via other I/O).

There have been multiple end users requesting statistics
including AT&T (and some HP customers who have not given
permission to be named). It is impossible for them
to investigate any issues related to tape performance
in a non-invasive way.

Signed-off-by: Shane Seymour <shane.seymour@hp.com>
---
Changes from v7
- Changed name of patch added colon
- Added better description of patch
- Removed tested by (myself) line
Changes from v6
- Removed tested by Laurence Oberman since the code has changed
significantly.
- Changed code to use ktime so time resolution is now in ns (Robert
Elliot) for virtual tape drives that may be able to submit and
complete an I/O within a jiffy.
- Changed code to use atomic64_t types for statistics to ensure
consistency between being updated and being read via sysfs (Robert
Elliot). This should help ensure that we do not have MP or
multi-threaded issues when accessing the data.
- Some tape stats structure members changed names after they
changed types to make their usage clearer.
- Sysfs stats files that changed from ms to ns changed names to
indicate that they were in ns now.
- Fixed typo in incremnented in sysfs description (Robert Elliot)
- Shorten statistics directory name to stats (Robert Elliot)
- Moved the update of in_flight so it's incremenented before we update
any statstics and decrememented after we're done.
- Missing braces between if/else added to more clearly show where
the if/else is.
- Tested on 4.0.0-next-20150423+
--- a/drivers/scsi/st.c	2015-03-04 18:04:34.428575747 -0600
+++ b/drivers/scsi/st.c	2015-04-22 17:04:43.908645984 -0500
@@ -471,6 +471,47 @@ static void st_release_request(struct st
 	kfree(streq);
 }
 
+static void st_do_stats(struct scsi_tape *STp, struct request *req)
+{
+	ktime_t now;
+
+	now = ktime_get();
+	if (req->cmd[0] == WRITE_6) {
+		now = ktime_sub(now, STp->stats->write_time);
+		atomic64_add(ktime_to_ns(now), &STp->stats->tot_write_time);
+		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
+		atomic64_inc(&STp->stats->write_cnt);
+		if (req->errors) {
+			atomic64_add(atomic_read(&STp->stats->last_write_size)
+				- STp->buffer->cmdstat.residual,
+				&STp->stats->write_byte_cnt);
+			if (STp->buffer->cmdstat.residual > 0)
+				atomic64_inc(&STp->stats->resid_cnt);
+		} else
+			atomic64_add(atomic_read(&STp->stats->last_write_size),
+				&STp->stats->write_byte_cnt);
+	} else if (req->cmd[0] == READ_6) {
+		now = ktime_sub(now, STp->stats->read_time);
+		atomic64_add(ktime_to_ns(now), &STp->stats->tot_read_time);
+		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
+		atomic64_inc(&STp->stats->read_cnt);
+		if (req->errors) {
+			atomic64_add(atomic_read(&STp->stats->last_read_size)
+				- STp->buffer->cmdstat.residual,
+				&STp->stats->read_byte_cnt);
+			if (STp->buffer->cmdstat.residual > 0)
+				atomic64_inc(&STp->stats->resid_cnt);
+		} else
+			atomic64_add(atomic_read(&STp->stats->last_read_size),
+				&STp->stats->read_byte_cnt);
+	} else {
+		now = ktime_sub(now, STp->stats->other_time);
+		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
+		atomic64_inc(&STp->stats->other_cnt);
+	}
+	atomic64_dec(&STp->stats->in_flight);
+}
+
 static void st_scsi_execute_end(struct request *req, int uptodate)
 {
 	struct st_request *SRpnt = req->end_io_data;
@@ -480,6 +521,8 @@ static void st_scsi_execute_end(struct r
 	STp->buffer->cmdstat.midlevel_result = SRpnt->result = req->errors;
 	STp->buffer->cmdstat.residual = req->resid_len;
 
+	st_do_stats(STp, req);
+
 	tmp = SRpnt->bio;
 	if (SRpnt->waiting)
 		complete(SRpnt->waiting);
@@ -496,6 +539,7 @@ static int st_scsi_execute(struct st_req
 	struct rq_map_data *mdata = &SRpnt->stp->buffer->map_data;
 	int err = 0;
 	int write = (data_direction == DMA_TO_DEVICE);
+	struct scsi_tape *STp = SRpnt->stp;
 
 	req = blk_get_request(SRpnt->stp->device->request_queue, write,
 			      GFP_KERNEL);
@@ -516,6 +560,17 @@ static int st_scsi_execute(struct st_req
 		}
 	}
 
+	atomic64_inc(&STp->stats->in_flight);
+	if (cmd[0] == WRITE_6) {
+		atomic_set(&STp->stats->last_write_size, bufflen);
+		STp->stats->write_time = ktime_get();
+	} else if (cmd[0] == READ_6) {
+		atomic_set(&STp->stats->last_read_size, bufflen);
+		STp->stats->read_time = ktime_get();
+	} else {
+		STp->stats->other_time = ktime_get();
+	}
+
 	SRpnt->bio = req->bio;
 	req->cmd_len = COMMAND_SIZE(cmd[0]);
 	memset(req->cmd, 0, BLK_MAX_CDB);
@@ -4222,6 +4277,12 @@ static int st_probe(struct device *dev)
 	}
 	tpnt->index = error;
 	sprintf(disk->disk_name, "st%d", tpnt->index);
+	tpnt->stats = kzalloc(sizeof(struct scsi_tape_stats), GFP_KERNEL);
+	if (tpnt->stats == NULL) {
+		sdev_printk(KERN_ERR, SDp,
+			    "st: Can't allocate statistics.\n");
+		goto out_idr_remove;
+	}
 
 	dev_set_drvdata(dev, tpnt);
 
@@ -4241,6 +4302,8 @@ static int st_probe(struct device *dev)
 
 out_remove_devs:
 	remove_cdevs(tpnt);
+	kfree(tpnt->stats);
+out_idr_remove:
 	spin_lock(&st_index_lock);
 	idr_remove(&st_index_idr, tpnt->index);
 	spin_unlock(&st_index_lock);
@@ -4298,6 +4361,7 @@ static void scsi_tape_release(struct kre
 
 	disk->private_data = NULL;
 	put_disk(disk);
+	kfree(tpnt->stats);
 	kfree(tpnt);
 	return;
 }
@@ -4513,6 +4577,184 @@ options_show(struct device *dev, struct
 }
 static DEVICE_ATTR_RO(options);
 
+/* Support for tape stats */
+
+/**
+ * read_cnt_show - return read count - count of reads made from tape drive
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t read_cnt_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%ld",
+		atomic64_read(&STm->tape->stats->read_cnt));
+}
+static DEVICE_ATTR_RO(read_cnt);
+
+/**
+ * read_byte_cnt_show - return read byte count - tape drives
+ * may use blocks less than 512 bytes this gives the raw byte count of
+ * of data read from the tape drive.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t read_byte_cnt_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%ld",
+		atomic64_read(&STm->tape->stats->read_byte_cnt));
+}
+static DEVICE_ATTR_RO(read_byte_cnt);
+
+/**
+ * read_us_show - return read us - overall time spent waiting on reads in ns.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t read_ns_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%ld",
+		atomic64_read(&STm->tape->stats->tot_read_time));
+}
+static DEVICE_ATTR_RO(read_ns);
+
+/**
+ * write_cnt_show - write count - number of user calls
+ * to write(2) that have written data to tape.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t write_cnt_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%ld",
+		atomic64_read(&STm->tape->stats->write_cnt));
+}
+static DEVICE_ATTR_RO(write_cnt);
+
+/**
+ * write_byte_cnt_show - write byte count - raw count of
+ * bytes written to tape.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t write_byte_cnt_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%ld",
+		atomic64_read(&STm->tape->stats->write_byte_cnt));
+}
+static DEVICE_ATTR_RO(write_byte_cnt);
+
+/**
+ * write_ns_show - write ns - number of nanoseconds waiting on write
+ * requests to complete.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t write_ns_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%ld",
+		atomic64_read(&STm->tape->stats->tot_write_time));
+}
+static DEVICE_ATTR_RO(write_ns);
+
+/**
+ * in_flight_show - number of I/Os currently in flight -
+ * in most cases this will be either 0 or 1. It may be higher if someone
+ * has also issued other SCSI commands such as via an ioctl.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t in_flight_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%ld",
+		atomic64_read(&STm->tape->stats->in_flight));
+}
+static DEVICE_ATTR_RO(in_flight);
+
+/**
+ * io_ns_show - io wait ns - this is the number of ns spent
+ * waiting on all I/O to complete. This includes tape movement commands
+ * such as rewinding, seeking to end of file or tape, it also includes
+ * read and write. To determine the time spent on tape movement
+ * subtract the read and write ns from this value.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t io_ns_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%ld",
+		atomic64_read(&STm->tape->stats->tot_io_time));
+}
+static DEVICE_ATTR_RO(io_ns);
+
+/**
+ * other_cnt_show - other io count - this is the number of
+ * I/O requests other than read and write requests.
+ * Typically these are tape movement requests but will include driver
+ * tape movement. This includes only requests issued by the st driver.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t other_cnt_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%ld",
+		atomic64_read(&STm->tape->stats->other_cnt));
+}
+static DEVICE_ATTR_RO(other_cnt);
+
+/**
+ * resid_cnt_show - A count of the number of times we get a residual
+ * count - this should indicate someone issuing reads larger than the
+ * block size on tape.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t resid_cnt_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%ld",
+		atomic64_read(&STm->tape->stats->resid_cnt));
+}
+static DEVICE_ATTR_RO(resid_cnt);
+
 static struct attribute *st_dev_attrs[] = {
 	&dev_attr_defined.attr,
 	&dev_attr_default_blksize.attr,
@@ -4521,7 +4763,35 @@ static struct attribute *st_dev_attrs[]
 	&dev_attr_options.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(st_dev);
+
+static struct attribute *st_stats_attrs[] = {
+	&dev_attr_read_cnt.attr,
+	&dev_attr_read_byte_cnt.attr,
+	&dev_attr_read_ns.attr,
+	&dev_attr_write_cnt.attr,
+	&dev_attr_write_byte_cnt.attr,
+	&dev_attr_write_ns.attr,
+	&dev_attr_in_flight.attr,
+	&dev_attr_io_ns.attr,
+	&dev_attr_other_cnt.attr,
+	&dev_attr_resid_cnt.attr,
+	NULL,
+};
+
+static struct attribute_group stats_group = {
+	.name = "stats",
+	.attrs = st_stats_attrs,
+};
+
+static struct attribute_group st_group = {
+	.attrs = st_dev_attrs,
+};
+
+static const struct attribute_group *st_dev_groups[] = {
+	&st_group,
+	&stats_group,
+	NULL,
+};
 
 /* The following functions may be useful for a larger audience. */
 static int sgl_map_user_pages(struct st_buffer *STbp,
--- a/drivers/scsi/st.h	2015-03-04 18:04:34.428575747 -0600
+++ b/drivers/scsi/st.h	2015-04-22 14:50:16.852195400 -0500
@@ -92,6 +92,27 @@ struct st_partstat {
 	int drv_file;
 };
 
+/* Tape statistics */
+struct scsi_tape_stats {
+	atomic64_t read_byte_cnt;  /* bytes read */
+	atomic64_t write_byte_cnt; /* bytes written */
+	atomic64_t in_flight;      /* Number of I/Os in flight */
+	atomic64_t read_cnt;       /* Count of read requests */
+	atomic64_t write_cnt;      /* Count of write requests */
+	atomic64_t other_cnt;      /* Count of other requests either
+				    * implicit or from user space
+				    * ioctl. */
+	atomic64_t resid_cnt;      /* Count of resid_len > 0 */
+	atomic64_t tot_read_time;  /* ktime spent completing reads */
+	atomic64_t tot_write_time; /* ktime spent completing writes */
+	atomic64_t tot_io_time;    /* ktime spent doing any I/O */
+	ktime_t read_time;         /* holds ktime request was queued */
+	ktime_t write_time;        /* holds ktime request was queued */
+	ktime_t other_time;        /* holds ktime request was queued */
+	atomic_t last_read_size;   /* Number of bytes issued for last read */
+	atomic_t last_write_size;  /* Number of bytes issued for last write */
+};
+
 #define ST_NBR_PARTITIONS 4
 
 /* The tape drive descriptor */
@@ -171,6 +192,7 @@ struct scsi_tape {
 #endif
 	struct gendisk *disk;
 	struct kref     kref;
+	struct scsi_tape_stats *stats;
 };
 
 /* Bit masks for use_pf */
--- a/Documentation/scsi/st.txt	2015-03-04 18:04:30.698576001 -0600
+++ b/Documentation/scsi/st.txt	2015-04-22 17:05:07.404644384 -0500
@@ -151,6 +151,65 @@ A link named 'tape' is made from the SCS
 directory corresponding to the mode 0 auto-rewind device (e.g., st0). 
 
 
+SYSFS AND STATISTICS FOR TAPE DEVICES
+
+The st driver maintains statistics for tape drives inside the sysfs filesystem.
+The following method can be used to locate the statistics that are
+available (assuming that sysfs is mounted at /sys):
+
+1. Use opendir(3) on the directory /sys/class/scsi_tape
+2. Use readdir(3) to read the directory contents
+3. Use regcomp(3)/regexec(3) to match directory entries to the extended
+        regular expression "^st[0-9]+$"
+4. Access the statistics from the /sys/class/scsi_tape/<match>/stats
+        directory (where <match> is a directory entry from /sys/class/scsi_tape
+        that matched the extended regular expression)
+
+The reason for using this approach is that all the character devices
+pointing to the same tape drive use the same statistics. That means
+that st0 would have the same statistics as nst0.
+
+The directory contains the following statistics files:
+
+1.  in_flight - The number of I/Os currently outstanding to this device.
+2.  io_ns - The amount of time spent waiting (in nanoseconds) for all I/O
+        to complete (including read and write). This includes tape movement
+        commands such as seeking between file or set marks and implicit tape
+        movement such as when rewind on close tape devices are used.
+3.  other_cnt - The number of I/Os issued to the tape drive other than read or
+        write commands. The time taken to complete these commands uses the
+        following calculation io_ms-read_ms-write_ms.
+4.  read_byte_cnt - The number of bytes read from the tape drive.
+5.  read_cnt - The number of read requests issued to the tape drive.
+6.  read_ns - The amount of time (in nanoseconds) spent waiting for read
+        requests to complete.
+7.  write_byte_cnt - The number of bytes written to the tape drive.
+8.  write_cnt - The number of write requests issued to the tape drive.
+9.  write_ns - The amount of time (in nanoseconds) spent waiting for write
+        requests to complete.
+10. resid_cnt - The number of times during a read or write we found
+	the residual amount to be non-zero. This should mean that a program
+	is issuing a read larger thean the block size on tape. For write
+	not all data made it to tape.
+
+Note: The in_flight value is incremented when an I/O starts the I/O
+itself is not added to the statistics until it completes.
+
+The total of read_cnt, write_cnt, and other_cnt may not total to the same
+value as iodone_cnt at the device level. The tape statistics only count
+I/O issued via the st module.
+
+When read the statistics may not be temporally consistent while I/O is in
+progress. The individual values are read and written to atomically however
+when reading them back via sysfs they may be in the process of being
+updated when starting an I/O or when it is completed.
+
+The value shown in in_flight is incremented before any statstics are
+updated and decremented when an I/O completes after updating statistics.
+The value of in_flight is 0 when there are no I/Os outstanding that are
+issued by the st driver. Tape statistics do not take into account any
+I/O performed via the sg device.
+
 BSD AND SYS V SEMANTICS
 
 The user can choose between these two behaviours of the tape driver by
--- a/Documentation/ABI/testing/sysfs-class-scsi_tape	1969-12-31 18:00:00.000000000 -0600
+++ b/Documentation/ABI/testing/sysfs-class-scsi_tape	2015-04-22 16:15:01.974849072 -0500
@@ -0,0 +1,109 @@
+What:           /sys/class/scsi_tape/*/stats/in_flight
+Date:           Apr 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Show the number of I/Os currently in-flight between the st
+		module and the SCSI mid-layer.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/stats/io_ns
+Date:           Apr 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total amount of time spent waiting for all I/O
+                to and from the tape drive to complete. This includes all
+                reads, writes, and other SCSI commands issued to the tape
+                drive. An example of other SCSI commands would be tape
+                movement such as a rewind when a rewind tape device is
+                closed. This item is measured in nanoseconds.
+
+                To determine the amount of time spent waiting for other I/O
+                to complete subtract read_ns and write_ns from this value.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/stats/other_cnt
+Date:           Apr 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		The number of I/O requests issued to the tape drive other
+		than SCSI read/write requests.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/stats/read_byte_cnt
+Date:           Apr 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total number of bytes requested from the tape drive.
+		This value is presented in bytes because tape drives support
+		variable length block sizes.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/stats/read_cnt
+Date:           Apr 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total number of read requests issued to the tape
+		drive.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/stats/read_ns
+Date:           Apr 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total amount of time in nanoseconds waiting for
+		read I/O requests to complete.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/stats/write_byte_cnt
+Date:           Apr 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total number of bytes written to the tape drive.
+		This value is presented in bytes because tape drives support
+		variable length block sizes.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/stats/write_cnt
+Date:           Apr 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total number of write requests issued to the tape
+		drive.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/stats/write_ms
+Date:           Apr 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total amount of time in nanoseconds waiting for
+		write I/O requests to complete.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/stats/resid_cnt
+Date:           Apr 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the number of times we found that a residual >0
+		was found when the SCSI midlayer indicated that there was
+		an error. For reads this may be a case of someone issuing
+		reads greater than the block size.
+Users:
