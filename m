From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 3/3] cciss: Remove kmalloc cast
Date: Wed, 22 Feb 2017 16:49:11 +1100
Message-ID: <1487742551-10839-4-git-send-email-me@tobin.cc>
References: <1487742551-10839-1-git-send-email-me@tobin.cc>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40183 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753814AbdBVFte (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 00:49:34 -0500
In-Reply-To: <1487742551-10839-1-git-send-email-me@tobin.cc>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, "Tobin C. Harding" <me@tobin.cc>

Coccinelle emits a warning about casting the return value of
kmalloc(). Coccinelle suggests removing the cast as do
kerneljanitors.

Remove cast from kmalloc() call.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 drivers/block/cciss_scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index f5c21f3..01a1f7e 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -647,8 +647,7 @@ cciss_scsi_setup(ctlr_info_t *h)
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
