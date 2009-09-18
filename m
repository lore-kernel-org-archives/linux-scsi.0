From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/24] libfc: adds missing exch release for accepted RRQ
Date: Fri, 18 Sep 2009 15:49:41 -0700
Message-ID: <20090918224941.5928.81763.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20571 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758786AbZIRWtq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:49:46 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
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
index d58111f..d157976 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1979,7 +1979,7 @@ retry:
  */
 static void fc_exch_els_rrq(struct fc_seq *sp, struct fc_frame *fp)
 {
-	struct fc_exch *ep;		/* request or subject exchange */
+	struct fc_exch *ep = NULL;	/* request or subject exchange */
 	struct fc_els_rrq *rp;
 	u32 sid;
 	u16 xid;
@@ -2029,15 +2029,16 @@ static void fc_exch_els_rrq(struct fc_seq *sp, struct fc_frame *fp)
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
 
 /**

