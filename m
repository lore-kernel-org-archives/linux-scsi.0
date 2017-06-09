From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 20/23] scsi: hisi_sas: add get_wideport_bitmap_v3_hw()
Date: Fri, 9 Jun 2017 22:16:33 +0800
Message-ID: <1497017796-105067-21-git-send-email-john.garry@huawei.com>
References: <1497017796-105067-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497017796-105067-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linuxarm@huawei.com, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add code for interface get_wideport_bitmap.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index ef5c158..3cd4b9a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -629,6 +629,18 @@ static void sl_notify_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
 }
 
+static int get_wideport_bitmap_v3_hw(struct hisi_hba *hisi_hba, int port_id)
+{
+	int i, bitmap = 0;
+	u32 phy_port_num_ma = hisi_sas_read32(hisi_hba, PHY_PORT_NUM_MA);
+
+	for (i = 0; i < hisi_hba->n_phy; i++)
+		if (((phy_port_num_ma >> (i * 4)) & 0xf) == port_id)
+			bitmap |= 1 << i;
+
+	return bitmap;
+}
+
 /**
  * The callpath to this function and upto writing the write
  * queue pointer should be safe from interruption.
@@ -1550,6 +1562,7 @@ static int hisi_sas_v3_init(struct hisi_hba *hisi_hba)
 	.hw_init = hisi_sas_v3_init,
 	.setup_itct = setup_itct_v3_hw,
 	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V3_HW,
+	.get_wideport_bitmap = get_wideport_bitmap_v3_hw,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v3_hdr),
 	.free_device = free_device_v3_hw,
 	.sl_notify = sl_notify_v3_hw,
-- 
1.9.1
