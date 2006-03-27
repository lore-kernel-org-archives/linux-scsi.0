From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 6/11] aacraid: Fix extra unregister_chrdev
Date: Mon, 27 Mar 2006 09:44:19 -0800
Message-ID: <1143481459.21975.41.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:38847 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751124AbWC0RoW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:44:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

If there are no aacraid controllers, we do not create the raid
controller chrdev, thus when the driver is unloaded it performs a
superfluous deregistration.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-03-22 11:17:48.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-03-22 11:17:50.000000000 -0800
@@ -1022,7 +1022,8 @@
 
 static void __exit aac_exit(void)
 {
-	unregister_chrdev(aac_cfg_major, "aac");
+	if (aac_cfg_major > -1)
+		unregister_chrdev(aac_cfg_major, "aac");
 	pci_unregister_driver(&aac_pci_driver);
 }
 

-- 
Mark Haverkamp <markh@osdl.org>

