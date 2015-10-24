From: Punit Vara <punitvara@gmail.com>
Subject: [PATCH] block: remove useless casting value returned by kmalloc to structure
Date: Sat, 24 Oct 2015 17:39:49 +0530
Message-ID: <1445688589-5856-1-git-send-email-punitvara@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34619 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbbJXMKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Oct 2015 08:10:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@pmcs.com
Cc: iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Punit Vara <punitvara@gmail.com>

This is the patch to the cciss_scsi.c file that resolves following warning
reported by coccicheck:

WARNING: casting value returned by memory allocation function to (struct
cciss_scsi_adapter_data_t *) is useless.

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/block/cciss_scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 1537302..4c27032 100644
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
2.5.3

