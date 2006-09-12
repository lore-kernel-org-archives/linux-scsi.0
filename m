From: Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH] BODGE scsi misc module reference count checks with no MODULE_UNLOAD
Date: Tue, 12 Sep 2006 10:02:24 +0100
Message-ID: <20060912090223.GA31576@shadowen.org>
References: <45067632.4020906@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 85-210-233-64.dsl.pipex.com ([85.210.233.64]:23254 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S964975AbWILJDZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Sep 2006 05:03:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

BODGE scsi misc module reference count checks with no MODULE_UNLOAD

A quick bodge to try and get this to compile for testing.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 20d2cdf..2acc0cb 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -884,7 +884,11 @@ void scsi_device_put(struct scsi_device 
 
 	/* The module refcount will be zero if scsi_device_get()
 	 * was called from a module removal routine */
-	if (module && module_refcount(module) != 0)
+	if (module
+#ifdef CONFIG_MODULE_UNLOAD
+			&& module_refcount(module) != 0
+#endif
+			)
 		module_put(module);
 	put_device(&sdev->sdev_gendev);
 }
