From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [PATCH v6] st implement tape statistics
Date: Thu, 12 Feb 2015 11:15:42 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BF405B2@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:49730 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbbBLLQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2015 06:16:25 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>

The following patch exposes statistics for the st driver via sysfs.
There is a need for companies with large numbers of tape drives
numbering in the tens of thousands to track the performance of
those tape drives (e.g. when a backup exceeds its window). The
statistics provided should allow the calculation of throughput,
average block sizes for read and write, and time spent waiting
for I/O to complete or doing tape movement.

Signed-off-by: Shane Seymour <shane.seymour@hp.com>
Tested-by: Shane Seymour <shane.seymour@hp.com>
---
- Removed comment
- Found an issue where read and write sizes were over reported
(fixed) In all the test cases I have the stats now report what I
expect to be the correct value. Some of the values to be used
with statistics are now stored in temporary variables and used
to calculate the stats when the I/O ends. Separated out the
timestamp into 3 since I found it was possible for other tape
I/O to happen during writes updating the stamp value causing
the time tracked to be wrong.
- Moved the end statistics into a separate function because it
had made the function that it was in too large.
- Added a new statistic - A count of the number of times we had
a residual greater than 0.
--- a/drivers/scsi/st.c	2015-01-11 14:46:00.243814755 -0600
+++ b/drivers/scsi/st.c	2015-02-11 22:37:01.382243090 -0600
@@ -471,6 +471,47 @@ static void st_release_request(struct st
 	kfree(streq);
 }
 
