From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH] aacraid: expanded expose physical device code (new)
Date: Fri, 26 Jan 2007 09:23:32 -0800
Message-ID: <1169832213.17872.7.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45669 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161056AbXAZRXr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jan 2007 12:23:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>, Christoph Hellwig <hch@infradead.org>

Received from Mark Salyzyn,

Take the expose_physicals flag and allow the user to select default (physicals
available via /dev/sg), exposed (physicals available via /dev/sd for
experimental reasons) and hidden (physicals blocked from all access). This
expands the functionality of the previous expose_physicals insmod parameter
which was added to support some experimental configurations.

Signed-off-by Mark Haverkamp <markh@linux-foundation.org>
---
The patch has been updated after talking with Mark about Christoph's
comments on the previous version of the patch.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2007-01-25 14:18:02.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2007-01-25 14:19:39.000000000 -0800
@@ -170,9 +170,9 @@
 module_param(acbsize, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(acbsize, "Request a specific adapter control block (FIB) size. Valid values are 512, 2048, 4096 and 8192. Default is to use suggestion from Firmware.");
 
-int expose_physicals = 0;
+int expose_physicals = -1;
 module_param(expose_physicals, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(expose_physicals, "Expose physical components of the arrays. 0=off, 1=on");
+MODULE_PARM_DESC(expose_physicals, "Expose physical components of the arrays. -1=protect 0=off, 1=on");
 /**
  *	aac_get_config_status	-	check the adapter configuration
  *	@common: adapter to query
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2007-01-25 14:18:02.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2007-01-25 14:52:13.000000000 -0800
@@ -398,11 +398,15 @@
 		sdev->skip_ms_page_3f = 1;
 	}
 	if ((sdev->type == TYPE_DISK) &&
-			!expose_physicals &&
 			(sdev_channel(sdev) != CONTAINER_CHANNEL)) {
-		struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
-		if (!aac->raid_scsi_mode || (sdev_channel(sdev) != 2))
-			sdev->no_uld_attach = 1;
+		if (expose_physicals == 0)
+			return -ENXIO;
+		if (expose_physicals < 0) {
+			struct aac_dev *aac =
+				(struct aac_dev *)sdev->host->hostdata;
+			if (!aac->raid_scsi_mode || (sdev_channel(sdev) != 2))
+				sdev->no_uld_attach = 1;
+		}
 	}
 	if (sdev->tagged_supported && (sdev->type == TYPE_DISK) &&
 			(sdev_channel(sdev) == CONTAINER_CHANNEL)) {

-- 
Mark Haverkamp <markh@linux-foundation.org>

