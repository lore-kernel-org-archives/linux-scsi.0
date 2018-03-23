From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/8] scsi: hisi_sas: make SAS address of SATA disks unique
Date: Sat, 24 Mar 2018 00:05:08 +0800
Message-ID: <1521821115-120040-2-git-send-email-john.garry@huawei.com>
References: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When directly connected with SATA disks in different SAS cores,
fill SAS address with scsi_host's id to make it's fake SAS address
unique.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index f89fb9a..89b9505 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3295,6 +3295,7 @@ static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
 	sas_phy->oob_mode = SATA_OOB_MODE;
 	/* Make up some unique SAS address */
 	attached_sas_addr[0] = 0x50;
+	attached_sas_addr[6] = hisi_hba->shost->host_no;
 	attached_sas_addr[7] = phy_no;
 	memcpy(sas_phy->attached_sas_addr, attached_sas_addr, SAS_ADDR_SIZE);
 	memcpy(sas_phy->frame_rcvd, fis, sizeof(struct dev_to_host_fis));
-- 
1.9.1
