From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH 1/2] scsi:ufs: Use PTR_ERR_OR_ZERO to replace the open code
Date: Mon, 13 Aug 2018 19:10:39 +0800
Message-ID: <1534158640-24353-2-git-send-email-zhongjiang@huawei.com>
References: <1534158640-24353-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1534158640-24353-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

PTR_ERR_OR_ZERO has implemented the if(IS_ERR(...)) + PTR_ERR, So
just replace them rather than duplicating its implement.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/scsi/ufs/ufs-hisi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index 46df707..e794994 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -505,10 +505,8 @@ static int ufs_hisi_get_resource(struct ufs_hisi_host *host)
 	/* get resource of ufs sys ctrl */
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	host->ufs_sys_ctrl = devm_ioremap_resource(dev, mem_res);
-	if (IS_ERR(host->ufs_sys_ctrl))
-		return PTR_ERR(host->ufs_sys_ctrl);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(host->ufs_sys_ctrl);
 }
 
 static void ufs_hisi_set_pm_lvl(struct ufs_hba *hba)
-- 
1.7.12.4
