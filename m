From: Christos Gkekas <chris.gekas@gmail.com>
Subject: [PATCH] bnx2i: Clean up unused pointers in bnx2i_hwi
Date: Sun, 10 Sep 2017 13:18:54 +0100
Message-ID: <1505045934-16272-1-git-send-email-chris.gekas@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christos Gkekas <chris.gekas@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Pointers bnx2i_cmd are set but never used, so they can be removed.

Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 42921db..e3f22cb 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -332,12 +332,10 @@ static void bnx2i_ring_dbell_update_sq_params(struct bnx2i_conn *bnx2i_conn,
 int bnx2i_send_iscsi_login(struct bnx2i_conn *bnx2i_conn,
 			   struct iscsi_task *task)
 {
-	struct bnx2i_cmd *bnx2i_cmd;
 	struct bnx2i_login_request *login_wqe;
 	struct iscsi_login_req *login_hdr;
 	u32 dword;
 
-	bnx2i_cmd = (struct bnx2i_cmd *)task->dd_data;
 	login_hdr = (struct iscsi_login_req *)task->hdr;
 	login_wqe = (struct bnx2i_login_request *)
 						bnx2i_conn->ep->qp.sq_prod_qe;
@@ -391,12 +389,10 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 	struct iscsi_tm *tmfabort_hdr;
 	struct scsi_cmnd *ref_sc;
 	struct iscsi_task *ctask;
-	struct bnx2i_cmd *bnx2i_cmd;
 	struct bnx2i_tmf_request *tmfabort_wqe;
 	u32 dword;
 	u32 scsi_lun[2];
 
-	bnx2i_cmd = (struct bnx2i_cmd *)mtask->dd_data;
 	tmfabort_hdr = (struct iscsi_tm *)mtask->hdr;
 	tmfabort_wqe = (struct bnx2i_tmf_request *)
 						bnx2i_conn->ep->qp.sq_prod_qe;
@@ -463,12 +459,10 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
 int bnx2i_send_iscsi_text(struct bnx2i_conn *bnx2i_conn,
 			  struct iscsi_task *mtask)
 {
-	struct bnx2i_cmd *bnx2i_cmd;
 	struct bnx2i_text_request *text_wqe;
 	struct iscsi_text *text_hdr;
 	u32 dword;
 
-	bnx2i_cmd = (struct bnx2i_cmd *)mtask->dd_data;
 	text_hdr = (struct iscsi_text *)mtask->hdr;
 	text_wqe = (struct bnx2i_text_request *) bnx2i_conn->ep->qp.sq_prod_qe;
 
@@ -541,11 +535,9 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 			    char *datap, int data_len, int unsol)
 {
 	struct bnx2i_endpoint *ep = bnx2i_conn->ep;
-	struct bnx2i_cmd *bnx2i_cmd;
 	struct bnx2i_nop_out_request *nopout_wqe;
 	struct iscsi_nopout *nopout_hdr;
 
-	bnx2i_cmd = (struct bnx2i_cmd *)task->dd_data;
 	nopout_hdr = (struct iscsi_nopout *)task->hdr;
 	nopout_wqe = (struct bnx2i_nop_out_request *)ep->qp.sq_prod_qe;
 
@@ -602,11 +594,9 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 int bnx2i_send_iscsi_logout(struct bnx2i_conn *bnx2i_conn,
 			    struct iscsi_task *task)
 {
-	struct bnx2i_cmd *bnx2i_cmd;
 	struct bnx2i_logout_request *logout_wqe;
 	struct iscsi_logout *logout_hdr;
 
-	bnx2i_cmd = (struct bnx2i_cmd *)task->dd_data;
 	logout_hdr = (struct iscsi_logout *)task->hdr;
 
 	logout_wqe = (struct bnx2i_logout_request *)
-- 
2.7.4
