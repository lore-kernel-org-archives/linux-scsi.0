From: John Garry <john.garry@huawei.com>
Subject: [PATCH 7/9] scsi: hisi_sas: Don't hard reset disk during controller reset
Date: Thu, 11 Apr 2019 20:46:42 +0800
Message-ID: <1554986804-233706-8-git-send-email-john.garry@huawei.com>
References: <1554986804-233706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554986804-233706-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

In the function of hisi_sas_init_device(), we added ops->hardreset() to
clear affiliation of STP target port or handle [STP pending] state.

Function hisi_sas_init_device() will be called when a device is found or
during controller reset. At controller reset, we call
hisi_sas_init_device() to re-init the disks, so calling hardreset() is
unnecessary and it also will cause some delay at controller reset.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index ede812759991..c02cf78a20c7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -754,7 +754,8 @@ static int hisi_sas_init_device(struct domain_device *device)
 		 * STP target port
 		 */
 		local_phy = sas_get_local_phy(device);
-		if (!scsi_is_sas_phy_local(local_phy)) {
+		if (!scsi_is_sas_phy_local(local_phy) &&
+		    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)) {
 			unsigned long deadline = ata_deadline(jiffies, 20000);
 			struct sata_device *sata_dev = &device->sata_dev;
 			struct ata_host *ata_host = sata_dev->ata_host;
-- 
2.17.1
