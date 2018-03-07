From: John Garry <john.garry@huawei.com>
Subject: [PATCH v4 03/10] scsi: hisi_sas: fix the issue of link rate inconsistency
Date: Wed, 7 Mar 2018 20:25:07 +0800
Message-ID: <1520425514-205565-4-git-send-email-john.garry@huawei.com>
References: <1520425514-205565-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520425514-205565-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com, hare@suse.de
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

In sysfs, there are two files about minimum linkrate, and also
two files for maximum linkrate. Take maximum linkrate example,
maximum_linkrate_hw is read-only and indicated by the register
HARD_PHY_LINKRATE, and maximum_linkrate is read-write and
corresponding to the register PROG_PHY_LINK_RATE.

But in the function phy_up_v*_hw(), we get *_linkrate value from
HARD_PHY_LINKRATE. It is not right. This patch is to fix this issue.

Unreferenced PHY-interrupt enum is also removed for v3 hw.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  2 ++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  1 -
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  8 +-------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 13 +------------
 4 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2d4dbed..9d16372 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -683,6 +683,8 @@ static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 
 	phy->hisi_hba = hisi_hba;
 	phy->port = NULL;
+	phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+	phy->maximum_linkrate = hisi_hba->hw->phy_get_max_linkrate();
 	sas_phy->enabled = (phy_no < hisi_hba->n_phy) ? 1 : 0;
 	sas_phy->class = SAS;
 	sas_phy->iproto = SAS_PROTOCOL_ALL;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 679e76f..38bbda9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -873,7 +873,6 @@ static void phy_set_linkrate_v1_hw(struct hisi_hba *hisi_hba, int phy_no,
 	sas_phy->phy->maximum_linkrate = max;
 	sas_phy->phy->minimum_linkrate = min;
 
-	min -= SAS_LINK_RATE_1_5_GBPS;
 	max -= SAS_LINK_RATE_1_5_GBPS;
 
 	for (i = 0; i <= max; i++)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 42b3fd6..67be346 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1603,7 +1603,6 @@ static void phy_set_linkrate_v2_hw(struct hisi_hba *hisi_hba, int phy_no,
 	sas_phy->phy->maximum_linkrate = max;
 	sas_phy->phy->minimum_linkrate = min;
 
-	min -= SAS_LINK_RATE_1_5_GBPS;
 	max -= SAS_LINK_RATE_1_5_GBPS;
 
 	for (i = 0; i <= max; i++)
@@ -2684,7 +2683,7 @@ static int prep_abort_v2_hw(struct hisi_hba *hisi_hba,
 static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	int i, res = IRQ_HANDLED;
-	u32 port_id, link_rate, hard_phy_linkrate;
+	u32 port_id, link_rate;
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	struct device *dev = hisi_hba->dev;
@@ -2723,11 +2722,6 @@ static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	}
 
 	sas_phy->linkrate = link_rate;
-	hard_phy_linkrate = hisi_sas_phy_read32(hisi_hba, phy_no,
-						HARD_PHY_LINKRATE);
-	phy->maximum_linkrate = hard_phy_linkrate & 0xf;
-	phy->minimum_linkrate = (hard_phy_linkrate >> 4) & 0xf;
-
 	sas_phy->oob_mode = SAS_OOB_MODE;
 	memcpy(sas_phy->attached_sas_addr, &id->sas_addr, SAS_ADDR_SIZE);
 	dev_info(dev, "phyup: phy%d link_rate=%d\n", phy_no, link_rate);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index a1f1868..1ee95ab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -340,12 +340,6 @@ struct hisi_sas_err_record_v3 {
 #define HISI_SAS_COMMAND_ENTRIES_V3_HW 4096
 #define HISI_SAS_MSI_COUNT_V3_HW 32
 
-enum {
-	HISI_SAS_PHY_PHY_UPDOWN,
-	HISI_SAS_PHY_CHNL_INT,
-	HISI_SAS_PHY_INT_NR
-};
-
 #define DIR_NO_DATA 0
 #define DIR_TO_INI 1
 #define DIR_TO_DEVICE 2
@@ -1121,7 +1115,7 @@ static int prep_abort_v3_hw(struct hisi_hba *hisi_hba,
 static int phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	int i, res = 0;
-	u32 context, port_id, link_rate, hard_phy_linkrate;
+	u32 context, port_id, link_rate;
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	struct device *dev = hisi_hba->dev;
@@ -1139,10 +1133,6 @@ static int phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 		goto end;
 	}
 	sas_phy->linkrate = link_rate;
-	hard_phy_linkrate = hisi_sas_phy_read32(hisi_hba, phy_no,
-						HARD_PHY_LINKRATE);
-	phy->maximum_linkrate = hard_phy_linkrate & 0xf;
-	phy->minimum_linkrate = (hard_phy_linkrate >> 4) & 0xf;
 	phy->phy_type &= ~(PORT_TYPE_SAS | PORT_TYPE_SATA);
 
 	/* Check for SATA dev */
@@ -1864,7 +1854,6 @@ static void phy_set_linkrate_v3_hw(struct hisi_hba *hisi_hba, int phy_no,
 	sas_phy->phy->maximum_linkrate = max;
 	sas_phy->phy->minimum_linkrate = min;
 
-	min -= SAS_LINK_RATE_1_5_GBPS;
 	max -= SAS_LINK_RATE_1_5_GBPS;
 
 	for (i = 0; i <= max; i++)
-- 
1.9.1
