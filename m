From: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH 2/4] Scsi: dmx3191d.c: Use module_pci_driver
Date: Fri, 25 Sep 2015 20:38:49 +0530
Message-ID: <1443193731-12587-2-git-send-email-shraddha.6596@gmail.com>
References: <1443193731-12587-1-git-send-email-shraddha.6596@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34286 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbbIYPJI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 11:09:08 -0400
Received: by padhy16 with SMTP id hy16so108385994pad.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 08:09:06 -0700 (PDT)
In-Reply-To: <1443193731-12587-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Hannes Reinecke <hare@suse.com>, Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org, Shraddha Barke <shraddha.6596@gmail.com>

Use module_pci_driver for drivers whose init and exit functions
only register and unregister respectively

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/scsi/dmx3191d.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index 3e08812..2913fc7 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -143,19 +143,7 @@ static struct pci_driver dmx3191d_pci_driver = {
 	.probe		= dmx3191d_probe_one,
 	.remove		= dmx3191d_remove_one,
 };
-
-static int __init dmx3191d_init(void)
-{
-	return pci_register_driver(&dmx3191d_pci_driver);
-}
-
-static void __exit dmx3191d_exit(void)
-{
-	pci_unregister_driver(&dmx3191d_pci_driver);
-}
-
-module_init(dmx3191d_init);
-module_exit(dmx3191d_exit);
+module_pci_driver(dmx3191d_pci_driver);
 
 MODULE_AUTHOR("Massimo Piccioni <dafastidio@libero.it>");
 MODULE_DESCRIPTION("Domex DMX3191D SCSI driver");
-- 
2.1.4

