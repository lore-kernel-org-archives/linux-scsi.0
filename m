From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/5] pmcraid: fix pmcraid_netlink_init() error path in module_init
Date: Sat, 16 Feb 2013 23:27:56 +0900
Message-ID: <1361024879-12934-2-git-send-email-akinobu.mita@gmail.com>
References: <1361024879-12934-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:64796 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3BPO22 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2013 09:28:28 -0500
Received: by mail-pb0-f50.google.com with SMTP id up1so1000879pbc.23
        for <linux-scsi@vger.kernel.org>; Sat, 16 Feb 2013 06:28:27 -0800 (PST)
In-Reply-To: <1361024879-12934-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

pmcraid_netlink_init() error path in module_init doesn't destroy
a struct class that was created just before.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/pmcraid.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 073ff48..db77bf9 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -6114,18 +6114,20 @@ static int __init pmcraid_init(void)
 	error = pmcraid_netlink_init();
 
 	if (error)
-		goto out_unreg_chrdev;
+		goto out_class_destroy;
 
 	error = pci_register_driver(&pmcraid_driver);
 
-	if (error == 0)
-		goto out_init;
+	if (error)
+		goto out_netlink_release;
 
-	pmcraid_err("failed to register pmcraid driver, error = %x\n",
-		     error);
-	class_destroy(pmcraid_class);
-	pmcraid_netlink_release();
+	return 0;
 
+out_netlink_release:
+	pmcraid_err("failed to register pmcraid driver, error = %x\n", error);
+	pmcraid_netlink_release();
+out_class_destroy:
+	class_destroy(pmcraid_class);
 out_unreg_chrdev:
 	unregister_chrdev_region(MKDEV(pmcraid_major, 0), PMCRAID_MAX_ADAPTERS);
 
-- 
1.8.1

