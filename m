From: John Garry <john.garry@huawei.com>
Subject: [PATCH 19/23] hisi_sas: add v2 code for itct setup and free
Date: Fri, 8 Jan 2016 22:15:38 +0800
Message-ID: <1452262542-64589-20-git-send-email-john.garry@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 91 ++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 94499b1..eca505f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -353,6 +353,95 @@ static void init_id_frame_v2_hw(struct hisi_hba *hisi_hba)
 		config_id_frame_v2_hw(hisi_hba, i);
 }
 
+static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
+			     struct hisi_sas_device *sas_dev)
+{
+	struct domain_device *device = sas_dev->sas_device;
+	struct device *dev = &hisi_hba->pdev->dev;
+	u64 qw0, device_id = sas_dev->device_id;
+	struct hisi_sas_itct *itct = &hisi_hba->itct[device_id];
+	struct domain_device *parent_dev = device->parent;
+
+	memset(itct, 0, sizeof(*itct));
+
+	/* qw0 */
+	qw0 = 0;
+	switch (sas_dev->dev_type) {
+	case SAS_END_DEVICE:
+	case SAS_EDGE_EXPANDER_DEVICE:
+	case SAS_FANOUT_EXPANDER_DEVICE:
+		qw0 = HISI_SAS_DEV_TYPE_SSP << ITCT_HDR_DEV_TYPE_OFF;
+		break;
+	case SAS_SATA_DEV:
+		if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type))
+			qw0 = HISI_SAS_DEV_TYPE_STP << ITCT_HDR_DEV_TYPE_OFF;
+		else
+			qw0 = HISI_SAS_DEV_TYPE_SATA << ITCT_HDR_DEV_TYPE_OFF;
+		break;
+	default:
+		dev_warn(dev, "setup itct: unsupported dev type (%d)\n",
+			 sas_dev->dev_type);
+	}
+
+	qw0 |= ((1 << ITCT_HDR_VALID_OFF) |
+		(device->max_linkrate << ITCT_HDR_MCR_OFF) |
+		(1 << ITCT_HDR_VLN_OFF) |
+		(device->port->id << ITCT_HDR_PORT_ID_OFF));
+	itct->qw0 = cpu_to_le64(qw0);
+
+	/* qw1 */
+	memcpy(&itct->sas_addr, device->sas_addr, SAS_ADDR_SIZE);
+	itct->sas_addr = __swab64(itct->sas_addr);
+
+	/* qw2 */
+	itct->qw2 = cpu_to_le64((500ULL << ITCT_HDR_INLT_OFF) |
+				(0xff00ULL << ITCT_HDR_BITLT_OFF) |
+				(0xff00ULL << ITCT_HDR_MCTLT_OFF) |
+				(0xff00ULL << ITCT_HDR_RTOLT_OFF));
+}
+
+static void free_device_v2_hw(struct hisi_hba *hisi_hba,
+			      struct hisi_sas_device *sas_dev)
+{
+	u64 qw0, dev_id = sas_dev->device_id;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct hisi_sas_itct *itct = &hisi_hba->itct[dev_id];
+	u32 reg_val = hisi_sas_read32(hisi_hba, ENT_INT_SRC3);
+	int i;
+
+	/* clear the itct interrupt state */
+	if (ENT_INT_SRC3_ITC_INT_MSK & reg_val)
+		hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
+				 ENT_INT_SRC3_ITC_INT_MSK);
+
+	/* clear the itct int*/
+	for (i = 0; i < 2; i++) {
+		/* clear the itct table*/
+		reg_val = hisi_sas_read32(hisi_hba, ITCT_CLR);
+		reg_val |= ITCT_CLR_EN_MSK | (dev_id & ITCT_DEV_MSK);
+		hisi_sas_write32(hisi_hba, ITCT_CLR, reg_val);
+
+		udelay(10);
+		reg_val = hisi_sas_read32(hisi_hba, ENT_INT_SRC3);
+		if (ENT_INT_SRC3_ITC_INT_MSK & reg_val) {
+			dev_dbg(dev, "got clear ITCT done interrupt\n");
+
+			/* invalid the itct state*/
+			qw0 = cpu_to_le64(itct->qw0);
+			qw0 &= ~(1 << ITCT_HDR_VALID_OFF);
+			hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
+					 ENT_INT_SRC3_ITC_INT_MSK);
+			hisi_hba->devices[dev_id].dev_type = SAS_PHY_UNUSED;
+			hisi_hba->devices[dev_id].dev_status = HISI_SAS_DEV_NORMAL;
+
+			/* clear the itct */
+			hisi_sas_write32(hisi_hba, ITCT_CLR, 0);
+			dev_dbg(dev, "clear ITCT ok\n");
+			break;
+		}
+	}
+}
+
 static int reset_hw_v2_hw(struct hisi_hba *hisi_hba)
 {
 	int i, reset_val;
@@ -1467,8 +1556,10 @@ static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 
 static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
+	.setup_itct = setup_itct_v2_hw,
 	.sl_notify = sl_notify_v2_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v2_hw,
+	.free_device = free_device_v2_hw,
 	.prep_smp = prep_smp_v2_hw,
 	.prep_ssp = prep_ssp_v2_hw,
 	.get_free_slot = get_free_slot_v2_hw,
-- 
1.9.1
