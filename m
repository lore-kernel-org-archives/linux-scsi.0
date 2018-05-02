From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: ufs: ufshcd: Remove VLA usage
Date: Wed, 2 May 2018 16:58:09 -0700
Message-ID: <20180502235809.GA13998@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On the quest to remove all VLAs from the kernel[1] this moves buffers
off the stack. In the second instance, this collapses two separately
allocated buffers into a single buffer, since they are used consecutively,
which saves 256 bytes (QUERY_DESC_MAX_SIZE + 1) of stack space.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/ufs/ufshcd.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 00e79057f870..a271534362f6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5958,14 +5958,18 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 {
 	int ret;
 	int buff_len = hba->desc_size.pwr_desc;
-	u8 desc_buf[hba->desc_size.pwr_desc];
+	u8 *desc_buf;
+
+	desc_buf = kmalloc(buff_len, GFP_KERNEL);
+	if (!desc_buf)
+		return;
 
 	ret = ufshcd_read_power_desc(hba, desc_buf, buff_len);
 	if (ret) {
 		dev_err(hba->dev,
 			"%s: Failed reading power descriptor.len = %d ret = %d",
 			__func__, buff_len, ret);
-		return;
+		goto out;
 	}
 
 	hba->init_prefetch_data.icc_level =
@@ -5983,6 +5987,8 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 			"%s: Failed configuring bActiveICCLevel = %d ret = %d",
 			__func__, hba->init_prefetch_data.icc_level , ret);
 
+out:
+	kfree(desc_buf);
 }
 
 /**
@@ -6052,9 +6058,17 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
 			       struct ufs_dev_desc *dev_desc)
 {
 	int err;
+	size_t buff_len;
 	u8 model_index;
-	u8 str_desc_buf[QUERY_DESC_MAX_SIZE + 1] = {0};
-	u8 desc_buf[hba->desc_size.dev_desc];
+	u8 *desc_buf;
+
+	buff_len = max_t(size_t, hba->desc_size.dev_desc,
+			 QUERY_DESC_MAX_SIZE + 1);
+	desc_buf = kmalloc(buff_len, GFP_KERNEL);
+	if (!desc_buf) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	err = ufshcd_read_device_desc(hba, desc_buf, hba->desc_size.dev_desc);
 	if (err) {
@@ -6072,7 +6086,10 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
 
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 
-	err = ufshcd_read_string_desc(hba, model_index, str_desc_buf,
+	/* Zero-pad entire buffer for string termination. */
+	memset(desc_buf, 0, buff_len);
+
+	err = ufshcd_read_string_desc(hba, model_index, desc_buf,
 				      QUERY_DESC_MAX_SIZE, true/*ASCII*/);
 	if (err) {
 		dev_err(hba->dev, "%s: Failed reading Product Name. err = %d\n",
@@ -6080,15 +6097,16 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
 		goto out;
 	}
 
-	str_desc_buf[QUERY_DESC_MAX_SIZE] = '\0';
-	strlcpy(dev_desc->model, (str_desc_buf + QUERY_DESC_HDR_SIZE),
-		min_t(u8, str_desc_buf[QUERY_DESC_LENGTH_OFFSET],
+	desc_buf[QUERY_DESC_MAX_SIZE] = '\0';
+	strlcpy(dev_desc->model, (desc_buf + QUERY_DESC_HDR_SIZE),
+		min_t(u8, desc_buf[QUERY_DESC_LENGTH_OFFSET],
 		      MAX_MODEL_LEN));
 
 	/* Null terminate the model string */
 	dev_desc->model[MAX_MODEL_LEN] = '\0';
 
 out:
+	kfree(desc_buf);
 	return err;
 }
 
-- 
2.17.0


-- 
Kees Cook
Pixel Security
