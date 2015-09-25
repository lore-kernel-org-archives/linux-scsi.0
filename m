From: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH 4/4] Scsi: a100u2w.c: Use module_pci_driver
Date: Fri, 25 Sep 2015 20:38:51 +0530
Message-ID: <1443193731-12587-4-git-send-email-shraddha.6596@gmail.com>
References: <1443193731-12587-1-git-send-email-shraddha.6596@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34377 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbbIYPJN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 11:09:13 -0400
Received: by padhy16 with SMTP id hy16so108388259pad.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 08:09:13 -0700 (PDT)
In-Reply-To: <1443193731-12587-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Hannes Reinecke <hare@suse.com>, Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org, Shraddha Barke <shraddha.6596@gmail.com>

Use module_pci_driver for drivers whose init and exit functions
only register and unregister respectively

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/scsi/a100u2w.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 8086bd0..5ef776c 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1222,19 +1222,7 @@ static struct pci_driver inia100_pci_driver = {
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
 MODULE_DESCRIPTION("Initio A100U2W SCSI driver");
 MODULE_AUTHOR("Initio Corporation");
 MODULE_LICENSE("Dual BSD/GPL");
-
-module_init(inia100_init);
-module_exit(inia100_exit);
+module_pci_driver(inia100_pci_driver);
-- 
2.1.4

