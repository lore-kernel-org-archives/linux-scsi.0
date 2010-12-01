From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 18/27] libfc: the timeout for the REC itself is 2 * R_A_TOV_els
Date: Tue, 30 Nov 2010 16:19:30 -0800
Message-ID: <20101201001930.18369.20826.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab0LAATb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:19:31 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

The timeout for the exchange carrying REC itself is 2 * R_A_TOV_els.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 088ea2a..a25057d 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1399,7 +1399,6 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 	struct fc_frame *fp;
 	struct fc_rport *rport;
 	struct fc_rport_libfc_priv *rpriv;
-	unsigned int rec_tov;
 
 	lport = fsp->lp;
 	rport = fsp->rport;
@@ -1411,8 +1410,6 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 		return;
 	}
 
-	rec_tov = get_fsp_rec_tov(fsp);
-
 	fp = fc_fcp_frame_alloc(lport, sizeof(struct fc_els_rec));
 	if (!fp)
 		goto retry;
@@ -1423,13 +1420,13 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 		       FC_FCTL_REQ, 0);
 	if (lport->tt.elsct_send(lport, rport->port_id, fp, ELS_REC,
 				 fc_fcp_rec_resp, fsp,
-				 jiffies_to_msecs(rec_tov))) {
+				 2 * lport->r_a_tov)) {
 		fc_fcp_pkt_hold(fsp);		/* hold while REC outstanding */
 		return;
 	}
 retry:
 	if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
-		fc_fcp_timer_set(fsp, rec_tov);
+		fc_fcp_timer_set(fsp, get_fsp_rec_tov(fsp));
 	else
 		fc_fcp_recovery(fsp, FC_TIMED_OUT);
 }

