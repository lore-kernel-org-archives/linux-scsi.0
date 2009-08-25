From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 47/64] libfc: discovery retry should clear pending first.
Date: Tue, 25 Aug 2009 14:02:38 -0700
Message-ID: <20090825210238.1553.78914.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8463 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932100AbZHYVCh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:02:37 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Currently fc_disc_timeout() restarts discovery only if it is not pending.
When the timer is scheduled, the discovery is left pending, so the
timeout never restarts it.

Fix by not checking for pending in the timeout handler.

If discovery is stopped and restarted in the meantime, the timeout will
be canceled.

Also, when a new discovery is started, the retry count wasn't cleared.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 9b8043b..3efdbba 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -233,6 +233,7 @@ static void fc_disc_restart(struct fc_disc *disc)
 	 * freshly-discovered remote ports.  Avoid wrapping to zero.
 	 */
 	disc->disc_id = (disc->disc_id + 2) | 1;
+	disc->retry_count = 0;
 	fc_disc_gpn_ft_req(disc);
 }
 
@@ -563,8 +564,7 @@ static void fc_disc_timeout(struct work_struct *work)
 					    struct fc_disc,
 					    disc_work.work);
 	mutex_lock(&disc->disc_mutex);
-	if (disc->requested && !disc->pending)
-		fc_disc_gpn_ft_req(disc);
+	fc_disc_gpn_ft_req(disc);
 	mutex_unlock(&disc->disc_mutex);
 }
 

