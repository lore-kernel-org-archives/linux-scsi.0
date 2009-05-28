From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 03/10] ibmvfc: Use DEVICE_ATTR macro
Date: Thu, 28 May 2009 16:17:25 -0500
Message-ID: <200905282117.n4SLHP4l021798@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50956 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762001AbZE1VRY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 May 2009 17:17:24 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n4SLBoNj026041
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:11:50 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4SLHQZr218582
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:17:26 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4SLHP1W021802
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:17:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Use DEVICE_ATTR macro for defining device sysfs attributes.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   67 +++++++----------------------------------
 1 file changed, 13 insertions(+), 54 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_attr_macros drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_attr_macros	2009-03-31 08:45:53.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-03-31 08:45:53.000000000 -0500
@@ -2434,14 +2434,6 @@ static ssize_t ibmvfc_show_host_partitio
 			vhost->login_buf->resp.partition_name);
 }
 
-static struct device_attribute ibmvfc_host_partition_name = {
-	.attr = {
-		.name = "partition_name",
-		.mode = S_IRUGO,
-	},
-	.show = ibmvfc_show_host_partition_name,
-};
-
 static ssize_t ibmvfc_show_host_device_name(struct device *dev,
 					    struct device_attribute *attr, char *buf)
 {
@@ -2452,14 +2444,6 @@ static ssize_t ibmvfc_show_host_device_n
 			vhost->login_buf->resp.device_name);
 }
 
-static struct device_attribute ibmvfc_host_device_name = {
-	.attr = {
-		.name = "device_name",
-		.mode = S_IRUGO,
-	},
-	.show = ibmvfc_show_host_device_name,
-};
-
 static ssize_t ibmvfc_show_host_loc_code(struct device *dev,
 					 struct device_attribute *attr, char *buf)
 {
@@ -2470,14 +2454,6 @@ static ssize_t ibmvfc_show_host_loc_code
 			vhost->login_buf->resp.port_loc_code);
 }
 
-static struct device_attribute ibmvfc_host_loc_code = {
-	.attr = {
-		.name = "port_loc_code",
-		.mode = S_IRUGO,
-	},
-	.show = ibmvfc_show_host_loc_code,
-};
-
 static ssize_t ibmvfc_show_host_drc_name(struct device *dev,
 					 struct device_attribute *attr, char *buf)
 {
@@ -2488,14 +2464,6 @@ static ssize_t ibmvfc_show_host_drc_name
 			vhost->login_buf->resp.drc_name);
 }
 
-static struct device_attribute ibmvfc_host_drc_name = {
-	.attr = {
-		.name = "drc_name",
-		.mode = S_IRUGO,
-	},
-	.show = ibmvfc_show_host_drc_name,
-};
-
 static ssize_t ibmvfc_show_host_npiv_version(struct device *dev,
 					     struct device_attribute *attr, char *buf)
 {
@@ -2504,14 +2472,6 @@ static ssize_t ibmvfc_show_host_npiv_ver
 	return snprintf(buf, PAGE_SIZE, "%d\n", vhost->login_buf->resp.version);
 }
 
-static struct device_attribute ibmvfc_host_npiv_version = {
-	.attr = {
-		.name = "npiv_version",
-		.mode = S_IRUGO,
-	},
-	.show = ibmvfc_show_host_npiv_version,
-};
-
 /**
  * ibmvfc_show_log_level - Show the adapter's error logging level
  * @dev:	class device struct
@@ -2556,14 +2516,13 @@ static ssize_t ibmvfc_store_log_level(st
 	return strlen(buf);
 }
 
-static struct device_attribute ibmvfc_log_level_attr = {
-	.attr = {
-		.name =		"log_level",
-		.mode =		S_IRUGO | S_IWUSR,
-	},
-	.show = ibmvfc_show_log_level,
-	.store = ibmvfc_store_log_level
-};
+static DEVICE_ATTR(partition_name, S_IRUGO, ibmvfc_show_host_partition_name, NULL);
+static DEVICE_ATTR(device_name, S_IRUGO, ibmvfc_show_host_device_name, NULL);
+static DEVICE_ATTR(port_loc_code, S_IRUGO, ibmvfc_show_host_loc_code, NULL);
+static DEVICE_ATTR(drc_name, S_IRUGO, ibmvfc_show_host_drc_name, NULL);
+static DEVICE_ATTR(npiv_version, S_IRUGO, ibmvfc_show_host_npiv_version, NULL);
+static DEVICE_ATTR(log_level, S_IRUGO | S_IWUSR,
+		   ibmvfc_show_log_level, ibmvfc_store_log_level);
 
 #ifdef CONFIG_SCSI_IBMVFC_TRACE
 /**
@@ -2612,12 +2571,12 @@ static struct bin_attribute ibmvfc_trace
 #endif
 
 static struct device_attribute *ibmvfc_attrs[] = {
-	&ibmvfc_host_partition_name,
-	&ibmvfc_host_device_name,
-	&ibmvfc_host_loc_code,
-	&ibmvfc_host_drc_name,
-	&ibmvfc_host_npiv_version,
-	&ibmvfc_log_level_attr,
+	&dev_attr_partition_name,
+	&dev_attr_device_name,
+	&dev_attr_port_loc_code,
+	&dev_attr_drc_name,
+	&dev_attr_npiv_version,
+	&dev_attr_log_level,
 	NULL
 };
 
_
