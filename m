From: John Garry <john.garry@huawei.com>
Subject: [PATCH 4/9] scsi: hisi_sas: Adjust the printk format of functions hisi_sas_init_device()
Date: Thu, 11 Apr 2019 20:46:39 +0800
Message-ID: <1554986804-233706-5-git-send-email-john.garry@huawei.com>
References: <1554986804-233706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554986804-233706-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

In function hisi_sas_init_device(), the log is as follows when error for
hardreset:
  hisi_sas_v3_hw 0000:74:02.0: SATA disk hardreset fail: 0xffffffed

Actually if hardreset failed, its return value is negative, so change
the print format from %x to %d.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d4da537f9a45..ede812759991 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -769,8 +769,7 @@ static int hisi_sas_init_device(struct domain_device *device)
 		}
 		sas_put_local_phy(local_phy);
 		if (rc) {
-			dev_warn(dev, "SATA disk hardreset fail: 0x%x\n",
-				 rc);
+			dev_warn(dev, "SATA disk hardreset fail: %d\n", rc);
 			return rc;
 		}
 
-- 
2.17.1
