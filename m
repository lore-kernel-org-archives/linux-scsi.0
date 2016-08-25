From: Zang Leigang <zangleigang@hisilicon.com>
Subject: [PATCH v2] UFS: Date Segment only need for WRITE DESCRIPTOR
Date: Thu, 25 Aug 2016 17:39:19 +0800
Message-ID: <20160825093919.5936-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:6950 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753994AbcHYJju (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2016 05:39:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Some device may cause a compatibility issue while receiving a Query UPIU
with Data Segment which does not expected.

Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
---
 drivers/scsi/ufs/ufshcd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f08d41a..9b21d88 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1266,9 +1266,12 @@ static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
 	ucd_req_ptr->header.dword_1 = UPIU_HEADER_DWORD(
 			0, query->request.query_func, 0, 0);
 
-	/* Data segment length */
-	ucd_req_ptr->header.dword_2 = UPIU_HEADER_DWORD(
-			0, 0, len >> 8, (u8)len);
+	/* Data segment length only need for WRITE_DESC */
+	if (query->request.upiu_req.opcode == UPIU_QUERY_OPCODE_WRITE_DESC)
+		ucd_req_ptr->header.dword_2 =
+			UPIU_HEADER_DWORD(0, 0, (len >> 8), (u8)len);
+	else
+		ucd_req_ptr->header.dword_2 = 0;
 
 	/* Copy the Query Request buffer as is */
 	memcpy(&ucd_req_ptr->qr, &query->request.upiu_req,
-- 
2.9.3

