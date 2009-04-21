From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/11] libfc: During fabric logoff,
	flush the rport Q after logging off dns port
Date: Tue, 21 Apr 2009 16:27:09 -0700
Message-ID: <20090421232709.8165.97257.stgit@fritz>
References: <20090421232647.8165.46673.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49867 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbZDUX1K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 19:27:10 -0400
In-Reply-To: <20090421232647.8165.46673.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Abhijeet Joglekar <abjoglek@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Abhijeet Joglekar <abjoglek@cisco.com>

We want to generate the rport queue event (from the logoff)
before flushing the queue otherwise the event may still be
in the queue when we logoff.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 52c4f2d..4cd9533 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -618,6 +618,11 @@ int fc_fabric_logoff(struct fc_lport *lport)
 {
 	lport->tt.disc_stop_final(lport);
 	mutex_lock(&lport->lp_mutex);
+	if (lport->dns_rp)
+		lport->tt.rport_logoff(lport->dns_rp);
+	mutex_unlock(&lport->lp_mutex);
+	lport->tt.rport_flush_queue();
+	mutex_lock(&lport->lp_mutex);
 	fc_lport_enter_logo(lport);
 	mutex_unlock(&lport->lp_mutex);
 	cancel_delayed_work_sync(&lport->retry_work);
@@ -1408,10 +1413,6 @@ static void fc_lport_enter_logo(struct fc_lport *lport)
 
 	fc_lport_state_enter(lport, LPORT_ST_LOGO);
 
-	/* DNS session should be closed so we can release it here */
-	if (lport->dns_rp)
-		lport->tt.rport_logoff(lport->dns_rp);
-
 	fp = fc_frame_alloc(lport, sizeof(*logo));
 	if (!fp) {
 		fc_lport_error(lport, fp);

