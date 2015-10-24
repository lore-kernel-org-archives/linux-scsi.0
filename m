From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 05/21] hpsa: fix hpsa_adjust_hpsa_scsi_table
Date: Sat, 24 Oct 2015 14:52:56 -0500
Message-ID: <20151024195256.17127.93962.stgit@brunhilda>
References: <20151024193306.17127.7819.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:55222 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752336AbbJXT4i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Oct 2015 15:56:38 -0400
In-Reply-To: <20151024193306.17127.7819.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Fix a NULL pointer issue in the driver when devices are removed
during a reset.

Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/block/cciss.h |    1 +
 drivers/scsi/hpsa.c   |   16 ++++++++++++++++
 drivers/scsi/hpsa.h   |    1 +
 3 files changed, 18 insertions(+)

diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 7fda30e..036fb0f 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -155,6 +155,7 @@ struct ctlr_info
 	size_t reply_pool_size;
 	unsigned char reply_pool_wraparound;
 	u32 *blockFetchTable;
+	atomic_t reset_in_progress;
 };
 
 /*  Defining the diffent access_methods
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3520d75..714bb76 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1656,6 +1656,11 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	int nadded, nremoved;
 	struct Scsi_Host *sh = NULL;
 
+	if (atomic_read(&h->reset_in_progress)) {
+		h->drv_req_rescan = 1;
+		return;
+	}
+
 	added = kzalloc(sizeof(*added) * HPSA_MAX_DEVICES, GFP_KERNEL);
 	removed = kzalloc(sizeof(*removed) * HPSA_MAX_DEVICES, GFP_KERNEL);
 
@@ -1764,8 +1769,14 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 		goto free_and_out;
 
 	sh = h->scsi_host;
+	if (sh == NULL) {
+		dev_warn(&h->pdev->dev, "%s: scsi_host is null\n", __func__);
+		return;
+	}
 	/* Notify scsi mid layer of any removed devices */
 	for (i = 0; i < nremoved; i++) {
+		if (!removed[i])
+			continue;
 		if (removed[i]->expose_state & HPSA_SCSI_ADD) {
 			struct scsi_device *sdev =
 				scsi_device_lookup(sh, removed[i]->bus,
@@ -1790,6 +1801,8 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 
 	/* Notify scsi mid layer of any added devices */
 	for (i = 0; i < nadded; i++) {
+		if (!added[i])
+			continue;
 		if (!(added[i]->expose_state & HPSA_SCSI_ADD))
 			continue;
 		if (scsi_add_device(sh, added[i]->bus,
@@ -5227,12 +5240,15 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 
 	hpsa_show_dev_msg(__stringify(KERN_WARNING), h, dev, "resetting");
 
+	atomic_set(&h->reset_in_progress, 1);
+
 	/* send a reset to the SCSI LUN which the command was sent to */
 	rc = hpsa_do_reset(h, dev, dev->scsi3addr, HPSA_RESET_TYPE_LUN,
 			   DEFAULT_REPLY_QUEUE);
 	snprintf(msg, sizeof(msg), "reset %s",
 		 rc == 0 ? "completed successfully" : "failed");
 	hpsa_show_dev_msg(__stringify(KERN_WARNING), h, dev, msg);
+	atomic_set(&h->reset_in_progress, 0);
 	return rc == 0 ? SUCCESS : FAILED;
 }
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 642c8ce..c7c1697 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -271,6 +271,7 @@ struct ctlr_info {
 	wait_queue_head_t abort_cmd_wait_queue;
 	wait_queue_head_t event_sync_wait_queue;
 	struct mutex reset_mutex;
+	atomic_t reset_in_progress;
 };
 
 struct offline_device_entry {

