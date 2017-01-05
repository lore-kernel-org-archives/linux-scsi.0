From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 2/4] scsi: ufs: unexport descritpor reading functions
Date: Thu,  5 Jan 2017 10:45:10 +0200
Message-ID: <1483605912-15041-2-git-send-email-tomas.winkler@intel.com>
References: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:17835 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031144AbdAEHt4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Jan 2017 02:49:56 -0500
In-Reply-To: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

Unexport ufshcd_read_device_desc and ufshcd_read_string_desc
there is no really possibility to calling them directly
outside of UFS context.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 9 ++++-----
 drivers/scsi/ufs/ufshcd.h | 7 -------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index be3c2900b6bb..63d7ae2c3be9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2208,11 +2208,10 @@ static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
 	return err;
 }
 
-int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
+static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
 {
 	return ufshcd_read_desc(hba, QUERY_DESC_IDN_DEVICE, 0, buf, size);
 }
-EXPORT_SYMBOL(ufshcd_read_device_desc);
 
 /**
  * ufshcd_read_string_desc - read string descriptor
@@ -2224,8 +2223,9 @@ EXPORT_SYMBOL(ufshcd_read_device_desc);
  *
  * Return 0 in case of success, non-zero otherwise
  */
-int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index, u8 *buf,
-				u32 size, bool ascii)
+#define ASCII_STD true
+static int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
+				   u8 *buf, u32 size, bool ascii)
 {
 	int err = 0;
 
@@ -2281,7 +2281,6 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index, u8 *buf,
 out:
 	return err;
 }
-EXPORT_SYMBOL(ufshcd_read_string_desc);
 
 /**
  * ufshcd_read_unit_desc_param - read the specified unit descriptor parameter
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 08cd26ed2382..00fb82589895 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -713,8 +713,6 @@ static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
 	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_PEER);
 }
 
-int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size);
-
 static inline bool ufshcd_is_hs_mode(struct ufs_pa_layer_attr *pwr_info)
 {
 	return (pwr_info->pwr_rx == FAST_MODE ||
@@ -723,11 +721,6 @@ static inline bool ufshcd_is_hs_mode(struct ufs_pa_layer_attr *pwr_info)
 		pwr_info->pwr_tx == FASTAUTO_MODE);
 }
 
-#define ASCII_STD true
-
-int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index, u8 *buf,
-				u32 size, bool ascii);
-
 /* Expose Query-Request API */
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, bool *flag_res);
-- 
2.7.4

