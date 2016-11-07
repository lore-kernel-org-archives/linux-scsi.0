From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v7 10/11] scsi: ufs: retrieve rpmb rw size
Date: Mon,  7 Nov 2016 21:53:13 +0200
Message-ID: <1478548394-8184-11-git-send-email-tomas.winkler@intel.com>
References: <1478548394-8184-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478548394-8184-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: Avri Altman <avri.altman@gmail.com>, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>, Alexander Usyskin <alexander.usyskin@intel.com>
List-Id: linux-scsi@vger.kernel.org

Retrieve maximum number of RPMB frames that can be
in a single request.
Currently the limitations is provided only for writes
via reliable_wr_cnt API.

V7: New in the series

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/scsi/ufs/ufs.h    |  6 ++++++
 drivers/scsi/ufs/ufshcd.c | 22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 845b874e2977..84bb8d7c6b63 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -176,6 +176,12 @@ enum ufs_desc_max_size {
 	QUERY_DESC_RFU_MAX_SIZE			= 0x00,
 };
 
+enum geometry_desc_param_offset {
+	GEOMETRY_DESC_LEN		= 0x0,
+	GEOMETRY_DESC_TYPE		= 0x1,
+	GEOMETRY_DESC_RPMB_RW_SIZE	= 0x17,
+};
+
 /* Unit descriptor parameters offsets in bytes*/
 enum unit_desc_param {
 	UNIT_DESC_PARAM_LEN			= 0x0,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 95bb9dc7fbfe..69f5b03f6774 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2196,6 +2196,15 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 				      param_offset, param_read_buf, param_size);
 }
 
+static inline int ufshcd_read_geometry_desc_param(struct ufs_hba *hba,
+				enum geometry_desc_param_offset param_offset,
+				u8 *param_read_buf, u32 param_size)
+{
+	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_GEOMETRY, 0,
+				      param_offset, param_read_buf, param_size);
+}
+
+
 /**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
@@ -4896,6 +4905,19 @@ static struct rpmb_ops ufshcd_rpmb_dev_ops = {
 static inline void ufshcd_rpmb_add(struct ufs_hba *hba)
 {
 	struct rpmb_dev *rdev;
+	u8 rw_size;
+	int ret;
+
+	ret = ufshcd_read_geometry_desc_param(hba, GEOMETRY_DESC_RPMB_RW_SIZE,
+					&rw_size, sizeof(rw_size));
+	if (ret) {
+		dev_warn(hba->dev, "%s: cannot get rpmb rw limit %d\n",
+			 dev_name(hba->dev), ret);
+		/* fallback to singel frame write */
+		rw_size = 1;
+	}
+
+	ufshcd_rpmb_dev_ops.reliable_wr_cnt = rw_size;
 
 	scsi_device_get(hba->sdev_ufs_rpmb);
 	rdev = rpmb_dev_register(hba->dev, &ufshcd_rpmb_dev_ops);
-- 
2.7.4
