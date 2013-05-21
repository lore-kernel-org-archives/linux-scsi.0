From: Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/6] scsi/a100u2w: Use module_pci_driver to register driver
Date: Tue, 21 May 2013 23:36:16 +0200
Message-ID: <1369172181-22070-1-git-send-email-peterhuewe@gmx.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56383 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab3EUVbN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 May 2013 17:31:13 -0400
Received: from mailout-de.gmx.net ([10.1.76.32]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LbO5M-1UBagH1QYE-00l0ju for
 <linux-scsi@vger.kernel.org>; Tue, 21 May 2013 23:31:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>

Removing some boilerplate by using module_pci_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/scsi/a100u2w.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 0163457..b8fd207 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1227,19 +1227,7 @@ static struct pci_driver inia100_pci_driver = {
 	.remove		= inia100_remove_one,
 };
 
-static int __init inia100_init(void)
-{
-	return pci_register_driver(&inia100_pci_driver);
-}
-
-static void __exit inia100_exit(void)
-{
-	pci_unregister_driver(&inia100_pci_driver);
-}
-
+module_pci_driver(inia100_pci_driver);
 MODULE_DESCRIPTION("Initio A100U2W SCSI driver");
 MODULE_AUTHOR("Initio Corporation");
 MODULE_LICENSE("Dual BSD/GPL");
-
-module_init(inia100_init);
-module_exit(inia100_exit);
-- 
1.8.1.5

