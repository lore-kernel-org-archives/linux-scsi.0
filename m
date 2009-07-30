From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/22] libfc: in fc_lport_destroy,
	flush rports after turning off link
Date: Wed, 29 Jul 2009 17:04:33 -0700
Message-ID: <20090730000433.24658.59151.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31161 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342AbZG3AEd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:04:33 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

During an fcoe module unload, we saw a problem where fc_rport_work()
finds the lport has been freed.  The rdata points to an area
containing 0x6b6b6b6b... the pool poison value from kmem_free().

In fcoe_if_destroy() we call fc_fabric_logoff() then fc_lport_destroy().
fc_fabric_logoff() flushes the remote port work, but we're still receiving
requests, and an RSCN or PLOGI arrives which creates more rports.

Note that although the LLD also checks link_up, it doesn't do it
under the lport mutex, so it can deliver frames to
fc_lport_recv_req() even after link_up is cleared.
So, re-check link_up there.

We need to flush the rports by calling disc_stop_final()
after we clear link_up.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 7bb451a..a430335 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -643,6 +643,7 @@ int fc_lport_destroy(struct fc_lport *lport)
 	mutex_unlock(&lport->lp_mutex);
 
 	lport->tt.fcp_abort_io(lport);
+	lport->tt.disc_stop_final(lport);
 	lport->tt.exch_mgr_reset(lport, 0, 0);
 	return 0;
 }
@@ -844,7 +845,10 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 	 * RSCN here.  These don't require a session.
 	 * Even if we had a session, it might not be ready.
 	 */
-	if (fh->fh_type == FC_TYPE_ELS && fh->fh_r_ctl == FC_RCTL_ELS_REQ) {
+	if (!lport->link_up)
+		fc_frame_free(fp);
+	else if (fh->fh_type == FC_TYPE_ELS &&
+		 fh->fh_r_ctl == FC_RCTL_ELS_REQ) {
 		/*
 		 * Check opcode.
 		 */