+static void st_do_stats(struct scsi_tape *STp, struct request *req)
+{
+	u64 ticks;
+
+	ticks = get_jiffies_64();
+	STp->stats->in_flight--;
+	if (req->cmd[0] == WRITE_6) {
+		ticks -= STp->stats->write_stamp;
+		STp->stats->write_ticks += ticks;
+		STp->stats->io_ticks += ticks;
+		STp->stats->write_cnt++;
+		if (req->errors) {
+			STp->stats->write_byte_cnt +=
+				STp->stats->last_write_size -
+				STp->buffer->cmdstat.residual;
+			if (STp->buffer->cmdstat.residual > 0)
+				STp->stats->resid_cnt++;
+		} else
+			STp->stats->write_byte_cnt +=
+				STp->stats->last_write_size;
+	} else if (req->cmd[0] == READ_6) {
+		ticks -= STp->stats->read_stamp;
+		STp->stats->read_ticks += ticks;
+		STp->stats->io_ticks += ticks;
+		STp->stats->read_cnt++;
+		if (req->errors)
+			STp->stats->read_byte_cnt +=
+				STp->stats->last_read_size -
+				STp->buffer->cmdstat.residual;
+			if (STp->buffer->cmdstat.residual > 0)
+				STp->stats->resid_cnt++;
+		else
+			STp->stats->read_byte_cnt +=
+				STp->stats->last_read_size;
+	} else {
+		ticks -= STp->stats->other_stamp;
+		STp->stats->io_ticks += ticks;
+		STp->stats->other_cnt++;
+	}
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
 
+	if (cmd[0] == WRITE_6) {
+		STp->stats->last_write_size = bufflen;
+		STp->stats->write_stamp = get_jiffies_64();
+	} else if (cmd[0] == READ_6) {
+		STp->stats->last_read_size = bufflen;
+		STp->stats->read_stamp = get_jiffies_64();
+	} else {
+		STp->stats->other_stamp = get_jiffies_64();
+	}
+	STp->stats->in_flight++;
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
@@ -4513,6 +4577,178 @@ options_show(struct device *dev, struct
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
+	return sprintf(buf, "%llu", STm->tape->stats->read_cnt);
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
+	return sprintf(buf, "%llu", STm->tape->stats->read_byte_cnt);
+}
+static DEVICE_ATTR_RO(read_byte_cnt);
+
+/**
+ * read_ms_show - return read ms - overall time spent waiting on reads in ms.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t read_ms_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u",
+		jiffies_to_msecs(STm->tape->stats->read_ticks));
+}
+static DEVICE_ATTR_RO(read_ms);
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
+	return sprintf(buf, "%llu", STm->tape->stats->write_cnt);
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
+	return sprintf(buf, "%llu",
+		STm->tape->stats->write_byte_cnt);
+}
+static DEVICE_ATTR_RO(write_byte_cnt);
+
+/**
+ * write_ms_show - write ms - number of milliseconds since
+ * last open waiting on write requests to complete.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t write_ms_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u",
+		jiffies_to_msecs(STm->tape->stats->write_ticks));
+}
+static DEVICE_ATTR_RO(write_ms);
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
+	return sprintf(buf, "%llu", STm->tape->stats->in_flight);
+}
+static DEVICE_ATTR_RO(in_flight);
+
+/**
+ * io_ms_show - io wait ms - this is the number of ms spent
+ * waiting on all I/O to complete. This includes tape movement commands
+ * such as rewinding, seeking to end of file or tape, etc. Except in
+ * complex tape management programs these will be indirect commands issued
+ * by the driver - e.g. rewind on close.
+ * @dev: struct device
+ * @attr: attribute structure
+ * @buf: buffer to return formatted data in
+ */
+static ssize_t io_ms_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct st_modedef *STm = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u",
+		jiffies_to_msecs(STm->tape->stats->io_ticks));
+}
+static DEVICE_ATTR_RO(io_ms);
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
+	return sprintf(buf, "%llu", STm->tape->stats->other_cnt);
+}
+static DEVICE_ATTR_RO(other_cnt);
+
+/**
+ * resid_cnt_show - A count of the number of times we get a residual
+ * count - this should indicate someon issuing reads larger than the
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
+	return sprintf(buf, "%llu", STm->tape->stats->resid_cnt);
+}
+static DEVICE_ATTR_RO(resid_cnt);
+
 static struct attribute *st_dev_attrs[] = {
 	&dev_attr_defined.attr,
 	&dev_attr_default_blksize.attr,
@@ -4521,7 +4757,35 @@ static struct attribute *st_dev_attrs[]
 	&dev_attr_options.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(st_dev);
+
+static struct attribute *st_stats_attrs[] = {
+	&dev_attr_read_cnt.attr,
+	&dev_attr_read_byte_cnt.attr,
+	&dev_attr_read_ms.attr,
+	&dev_attr_write_cnt.attr,
+	&dev_attr_write_byte_cnt.attr,
+	&dev_attr_write_ms.attr,
+	&dev_attr_in_flight.attr,
+	&dev_attr_io_ms.attr,
+	&dev_attr_other_cnt.attr,
+	&dev_attr_resid_cnt.attr,
+	NULL,
+};
+
+static struct attribute_group stats_group = {
+	.name = "statistics",
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
--- a/drivers/scsi/st.h	2015-01-11 14:46:00.243814755 -0600
+++ b/drivers/scsi/st.h	2015-02-11 22:12:50.442341908 -0600
@@ -92,6 +92,26 @@ struct st_partstat {
 	int drv_file;
 };
 
+/* Tape statistics */
+struct scsi_tape_stats {
+	u64 read_byte_cnt;      /* bytes read */
+	u64 write_byte_cnt;     /* bytes written */
+	u64 in_flight;          /* Number of I/Os in flight */
+	u64 read_cnt;           /* Count of read requests */
+	u64 write_cnt;          /* Count of write requests */
+	u64 other_cnt;          /* Count of other requests either implicit
+					or from user space via ioctl. */
+	u64 read_ticks;         /* Ticks spent completing read requests */
+	u64 write_ticks;        /* Ticks spent completing write requests */
+	u64 io_ticks;           /* Ticks spent doing any I/O */
+	u64 resid_cnt;          /* Count of resid_len > 0 */
+	u64 read_stamp;         /* holds time request was queued */
+	u64 write_stamp;        /* holds time request was queued */
+	u64 other_stamp;        /* holds time request was queued */
+	u32 last_read_size;	/* Number of bytes issued for last read */
+	u32 last_write_size;	/* Number of bytes issued for last write */
+};
+
 #define ST_NBR_PARTITIONS 4
 
 /* The tape drive descriptor */
@@ -171,6 +191,7 @@ struct scsi_tape {
 #endif
 	struct gendisk *disk;
 	struct kref     kref;
+	struct scsi_tape_stats *stats;
 };
 
 /* Bit masks for use_pf */
