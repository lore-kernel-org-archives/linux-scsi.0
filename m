From: Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH] scsi_device_put unused variable module without CONFIG_MODULE_UNLOAD
Date: Wed, 22 Nov 2006 14:39:06 +0000
Message-ID: <5b8c107f6d06b70065ca44309be0dcbf@pinky>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 41.150.104.212.access.eclipse.net.uk ([212.104.150.41]:53920
	"EHLO localhost.localdomain") by vger.kernel.org with ESMTP
	id S1753375AbWKVOjJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Nov 2006 09:39:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, apw@shadowen.org

scsi_device_put: unused variable module without CONFIG_MODULE_UNLOAD

When CONFIG_MODULE_UNLOAD is not defined then the module variable
in scsi_device_put() becomes unused resulting in the warnings below.
Move this inside the existing #ifdef.

  .../drivers/scsi/scsi.c:883: warning: unused variable 'module'
  
Against 2.6.19-rc5-mm2.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 680d72e..fafc00d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -880,9 +880,9 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
+#ifdef CONFIG_MODULE_UNLOAD
 	struct module *module = sdev->host->hostt->module;
 
-#ifdef CONFIG_MODULE_UNLOAD
 	/* The module refcount will be zero if scsi_device_get()
 	 * was called from a module removal routine */
 	if (module && module_refcount(module) != 0)
