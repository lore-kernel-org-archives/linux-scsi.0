From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 2/7] genhd: expose AN to user space
Date: Tue, 24 Apr 2007 14:30:10 -0700
Message-ID: <20070424143010.f37333f7.kristen.c.accardi@intel.com>
References: <20070424074856.005152262@intel.com>
	<20070423165950.7d64bd8e.kristen.c.accardi@intel.com>
	<462DBA33.9060207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29843 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423128AbXDXVcp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2007 17:32:45 -0400
In-Reply-To: <462DBA33.9060207@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Allow user space to determine if a disk supports Asynchronous Notification
of media changes.  This is done by adding a new sysfs file "capability_flags",
which is documented in (insert file name).  This sysfs file will export all
disk capabilities flags to user space.  We also define a new flag to define
the media change notification capability.

Changed from last version:
* changed sysfs filename to "capability" from "capability_flags"

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/block/genhd.c
===================================================================
--- 2.6-git.orig/block/genhd.c
+++ 2.6-git/block/genhd.c
@@ -370,7 +370,10 @@ static ssize_t disk_size_read(struct gen
 {
 	return sprintf(page, "%llu\n", (unsigned long long)get_capacity(disk));
 }
-
+static ssize_t disk_capability_read(struct gendisk *disk, char *page)
+{
+	return sprintf(page, "%x\n", disk->flags);
+}
 static ssize_t disk_stats_read(struct gendisk * disk, char *page)
 {
 	preempt_disable();
@@ -413,6 +416,10 @@ static struct disk_attribute disk_attr_s
 	.attr = {.name = "size", .mode = S_IRUGO },
 	.show	= disk_size_read
 };
+static struct disk_attribute disk_attr_capability = {
+	.attr = {.name = "capability", .mode = S_IRUGO },
+	.show	= disk_capability_read
+};
 static struct disk_attribute disk_attr_stat = {
 	.attr = {.name = "stat", .mode = S_IRUGO },
 	.show	= disk_stats_read
@@ -453,6 +460,7 @@ static struct attribute * default_attrs[
 	&disk_attr_removable.attr,
 	&disk_attr_size.attr,
 	&disk_attr_stat.attr,
+	&disk_attr_capability.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&disk_attr_fail.attr,
 #endif
Index: 2.6-git/include/linux/genhd.h
===================================================================
--- 2.6-git.orig/include/linux/genhd.h
+++ 2.6-git/include/linux/genhd.h
@@ -94,6 +94,7 @@ struct hd_struct {
 
 #define GENHD_FL_REMOVABLE			1
 #define GENHD_FL_DRIVERFS			2
+#define GENHD_FL_MEDIA_CHANGE_NOTIFY		4
 #define GENHD_FL_CD				8
 #define GENHD_FL_UP				16
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
Index: 2.6-git/Documentation/block/capability.txt
===================================================================
--- /dev/null
+++ 2.6-git/Documentation/block/capability.txt
@@ -0,0 +1,15 @@
+Generic Block Device Capability
+===============================================================================
+This file documents the sysfs file block/<disk>/capability
+
+capability is a hex word indicating which capabilities a specific disk
+supports.  For more information on bits not listed here, see
+include/linux/genhd.h
+
+Capability				Value
+-------------------------------------------------------------------------------
+GENHD_FL_MEDIA_CHANGE_NOTIFY		4
+	When this bit is set, the disk supports Asynchronous Notification
+	of media change events.  These events will be broadcast to user
+	space via kernel uevent.
+
