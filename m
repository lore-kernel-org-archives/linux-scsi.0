From: Avri Altman <avri.altman@wdc.com>
Subject: [REPOST PATCH v4 2/3] scsi: ufs: Allow reading descriptor via raw upiu
Date: Wed, 20 Feb 2019 09:11:13 +0200
Message-ID: <1550646674-15258-3-git-send-email-avri.altman@wdc.com>
References: <1550646674-15258-1-git-send-email-avri.altman@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550646674-15258-1-git-send-email-avri.altman@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Evan Green <evgreen@chromium.org>, Bean Huo <beanhuo@micron.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Avri Altman <avri.altman@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Allow to read descriptors via raw upiu. This in fact was forbidden just
as a precaution, as ufs-bsg actually enforces which functionality is
supported.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Evan Green <evgreen@chromium.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5ca4581..7b5b601 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5780,6 +5780,20 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	/* just copy the upiu response as it is */
 	memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
+	if (desc_buff && desc_op == UPIU_QUERY_OPCODE_READ_DESC) {
+		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr + sizeof(*rsp_upiu);
+		u16 resp_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) &
+			       MASK_QUERY_DATA_SEG_LEN;
+
+		if (*buff_len >= resp_len) {
+			memcpy(desc_buff, descp, resp_len);
+			*buff_len = resp_len;
+		} else {
+			dev_warn(hba->dev, "rsp size is bigger than buffer");
+			*buff_len = 0;
+			err = -EINVAL;
+		}
+	}
 
 	ufshcd_put_dev_cmd_tag(hba, tag);
 	wake_up(&hba->dev_cmd.tag_wq);
@@ -5815,11 +5829,6 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 	int ocs_value;
 	u8 tm_f = be32_to_cpu(req_upiu->header.dword_1) >> 16 & MASK_TM_FUNC;
 
-	if (desc_buff && desc_op != UPIU_QUERY_OPCODE_WRITE_DESC) {
-		err = -ENOTSUPP;
-		goto out;
-	}
-
 	switch (msgcode) {
 	case UPIU_TRANSACTION_NOP_OUT:
 		cmd_type = DEV_CMD_TYPE_NOP;
@@ -5860,7 +5869,6 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 		break;
 	}
 
-out:
 	return err;
 }
 
-- 
1.9.1
