From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 1/4] bnx2fc: Allow FLOGI to be retried when receiving
 bad responses.
Date: Wed, 11 Apr 2012 15:54:49 -0700
Message-ID: <1334184892-18419-2-git-send-email-bprakash@broadcom.com>
References: <1334184892-18419-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3318 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761387Ab2DKWzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Apr 2012 18:55:06 -0400
In-Reply-To: <1334184892-18419-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Commit 907c07d45199f954ddcf66c2c9763c87d012cb15 added more cases to do FLOGI
retry on receiving bad response. Remove the code that drops the packet and
allow the stack to handle bad FLOGI response.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_els.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index ce0ce3e..cf3bdcd 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -854,7 +854,6 @@ static void bnx2fc_flogi_resp(struct fc_seq *seq, struct fc_frame *fp,
 	struct fc_exch *exch = fc_seq_exch(seq);
 	struct fc_lport *lport = exch->lp;
 	u8 *mac;
-	struct fc_frame_header *fh;
 	u8 op;
 
 	if (IS_ERR(fp))
@@ -862,13 +861,6 @@ static void bnx2fc_flogi_resp(struct fc_seq *seq, struct fc_frame *fp,
 
 	mac = fr_cb(fp)->granted_mac;
 	if (is_zero_ether_addr(mac)) {
-		fh = fc_frame_header_get(fp);
-		if (fh->fh_type != FC_TYPE_ELS) {
-			printk(KERN_ERR PFX "bnx2fc_flogi_resp:"
-				"fh_type != FC_TYPE_ELS\n");
-			fc_frame_free(fp);
-			return;
-		}
 		op = fc_frame_payload_op(fp);
 		if (lport->vport) {
 			if (op == ELS_LS_RJT) {
@@ -878,12 +870,10 @@ static void bnx2fc_flogi_resp(struct fc_seq *seq, struct fc_frame *fp,
 				return;
 			}
 		}
-		if (fcoe_ctlr_recv_flogi(fip, lport, fp)) {
-			fc_frame_free(fp);
-			return;
-		}
+		fcoe_ctlr_recv_flogi(fip, lport, fp);
 	}
-	fip->update_mac(lport, mac);
+	if (!is_zero_ether_addr(mac))
+		fip->update_mac(lport, mac);
 done:
 	fc_lport_flogi_resp(seq, fp, lport);
 }
-- 
1.7.0.6


