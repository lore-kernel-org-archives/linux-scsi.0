From: Andy Grover <agrover@redhat.com>
Subject: [PATCH] block: Export REQ_FLUSH status via sysfs
Date: Wed, 14 May 2014 15:51:48 -0700
Message-ID: <1400107908-16095-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbaENWvt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2014 18:51:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org

Whether this is set or not is important for whether good performance is
possible, when using the block device as a backstore for the kernel
target. Exposing this will let kernel target configuration tools provide
this information to the user when configuring LIO targets.

Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 block/genhd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 791f419..258fadc 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -958,6 +958,14 @@ static ssize_t disk_capability_show(struct device *dev,
 	return sprintf(buf, "%x\n", disk->flags);
 }
 
+static ssize_t req_flush_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%x\n", !!(disk->queue->flush_flags & REQ_FLUSH));
+}
+
 static ssize_t disk_alignment_offset_show(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf)
@@ -985,6 +993,7 @@ static DEVICE_ATTR(alignment_offset, S_IRUGO, disk_alignment_offset_show, NULL);
 static DEVICE_ATTR(discard_alignment, S_IRUGO, disk_discard_alignment_show,
 		   NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
+static DEVICE_ATTR(req_flush, S_IRUGO, req_flush_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
@@ -1006,6 +1015,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_alignment_offset.attr,
 	&dev_attr_discard_alignment.attr,
 	&dev_attr_capability.attr,
+	&dev_attr_req_flush.attr,
 	&dev_attr_stat.attr,
 	&dev_attr_inflight.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
-- 
1.9.0

