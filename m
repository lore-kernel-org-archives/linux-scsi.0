From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH] BNX2I: Added reconnect fix connecting against Lefthand
 targets
Date: Sat, 8 Jan 2011 18:00:24 -0800
Message-ID: <1294538424-4168-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1362 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1AIB5q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jan 2011 20:57:46 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

The nopout's reserved field was not being initialized to zero
before being reused.  Stale CDB values from previous SCSI cmds
of the same BHS offset was the cause of the disconnection
initiated by the Lefthand target.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 9375369..5442f1a 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -490,6 +490,9 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
 	bnx2i_cmd = (struct bnx2i_cmd *)task->dd_data;
 	nopout_hdr = (struct iscsi_nopout *)task->hdr;
 	nopout_wqe = (struct bnx2i_nop_out_request *)ep->qp.sq_prod_qe;
+
+	memset(nopout_wqe, 0x00, sizeof(struct bnx2i_nop_out_request));
+
 	nopout_wqe->op_code = nopout_hdr->opcode;
 	nopout_wqe->op_attr = ISCSI_FLAG_CMD_FINAL;
 	memcpy(nopout_wqe->lun, nopout_hdr->lun, 8);
-- 
1.7.0.5


