From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 9/11] aacraid: Show max channel and max id is sysfs
Date: Mon, 27 Mar 2006 09:44:29 -0800
Message-ID: <1143481469.21975.44.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:44479 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751130AbWC0Rob (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:44:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

Add max_channel and max_id sysfs parameters.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-03-22 12:46:08.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-03-22 12:48:10.000000000 -0800
@@ -688,6 +688,18 @@
 	return len;
 }
 
+static ssize_t aac_show_max_channel(struct class_device *class_dev, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+	  class_to_shost(class_dev)->max_channel);
+}
+
+static ssize_t aac_show_max_id(struct class_device *class_dev, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+	  class_to_shost(class_dev)->max_id);
+}
+
 
 static struct class_device_attribute aac_model = {
 	.attr = {
@@ -731,6 +743,20 @@
 	},
 	.show = aac_show_serial_number,
 };
+static struct class_device_attribute aac_max_channel = {
+	.attr = {
+		.name = "max_channel",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_max_channel,
+};
+static struct class_device_attribute aac_max_id = {
+	.attr = {
+		.name = "max_id",
+		.mode = S_IRUGO,
+	},
+	.show = aac_show_max_id,
+};
 
 static struct class_device_attribute *aac_attrs[] = {
 	&aac_model,
@@ -739,6 +765,8 @@
 	&aac_monitor_version,
 	&aac_bios_version,
 	&aac_serial_number,
+	&aac_max_channel,
+	&aac_max_id,
 	NULL
 };
 

-- 
Mark Haverkamp <markh@osdl.org>

