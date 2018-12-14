From: Ivan Mironov <mironov.ivan@gmail.com>
Subject: [PATCH 4/6] scsi: hpsa: Ignore HBA flag from NVRAM if logical devices exist
Date: Fri, 14 Dec 2018 18:21:13 +0500
Message-ID: <20181214132115.21440-5-mironov.ivan@gmail.com>
References: <20181214132115.21440-1-mironov.ivan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181214132115.21440-1-mironov.ivan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, mironov.ivan@gmail.com
Cc: linux-kernel@vger.kernel.org, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com
List-Id: linux-scsi@vger.kernel.org

Simultaneous use of physical devices and logical RAID devices may be
dangerous.

Signed-off-by: Ivan Mironov <mironov.ivan@gmail.com>
---
 drivers/scsi/hpsa.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 60f1f7949d8d..0b5b3a651b70 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4364,10 +4364,11 @@ static int hpsa_nvram_hba_flag_enabled(struct ctlr_info *h, bool *flag_enabled)
 	return rc;
 }
 
-static int hpsa_update_nvram_hba_mode(struct ctlr_info *h)
+static int hpsa_update_nvram_hba_mode(struct ctlr_info *h, u32 nlogicals)
 {
 	int rc;
 	bool flag_enabled;
+	bool ignore;
 
 	if (!hpsa_use_nvram_hba_flag)
 		return 0;
@@ -4378,10 +4379,13 @@ static int hpsa_update_nvram_hba_mode(struct ctlr_info *h)
 	if (rc)
 		return rc;
 
-	dev_info(&h->pdev->dev, "NVRAM HBA flag: %s\n",
-		flag_enabled ? "enabled" : "disabled");
+	ignore = flag_enabled && nlogicals;
 
-	h->nvram_hba_mode_enabled = flag_enabled;
+	dev_info(&h->pdev->dev, "NVRAM HBA flag: %s%s\n",
+		flag_enabled ? "enabled" : "disabled",
+		ignore ? " (ignored because of existing logical devices)" : "");
+
+	h->nvram_hba_mode_enabled = flag_enabled && !ignore;
 
 	return 0;
 }
@@ -4442,7 +4446,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 			__func__);
 	}
 
-	if (hpsa_update_nvram_hba_mode(h)) {
+	if (hpsa_update_nvram_hba_mode(h, nlogicals)) {
 		h->drv_req_rescan = 1;
 		goto out;
 	}
-- 
2.19.2
