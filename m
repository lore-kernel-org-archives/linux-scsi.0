From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/11] libfc: Hold disc mutex while processing gpn ft resp
Date: Tue, 21 Apr 2009 16:26:52 -0700
Message-ID: <20090421232652.8165.2757.stgit@fritz>
References: <20090421232647.8165.46673.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62990 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZDUX0x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 19:26:53 -0400
In-Reply-To: <20090421232647.8165.46673.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Abhijeet Joglekar <abjoglek@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Abhijeet Joglekar <abjoglek@cisco.com>

gpn_ft_resp processing currently does not hold the discovery lock.
disc_done() thus gets called from gpn_ft_resp or from gpn_ft_parse
without the lock held. This then sets disc->pending to zero or calls
gpn_ft_req() without disc_lock held.

- Hold disc mutex during gpn_ft resp processing
- In disc_done, release the disc mutex while calling lport callback

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index e57556e..4480630 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -461,21 +461,29 @@ static void fc_disc_del_target(struct fc_disc *disc, struct fc_rport *rport)
 /**
  * fc_disc_done() - Discovery has been completed
  * @disc: FC discovery context
+ * Locking Note: This function expects that the disc mutex is locked before
+ * it is called. The discovery callback is then made with the lock released,
+ * and the lock is re-taken before returning from this function
  */
 static void fc_disc_done(struct fc_disc *disc)
 {
 	struct fc_lport *lport = disc->lport;
+	enum fc_disc_event event;
 
 	FC_DEBUG_DISC("Discovery complete for port (%6x)\n",
 		      fc_host_port_id(lport->host));
 
-	disc->disc_callback(lport, disc->event);
+	event = disc->event;
 	disc->event = DISC_EV_NONE;
 
 	if (disc->requested)
 		fc_disc_gpn_ft_req(disc);
 	else
 		disc->pending = 0;
+
+	mutex_unlock(&disc->disc_mutex);
+	disc->disc_callback(lport, event);
+	mutex_lock(&disc->disc_mutex);
 }
 
 /**
@@ -681,8 +689,8 @@ static void fc_disc_timeout(struct work_struct *work)
  * @fp: response frame
  * @lp_arg: Fibre Channel host port instance
  *
- * Locking Note: This function expects that the disc_mutex is locked
- *		 before it is called.
+ * Locking Note: This function is called without disc mutex held, and
+ *		 should do all its processing with the mutex held
  */
 static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 				void *disc_arg)
@@ -695,11 +703,13 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	unsigned int len;
 	int error;
 
+	mutex_lock(&disc->disc_mutex);
 	FC_DEBUG_DISC("Received a GPN_FT response on port (%6x)\n",
 		      fc_host_port_id(disc->lport->host));
 
 	if (IS_ERR(fp)) {
 		fc_disc_error(disc, fp);
+		mutex_unlock(&disc->disc_mutex);
 		return;
 	}
 
@@ -744,6 +754,8 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 			disc->seq_count++;
 	}
 	fc_frame_free(fp);
+
+	mutex_unlock(&disc->disc_mutex);
 }
 
 /**

