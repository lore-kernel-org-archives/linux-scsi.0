From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 2/2] [SCSI] ufs: calculate read/write xfer len from cdb
Date: Fri,  6 Apr 2012 17:57:21 +0530
Message-ID: <1333715241-32346-2-git-send-email-santoshsy@gmail.com>
References: <1333715241-32346-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48278 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab2DFM1k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 08:27:40 -0400
Received: by pbcun15 with SMTP id un15so2607180pbc.19
        for <linux-scsi@vger.kernel.org>; Fri, 06 Apr 2012 05:27:40 -0700 (PDT)
In-Reply-To: <1333715241-32346-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, yoshitake.kobayashi@toshiba.co.jp, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

Currently the Expected data transfer length field in
command UPIU is being updated with "transfersize" from
the scsi_cmnd struct. But, if the read/write data
transfer size exceeds the sector size, the "transfersize"
will be truncated to the sector size. Thanks to KOBAYASHI
Yoshitake for pointing it out.

This patch ensures that the correct read/write data transfer
size is calculated from the "transfer length" available in the
CDB.

Reported-by: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
Signed-off-by: Santosh Y <santoshsy@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1878cd8..4f99ab4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -585,6 +585,41 @@ static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
 }
 
 /**
+ * ufshcd_get_transfer_len - calculate data transfer size for read/write
+ *			     commands from the CDB
+ * @cmdp: pointer to SCSI command
+ */
+static inline u32 ufshcd_get_transfer_len(struct scsi_cmnd *cmdp)
+{
+	u32 transfer_len;
+
+	switch (cmdp->cmnd[0]) {
+	case READ_6:
+	case WRITE_6:
+		transfer_len = cmdp->device->sector_size *
+			       cmdp->cmnd[4];
+		break;
+	case READ_10:
+	case WRITE_10:
+		transfer_len = cmdp->device->sector_size *
+			       ((cmdp->cmnd[7] << 8) |
+				cmdp->cmnd[8]);
+		break;
+	case READ_16:
+	case WRITE_16:
+		transfer_len = cmdp->device->sector_size *
+			       ((cmdp->cmnd[10] << 24) |
+				(cmdp->cmnd[11] << 16) |
+				(cmdp->cmnd[12] << 8) |
+				cmdp->cmnd[13]);
+		break;
+	default:
+		transfer_len = cmdp->transfersize;
+	}
+	return transfer_len;
+}
+
+/**
  * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
  * @lrb - pointer to local reference block
  */
@@ -640,7 +675,7 @@ static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
 		ucd_cmd_ptr->header.dword_2 = 0;
 
 		ucd_cmd_ptr->exp_data_transfer_len =
-			cpu_to_be32(lrbp->cmd->transfersize);
+			cpu_to_be32(ufshcd_get_transfer_len(lrbp->cmd));
 
 		memcpy(ucd_cmd_ptr->cdb,
 		       lrbp->cmd->cmnd,
-- 
1.7.5.4

