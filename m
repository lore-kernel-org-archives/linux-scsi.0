From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 17/18] be2iscsi: Fix issue in passing the exp_cmdsn and  max_cmdsn
Date: Fri,  5 Apr 2013 20:38:37 -0700
Message-ID: <1365219519-3457-17-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:44803 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422650Ab3DFDjN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:39:13 -0400
Received: by mail-da0-f49.google.com with SMTP id t11so1807765daj.8
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:39:13 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Command Window value from the CQE was used to calculate the
 max_cmdsn for that session.The command window value extracted
 for SKH-R adapter was not proper. The value was extracted from
 BE adapter completion event. Fixed the issue by getting the
 cmd_wnd value from SKH-R CQE.

 The exp_cmdsn and max_cmdsn values were not converted to BE format
 before calling the __iscsi_complete_pdu(). Fixed the issue of converting
 to BE format.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 39ac051..77c6fe4 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1326,8 +1326,9 @@ be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 	hdr->t2retain = 0;
 	hdr->flags = csol_cqe->i_flags;
 	hdr->response = csol_cqe->i_resp;
-	hdr->exp_cmdsn = csol_cqe->exp_cmdsn;
-	hdr->max_cmdsn = (csol_cqe->exp_cmdsn + csol_cqe->cmd_wnd - 1);
+	hdr->exp_cmdsn = cpu_to_be32(csol_cqe->exp_cmdsn);
+	hdr->max_cmdsn = cpu_to_be32(csol_cqe->exp_cmdsn +
+				     csol_cqe->cmd_wnd - 1);
 
 	hdr->dlength[0] = 0;
 	hdr->dlength[1] = 0;
@@ -1350,9 +1351,9 @@ be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
 	hdr->opcode = ISCSI_OP_SCSI_TMFUNC_RSP;
 	hdr->flags = csol_cqe->i_flags;
 	hdr->response = csol_cqe->i_resp;
-	hdr->exp_cmdsn = csol_cqe->exp_cmdsn;
-	hdr->max_cmdsn = (csol_cqe->exp_cmdsn +
-			  csol_cqe->cmd_wnd - 1);
+	hdr->exp_cmdsn = cpu_to_be32(csol_cqe->exp_cmdsn);
+	hdr->max_cmdsn = cpu_to_be32(csol_cqe->exp_cmdsn +
+				     csol_cqe->cmd_wnd - 1);
 
 	hdr->itt = io_task->libiscsi_itt;
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
@@ -1404,8 +1405,8 @@ be_complete_nopin_resp(struct beiscsi_conn *beiscsi_conn,
 	hdr = (struct iscsi_nopin *)task->hdr;
 	hdr->flags = csol_cqe->i_flags;
 	hdr->exp_cmdsn = cpu_to_be32(csol_cqe->exp_cmdsn);
-	hdr->max_cmdsn = be32_to_cpu(hdr->exp_cmdsn +
-			 csol_cqe->cmd_wnd - 1);
+	hdr->max_cmdsn = cpu_to_be32(csol_cqe->exp_cmdsn +
+				     csol_cqe->cmd_wnd - 1);
 
 	hdr->opcode = ISCSI_OP_NOOP_IN;
 	hdr->itt = io_task->libiscsi_itt;
@@ -1446,7 +1447,7 @@ static void adapter_get_sol_cqe(struct beiscsi_hba *phba,
 					      cid, psol);
 		csol_cqe->hw_sts = AMAP_GET_BITS(struct amap_sol_cqe_v2,
 						 hw_sts, psol);
-		csol_cqe->cmd_wnd = AMAP_GET_BITS(struct amap_sol_cqe,
+		csol_cqe->cmd_wnd = AMAP_GET_BITS(struct amap_sol_cqe_v2,
 						  i_cmd_wnd, psol);
 		if (AMAP_GET_BITS(struct amap_sol_cqe_v2,
 				  cmd_cmpl, psol))
-- 
1.7.10.4

