From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] libfc: unsafe refcounting in fc_rport_work()
Date: Wed, 20 Apr 2016 15:24:21 +0200
Message-ID: <1461158661-97688-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbcDTNY2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2016 09:24:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When pushing items on a workqueue we cannot take reference
when the workqueue item is executed, as the structure might
already been freed at that time.
So instead we need to take a reference before adding it
to the workqueue, thereby ensuring that the workqueue item
will always be valid.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/libfc/fc_rport.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 589ff9a..8b08263f 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -263,7 +263,6 @@ static void fc_rport_work(struct work_struct *work)
 		ids = rdata->ids;
 		rdata->event = RPORT_EV_NONE;
 		rdata->major_retries = 0;
-		kref_get(&rdata->kref);
 		mutex_unlock(&rdata->rp_mutex);
 
 		if (!rport)
@@ -297,7 +296,6 @@ static void fc_rport_work(struct work_struct *work)
 			FC_RPORT_DBG(rdata, "lld callback ev %d\n", event);
 			rdata->lld_event_callback(lport, rdata, event);
 		}
-		kref_put(&rdata->kref, lport->tt.rport_destroy);
 		break;
 
 	case RPORT_EV_FAILED:
@@ -377,6 +375,7 @@ static void fc_rport_work(struct work_struct *work)
 		mutex_unlock(&rdata->rp_mutex);
 		break;
 	}
+	kref_put(&rdata->kref, lport->tt.rport_destroy);
 }
 
 /**
@@ -438,8 +437,15 @@ static void fc_rport_enter_delete(struct fc_rport_priv *rdata,
 
 	fc_rport_state_enter(rdata, RPORT_ST_DELETE);
 
-	if (rdata->event == RPORT_EV_NONE)
-		queue_work(rport_event_queue, &rdata->event_work);
+	if (rdata->event == RPORT_EV_NONE) {
+		if (!kref_get_unless_zero(&rdata->kref)) {
+			FC_RPORT_DBG(rdata, "port already deleted\n");
+			return;
+		}
+		if (!queue_work(rport_event_queue, &rdata->event_work))
+			kref_put(&rdata->kref,
+				 rdata->local_port->tt.rport_destroy);
+	}
 	rdata->event = event;
 }
 
@@ -487,8 +493,15 @@ static void fc_rport_enter_ready(struct fc_rport_priv *rdata)
 
 	FC_RPORT_DBG(rdata, "Port is Ready\n");
 
-	if (rdata->event == RPORT_EV_NONE)
-		queue_work(rport_event_queue, &rdata->event_work);
+	if (rdata->event == RPORT_EV_NONE) {
+		if (!kref_get_unless_zero(&rdata->kref)) {
+			FC_RPORT_DBG(rdata, "port already deleted\n");
+			return;
+		}
+		if (!queue_work(rport_event_queue, &rdata->event_work))
+			kref_put(&rdata->kref,
+				 rdata->local_port->tt.rport_destroy);
+	}
 	rdata->event = RPORT_EV_READY;
 }
 
-- 
1.8.5.6

