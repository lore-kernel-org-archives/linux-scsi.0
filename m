From: Xidong Wang <wangxidong_97@163.com>
Subject: [PATCH 1/1] scsi:mvsas:fix memory leak
Date: Wed,  4 Apr 2018 10:37:52 +0800
Message-ID: <1522809472-11749-1-git-send-email-wangxidong_97@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jack Wang <jinpu.wang@profitbricks.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>
Cc: Kees Cook <keescook@chromium.org>, Pan Bian <bianpan2016@163.com>, Xidong Wang <wangxidong_97@163.com>, Romain Perier <romain.perier@collabora.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In function mvs_pci_init(), the memory allocated by
scsi_host_alloc() is not released on the error path that mvi,
which holds the return value of mvs_pci_alloc(), is NULL.
This will result in a memory leak bug.

Signed-off-by: Xidong Wang <wangxidong_97@163.com>
---
 drivers/scsi/mvsas/mv_init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 8c91637..936b8ef 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -370,8 +370,10 @@ static struct mvs_info *mvs_pci_alloc(struct pci_dev *pdev,
 	mvi = kzalloc(sizeof(*mvi) +
 		(1L << mvs_chips[ent->driver_data].slot_width) *
 		sizeof(struct mvs_slot_info), GFP_KERNEL);
-	if (!mvi)
+	if (!mvi) {
+		scsi_host_put(shost);
 		return NULL;
+	}
 
 	mvi->pdev = pdev;
 	mvi->dev = &pdev->dev;
-- 
2.7.4
