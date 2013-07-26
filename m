From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH 1/7] scsi: ufs: amend the ocs handling with fatal error
Date: Fri, 26 Jul 2013 22:45:15 +0900
Message-ID: <001c01ce8a06$5bcbc1c0$13634540$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
 <1374280885-11526-2-git-send-email-mita@fixstars.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51070 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829Ab3GZNpR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jul 2013 09:45:17 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MQJ00EUKQ7FU1R0@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 26 Jul 2013 22:45:15 +0900 (KST)
In-reply-to: <1374280885-11526-2-git-send-email-mita@fixstars.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

Fatal error in OCS(overall command status) field indicates
error conditions which is not covered by UFSHCI.
It means that host cannot define the result of command status
and therefore host may need to check transfer response UPIU's
response and status field.
It was actually found that 'CHECK CONDITION' is stored in status
field of UPIU where OCS is 'FATAL ERROR'.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b743bd6..4cf3a2d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1199,7 +1199,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	switch (ocs) {
 	case OCS_SUCCESS:
-
+	case OCS_FATAL_ERROR:
 		/* check if the returned transfer response is valid */
 		result = ufshcd_is_valid_req_rsp(lrbp->ucd_rsp_ptr);
 		if (result) {
@@ -1229,7 +1229,6 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case OCS_MISMATCH_DATA_BUF_SIZE:
 	case OCS_MISMATCH_RESP_UPIU_SIZE:
 	case OCS_PEER_COMM_FAILURE:
-	case OCS_FATAL_ERROR:
 	default:
 		result |= DID_ERROR << 16;
 		dev_err(hba->dev,
-- 
1.7.0.4


