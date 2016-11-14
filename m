From: Li Qiang <liq3ea@gmail.com>
Subject: [PATCH] 53c700: fix memory leak of dma non-cosistent memory
Date: Mon, 14 Nov 2016 15:07:58 +0800
Message-ID: <582962db.0130ed0a.10866.5633@mx.google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35901 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752875AbcKNHIN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2016 02:08:13 -0500
Received: by mail-qk0-f195.google.com with SMTP id h201so10186749qke.3
        for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2016 23:08:12 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Li Qiang <liq3ea@gmail.com>

From: Li Qiang <liq3ea@gmail.com>

In NCR_700_detect function, if an error occurs it will return
NULL without freeing the dma non-cosistent memory once allocated.
This patch avoid this.

Signed-off-by: Li Qiang <liq3ea@gmail.com>
---
 drivers/scsi/53c700.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 95e32a4..d5a2ba3 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -332,8 +332,10 @@ struct Scsi_Host *
 		tpnt->proc_name = "53c700";
 
 	host = scsi_host_alloc(tpnt, 4);
-	if (!host)
+	if (!host) {
+		dma_free_noncoherent(hostdata->dev, TOTAL_MEM_SIZE, memory, pScript);
 		return NULL;
+	}
 	memset(hostdata->slots, 0, sizeof(struct NCR_700_command_slot)
 	       * NCR_700_COMMAND_SLOTS_PER_HOST);
 	for (j = 0; j < NCR_700_COMMAND_SLOTS_PER_HOST; j++) {
@@ -394,6 +396,7 @@ struct Scsi_Host *
 
 	if (scsi_add_host(host, dev)) {
 		dev_printk(KERN_ERR, dev, "53c700: scsi_add_host failed\n");
+		dma_free_noncoherent(hostdata->dev, TOTAL_MEM_SIZE, memory, pScript);
 		scsi_host_put(host);
 		return NULL;
 	}
-- 
1.8.3.1

