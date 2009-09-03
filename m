From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 02/10] scsi error: have scsi-ml call change_queue_depth to
	handle QUEUE_FULL
Date: Thu, 03 Sep 2009 15:22:36 -0700
Message-ID: <20090903222236.24946.36153.stgit@vi1.jf.intel.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:41922 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294AbZICWWe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 18:22:34 -0400
In-Reply-To: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Mike Christie <michaelc@cs.wisc.edu>

This has scsi-ml call the change_queue_depth functions when
we get a QUEUE_FULL. It will only change the queue depth if
change_queue_depth is set because the LLD may have to
modify some internal resources, so I thought this would
be the safest route.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/scsi_error.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 877204d..7d1b862 100644
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
@@ -387,8 +408,10 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		 * let issuer deal with this, it could be just fine
 		 */
 		return SUCCESS;
-	case BUSY:
 	case QUEUE_FULL:
+		scsi_handle_queue_full(scmd->device);
+		/* fall through */
+	case BUSY:
 	default:
 		return FAILED;
 	}
@@ -1384,6 +1407,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 */
 	switch (status_byte(scmd->result)) {
 	case QUEUE_FULL:
+		scsi_handle_queue_full(scmd->device);
 		/*
 		 * the case of trying to send too many commands to a
 		 * tagged queueing device.

