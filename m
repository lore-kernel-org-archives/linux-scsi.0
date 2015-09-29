From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/36] scsi_dh_alua: separate out alua_stpg()
Date: Tue, 29 Sep 2015 12:47:16 +0200
Message-ID: <1443523658-87622-15-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934681AbbI2Kr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:47:57 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

Seperate out SET TARGET PORT GROUP functionality into a separate
function alua_stpg().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 86 ++++++++++++++++++------------
 1 file changed, 52 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 63423b2..59fe3e9 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -614,6 +614,56 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 }
 
 /*
+ * alua_stpg - Issue a SET TARGET GROUP STATES command
+ *
+ * Issue a SET TARGET GROUP STATES command and evaluate the
+ * response. Returns SCSI_DH_RETRY per default to trigger
+ * a re-evaluation of the target group state.
+ */
+static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h,
+			  activate_complete fn, void *data)
+{
+	int err = SCSI_DH_OK;
+	int stpg = 0;
+
+	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
+		/* Only implicit ALUA supported */
+		return err;
+	}
+
+	switch (h->state) {
+	case TPGS_STATE_NONOPTIMIZED:
+		stpg = 1;
+		if ((h->flags & ALUA_OPTIMIZE_STPG) &&
+		    !h->pref &&
+		    (h->tpgs & TPGS_MODE_IMPLICIT))
+			stpg = 0;
+		break;
+	case TPGS_STATE_STANDBY:
+	case TPGS_STATE_UNAVAILABLE:
+		stpg = 1;
+		break;
+	case TPGS_STATE_OFFLINE:
+		err = SCSI_DH_IO;
+		break;
+	case TPGS_STATE_TRANSITIONING:
+		err = SCSI_DH_RETRY;
+		break;
+	default:
+		break;
+	}
+
+	if (stpg) {
+		h->callback_fn = fn;
+		h->callback_data = data;
+		err = submit_stpg(h);
+		if (err != SCSI_DH_OK)
+			h->callback_fn = h->callback_data = NULL;
+	}
+	return err;
+}
+
+/*
  * alua_initialize - Initialize ALUA state
  * @sdev: the device to be initialized
  *
@@ -690,7 +740,6 @@ static int alua_activate(struct scsi_device *sdev,
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	int err = SCSI_DH_OK;
-	int stpg = 0;
 
 	err = alua_rtpg(sdev, h, 1);
 	if (err != SCSI_DH_OK)
@@ -699,41 +748,10 @@ static int alua_activate(struct scsi_device *sdev,
 	if (optimize_stpg)
 		h->flags |= ALUA_OPTIMIZE_STPG;
 
-	if (h->tpgs & TPGS_MODE_EXPLICIT) {
-		switch (h->state) {
-		case TPGS_STATE_NONOPTIMIZED:
-			stpg = 1;
-			if ((h->flags & ALUA_OPTIMIZE_STPG) &&
-			    (!h->pref) &&
-			    (h->tpgs & TPGS_MODE_IMPLICIT))
-				stpg = 0;
-			break;
-		case TPGS_STATE_STANDBY:
-		case TPGS_STATE_UNAVAILABLE:
-			stpg = 1;
-			break;
-		case TPGS_STATE_OFFLINE:
-			err = SCSI_DH_IO;
-			break;
-		case TPGS_STATE_TRANSITIONING:
-			err = SCSI_DH_RETRY;
-			break;
-		default:
-			break;
-		}
-	}
-
-	if (stpg) {
-		h->callback_fn = fn;
-		h->callback_data = data;
-		err = submit_stpg(h);
-		if (err == SCSI_DH_OK)
-			return 0;
-		h->callback_fn = h->callback_data = NULL;
-	}
+	err = alua_stpg(sdev, h, fn, data);
 
 out:
-	if (fn)
+	if (err != SCSI_DH_OK && fn)
 		fn(data, err);
 	return 0;
 }
-- 
1.8.5.6

