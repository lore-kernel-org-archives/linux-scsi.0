From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [RFC,PATCH] Statistics for SCSI tapes
Date: Tue, 22 Feb 2005 22:24:53 +0200 (EET)
Message-ID: <Pine.LNX.4.61.0502222211070.6519@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:24232 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261230AbVBVUX7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 15:23:59 -0500
Received: from kai.makisara.local ([84.230.129.65])
          by fep32-app.kolumbus.fi with ESMTP
          id <20050222202353.CGYT13446.fep32-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2005 22:23:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The patch at the end of this message adds a stat file to the primary st 
directory in /sys of each tape (e.g., /sys/class/scsi_tape/st0/stat). The 
contents of the file match the contents of the stat files in the 
subdirectories of /sys/block so that the same tools could be used to 
analyze all stat files (provided they find the stat files).

Some Unices implement statistics for each tape partition but this patch 
does not count the partitions separately.

The patch is against 2.6.11-rc4 + the descriptor based sense patch I sent 
on Feb 13 + the patch sent a few minutes ago. The patched driver compiles, 
did not crash the system and produced reasonable looking numbers.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.11-rc4-k2/drivers/scsi/st.c	2005-02-20 22:22:51.000000000 +0200
+++ linux-2.6.11-rc4-k3/drivers/scsi/st.c	2005-02-21 22:07:32.000000000 +0200
@@ -392,6 +392,14 @@ static void st_sleep_done(struct scsi_cm
 {
 	struct scsi_tape *STp = container_of(SCpnt->request->rq_disk->private_data,
 					     struct scsi_tape, driver);
+	unsigned long ticks = jiffies - STp->tapestats.stamp;
+
+	STp->tapestats.io_ticks += ticks;
+	STp->tapestats.in_flight--;
+	if (SCpnt->cmnd[0] == WRITE_6)
+		STp->tapestats.write_ticks += ticks;
+	else if (SCpnt->cmnd[0] == READ_6)
+		STp->tapestats.read_ticks += ticks;
 
 	(STp->buffer)->cmdstat.midlevel_result = SCpnt->result;
 	SCpnt->request->rq_status = RQ_SCSI_DONE;
@@ -423,6 +431,16 @@ st_do_scsi(struct scsi_request * SRpnt, 
 		}
 	}
 
+	if (cmd[0] == WRITE_6) {
+		STp->tapestats.write_bytes += bytes;
+		STp->tapestats.writes++;
+	}
+	else if (cmd[0] == READ_6) {
+		STp->tapestats.read_bytes += bytes;
+		STp->tapestats.reads++;
+	}
+	STp->tapestats.in_flight++;
+
 	init_completion(&STp->wait);
 	SRpnt->sr_use_sg = STp->buffer->do_dio || (bytes > (STp->buffer)->frp[0].length);
 	if (SRpnt->sr_use_sg) {
@@ -439,6 +457,8 @@ st_do_scsi(struct scsi_request * SRpnt, 
 	SRpnt->sr_request->rq_disk = STp->disk;
 	STp->buffer->cmdstat.have_sense = 0;
 
+	STp->tapestats.stamp = jiffies;
+
 	scsi_do_req(SRpnt, (void *) cmd, bp, bytes,
 		    st_sleep_done, timeout, retries);
 
@@ -3957,6 +3977,7 @@ static int st_probe(struct device *dev)
 			STm->cdevs[j] = cdev;
 
 		}
+		STm->tapestats = &tpnt->tapestats;
 		do_create_class_files(tpnt, dev_num, mode);
 	}
 
@@ -4237,6 +4258,28 @@ static ssize_t st_defcompression_show(st
 
 CLASS_DEVICE_ATTR(default_compression, S_IRUGO, st_defcompression_show, NULL);
 
+static ssize_t st_stat_show(struct class_device *class_dev, char *buf)
+{
+	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
+	ssize_t l = 0;
+
+	l = snprintf(buf, PAGE_SIZE,
+		     "%8u %8u %8llu %8u "
+		     "%8u %8u %8llu %8u "
+		     "%8u %8u %8u"
+		     "\n",
+		     STm->tapestats->reads, 0, STm->tapestats->read_bytes >> 9,
+		     jiffies_to_msecs(STm->tapestats->read_ticks),
+		     STm->tapestats->writes, 0, STm->tapestats->write_bytes >> 9,
+		     jiffies_to_msecs(STm->tapestats->write_ticks),
+		     STm->tapestats->in_flight,
+		     jiffies_to_msecs(STm->tapestats->io_ticks),
+		     jiffies_to_msecs(STm->tapestats->io_ticks));
+	return l;
+}
+
+CLASS_DEVICE_ATTR(stat, S_IRUGO, st_stat_show, NULL);
+
 static void do_create_class_files(struct scsi_tape *STp, int dev_num, int mode)
 {
 	int i, rew, error;
@@ -4273,6 +4316,8 @@ static void do_create_class_files(struct
 		class_device_create_file(st_class_member,
 					 &class_device_attr_default_compression);
 		if (mode == 0 && rew == 0) {
+			class_device_create_file(st_class_member,
+						 &class_device_attr_stat);
 			error = sysfs_create_link(&STp->device->sdev_gendev.kobj,
 						  &st_class_member->kobj,
 						  "tape");
--- linux-2.6.11-rc4-k2/drivers/scsi/st.h	2005-02-13 10:40:21.000000000 +0200
+++ linux-2.6.11-rc4-k3/drivers/scsi/st.h	2005-02-21 21:45:11.000000000 +0200
@@ -57,6 +57,7 @@ struct st_modedef {
 	unsigned char default_compression;	/* 0 = don't touch, etc */
 	short default_density;	/* Forced density, -1 = no value */
 	int default_blksize;	/* Forced blocksize, -1 = no value */
+	struct tape_stats *tapestats;
 	struct cdev *cdevs[2];  /* Auto-rewind and non-rewind devices */
 };
 
@@ -83,6 +84,16 @@ struct st_partstat {
 
 #define ST_NBR_PARTITIONS 4
 
+/* The performance counters */
+struct tape_stats {
+	u64 read_bytes, write_bytes;
+	u32 reads, writes;
+	u64 read_ticks, write_ticks;
+	u32 io_ticks;
+	u32 in_flight;
+	unsigned long stamp;
+};
+
 /* The tape drive descriptor */
 struct scsi_tape {
 	struct scsi_driver *driver;
@@ -144,6 +155,8 @@ struct scsi_tape {
 	int recover_count;     /* From tape opening */
 	int recover_reg;       /* From last status call */
 
+	struct tape_stats tapestats;	/* the performance counters */
+
 #if DEBUG
 	unsigned char write_pending;
 	int nbr_finished;
