From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/4] aacraid: better sysfs adapter information
Date: Wed, 11 Jan 2006 09:28:16 -0800
Message-ID: <1137000496.20470.40.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:23428 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932224AbWAKR2S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2006 12:28:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn.

Provide more accurate adapter information.

Allows the Adapter Firmware to override the Adapter product
information.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-01-11 09:19:54.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-01-11 09:20:08.000000000 -0800
@@ -575,7 +575,15 @@
 	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%s\n",
+	if (dev->supplement_adapter_info.AdapterTypeText[0]) {
+		char * cp = dev->supplement_adapter_info.AdapterTypeText;
+		while (*cp && *cp != ' ')
+			++cp;
+		while (*cp == ' ')
+			++cp;
+		len = snprintf(buf, PAGE_SIZE, "%s\n", cp);
+	} else
+		len = snprintf(buf, PAGE_SIZE, "%s\n",
 		  aac_drivers[dev->cardtype].model);
 	return len;
 }
@@ -586,7 +594,15 @@
 	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "%s\n",
+	if (dev->supplement_adapter_info.AdapterTypeText[0]) {
+		char * cp = dev->supplement_adapter_info.AdapterTypeText;
+		while (*cp && *cp != ' ')
+			++cp;
+		len = snprintf(buf, PAGE_SIZE, "%.*s\n",
+		  (int)(cp - (char *)dev->supplement_adapter_info.AdapterTypeText),
+		  dev->supplement_adapter_info.AdapterTypeText);
+	} else
+		len = snprintf(buf, PAGE_SIZE, "%s\n",
 		  aac_drivers[dev->cardtype].vname);
 	return len;
 }

-- 
Mark Haverkamp <markh@osdl.org>

