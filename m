From: akpm@linux-foundation.org
Subject: [patch 27/28] drivers/scsi/scsi_sysfs.c: fix sdev_rw_attr macro for scsi device sysfs entries
Date: Tue, 27 Apr 2010 14:23:09 -0700
Message-ID: <201004272123.o3RLN9UB020864@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757022Ab0D0VXf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 17:23:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, kusumi.tomohiro@jp.fujitsu.com, xiyou.wangcong@gmail.com

From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>

Fix the sdev_rw_attr() macro for scsi device sysfs entries.  It seems
there is no such function snscanf in the current linux kernel, so it fails
to compile scsi driver when someone try to add a new rw entry.  This has
been unfixed for a long time probably because current scsi device has no
rw entries.

# grep snscanf . -rn
./drivers/scsi/scsi_sysfs.c:489:        snscanf (buf, 20, format_string, &sdev->field);                 \

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_sysfs.c~drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c~drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries
+++ a/drivers/scsi/scsi_sysfs.c
@@ -474,7 +474,7 @@ static DEVICE_ATTR(field, S_IRUGO, sdev_
 
 
 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rw_attr: create a function and attribute variable for a
  * read/write field.
  */
 #define sdev_rw_attr(field, format_string)				\
@@ -486,7 +486,7 @@ sdev_store_##field (struct device *dev, 
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
-	snscanf (buf, 20, format_string, &sdev->field);			\
+	sscanf(buf, format_string, &sdev->field);			\
 	return count;							\
 }									\
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
_
