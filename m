From: Clemens Fruhwirth <clemens@endorphin.org>
Subject: Re: [PATCH] Forcing capacity sizes for block devices - (sorry, gmail
 ruined inlining with wordwrapping in the last mail)
Date: Sun, 20 Dec 2009 14:19:08 +0100
Message-ID: <4B2E244C.8070705@endorphin.org>
References: <2f83750a0912200405v77f39a7eifef024cc4cb10a20@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:52679 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZLTNTR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2009 08:19:17 -0500
Received: by fxm21 with SMTP id 21so4023386fxm.21
        for <linux-scsi@vger.kernel.org>; Sun, 20 Dec 2009 05:19:15 -0800 (PST)
In-Reply-To: <2f83750a0912200405v77f39a7eifef024cc4cb10a20@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, grundler@google.com

Make the size attribute of block devices writable via sysfs. This allows 
userspace to force
device boundaries in cases where the device driver is unable to detect 
the correct size, as
with spec-incompliant SD card readers.

diff -uprN -X linux-2.6.32-vanilla/Documentation/dontdiff 
linux-2.6.32-vanilla/block/genhd.c linux-2.6.32-patched/block/genhd.c
--- linux-2.6.32-vanilla/block/genhd.c    2009-12-03 04:51:21.000000000 
+0100
+++ linux-2.6.32-patched/block/genhd.c    2009-12-15 14:38:24.962463446 
+0100
@@ -865,7 +865,7 @@ static DEVICE_ATTR(range, S_IRUGO, disk_
  static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
  static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
  static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
-static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
+static DEVICE_ATTR(size, S_IRUGO | S_IWUSR, part_size_show, 
part_size_set);
  static DEVICE_ATTR(alignment_offset, S_IRUGO, 
disk_alignment_offset_show, NULL);
  static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
  static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
diff -uprN -X linux-2.6.32-vanilla/Documentation/dontdiff 
linux-2.6.32-vanilla/fs/partitions/check.c 
linux-2.6.32-patched/fs/partitions/check.c
--- linux-2.6.32-vanilla/fs/partitions/check.c    2009-12-03 
04:51:21.000000000 +0100
+++ linux-2.6.32-patched/fs/partitions/check.c    2009-12-19 
10:38:58.745294907 +0100
@@ -219,6 +219,18 @@ ssize_t part_size_show(struct device *de
      return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
  }

+ssize_t part_size_set(struct device *dev,
+              struct device_attribute *attr, char *buf, size_t len)
+{
+    struct hd_struct *p = dev_to_part(dev);
+    unsigned long long val;
+    if (strict_strtoull(buf, 0, &val))
+        return -EINVAL;
+
+    p->nr_sects = val;
+    return len;
+}
+
  ssize_t part_alignment_offset_show(struct device *dev,
                     struct device_attribute *attr, char *buf)
  {
diff -uprN -X linux-2.6.32-vanilla/Documentation/dontdiff 
linux-2.6.32-vanilla/include/linux/genhd.h 
linux-2.6.32-patched/include/linux/genhd.h
--- linux-2.6.32-vanilla/include/linux/genhd.h    2009-12-03 
04:51:21.000000000 +0100
+++ linux-2.6.32-patched/include/linux/genhd.h    2009-12-19 
10:40:30.900871273 +0100
@@ -549,6 +549,9 @@ extern void blk_unregister_region(dev_t

  extern ssize_t part_size_show(struct device *dev,
                    struct device_attribute *attr, char *buf);
+extern ssize_t part_size_set(struct device *dev,
+                 struct device_attribute *attr, char *buf,
+                 size_t len);
  extern ssize_t part_stat_show(struct device *dev,
                    struct device_attribute *attr, char *buf);
  extern ssize_t part_inflight_show(struct device *dev,

Signed-off-by: Clemens Fruhwirth <clemens@endorphin.org>
Reviewed-by: Grant Grundler <grundler@google.com>
