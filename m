From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sd: Reshuffle init_sd to avoid crash
Date: Wed, 10 Oct 2012 10:36:11 +0200
Message-ID: <1349858171-29358-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab2JJIgT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 04:36:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Joel D. Diaz" <joeldiaz@us.ibm.com>

scsi_register_driver will register a prep_fn() function, which
in turn migh need to use the sd_cdp_pool for DIF.
Which hasn't been initialised at this point, leading to
a crash. So reshuffle the init_sd() and exit_sd() paths
to have the driver registered last.

Signed-off-by: Joel D. Diaz <joeldiaz@us.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 12f6fdf..a88c34e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2960,10 +2960,6 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
-	err = scsi_register_driver(&sd_template.gendrv);
-	if (err)
-		goto err_out_class;
-
 	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
 					 0, 0, NULL);
 	if (!sd_cdb_cache) {
@@ -2977,8 +2973,15 @@ static int __init init_sd(void)
 		goto err_out_cache;
 	}
 
+	err = scsi_register_driver(&sd_template.gendrv);
+	if (err)
+		goto err_out_driver;
+
 	return 0;
 
+err_out_driver:
+	mempool_destroy(sd_cdb_pool);
+
 err_out_cache:
 	kmem_cache_destroy(sd_cdb_cache);
 
@@ -3001,10 +3004,10 @@ static void __exit exit_sd(void)
 
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
+	scsi_unregister_driver(&sd_template.gendrv);
 	mempool_destroy(sd_cdb_pool);
 	kmem_cache_destroy(sd_cdb_cache);
 
-	scsi_unregister_driver(&sd_template.gendrv);
 	class_unregister(&sd_disk_class);
 
 	for (i = 0; i < SD_MAJORS; i++)
-- 
1.7.4.2