--- a/Documentation/scsi/st.txt	2015-01-11 14:45:56.235815028 -0600
+++ b/Documentation/scsi/st.txt	2015-02-11 22:17:17.588323714 -0600
@@ -151,6 +151,59 @@ A link named 'tape' is made from the SCS
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
+4. Access the statistics from the /sys/class/scsi_tape/<match>/statistics
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
+2.  io_ms - The amount of time spent waiting (in milliseconds) for all I/O
+        to complete (including read and write). This includes tape movement
+        commands such as seeking between file or set marks and implicit tape
+        movement such as when rewind on close tape devices are used.
+3.  other_cnt - The number of I/Os issued to the tape drive other than read or
+        write commands. The time taken to complete these commands uses the
+        following calculation io_ms-read_ms-write_ms.
+4.  read_byte_cnt - The number of bytes read from the tape drive.
+5.  read_cnt - The number of read requests issued to the tape drive.
+6.  read_ms - The amount of time (in milliseconds) spent waiting for read
+        requests to complete.
+7.  write_byte_cnt - The number of bytes written to the tape drive.
+8.  write_cnt - The number of write requests issued to the tape drive.
+9.  write_ms - The amount of time (in milliseconds) spent waiting for write
+        requests to complete.
+10. resid_cnt - The number of times during a read or write we found
+	the residual amount to be non-zero. This should mean that a program
+	is issuing a read larger thean the block size on tape. For write
+	not all data made it to tape.
+
+Note: The in_flight value is incremnented when an I/O starts the I/O
+itself is not added to the statistics until it completes.
+
+The total of read_cnt, write_cnt, and other_cnt may not total to the same
+value as iodone_cnt at the device level. The tape statistics only count
+I/O issued via the st module.
+
+When read the statistics may not be temporally consistent. They should
+however be close and when used to calculate averages or throughput it
+shouldn't matter.
+
+
 BSD AND SYS V SEMANTICS
 
 The user can choose between these two behaviours of the tape driver by
--- a/Documentation/ABI/testing/sysfs-class-scsi_tape	1969-12-31 18:00:00.000000000 -0600
+++ b/Documentation/ABI/testing/sysfs-class-scsi_tape	2015-02-11 22:35:28.068249446 -0600
@@ -0,0 +1,109 @@
+What:           /sys/class/scsi_tape/*/statistics/in_flight
+Date:           Feb 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Show the number of I/Os currently in-flight between the st
+		module and the SCSI mid-layer.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/statistics/io_ms
+Date:           Feb 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total amount of time spent waiting for all I/O
+                to and from the tape drive to complete. This includes all
+                reads, writes, and other SCSI commands issued to the tape
+                drive. An example of other SCSI commands would be tape
+                movement such as a rewind when a rewind tape device is
+                closed.
+
+                To determine the amount of time spent waiting for other I/O
+                to complete subtract read_ms and write_ms from this value.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/statistics/other_cnt
+Date:           Feb 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		The number of I/O requests issued to the tape drive other
+		than SCSI read/write requests.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/statistics/read_byte_cnt
+Date:           Feb 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total number of bytes requested from the tape drive.
+		This value is presented in bytes because tape drives support
+		variable length block sizes.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/statistics/read_cnt
+Date:           Feb 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total number of read requests issued to the tape
+		drive.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/statistics/read_ms
+Date:           Feb 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total amount of time in milliseconds waiting for
+		read I/O requests to complete.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/statistics/write_byte_cnt
+Date:           Feb 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total number of bytes written to the tape drive.
+		This value is presented in bytes because tape drives support
+		variable length block sizes.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/statistics/write_cnt
+Date:           Feb 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total number of write requests issued to the tape
+		drive.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/statistics/write_ms
+Date:           Feb 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the total amount of time in milliseconds waiting for
+		write I/O requests to complete.
+Users:
+
+
+What:           /sys/class/scsi_tape/*/statistics/resid_cnt
+Date:           Feb 2015
+KernelVersion:  ??????
+Contact:        Shane Seymour <shane.seymour@hp.com>
+Description:
+		Shows the number of times we found that a residual >0
+		was found when the SCSI midlayer indicated that there was
+		an error. For reads this may be a case of someone issuing
+		reads greater than the block size.
+Users:
