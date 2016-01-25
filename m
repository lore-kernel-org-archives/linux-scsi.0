From: j00310691 <john.garry@huawei.com>
Subject: [PATCH v2 10/23] hisi_sas: add init_id_frame_v2_hw()
Date: Tue, 26 Jan 2016 01:21:59 +0800
Message-ID: <1453742532-53092-11-git-send-email-john.garry@huawei.com>
References: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: John Garry <john.garry@huawei.com>

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 40 ++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index da9c375..6f05333 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -288,6 +288,44 @@ static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
 	return readl(regs);
 }
 
+static void config_id_frame_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	struct sas_identify_frame identify_frame;
+	u32 *identify_buffer;
+
+	memset(&identify_frame, 0, sizeof(identify_frame));
+	identify_frame.dev_type = SAS_END_DEVICE;
+	identify_frame.frame_type = 0;
+	identify_frame._un1 = 1;
+	identify_frame.initiator_bits = SAS_PROTOCOL_ALL;
+	identify_frame.target_bits = SAS_PROTOCOL_NONE;
+	memcpy(&identify_frame._un4_11[0], hisi_hba->sas_addr, SAS_ADDR_SIZE);
+	memcpy(&identify_frame.sas_addr[0], hisi_hba->sas_addr,	SAS_ADDR_SIZE);
+	identify_frame.phy_id = phy_no;
+	identify_buffer = (u32 *)(&identify_frame);
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD0,
+			__swab32(identify_buffer[0]));
+	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD1,
+			identify_buffer[2]);
+	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD2,
+			identify_buffer[1]);
+	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD3,
+			identify_buffer[4]);
+	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD4,
+			identify_buffer[3]);
+	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD5,
+			__swab32(identify_buffer[5]));
+}
+
+static void init_id_frame_v2_hw(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	for (i = 0; i < hisi_hba->n_phy; i++)
+		config_id_frame_v2_hw(hisi_hba, i);
+}
+
 static int reset_hw_v2_hw(struct hisi_hba *hisi_hba)
 {
 	int i, reset_val;
@@ -520,6 +558,8 @@ static int hw_init_v2_hw(struct hisi_hba *hisi_hba)
 	msleep(100);
 	init_reg_v2_hw(hisi_hba);
 
+	init_id_frame_v2_hw(hisi_hba);
+
 	return 0;
 }
 
-- 
1.9.1
