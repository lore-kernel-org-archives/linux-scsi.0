From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] scsi_dh_alua: add missing transitioning state support
Date: Tue, 17 Aug 2010 15:05:56 -0400
Message-ID: <1282071956-391-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab0HQTGD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2010 15:06:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

Handle transitioning in the prep_fn.
Handle transitioning in alua_rtpg's implicit alua code too.

These gaps were identified during controller failover testing of an
ALUA array.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 1a970a7..c1eedc5 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -616,6 +616,9 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 		    h->state == TPGS_STATE_STANDBY)
 			/* Useable path if active */
 			err = SCSI_DH_OK;
+		else if (h->state == TPGS_STATE_TRANSITIONING)
+			/* State transition, retry */
+			goto retry;
 		else
 			/* Path unuseable for unavailable/offline */
 			err = SCSI_DH_DEV_OFFLINED;
@@ -698,13 +701,14 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 	struct alua_dh_data *h = get_alua_data(sdev);
 	int ret = BLKPREP_OK;
 
-	if (h->state != TPGS_STATE_OPTIMIZED &&
-	    h->state != TPGS_STATE_NONOPTIMIZED) {
+	if (h->state == TPGS_STATE_TRANSITIONING)
+		ret = BLKPREP_DEFER;
+	else if (h->state != TPGS_STATE_OPTIMIZED &&
+		 h->state != TPGS_STATE_NONOPTIMIZED) {
 		ret = BLKPREP_KILL;
 		req->cmd_flags |= REQ_QUIET;
 	}
 	return ret;
-
 }
 
 static const struct scsi_dh_devlist alua_dev_list[] = {
