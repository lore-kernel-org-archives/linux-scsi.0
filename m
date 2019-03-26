From: Huang Zijiang <huang.zijiang@zte.com.cn>
Subject: [PATCH] scsi: sun_esp: : Fix object reference leaks in esp_sbus_probe
Date: Wed, 27 Mar 2019 07:55:57 +0800
Message-ID: <1553644557-35817-1-git-send-email-huang.zijiang@zte.com.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wang.yi59@zte.com.cn, Huang Zijiang <huang.zijiang@zte.com.cn>
List-Id: linux-scsi@vger.kernel.org

The of_find_device_by_node() takes a reference to the underlying device
structure, we should release that reference whatever of_find_device_by_node
reutrns.

Signed-off-by: Huang Zijiang <huang.zijiang@zte.com.cn>
---
 drivers/scsi/sun_esp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index a11efbc..a74605a 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -543,9 +543,8 @@ static int esp_sbus_probe(struct platform_device *op)
 		return -ENODEV;
 
 	ret = esp_sbus_probe_one(op, dma_of, hme);
-	if (ret)
-		put_device(&dma_of->dev);
 
+	put_device(&dma_of->dev);
 	return ret;
 }
 
-- 
1.8.3.1
