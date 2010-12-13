From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: [PATCH] add recovery flag options for scsi_eh
Date: Mon, 13 Dec 2010 09:54:23 +0900
Message-ID: <4D056EBF.3050200@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48164 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab0LMAye (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Dec 2010 19:54:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, linux-raid@vger.kernel.org

Hi,

This patch introduces fast scsi_eh option mainly for an environment
using software raid or multipath.

The problem I mention in the following regarding default behavior of
the scsi_eh kernel thread prevents high availability of software raid
or multipath storage. So I strongly feel that the driver provide some
options on what to do.


Problem

  We've had a particulary bad storage device which, for exmaple, showed
  following behavior when i/o had timed out.
  
  While unjamming stalled commands, LLDD (using lpfc) i/o abort handler
  has succeeded, but scsi_eh_tur had no response from the drive and
  resulted in being timed out for some reason. This made it look like
  whole aborting failed although abort handler itself did not fail.
  
  After the abort failure, the thread has gone through all the reset
  handlers (lun, target, bus, host). Whether they succeeded or ended up
  offlining the device, they spent pretty much time depending on the
  number of stalled commands, and because of all the tur commands.
  
  Possibly spending almost 10 minutes or so unjamming stalled commands
  prevents high availability of software raid or multipath storage, and
  that is a big obstacle for such an environment.
  
  http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12337.html
  Also, as this patch says, there can be a situation where only a lun
  or a target reset is necessary when fighting against a bad storage,
  but current scsi_eh has no choice. Getting FAST_IO_FAIL from LLDD
  seems to be the only way to make it a bit faster.

  http://www.mail-archive.com/linux-raid@vger.kernel.org/msg09024.html
  http://www.spinics.net/lists/raid/msg03604.html
  I've found other patches on Google that basically refer to the same
  problem and resolve it in different implementation, although they
  seem to be rejected for some reasons I don't know.


Patch

  This patch provides options that can resolve my problem.
  I've added a flag to block gendisk and made it configurable
  through sysfs (eg. /sys/block/sdx/recovery_flag).
  
  SCSI driver uses this flag as a bit field option. When scsi_eh
  wakes up and start unjamming, it tests the corresponding bit field
  to see if reset handlers or tur are set to ignore for that device.
  If yes, then that action is ignored, but all the bit fields are set
  to zero as default so it keeps default behavior.
  
  By setting a bit field as an option, we can have some choices on
  what to do when i/o had timed out. Manually changing default behavior
  helps those who think default scsi_eh is doing too much.
  
  It could be better if bit field test in scsi_eh could transparently
  test non physical upper layer block device such as md or dm since
  this option is mainly for those environment. This could be a future
  goal.
  
  I've only mentioned about SCSI error, but this flag could be used
  by other block device drivers (non libata ide, or may be dm) as
  they could also use block request's timeout handler.

Any comments would be helpful, thanks.
Tomohiro Kusumi


Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
---
--- linux-2.6.37-rc5.org/include/linux/genhd.h	2010-12-07 13:09:04.000000000 +0900
+++ linux-2.6.37-rc5.test/include/linux/genhd.h	2010-12-10 15:13:30.514410976 +0900
@@ -178,6 +178,9 @@
 	struct blk_integrity *integrity;
 #endif
 	int node_id;
+
+#define BLK_RECOVERY_FLAG_MASK 0xFFFF
+	int recovery_flag; /* to select device driver's recovery action on timeout */
 };
 
 static inline struct gendisk *part_to_disk(struct hd_struct *part)
--- linux-2.6.37-rc5.org/block/genhd.c	2010-12-07 13:09:04.000000000 +0900
+++ linux-2.6.37-rc5.test/block/genhd.c	2010-12-10 15:17:40.845410756 +0900
@@ -875,6 +875,31 @@
 	return sprintf(buf, "%d\n", queue_discard_alignment(disk->queue));
 }
 
+static ssize_t disk_recovery_flag_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%04x\n",
+			disk->recovery_flag & BLK_RECOVERY_FLAG_MASK);
+}
+
+static ssize_t disk_recovery_flag_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	if (count) {
+		char *p = (char*)buf;
+		int val = simple_strtoul(p, &p, 16);
+		disk->recovery_flag = val & BLK_RECOVERY_FLAG_MASK;
+	}
+
+	return count;
+}
+
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
@@ -886,6 +911,8 @@
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
+static DEVICE_ATTR(recovery_flag, S_IRUGO|S_IWUSR, disk_recovery_flag_show,
+		disk_recovery_flag_store);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -907,6 +934,7 @@
 	&dev_attr_capability.attr,
 	&dev_attr_stat.attr,
 	&dev_attr_inflight.attr,
