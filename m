From: Mike Christie <mikenc@us.ibm.com>
Subject: [PATCH] fix compile errors in scsi_sysfs.c
Date: Wed, 15 Oct 2003 16:38:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F8DDA89.500@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020808000203000909000709"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:412 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262613AbTJOXiv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Oct 2003 19:38:51 -0400
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e5.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id h9FNcoUN680120
	for <linux-scsi@vger.kernel.org>; Wed, 15 Oct 2003 19:38:50 -0400
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id h9FNcnnl218396
	for <linux-scsi@vger.kernel.org>; Wed, 15 Oct 2003 19:38:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020808000203000909000709
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

In scsi_sysfs.c there is a call to snscanf, but I could only find this 
function defined and in use by the toshiba acpi files. The attached 
patch replaces snscanf with sscanf.

Mike Christie
mikenc@us.ibm.com

--------------020808000203000909000709
Content-Type: text/plain;
 name="scsi_sysfs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_sysfs.patch"

--- linux-2.6.0-test7/drivers/scsi/scsi_sysfs.c	2003-10-08 12:24:02.000000000 -0700
+++ linux-2.6.0-test7-scsi/drivers/scsi/scsi_sysfs.c	2003-10-15 02:07:58.246162299 -0700
@@ -195,8 +195,7 @@
 {									\
 	struct scsi_device *sdev;					\
 	sdev = to_scsi_device(dev);					\
-	snscanf (buf, 20, format_string, &sdev->field);			\
-	return count;							\
+	return sscanf (buf, format_string, &sdev->field);		\
 }									\
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field)
 

--------------020808000203000909000709--

