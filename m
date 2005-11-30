From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 4/5] aacraid: better sysfs adapter information
Date: Wed, 30 Nov 2005 10:36:32 -0800
Message-ID: <1133375792.2288.24.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:48014 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751503AbVK3Sgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 13:36:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn.

Provide more accurate adapter information.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

Index: scsi-misc-aac/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2005-11-28 15:15:02.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2005-11-28 15:15:16.000000000 -0800
@@ -598,7 +598,15 @@
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
@@ -609,7 +617,15 @@
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

