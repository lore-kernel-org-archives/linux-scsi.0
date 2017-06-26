From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 2/7] bnx2fc: Check for connection offload before sending RRQ.
Date: Mon, 26 Jun 2017 08:59:33 -0700
Message-ID: <20170626155938.2091-3-chad.dupuis@cavium.com>
References: <20170626155938.2091-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0077.outbound.protection.outlook.com ([104.47.34.77]:30504
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751592AbdFZP7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jun 2017 11:59:43 -0400
In-Reply-To: <20170626155938.2091-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

If the connection is not offloaded then the backpointers from the tgt
pointer are undefined.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/bnx2fc/bnx2fc_els.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index 68ca518..fee12c3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -61,13 +61,20 @@ int bnx2fc_send_rrq(struct bnx2fc_cmd *aborted_io_req)
 
 	struct fc_els_rrq rrq;
 	struct bnx2fc_rport *tgt = aborted_io_req->tgt;
-	struct fc_lport *lport = tgt->rdata->local_port;
+	struct fc_lport *lport = NULL;
 	struct bnx2fc_els_cb_arg *cb_arg = NULL;
-	u32 sid = tgt->sid;
-	u32 r_a_tov = lport->r_a_tov;
+	u32 sid = 0;
+	u32 r_a_tov = 0;
 	unsigned long start = jiffies;
 	int rc;
 
+	if (!test_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags))
+		return -EINVAL;
+
+	lport = tgt->rdata->local_port;
+	sid = tgt->sid;
+	r_a_tov = lport->r_a_tov;
+
 	BNX2FC_ELS_DBG("Sending RRQ orig_xid = 0x%x\n",
 		   aborted_io_req->xid);
 	memset(&rrq, 0, sizeof(rrq));
-- 
1.8.5.6
