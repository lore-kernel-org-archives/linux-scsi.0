From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: [PATCH] fix sdev_rw_attr macro for scsi device sysfs entries
Date: Wed, 14 Apr 2010 15:15:14 +0900
Message-ID: <4BC55D72.7080301@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi

This patch fixes sdev_rw_attr() macro for scsi device sysfs entries.
It seems there is no such function snscanf in the current linux kernel,
so it fails to compile scsi driver when someone try to add a new rw entry.
This has been unfixed for a long time probably because current scsi device
has no rw entries.

# grep snscanf . -rn
./drivers/scsi/scsi_sysfs.c:489:        snscanf (buf, 20, format_string, &sdev->field);                 \

Thanks,
Tomohiro Kusumi



Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
---

diff -aNur linux-2.6.34-rc4.org/drivers/scsi/scsi_sysfs.c linux-2.6.34-rc4/drivers/scsi/scsi_sysfs.c
--- linux-2.6.34-rc4.org/drivers/scsi/scsi_sysfs.c	2010-04-13 10:41:35.000000000 +0900
+++ linux-2.6.34-rc4/drivers/scsi/scsi_sysfs.c	2010-04-14 15:05:50.000000000 +0900
@@ -474,7 +474,7 @@
 
 
 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rw_attr: create a function and attribute variable for a
  * read/write field.
  */
 #define sdev_rw_attr(field, format_string)				\
@@ -486,7 +486,7 @@
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
-	snscanf (buf, 20, format_string, &sdev->field);			\
+	sscanf (buf, format_string, &sdev->field);			\
 	return count;							\
 }									\
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field);
