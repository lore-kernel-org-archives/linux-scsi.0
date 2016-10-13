From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] cciss: remove unneeded void pointer cast
Date: Thu, 13 Oct 2016 13:10:42 -0300
Message-ID: <1476375042-10175-1-git-send-email-javier@osg.samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53404
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754421AbcJMQLP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 12:11:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>, esc.storagedev@microsemi.com, iss_storagedev@hp.com, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org

It's not necessary to cast the result of kmalloc, since void pointers are
promoted to any other type. This also fixes following coccinelle warning:

casting value returned by memory allocation function to (struct cciss_scsi_adapter_data_t *) is useless.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/block/cciss_scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 1537302e56e3..06692f164f40 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -703,8 +703,7 @@ cciss_scsi_setup(ctlr_info_t *h)
 	struct cciss_scsi_adapter_data_t * shba;
 
 	ccissscsi[h->ctlr].ndevices = 0;
-	shba = (struct cciss_scsi_adapter_data_t *)
-		kmalloc(sizeof(*shba), GFP_KERNEL);	
+	shba = kmalloc(sizeof(*shba), GFP_KERNEL);
 	if (shba == NULL)
 		return;
 	shba->scsi_host = NULL;
-- 
2.7.4

