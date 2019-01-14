From: wangbo <wdjjwb@163.com>
Subject: [PATCH] scsi: wd719x Replace GFP_KERNEL with GFP_ATOMIC in wd719x_chip_init
Date: Mon, 14 Jan 2019 23:24:49 +0800
Message-ID: <1547479489-11560-1-git-send-email-wdjjwb@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, wang.bo116@zte.com.cn, wangbo <wdjjwb@163.com>
List-Id: linux-scsi@vger.kernel.org

wd719x_host_reset get spinlock first then call wd719x_chip_init,
so replace GFP_KERNEL with GFP_ATOMIC in wd719x_chip_init.

Signed-off-by: wangbo <wang.bo116@zte.com.cn>
---
 drivers/scsi/wd719x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index e3310e9..7b1b645 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -318,7 +318,7 @@ static int wd719x_chip_init(struct wd719x *wd)
 
 	if (!wd->fw_virt)
 		wd->fw_virt = dma_alloc_coherent(&wd->pdev->dev, wd->fw_size,
-						 &wd->fw_phys, GFP_KERNEL);
+						 &wd->fw_phys, GFP_ATOMIC);
 	if (!wd->fw_virt) {
 		ret = -ENOMEM;
 		goto wd719x_init_end;
-- 
2.7.4
