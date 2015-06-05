From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 2/3] libfc: Fix fc_exch_recv_req() error path
Date: Fri, 05 Jun 2015 14:20:46 -0700
Message-ID: <20150605212045.6054.14709.stgit@lin-nd1-054.jf.intel.com>
References: <20150605212003.6054.15351.stgit@lin-nd1-054.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:25329 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbbFEVUr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Jun 2015 17:20:47 -0400
In-Reply-To: <20150605212003.6054.15351.stgit@lin-nd1-054.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: fcoe-devel@open-fcoe.org, target-devel <target-devel@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Vasu Dev <vasu.dev@intel.com>, stable <stable@vger.kernel.org>Vasu Dev <vasu.dev@intel.com>

From: Bart Van Assche <bart.vanassche@sandisk.com>

Due to patch "libfc: Do not invoke the response handler after
fc_exch_done()" (commit ID 7030fd62) the lport_recv() call
in fc_exch_recv_req() is passed a dangling pointer. Avoid this
by moving the fc_frame_free() call from fc_invoke_resp() to its
callers. This patch fixes the following crash:

general protection fault: 0000 [#3] PREEMPT SMP
RIP: fc_lport_recv_req+0x72/0x280 [libfc]
Call Trace:
 fc_exch_recv+0x642/0xde0 [libfc]
 fcoe_percpu_receive_thread+0x46a/0x5ed [fcoe]
 kthread+0x10a/0x120
 ret_from_fork+0x42/0x70

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Vasu Dev <vasu.dev@intel.com>
Cc: stable <stable@vger.kernel.org>

-v2

Updated to revised patch posted at:
http://lists.open-fcoe.org/pipermail/fcoe-devel/2015-May/012462.html

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 1b3a094..30f9ef0 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -733,8 +733,6 @@ static bool fc_invoke_resp(struct fc_exch *ep, struct fc_seq *sp,
 	if (resp) {
 		resp(sp, fp, arg);
 		res = true;
-	} else if (!IS_ERR(fp)) {
-		fc_frame_free(fp);
 	}
 
 	spin_lock_bh(&ep->ex_lock);
@@ -1596,7 +1594,8 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	 * If new exch resp handler is valid then call that
 	 * first.
 	 */
-	fc_invoke_resp(ep, sp, fp);
+	if (!fc_invoke_resp(ep, sp, fp))
+		fc_frame_free(fp);
 
 	fc_exch_release(ep);
 	return;
@@ -1695,7 +1694,8 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	fc_exch_hold(ep);
 	if (!rc)
 		fc_exch_delete(ep);
-	fc_invoke_resp(ep, sp, fp);
+	if (!fc_invoke_resp(ep, sp, fp))
+		fc_frame_free(fp);
 	if (has_rec)
 		fc_exch_timer_set(ep, ep->r_a_tov);
 	fc_exch_release(ep);

