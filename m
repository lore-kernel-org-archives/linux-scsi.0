From: "Gwendal Grignou" <gwendal@google.com>
Subject: [PATCH 2.6.25 1/1] scsi_sysfs: Fix cut and paste errors
Date: Mon, 10 Mar 2008 14:10:12 -0700
Message-ID: <e7510f760803101410od1d6c8av40db1b9e01d8b700@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:38559 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYCJVKT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2008 17:10:19 -0400
Received: from zps78.corp.google.com (zps78.corp.google.com [172.25.146.78])
	by smtp-out.google.com with ESMTP id m2ALADwj012115
	for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2008 21:10:14 GMT
Received: from wa-out-1112.google.com (wafk22.prod.google.com [10.114.187.22])
	by zps78.corp.google.com with ESMTP id m2AL8hRt018261
	for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2008 14:10:13 -0700
Received: by wa-out-1112.google.com with SMTP id k22so2491052waf.18
        for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2008 14:10:12 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

snscanf is not defined in the kernel, and function names in comment
did not match the function.

Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 drivers/scsi/scsi_sysfs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ed83cdb..ff5ca75 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -441,7 +441,7 @@ static DEVICE_ATTR(field, S_IRUGO, sdev_


 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rw_attr: create a function and attribute variable for a
  * read/write field.
  */
 #define sdev_rw_attr(field, format_string)				\
@@ -452,7 +452,7 @@ sdev_store_##field (struct device *dev,
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
-	snscanf (buf, 20, format_string, &sdev->field);			\
+	sscanf (buf, format_string, &sdev->field);			\
 	return count;							\
 }									\
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field,
sdev_store_##field);
@@ -461,7 +461,7 @@ static DEVICE_ATTR(field, S_IRUGO | S_IW
  * so leave this code in */
 #if 0
 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rw_attr_bit: create a function and attribute variable for a
  * read/write bit field.
  */
 #define sdev_rw_attr_bit(field)						\
