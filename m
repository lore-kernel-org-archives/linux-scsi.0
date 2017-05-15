From: Johan Hovold <johan@kernel.org>
Subject: [PATCH] scsi: sun_esp: fix device reference leaks
Date: Mon, 15 May 2017 17:59:29 +0200
Message-ID: <20170515155929.21014-1-johan@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36850 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932368AbdEOP7v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2017 11:59:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>

Make sure to drop the reference to the dma device taken by
of_find_device_by_node() on probe errors and on driver unbind.

Fixes: 334ae614772b ("sparc: Kill SBUS DVMA layer.")
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/scsi/sun_esp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 7b6d4c2087d7..747ee64a78e1 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -566,6 +566,7 @@ static int esp_sbus_probe(struct platform_device *op)
 	struct device_node *dp = op->dev.of_node;
 	struct platform_device *dma_of = NULL;
 	int hme = 0;
+	int ret;
 
 	if (dp->parent &&
 	    (!strcmp(dp->parent->name, "espdma") ||
@@ -580,7 +581,11 @@ static int esp_sbus_probe(struct platform_device *op)
 	if (!dma_of)
 		return -ENODEV;
 
-	return esp_sbus_probe_one(op, dma_of, hme);
+	ret = esp_sbus_probe_one(op, dma_of, hme);
+	if (ret)
+		put_device(&dma_of->dev);
+
+	return ret;
 }
 
 static int esp_sbus_remove(struct platform_device *op)
@@ -613,6 +618,8 @@ static int esp_sbus_remove(struct platform_device *op)
 
 	dev_set_drvdata(&op->dev, NULL);
 
+	put_device(&dma_of->dev);
+
 	return 0;
 }
 
-- 
2.13.0
