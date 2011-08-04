From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 13/18] bnx2fc: code cleanup in bnx2fc_offload_session
Date: Thu, 4 Aug 2011 11:47:08 -0700
Message-ID: <1312483633-479-14-git-send-email-bprakash@broadcom.com>
References: <1312483633-479-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1322 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab1HDSrb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 14:47:31 -0400
In-Reply-To: <1312483633-479-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

- Free session resources before rport logoff
- Do not free session resources in bnx2fc_alloc_session_resc() as it is handled
  in caller's error handling path.
- Do not call bnx2fc_free_session_resc() if bnx2fc_init_tgt() fails as cq_lock
  is not yet initialized.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 2f7a7da..38fe85a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -83,7 +83,7 @@ static void bnx2fc_offload_session(struct fcoe_port *port,
 	rval = bnx2fc_alloc_session_resc(hba, tgt);
 	if (rval) {
 		printk(KERN_ERR PFX "Failed to allocate resources\n");
-		goto ofld_err;
+		goto tgt_init_err;
 	}
 
 	/*
@@ -141,11 +141,12 @@ retry_ofld:
 ofld_err:
 	/* couldn't offload the session. log off from this rport */
 	BNX2FC_TGT_DBG(tgt, "bnx2fc_offload_session - offload error\n");
-	lport->tt.rport_logoff(rdata);
 	/* Free session resources */
 	bnx2fc_free_session_resc(hba, tgt);
+tgt_init_err:
 	if (tgt->fcoe_conn_id != -1)
 		bnx2fc_free_conn_id(hba, tgt->fcoe_conn_id);
+	lport->tt.rport_logoff(rdata);
 }
 
 void bnx2fc_flush_active_ios(struct bnx2fc_rport *tgt)
@@ -790,8 +791,6 @@ static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 	return 0;
 
 mem_alloc_failure:
-	bnx2fc_free_session_resc(hba, tgt);
-	bnx2fc_free_conn_id(hba, tgt->fcoe_conn_id);
 	return -ENOMEM;
 }
 
-- 
1.7.0.6


