From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 2/4] scsi error: have scsi-ml call change_queue_depth to handle QUEUE_FULL
Date: Tue, 19 May 2009 00:52:45 -0500
Message-ID: <12427123692457-git-send-email-michaelc@cs.wisc.edu>
References: <12427123671020-git-send-email-michaelc@cs.wisc.edu>
 <12427123683166-git-send-email-michaelc@cs.wisc.edu>
 <1242712369913-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57048 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbZESFwv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2009 01:52:51 -0400
In-Reply-To: <1242712369913-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This has scsi-ml call the change_queue_depth functions when
we get a QUEUE_FULL. It will only change the queue depth if
change_queue_depth is set because the LLD may have to
modify some internal resources, so I thought this would
be the safest route.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 0c2c73b..792644e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -331,6 +331,27 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	}
 }
 
+static void scsi_handle_queue_full(struct scsi_device *sdev)
+{
+	struct scsi_host_template *sht = sdev->host->hostt;
+	struct scsi_device *tmp_sdev;
+
+	if (!sht->change_queue_depth)
+		return;
+
+	shost_for_each_device(tmp_sdev, sdev->host) {
+		if (tmp_sdev->id != sdev->id)
+			continue;
+		/*
+		 * We do not know the number of commands that were at
+		 * the device when we got the queue full so we start
+		 * from the highest possible value and work our way down.
+		 */
+		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth - 1,
+					SCSI_QDEPTH_QFULL);
+	}
+}
+
 /**
  * scsi_eh_completed_normally - Disposition a eh cmd on return from LLD.
  * @scmd:	SCSI cmd to examine.
@@ -382,8 +403,10 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		 * who knows?  FIXME(eric)
 		 */
 		return SUCCESS;
-	case BUSY:
 	case QUEUE_FULL:
+		scsi_handle_queue_full(scmd->device);
+		/* fall through */
+	case BUSY:
 	case RESERVATION_CONFLICT:
 	default:
 		return FAILED;
@@ -1380,6 +1403,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 */
 	switch (status_byte(scmd->result)) {
 	case QUEUE_FULL:
+		scsi_handle_queue_full(scmd->device);
 		/*
 		 * the case of trying to send too many commands to a
 		 * tagged queueing device.
-- 
1.6.0.6

