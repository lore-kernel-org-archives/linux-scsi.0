From: Vasu Dev <vasu.dev@intel.com>
Subject: [RFC PATCH 7/9] scsi: add common queue_depth ramp up code
Date: Wed, 26 Aug 2009 11:03:52 -0700
Message-ID: <20090826180352.23396.92986.stgit@vi1.jf.intel.com>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16922 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZHZSDu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 14:03:50 -0400
In-Reply-To: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

Adds scsi_handle_queue_ramp_up to ramp up queue_depth on
successful completion of IO. The scsi_handle_queue_ramp_up
will do ramp up on all luns of a target, just same as
ramp down done on all luns on a target.

However ramp up is skipped if lapsed time since either
last queue ramp up or down is less than LLD specified
queue_ramp_up_period.

The ramp up is also skipped in case the change_queue_depth
is not supported by LLD.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/scsi_error.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7d1b862..08490c7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -331,6 +331,42 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	}
 }
 
+static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
+{
+	struct scsi_host_template *sht = sdev->host->hostt;
+	struct scsi_device *tmp_sdev;
+
+	if (!sht->change_queue_depth)
+		return;
+
+	if (time_before(jiffies,
+	    sdev->last_queue_ramp_up + sdev->queue_ramp_up_period))
+		return;
+
+	if (time_before(jiffies,
+	    sdev->last_queue_full_time + sdev->queue_ramp_up_period))
+		return;
+
+	/*
+	 * Walk all devices of a target and do
+	 * ramp up on them.
+	 */
+	shost_for_each_device(tmp_sdev, sdev->host) {
+		if ((tmp_sdev->channel != sdev->channel) ||
+		    (tmp_sdev->id != sdev->id))
+			continue;
+		/*
+		 * We do not know max queue_depth supported by the
+		 * device, so pass the existing queue_depth and let
+		 * device adjust the queue_depth on ramp up change
+		 * event.
+		 */
+		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth,
+					SCSI_QDEPTH_RAMP_UP);
+		sdev->last_queue_ramp_up = jiffies;
+	}
+}
+
 static void scsi_handle_queue_full(struct scsi_device *sdev)
 {
 	struct scsi_host_template *sht = sdev->host->hostt;
@@ -392,6 +428,7 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 	 */
 	switch (status_byte(scmd->result)) {
 	case GOOD:
+		scsi_handle_queue_ramp_up(scmd->device);
 	case COMMAND_TERMINATED:
 		return SUCCESS;
 	case CHECK_CONDITION:
@@ -1421,6 +1458,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 */
 		return ADD_TO_MLQUEUE;
 	case GOOD:
+		scsi_handle_queue_ramp_up(scmd->device);
 	case COMMAND_TERMINATED:
 		return SUCCESS;
 	case TASK_ABORTED:

