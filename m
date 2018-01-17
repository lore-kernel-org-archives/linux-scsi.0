From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/3] scsi: hisi_sas: fix a bug in hisi_sas_dev_gone()
Date: Thu, 18 Jan 2018 00:46:54 +0800
Message-ID: <1516207614-159721-4-git-send-email-john.garry@huawei.com>
References: <1516207614-159721-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516207614-159721-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When device gone, NULL pointer can be accessed in
free_device callback if during SAS controller reset
as we clear structure sas_dev prior.

Actually we can only set dev_type as SAS_PHY_UNUSED
and not clear structure sas_dev as all the members
of structure sas_dev will be re-initialized after
device found.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 791462d..2d4dbed 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -796,7 +796,6 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 
 		hisi_hba->hw->clear_itct(hisi_hba, sas_dev);
 		device->lldd_dev = NULL;
-		memset(sas_dev, 0, sizeof(*sas_dev));
 	}
 
 	if (hisi_hba->hw->free_device)
-- 
1.9.1
