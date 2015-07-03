From: Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] SCSI: bnx2i: remove redundant check
Date: Fri, 03 Jul 2015 13:29:14 +0530
Message-ID: <1435910355-30070-1-git-send-email-maninder1.s@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:52187 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbbGCIAM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2015 04:00:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pankaj.m@samsung.com, Maninder Singh <maninder1.s@samsung.com>

Removing static analysis error:-
(error) Possible null pointer dereference: hba
	hba->cid_que.conn_cid_tbl[iscsi_cid] = bnx2i_conn;
	^^^^

Validation of hba is not required in if check,
because validation is done before entrying to this function
and error comes because after this check hba is dereferenced 
without validation.

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 7289437..cbec2ea 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -239,7 +239,7 @@ static int bnx2i_bind_conn_to_iscsi_cid(struct bnx2i_hba *hba,
 					struct bnx2i_conn *bnx2i_conn,
 					u32 iscsi_cid)
 {
-	if (hba && hba->cid_que.conn_cid_tbl[iscsi_cid]) {
+	if (hba->cid_que.conn_cid_tbl[iscsi_cid]) {
 		iscsi_conn_printk(KERN_ALERT, bnx2i_conn->cls_conn->dd_data,
 				 "conn bind - entry #%d not free\n", iscsi_cid);
 		return -EBUSY;
-- 
1.7.9.5

