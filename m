From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 05/48] hpsa: correct change_queue_depth
Date: Fri, 23 Jan 2015 16:41:30 -0600
Message-ID: <20150123224130.14919.50867.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:34192 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbbAWWmY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:42:24 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

We change drive queue depths to match drive reported queue depths.
The name of the SML function was changed from scsi_adjust_queue_depth
changed to scsi_change_queue_depth.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 371d0a8..7dfe829 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -217,6 +217,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static void hpsa_scan_start(struct Scsi_Host *);
 static int hpsa_scan_finished(struct Scsi_Host *sh,
 	unsigned long elapsed_time);
+static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth);
 
 static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
 static int hpsa_eh_abort_handler(struct scsi_cmnd *scsicmd);
@@ -672,7 +673,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.queuecommand		= hpsa_scsi_queue_command,
 	.scan_start		= hpsa_scan_start,
 	.scan_finished		= hpsa_scan_finished,
-	.change_queue_depth	= scsi_change_queue_depth,
+	.change_queue_depth	= hpsa_change_queue_depth,
 	.this_id		= -1,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_abort_handler	= hpsa_eh_abort_handler,
@@ -4007,6 +4008,19 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 	spin_unlock_irqrestore(&h->scan_lock, flags);
 }
 
+static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+	struct ctlr_info *h = sdev_to_hba(sdev);
+
+	if (qdepth < 1)
+		qdepth = 1;
+	else
+		if (qdepth > h->nr_cmds)
+			qdepth = h->nr_cmds;
+	scsi_change_queue_depth(sdev, qdepth);
+	return sdev->queue_depth;
+}
+
 static int hpsa_scan_finished(struct Scsi_Host *sh,
 	unsigned long elapsed_time)
 {

