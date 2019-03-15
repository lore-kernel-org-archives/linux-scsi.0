From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH v2] scsi: ufs: fix a missing check of devm_reset_control_get
Date: Fri, 15 Mar 2019 02:11:56 -0500
Message-ID: <20190315071156.21588-1-kjlu@umn.edu>
References: <SN6PR04MB4925DB2652FAED5F3AED27CCFC4B0@SN6PR04MB4925.namprd04.prod.outlook.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN6PR04MB4925DB2652FAED5F3AED27CCFC4B0@SN6PR04MB4925.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

devm_reset_control_get could fail, so the fix checks its
return value and passes the error code upstream in case it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Acked-by: Avri Altman <avri.altman@wdc.com>

---
V2: Use full line please
---
 drivers/scsi/ufs/ufs-hisi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index 452e19f8fb47..c2cee73a8560 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -544,6 +544,10 @@ static int ufs_hisi_init_common(struct ufs_hba *hba)
 	ufshcd_set_variant(hba, host);
 
 	host->rst  = devm_reset_control_get(dev, "rst");
+	if (IS_ERR(host->rst)) {
+		dev_err(dev, "%s: failed to get reset control\n", __func__);
+		return PTR_ERR(host->rst);
+	}
 
 	ufs_hisi_set_pm_lvl(hba);
 
-- 
2.17.1
