From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/23] scsi_dh_alua: separate out alua_stpg()
Date: Mon,  8 Feb 2016 15:34:25 +0100
Message-ID: <1454942086-128704-3-git-send-email-hare@suse.de>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbcBHOew (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 09:34:52 -0500
In-Reply-To: <1454942086-128704-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

Separate out SET TARGET PORT GROUP functionality into a separate
function alua_stpg().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 95 +++++++++++++++++++-----------
 1 file changed, 61 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index df71e85..7c66e4a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -579,6 +579,65 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h, int wait_
 }
 
 /*
+ * alua_stpg - Issue a SET TARGET GROUP STATES command
+ *
+ * Issue a SET TARGET GROUP STATES command and evaluate the
+ * response. Returns SCSI_DH_RETRY if the target port group
+ * state is found to be in 'transitioning'.
+ * If SCSI_DH_OK is returned the passed-in 'fn' function
+ * this function will take care of executing 'fn'.
+ * Otherwise 'fn' should be executed by the caller with the
+ * returned error code.
+ */
+static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_data *h,
+			  activate_complete fn, void *data)
+{
+	int err = SCSI_DH_OK;
+	int stpg = 0;
+
+	if (!(h->tpgs & TPGS_MODE_EXPLICIT))
+		/* Only implicit ALUA supported */
+		goto out;
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
+		else
+			fn = NULL;
+	}
+out:
+	if (fn)
+		fn(data, err);
+
+	return err;
+}
+
+/*
  * alua_initialize - Initialize ALUA state
  * @sdev: the device to be initialized
  *
@@ -655,7 +714,6 @@ static int alua_activate(struct scsi_device *sdev,
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	int err = SCSI_DH_OK;
-	int stpg = 0;
 
 	err = alua_rtpg(sdev, h, 1);
 	if (err != SCSI_DH_OK)
@@ -664,41 +722,10 @@ static int alua_activate(struct scsi_device *sdev,
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