+	&dev_attr_recovery_flag.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
--- linux-2.6.37-rc5.org/drivers/scsi/scsi_error.c	2010-12-07 13:09:04.000000000 +0900
+++ linux-2.6.37-rc5.test/drivers/scsi/scsi_error.c	2010-12-10 20:43:18.671963777 +0900
@@ -50,6 +50,19 @@
 #define BUS_RESET_SETTLE_TIME   (10)
 #define HOST_RESET_SETTLE_TIME  (10)
 
+#define IGN_BUS_DEVICE_RESET(scmd)	(scmd_recovery_flag(scmd) & 0x01)
+#define IGN_TARGET_RESET(scmd)		(scmd_recovery_flag(scmd) & 0x02)
+#define IGN_BUS_RESET(scmd)		(scmd_recovery_flag(scmd) & 0x04)
+#define IGN_HOST_RESET(scmd)		(scmd_recovery_flag(scmd) & 0x08)
+#define IGN_TUR(scmd)			(scmd_recovery_flag(scmd) & 0x10)
+
+static int scmd_recovery_flag(struct scsi_cmnd *scmd)
+{
+	if (!scmd->request->rq_disk)
+		return 0;
+	return scmd->request->rq_disk->recovery_flag;
+}
+
 /* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
@@ -980,6 +993,8 @@
 						  "0x%p\n", current->comm,
 						  scmd));
 		rtn = scsi_try_to_abort_cmd(scmd);
+		if (rtn == SUCCESS && IGN_TUR(scmd))
+			rtn = FAST_IO_FAIL;
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
 			if (!scsi_device_online(scmd->device) ||
@@ -1105,11 +1120,15 @@
 
 		if (!bdr_scmd)
 			continue;
+		if (IGN_BUS_DEVICE_RESET(bdr_scmd))
+			continue;
 
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending BDR sdev:"
 						  " 0x%p\n", current->comm,
 						  sdev));
 		rtn = scsi_try_bus_device_reset(bdr_scmd);
+		if (rtn == SUCCESS && IGN_TUR(bdr_scmd))
+			rtn = FAST_IO_FAIL;
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			if (!scsi_device_online(sdev) ||
 			    rtn == FAST_IO_FAIL ||
@@ -1170,11 +1189,15 @@
 		if (!tgtr_scmd)
 			/* no more commands, that's it */
 			break;
+		if (IGN_TARGET_RESET(tgtr_scmd))
+			goto next;
 
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending target reset "
 						  "to target %d\n",
 						  current->comm, id));
 		rtn = scsi_try_target_reset(tgtr_scmd);
+		if (rtn == SUCCESS && IGN_TUR(tgtr_scmd))
+			rtn = FAST_IO_FAIL;
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (id == scmd_id(scmd))
@@ -1189,6 +1212,7 @@
 							  " failed target: "
 							  "%d\n",
 							  current->comm, id));
+next:
 		id++;
 	} while(id != 0);
 
@@ -1231,10 +1255,14 @@
 
 		if (!chan_scmd)
 			continue;
+		if (IGN_BUS_RESET(chan_scmd))
+			continue;
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending BRST chan:"
 						  " %d\n", current->comm,
 						  channel));
 		rtn = scsi_try_bus_reset(chan_scmd);
+		if (rtn == SUCCESS && IGN_TUR(chan_scmd))
+			rtn = FAST_IO_FAIL;
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (channel == scmd_channel(scmd))
@@ -1269,10 +1297,14 @@
 		scmd = list_entry(work_q->next,
 				  struct scsi_cmnd, eh_entry);
 
+		if (IGN_HOST_RESET(scmd))
+			goto end;
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending HRST\n"
 						  , current->comm));
 
 		rtn = scsi_try_host_reset(scmd);
+		if (rtn == SUCCESS && IGN_TUR(scmd))
+			rtn = FAST_IO_FAIL;
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (!scsi_device_online(scmd->device) ||
@@ -1287,6 +1319,7 @@
 							  current->comm));
 		}
 	}
+end:
 	return list_empty(work_q);
 }

