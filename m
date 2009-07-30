From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/22] libfc: fix: cancel rport retry timer
Date: Wed, 29 Jul 2009 17:04:54 -0700
Message-ID: <20090730000454.24658.922.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62139 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354AbZG3AEy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:04:54 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The timer for rport retries wasn't getting canceled, and
would occasionally go off after the module was unloaded.

Add logic to cancel the timer in fc_rport_work().

Since we cancel the timer before deleting the rdata,
it is no longer necessary to do a get_device() for the pending timer.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index a86df0b..90cc90d 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -276,6 +276,7 @@ static void fc_rport_work(struct work_struct *work)
 		mutex_unlock(&rdata->rp_mutex);
 		if (rport_ops->event_callback)
 			rport_ops->event_callback(lport, rport, event);
+		cancel_delayed_work_sync(&rdata->retry_work);
 		if (trans_state == FC_PORTSTATE_ROGUE)
 			put_device(&rport->dev);
 		else {
@@ -433,7 +434,6 @@ static void fc_rport_timeout(struct work_struct *work)
 	}
 
 	mutex_unlock(&rdata->rp_mutex);
-	put_device(&rport->dev);
 }
 
 /**
@@ -494,7 +494,6 @@ static void fc_rport_error_retry(struct fc_rport *rport, struct fc_frame *fp)
 		/* no additional delay on exchange timeouts */
 		if (PTR_ERR(fp) == -FC_EX_TIMEOUT)
 			delay = 0;
-		get_device(&rport->dev);
 		schedule_delayed_work(&rdata->retry_work, delay);
 		return;
 	}

