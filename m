From: Ivan Mironov <mironov.ivan@gmail.com>
Subject: [PATCH 6/6] scsi: hpsa: Do not use HBA flag from NVRAM if HBA is not supported
Date: Fri, 14 Dec 2018 18:21:15 +0500
Message-ID: <20181214132115.21440-7-mironov.ivan@gmail.com>
References: <20181214132115.21440-1-mironov.ivan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181214132115.21440-1-mironov.ivan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, mironov.ivan@gmail.com
Cc: linux-kernel@vger.kernel.org, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com
List-Id: linux-scsi@vger.kernel.org

Check bmic_identify_controller.yet_more_controller_flags for HBA support
bit before trying to enable HBA mode.

HP's ssacli tool calls this bit "Hba Mode Supported" in full diagnostics
report.

Signed-off-by: Ivan Mironov <mironov.ivan@gmail.com>
---
 drivers/scsi/hpsa.c     | 16 ++++++++++++++--
 drivers/scsi/hpsa_cmd.h |  4 ++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0b5b3a651b70..38026b82ac6b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4342,6 +4342,12 @@ static bool hpsa_skip_device(struct ctlr_info *h, u8 *lunaddrbytes,
 	return false;
 }
 
+static bool is_hba_supported(const struct bmic_identify_controller *id_ctlr)
+{
+	return le32_to_cpu(id_ctlr->yet_more_controller_flags) &
+			YET_MORE_CTLR_FLAG_HBA_MODE_SUPP;
+}
+
 static int hpsa_nvram_hba_flag_enabled(struct ctlr_info *h, bool *flag_enabled)
 {
 	int rc;
@@ -4364,7 +4370,8 @@ static int hpsa_nvram_hba_flag_enabled(struct ctlr_info *h, bool *flag_enabled)
 	return rc;
 }
 
-static int hpsa_update_nvram_hba_mode(struct ctlr_info *h, u32 nlogicals)
+static int hpsa_update_nvram_hba_mode(struct ctlr_info *h, u32 nlogicals,
+	const struct bmic_identify_controller *id_ctlr)
 {
 	int rc;
 	bool flag_enabled;
@@ -4373,6 +4380,11 @@ static int hpsa_update_nvram_hba_mode(struct ctlr_info *h, u32 nlogicals)
 	if (!hpsa_use_nvram_hba_flag)
 		return 0;
 
+	if (!is_hba_supported(id_ctlr)) {
+		dev_info(&h->pdev->dev, "NVRAM HBA flag: not supported\n");
+		return 0;
+	}
+
 	rc = hpsa_nvram_hba_flag_enabled(h, &flag_enabled);
 	if (rc == -ENOMEM)
 		dev_warn(&h->pdev->dev, "Out of memory.\n");
@@ -4446,7 +4458,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 			__func__);
 	}
 
-	if (hpsa_update_nvram_hba_mode(h, nlogicals)) {
+	if (hpsa_update_nvram_hba_mode(h, nlogicals, id_ctlr)) {
 		h->drv_req_rescan = 1;
 		goto out;
 	}
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 64100a33f844..b27f94b257bc 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -806,6 +806,10 @@ struct bmic_identify_controller {
 };
 
 
+/* ssacli calls this bit "Hba Mode Supported". */
+#define YET_MORE_CTLR_FLAG_HBA_MODE_SUPP (1 << 25)
+
+
 struct bmic_identify_physical_device {
 	u8    scsi_bus;          /* SCSI Bus number on controller */
 	u8    scsi_id;           /* SCSI ID on this bus */
-- 
2.19.2
