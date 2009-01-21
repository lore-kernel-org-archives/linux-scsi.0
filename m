From: Robert Love <robert.w.love@intel.com>
Subject: [Open-FCoE PATCH 4/6] libfc: fixed a soft lockup issue in
	fc_exch_recv_abts
Date: Wed, 21 Jan 2009 12:45:00 -0800
Message-ID: <20090121204500.2468.92916.stgit@fritz>
References: <20090121204444.2468.66245.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2728 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbZAUUpB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2009 15:45:01 -0500
In-Reply-To: <20090121204444.2468.66245.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

From: Vasu Dev <vasu.dev@intel.com>

The fc_seq_start_next grabs ep->ex_lock but this lock was already held here,
so instead called fc_seq_start_next_locked to avoid soft lockup.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index e874e77..dd269e5 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1096,7 +1096,7 @@ static void fc_exch_recv_abts(struct fc_exch *ep, struct fc_frame *rx_fp)
 		ap->ba_high_seq_cnt = fh->fh_seq_cnt;
 		ap->ba_low_seq_cnt = htons(sp->cnt);
 	}
-	sp = fc_seq_start_next(sp);
+	sp = fc_seq_start_next_locked(sp);
 	spin_unlock_bh(&ep->ex_lock);
 	fc_seq_send_last(sp, fp, FC_RCTL_BA_ACC, FC_TYPE_BLS);
 	fc_frame_free(rx_fp);

