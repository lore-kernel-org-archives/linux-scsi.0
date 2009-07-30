From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/22] libfc: fc_rport_logoff should not drop the lock
Date: Wed, 29 Jul 2009 17:04:49 -0700
Message-ID: <20090730000449.24658.83683.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47304 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439AbZG3AFB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:05:01 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

fc_rport_logoff drops the rport lock in order to cancel work
that may be pending.  This is undesirable as the state can
completely change, and the caller may not expect that the
lock could've been dropped.

If there is work pending, it will acquire the rdata mutex and
so we're protected and can change the event from READY to DELETE.
Queue the work only if there is no event already pending.

There were a couple other cases where the state was set to
DELETE and work queued, even though the state may have already
been DELETE.  Fix these using a common function fc_rport_enter_delete().

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |   60 ++++++++++++++++++++++++++---------------
 1 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index bf7364f..a86df0b 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -230,6 +230,7 @@ static void fc_rport_work(struct work_struct *work)
 		ids.port_name = rport->port_name;
 		ids.node_name = rport->node_name;
 
+		rdata->event = RPORT_EV_NONE;
 		mutex_unlock(&rdata->rp_mutex);
 
 		new_rport = fc_remote_port_add(lport->host, 0, &ids);
@@ -311,6 +312,37 @@ int fc_rport_login(struct fc_rport *rport)
 }
 
 /**
+ * fc_rport_enter_delete() - schedule a remote port to be deleted.
+ * @rport: Fibre Channel remote port
+ * @event: event to report as the reason for deletion
+ *
+ * Locking Note: Called with the rport lock held.
+ *
+ * Allow state change into DELETE only once.
+ *
+ * Call queue_work only if there's no event already pending.
+ * Set the new event so that the old pending event will not occur.
+ * Since we have the mutex, even if fc_rport_work() is already started,
+ * it'll see the new event.
+ */
+static void fc_rport_enter_delete(struct fc_rport *rport,
+				  enum fc_rport_event event)
+{
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;
+
+	if (rdata->rp_state == RPORT_ST_DELETE)
+		return;
+
+	FC_RPORT_DBG(rport, "Delete port\n");
+
+	fc_rport_state_enter(rport, RPORT_ST_DELETE);
+
+	if (rdata->event == RPORT_EV_NONE)
+		queue_work(rport_event_queue, &rdata->event_work);
+	rdata->event = event;
+}
+
+/**
  * fc_rport_logoff() - Logoff and remove an rport
  * @rport: Fibre Channel remote port to be removed
  *
@@ -338,17 +370,7 @@ int fc_rport_logoff(struct fc_rport *rport)
 	 * Change the state to Delete so that we discard
 	 * the response.
 	 */
-	fc_rport_state_enter(rport, RPORT_ST_DELETE);
-
-	mutex_unlock(&rdata->rp_mutex);
-
-	cancel_delayed_work_sync(&rdata->retry_work);
-
-	mutex_lock(&rdata->rp_mutex);
-
-	rdata->event = RPORT_EV_STOP;
-	queue_work(rport_event_queue, &rdata->event_work);
-
+	fc_rport_enter_delete(rport, RPORT_EV_STOP);
 	mutex_unlock(&rdata->rp_mutex);
 
 out:
@@ -370,8 +392,9 @@ static void fc_rport_enter_ready(struct fc_rport *rport)
 
 	FC_RPORT_DBG(rport, "Port is Ready\n");
 
+	if (rdata->event == RPORT_EV_NONE)
+		queue_work(rport_event_queue, &rdata->event_work);
 	rdata->event = RPORT_EV_CREATED;
-	queue_work(rport_event_queue, &rdata->event_work);
 }
 
 /**
@@ -432,10 +455,7 @@ static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
 	case RPORT_ST_PLOGI:
 	case RPORT_ST_PRLI:
 	case RPORT_ST_LOGO:
-		rdata->event = RPORT_EV_FAILED;
-		fc_rport_state_enter(rport, RPORT_ST_DELETE);
-		queue_work(rport_event_queue,
-			   &rdata->event_work);
+		fc_rport_enter_delete(rport, RPORT_EV_FAILED);
 		break;
 	case RPORT_ST_RTV:
 		fc_rport_enter_ready(rport);
@@ -651,9 +671,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	} else {
 		FC_RPORT_DBG(rport, "Bad ELS response for PRLI command\n");
-		rdata->event = RPORT_EV_FAILED;
-		fc_rport_state_enter(rport, RPORT_ST_DELETE);
-		queue_work(rport_event_queue, &rdata->event_work);
+		fc_rport_enter_delete(rport, RPORT_EV_FAILED);
 	}
 
 out:
@@ -702,9 +720,7 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 		fc_rport_enter_rtv(rport);
 	} else {
 		FC_RPORT_DBG(rport, "Bad ELS response for LOGO command\n");
-		rdata->event = RPORT_EV_LOGO;
-		fc_rport_state_enter(rport, RPORT_ST_DELETE);
-		queue_work(rport_event_queue, &rdata->event_work);
+		fc_rport_enter_delete(rport, RPORT_EV_LOGO);
 	}
 
 out:

