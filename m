From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/16] libfc: send point-to-poin FLOGI LS_ACC to assigned D_DID
Date: Fri, 12 Mar 2010 16:08:12 -0800
Message-ID: <20100313000812.22251.10610.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934757Ab0CMAIO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:08:14 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The method we've been using for point-to-point mode requires
that the LS_ACC for the FLOGI uses the D_ID and S_ID assigned
to the remote port and local port, not those in the exchange.

This is not the correct method, but for now, it's what works
with the old target, as well as with new targets based on libfc.

This patch changes the addresses used accordingly.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index af7343a..02e6302 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -834,7 +834,7 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 		 */
 		f_ctl = FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ;
 		ep = fc_seq_exch(sp);
-		fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, ep->did, ep->sid,
+		fc_fill_fc_hdr(fp, FC_RCTL_ELS_REP, remote_fid, local_fid,
 			       FC_TYPE_ELS, f_ctl, 0);
 		lport->tt.seq_send(lport, sp, fp);
 

