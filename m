From: Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: Check that space was properly alloced in copy_query_response
Date: Tue, 21 May 2019 11:24:22 +0300
Message-ID: <1558427062-5084-1-git-send-email-avri.altman@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Evan Green <evgreen@chromium.org>, Bean Huo <beanhuo@micron.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Avri Altman <avri.altman@wdc.com>
List-Id: linux-scsi@vger.kernel.org

struct ufs_dev_cmd is the main container that supports device management
commands. In the case of a read descriptor request, we assume that the
proper space was allocated in dev_cmd to hold the returning descriptor.

This is no longer true, as there are flows that doesn't use dev_cmd
for device management requests, and was wrong in the first place.

fixes: d44a5f98bb49 (ufs: query descriptor API)

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8c1c551..3fe3029 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1917,7 +1917,8 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	memcpy(&query_res->upiu_res, &lrbp->ucd_rsp_ptr->qr, QUERY_OSF_SIZE);
 
 	/* Get the descriptor */
-	if (lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
+	if (hba->dev_cmd.query.descriptor &&
+	    lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
 		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr +
 				GENERAL_UPIU_REQUEST_SIZE;
 		u16 resp_len;
-- 
1.9.1
