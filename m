From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 10/27] hpsa: fix hpsa_adjust_hpsa_scsi_table
Date: Wed, 04 Nov 2015 15:50:56 -0600
Message-ID: <20151104215056.15472.70511.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53421 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030228AbbKDVys (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:54:48 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Fix a NULL pointer issue in the driver when devices are removed
during a reset.

Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   16 ++++++++++++++++
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ae9968b..382cb5d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1663,6 +1663,15 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 	int nadded, nremoved;
 	struct Scsi_Host *sh = NULL;
 
+	/*
+	 * A reset can cause a device status to change
+	 * re-schedule the scan to see what happened.
+	 */
+	if (h->reset_in_progress) {
+		h->drv_req_rescan = 1;
+		return;
+	}
+
 	added = kzalloc(sizeof(*added) * HPSA_MAX_DEVICES, GFP_KERNEL);
 	removed = kzalloc(sizeof(*removed) * HPSA_MAX_DEVICES, GFP_KERNEL);
 
@@ -1771,6 +1780,10 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 		goto free_and_out;
 
 	sh = h->scsi_host;
+	if (sh == NULL) {
+		dev_warn(&h->pdev->dev, "%s: scsi_host is null\n", __func__);
+		goto free_and_out;
+	}
 	/* Notify scsi mid layer of any removed devices */
 	for (i = 0; i < nremoved; i++) {
 		if (removed[i] == NULL)
@@ -5234,12 +5247,15 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 
 	hpsa_show_dev_msg(KERN_WARNING, h, dev, "resetting");
 
+	h->reset_in_progress = 1;
+
 	/* send a reset to the SCSI LUN which the command was sent to */
 	rc = hpsa_do_reset(h, dev, dev->scsi3addr, HPSA_RESET_TYPE_LUN,
 			   DEFAULT_REPLY_QUEUE);
 	snprintf(msg, sizeof(msg), "reset %s",
 		 rc == 0 ? "completed successfully" : "failed");
 	hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
+	h->reset_in_progress = 0;
 	return rc == 0 ? SUCCESS : FAILED;
 }
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index b173c0e..dc113c1a 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -271,6 +271,7 @@ struct ctlr_info {
 	wait_queue_head_t abort_cmd_wait_queue;
 	wait_queue_head_t event_sync_wait_queue;
 	struct mutex reset_mutex;
+	u8 reset_in_progress;
 };
 
 struct offline_device_entry {

