From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 4/8] libfc: Check if exchange is completed when receiving a
	sequence
Date: Wed, 06 May 2009 10:52:29 -0700
Message-ID: <20090506175228.26695.46133.stgit@fritz>
References: <20090506175206.26695.19457.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48604 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811AbZEFRw3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2009 13:52:29 -0400
In-Reply-To: <20090506175206.26695.19457.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Steve Ma <steve.ma@intel.com>

From: Steve Ma <steve.ma@intel.com>

When a sequence is received in response to an exchange we issued previously,
we should check to see if the exchange has completed. If yes, the sequence
should be discarded. Since the exchange might be still in the completion
process, it should be untouched.

Signed-off-by: Steve Ma <steve.ma@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 992af05..7af9bce 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1159,6 +1159,10 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		atomic_inc(&mp->stats.xid_not_found);
 		goto out;
 	}
+	if (ep->esb_stat & ESB_ST_COMPLETE) {
+		atomic_inc(&mp->stats.xid_not_found);
+		goto out;
+	}
 	if (ep->rxid == FC_XID_UNKNOWN)
 		ep->rxid = ntohs(fh->fh_rx_id);
 	if (ep->sid != 0 && ep->sid != ntoh24(fh->fh_d_id)) {

