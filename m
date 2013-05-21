From: Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 4/6] scsi/mvumi: Use module_pci_driver to register driver
Date: Tue, 21 May 2013 23:36:19 +0200
Message-ID: <1369172181-22070-4-git-send-email-peterhuewe@gmx.de>
References: <1369172181-22070-1-git-send-email-peterhuewe@gmx.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:56910 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab3EUVbP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 May 2013 17:31:15 -0400
Received: from mailout-de.gmx.net ([10.1.76.32]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MC6gQ-1UnfZh3196-008r5F for
 <linux-scsi@vger.kernel.org>; Tue, 21 May 2013 23:31:13 +0200
In-Reply-To: <1369172181-22070-1-git-send-email-peterhuewe@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/scsi/mvumi.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index c3601b5..92a3254 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2723,7 +2723,6 @@ fail:
 }
 
 static struct pci_driver mvumi_pci_driver = {
-
 	.name = MV_DRIVER_NAME,
 	.id_table = mvumi_pci_table,
 	.probe = mvumi_probe_one,
@@ -2735,22 +2734,4 @@ static struct pci_driver mvumi_pci_driver = {
 #endif
 };
 
-/**
- * mvumi_init - Driver load entry point
- */
-static int __init mvumi_init(void)
-{
-	return pci_register_driver(&mvumi_pci_driver);
-}
-
-/**
- * mvumi_exit - Driver unload entry point
- */
-static void __exit mvumi_exit(void)
-{
-
-	pci_unregister_driver(&mvumi_pci_driver);
-}
-
-module_init(mvumi_init);
-module_exit(mvumi_exit);
+module_pci_driver(mvumi_pci_driver);
-- 
1.8.1.5

