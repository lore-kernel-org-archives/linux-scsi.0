From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v2 08/12] libfc:Fix for exchange/seq loopup failure when FCoE
 stack is used as target and connected to windows initaitor
Date: Mon, 20 Jun 2011 16:59:30 -0700
Message-ID: <20110620235930.1777.70038.stgit@localhost6.localdomain6>
References: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11976 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434Ab1FTX7b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 19:59:31 -0400
In-Reply-To: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kiran Patil <kiran.patil@intel.com>

From: Kiran Patil <kiran.patil@intel.com>

Problem: Linux based SW target (TCM) connected to windows initiator was unable to satisfy
write request of size > 2K.

Fix: Existing linux implememtation of FCoE stack is expecting sequence number to match w.r.t
incoming framme. When DDP is used on target in response to write request from initiator, SW
stack is notified only when last data frame arrives and only the pakcket header of last data
frame is posted to NetRx queue of storage. When that last packet was processed in libfc:Exchange
layer, implementation was expecting sequence number to match, but in this case sequence number
which is embedded in FC Header is assigned by windows initaitor, hence due to sequence number mismatch
post-processing which shall result into sending RSP is not done. Enhanced the code to
utilize the sequence number of incoming last frame and process the packet so that, it
will eventually complete the write request by sending write response (RSP) GOOD.

Notes/Dependencies: This patch is validated using windows and linux initiator to make
sure, it doesn't break anything.

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 3b8a645..f5a0665 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -965,8 +965,30 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 		sp = &ep->seq;
 		if (sp->id != fh->fh_seq_id) {
 			atomic_inc(&mp->stats.seq_not_found);
-			reject = FC_RJT_SEQ_ID;	/* sequence/exch should exist */
-			goto rel;
+			if (f_ctl & FC_FC_END_SEQ) {
+				/*
+				 * Update sequence_id based on incoming last
+				 * frame of sequence exchange. This is needed
+				 * for FCoE target where DDP has been used
+				 * on target where, stack is indicated only
+				 * about last frame's (payload _header) header.
+				 * Whereas "seq_id" which is part of
+				 * frame_header is allocated by initiator
+				 * which is totally different from "seq_id"
+				 * allocated when XFER_RDY was sent by target.
+				 * To avoid false -ve which results into not
+				 * sending RSP, hence write request on other
+				 * end never finishes.
+				 */
+				spin_lock_bh(&ep->ex_lock);
+				sp->ssb_stat |= SSB_ST_RESP;
+				sp->id = fh->fh_seq_id;
+				spin_unlock_bh(&ep->ex_lock);
+			} else {
+				/* sequence/exch should exist */
+				reject = FC_RJT_SEQ_ID;
+				goto rel;
+			}
 		}
 	}
 	WARN_ON(ep != fc_seq_exch(sp));

