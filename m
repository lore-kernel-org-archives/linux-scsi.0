From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/20] libfc: adds missing exch release for accepted RRQ
Date: Wed, 21 Oct 2009 16:27:33 -0700
Message-ID: <20091021232733.12986.94221.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52447 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbZJUX2a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:28:30 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Adds missing exch release when RRQ is accepted by calling
fc_seq_ls_acc. Adds common exch release for fc_exch_els_rrq
by use of out label.

Reported-by: Alex Lyakas <alexl@mellanox.co.il>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index bdae9a9..8ce4182 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1718,7 +1718,7 @@ retry:
  */
 static void fc_exch_els_rrq(struct fc_seq *sp, struct fc_frame *fp)
 {
-	struct fc_exch *ep;		/* request or subject exchange */
+	struct fc_exch *ep = NULL;	/* request or subject exchange */
 	struct fc_els_rrq *rp;
 	u32 sid;
 	u16 xid;
@@ -1768,15 +1768,16 @@ static void fc_exch_els_rrq(struct fc_seq *sp, struct fc_frame *fp)
 	 * Send LS_ACC.
 	 */
 	fc_seq_ls_acc(sp);
-	fc_frame_free(fp);
-	return;
+	goto out;
 
 unlock_reject:
 	spin_unlock_bh(&ep->ex_lock);
-	fc_exch_release(ep);	/* drop hold from fc_exch_find */
 reject:
 	fc_seq_ls_rjt(sp, ELS_RJT_LOGIC, explan);
+out:
 	fc_frame_free(fp);
+	if (ep)
+		fc_exch_release(ep);	/* drop hold from fc_exch_find */
 }
 
 struct fc_exch_mgr_anchor *fc_exch_mgr_add(struct fc_lport *lport,

