From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 07/10] scsi: add common queue_depth ramp up code
Date: Thu, 03 Sep 2009 15:23:04 -0700
Message-ID: <20090903222304.24946.11721.stgit@vi1.jf.intel.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5838 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412AbZICWXD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 18:23:03 -0400
In-Reply-To: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

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

 drivers/scsi/scsi_error.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7d1b862..c820ee7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -331,6 +331,40 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
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
+		 * call back into LLD to increase queue_depth by one
+		 * with ramp up reason code.
+		 */
+		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth + 1,
+					SCSI_QDEPTH_RAMP_UP);
+		sdev->last_queue_ramp_up = jiffies;
+	}
+}
+
 static void scsi_handle_queue_full(struct scsi_device *sdev)
 {
 	struct scsi_host_template *sht = sdev->host->hostt;
@@ -392,6 +426,7 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 	 */
 	switch (status_byte(scmd->result)) {
 	case GOOD:
+		scsi_handle_queue_ramp_up(scmd->device);
 	case COMMAND_TERMINATED:
 		return SUCCESS;
 	case CHECK_CONDITION:
@@ -1421,6 +1456,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 */
 		return ADD_TO_MLQUEUE;
 	case GOOD:
+		scsi_handle_queue_ramp_up(scmd->device);
 	case COMMAND_TERMINATED:
 		return SUCCESS;
 	case TASK_ABORTED:

