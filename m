From: Akinobu Mita <mita@fixstars.com>
Subject: [PATCH -next] ufs: fix source address of the read descriptor
Date: Thu, 29 Aug 2013 00:00:30 +0900
Message-ID: <1377702030-12901-1-git-send-email-mita@fixstars.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo.fixstars.hdemail.jp ([176.34.54.138]:49760 "EHLO
	mo.fixstars.hdemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab3H1PFE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2013 11:05:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <mita@fixstars.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, James Bottomley <JBottomley@Parallels.com>

When the query request with read descriptor opcode is completed, the
descriptor is copied from response UPIU to the buffer that the caller
has specified.  Unfortunately the source address of the descriptor is
broken due to the unnecessary address-of operator.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a0f5ac2..7a319c6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -454,8 +454,7 @@ void ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	/* Get the descriptor */
 	if (lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
-		u8 *descp = (u8 *)&lrbp->ucd_rsp_ptr +
-				GENERAL_UPIU_REQUEST_SIZE;
+		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr + GENERAL_UPIU_REQUEST_SIZE;
 		u16 len;
 
 		/* data segment length */
-- 
1.8.3.1

