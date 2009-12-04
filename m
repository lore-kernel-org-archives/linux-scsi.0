From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 04/15] be2iscsi: Added opcode for ISCSI_OP_LOGOUT_RSP,
 ISCSI_OP_SCSI_TMFUNC_RSP
Date: Fri, 4 Dec 2009 08:49:50 +0530
Message-ID: <20091204031940.GA6057@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:6644 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753429AbZLDDTg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 22:19:36 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	This patch adds opcodes in thecompletion path that were
missed out earlier

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ac76b14..b24be79 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -810,6 +810,7 @@ be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 	struct iscsi_conn *conn = beiscsi_conn->conn;
 
 	hdr = (struct iscsi_logout_rsp *)task->hdr;
+	hdr->opcode = ISCSI_OP_LOGOUT_RSP;
 	hdr->t2wait = 5;
 	hdr->t2retain = 0;
 	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
@@ -824,6 +825,9 @@ be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 					& SOL_EXP_CMD_SN_MASK) +
 			((psol->dw[offsetof(struct amap_sol_cqe, i_cmd_wnd)
 					/ 32] & SOL_CMD_WND_MASK) >> 24) - 1);
+	hdr->dlength[0] = 0;
+	hdr->dlength[1] = 0;
+	hdr->dlength[2] = 0;
 	hdr->hlength = 0;
 	hdr->itt = io_task->libiscsi_itt;
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0);
@@ -838,6 +842,7 @@ be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
 	struct beiscsi_io_task *io_task = task->dd_data;
 
 	hdr = (struct iscsi_tm_rsp *)task->hdr;
+	hdr->opcode = ISCSI_OP_SCSI_TMFUNC_RSP;
 	hdr->flags = ((psol->dw[offsetof(struct amap_sol_cqe, i_flags) / 32]
 					& SOL_FLAGS_MASK) >> 24) | 0x80;
 	hdr->response = (psol->dw[offsetof(struct amap_sol_cqe, i_resp) /
-- 
1.6.4

