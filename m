From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 4/4] scsi: ufs: refactor device descriptor reading
Date: Thu,  5 Jan 2017 10:45:12 +0200
Message-ID: <1483605912-15041-4-git-send-email-tomas.winkler@intel.com>
References: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

Pull device descriptor reading out of ufs quirk so it
can be used also for other purposes.

Revamp the fixup setup:
1. Rename ufs_device_info to ufs_dev_desc as very similar
name ufs_dev_info is already in use.
2. Make the handlers static as they are not used out of the
ufshdc.c file.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/ufs/ufs.h        | 12 ++++++++++++
 drivers/scsi/ufs/ufs_quirks.h | 28 ++++++----------------------
 drivers/scsi/ufs/ufshcd.c     | 40 +++++++++++++++++++---------------------
 3 files changed, 37 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 8e6709a3fb6b..318e4a1f76c9 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -523,4 +523,16 @@ struct ufs_dev_info {
 	bool is_lu_power_on_wp;
 };
 
+#define MAX_MODEL_LEN 16
+/**
+ * ufs_dev_desc - ufs device details from the device descriptor
+ *
+ * @wmanufacturerid: card details
+ * @model: card model
+ */
+struct ufs_dev_desc {
+	u16 wmanufacturerid;
+	char model[MAX_MODEL_LEN + 1];
+};
+
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index 08b799d4efcc..71f73d1d1ad1 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -21,41 +21,28 @@
 #define UFS_ANY_VENDOR 0xFFFF
 #define UFS_ANY_MODEL  "ANY_MODEL"
 
-#define MAX_MODEL_LEN 16
-
 #define UFS_VENDOR_TOSHIBA     0x198
 #define UFS_VENDOR_SAMSUNG     0x1CE
 #define UFS_VENDOR_SKHYNIX     0x1AD
 
 /**
- * ufs_device_info - ufs device details
- * @wmanufacturerid: card details
- * @model: card model
- */
-struct ufs_device_info {
-	u16 wmanufacturerid;
-	char model[MAX_MODEL_LEN + 1];
-};
-
-/**
  * ufs_dev_fix - ufs device quirk info
  * @card: ufs card details
  * @quirk: device quirk
  */
 struct ufs_dev_fix {
-	struct ufs_device_info card;
+	struct ufs_dev_desc card;
 	unsigned int quirk;
 };
 
 #define END_FIX { { 0 }, 0 }
 
 /* add specific device quirk */
-#define UFS_FIX(_vendor, _model, _quirk) \
-		{					  \
-			.card.wmanufacturerid = (_vendor),\
-			.card.model = (_model),		  \
-			.quirk = (_quirk),		  \
-		}
+#define UFS_FIX(_vendor, _model, _quirk) { \
+	.card.wmanufacturerid = (_vendor),\
+	.card.model = (_model),		   \
+	.quirk = (_quirk),		   \
+}
 
 /*
  * If UFS device is having issue in processing LCC (Line Control
@@ -144,7 +131,4 @@ struct ufs_dev_fix {
  */
 #define UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME	(1 << 8)
 
-struct ufs_hba;
-void ufs_advertise_fixup_device(struct ufs_hba *hba);
-
 #endif /* UFS_QUIRKS_H_ */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fdea08f79b7d..53b3ec40a7b0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5008,8 +5008,8 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 	return ret;
 }
 
-static int ufs_get_device_info(struct ufs_hba *hba,
-				struct ufs_device_info *card_data)
+static int ufs_get_device_desc(struct ufs_hba *hba,
+			       struct ufs_dev_desc *dev_desc)
 {
 	int err;
 	u8 model_index;
@@ -5028,7 +5028,7 @@ static int ufs_get_device_info(struct ufs_hba *hba,
 	 * getting vendor (manufacturerID) and Bank Index in big endian
 	 * format
 	 */
-	card_data->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
+	dev_desc->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
 				     desc_buf[DEVICE_DESC_PARAM_MANF_ID + 1];
 
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
@@ -5042,36 +5042,26 @@ static int ufs_get_device_info(struct ufs_hba *hba,
 	}
 
 	str_desc_buf[QUERY_DESC_STRING_MAX_SIZE] = '\0';
-	strlcpy(card_data->model, (str_desc_buf + QUERY_DESC_HDR_SIZE),
+	strlcpy(dev_desc->model, (str_desc_buf + QUERY_DESC_HDR_SIZE),
 		min_t(u8, str_desc_buf[QUERY_DESC_LENGTH_OFFSET],
 		      MAX_MODEL_LEN));
 
 	/* Null terminate the model string */
-	card_data->model[MAX_MODEL_LEN] = '\0';
+	dev_desc->model[MAX_MODEL_LEN] = '\0';
 
 out:
 	return err;
 }
 
-void ufs_advertise_fixup_device(struct ufs_hba *hba)
+static void ufs_fixup_device_setup(struct ufs_hba *hba,
+				   struct ufs_dev_desc *dev_desc)
 {
-	int err;
 	struct ufs_dev_fix *f;
-	struct ufs_device_info card_data;
-
-	card_data.wmanufacturerid = 0;
-
-	err = ufs_get_device_info(hba, &card_data);
-	if (err) {
-		dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
-			__func__, err);
-		return;
-	}
 
 	for (f = ufs_fixups; f->quirk; f++) {
-		if (((f->card.wmanufacturerid == card_data.wmanufacturerid) ||
-		    (f->card.wmanufacturerid == UFS_ANY_VENDOR)) &&
-		    (STR_PRFX_EQUAL(f->card.model, card_data.model) ||
+		if ((f->card.wmanufacturerid == dev_desc->wmanufacturerid ||
+		     f->card.wmanufacturerid == UFS_ANY_VENDOR) &&
+		    (STR_PRFX_EQUAL(f->card.model, dev_desc->model) ||
 		     !strcmp(f->card.model, UFS_ANY_MODEL)))
 			hba->dev_quirks |= f->quirk;
 	}
@@ -5249,6 +5239,7 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
  */
 static int ufshcd_probe_hba(struct ufs_hba *hba)
 {
+	struct ufs_dev_desc card = {0};
 	int ret;
 
 	ret = ufshcd_link_startup(hba);
@@ -5272,7 +5263,14 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
-	ufs_advertise_fixup_device(hba);
+	ret = ufs_get_device_desc(hba, &card);
+	if (ret) {
+		dev_err(hba->dev, "%s: Failed getting device info. err = %d\n",
+			__func__, ret);
+		goto out;
+	}
+
+	ufs_fixup_device_setup(hba, &card);
 	ufshcd_tune_unipro_params(hba);
 
 	ret = ufshcd_set_vccq_rail_unused(hba,
-- 
2.7.4
