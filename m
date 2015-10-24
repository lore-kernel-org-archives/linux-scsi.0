From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 14/21] hpsa: move scsi_add_device and scsi_remove_device
 calls to new function
Date: Sat, 24 Oct 2015 14:53:51 -0500
Message-ID: <20151024195351.17127.32431.stgit@brunhilda>
References: <20151024193306.17127.7819.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:51456 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752418AbbJXT5e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Oct 2015 15:57:34 -0400
In-Reply-To: <20151024193306.17127.7819.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@pmcs.com>

preparation for adding the sas transport class

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   62 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2c26f1c..ce8b169 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1646,6 +1646,39 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
 	}
 }
 
+static int hpsa_add_device(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
+{
+	int rc = 0;
+
+	rc = scsi_add_device(h->scsi_host, device->bus,
+					device->target, device->lun);
+	return rc;
+}
+
+static void hpsa_remove_device(struct ctlr_info *h,
+			struct hpsa_scsi_dev_t *device)
+{
+	struct scsi_device *sdev = NULL;
+
+	sdev = scsi_device_lookup(h->scsi_host, device->bus,
+						device->target, device->lun);
+
+	if (sdev) {
+		scsi_remove_device(sdev);
+		scsi_device_put(sdev);
+	} else {
+		/*
+		 * We don't expect to get here.  Future commands
+		 * to this device will get a selection timeout as
+		 * if the device were gone.
+		 */
+		dev_warn(&h->pdev->dev,
+			"didn't find scsi %d:%d:%d:%d for removal.",
+			h->scsi_host->host_no, device->bus,
+			device->target, device->lun);
+	}
+}
+
 static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	struct hpsa_scsi_dev_t *sd[], int nsds)
 {
@@ -1658,7 +1691,6 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	unsigned long flags;
 	struct hpsa_scsi_dev_t **added, **removed;
 	int nadded, nremoved;
-	struct Scsi_Host *sh = NULL;
 
 	if (atomic_read(&h->reset_in_progress)) {
 		h->drv_req_rescan = 1;
@@ -1772,33 +1804,12 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	if (hostno == -1 || !changes)
 		goto free_and_out;
 
-	sh = h->scsi_host;
-	if (sh == NULL) {
-		dev_warn(&h->pdev->dev, "%s: scsi_host is null\n", __func__);
-		return;
-	}
 	/* Notify scsi mid layer of any removed devices */
 	for (i = 0; i < nremoved; i++) {
 		if (!removed[i])
 			continue;
-		if (removed[i]->expose_device) {
-			struct scsi_device *sdev =
-				scsi_device_lookup(sh, removed[i]->bus,
-					removed[i]->target, removed[i]->lun);
-			if (sdev != NULL) {
-				scsi_remove_device(sdev);
-				scsi_device_put(sdev);
-			} else {
-				/*
-				 * We don't expect to get here.
-				 * future cmds to this device will get selection
-				 * timeout as if the device was gone.
-				 */
-				hpsa_show_dev_msg(__stringify(KERN_WARNING),
-					h, removed[i],
-					"didn't find device for removal.");
-			}
-		}
+		if (removed[i]->expose_device)
+			hpsa_remove_device(h, removed[i]);
 		kfree(removed[i]);
 		removed[i] = NULL;
 	}
@@ -1809,8 +1820,7 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 			continue;
 		if (!(added[i]->expose_device))
 			continue;
-		if (scsi_add_device(sh, added[i]->bus,
-			added[i]->target, added[i]->lun) == 0)
+		if (hpsa_add_device(h, added[i]) == 0)
 			continue;
 		hpsa_show_dev_msg(__stringify(KERN_WARNING), h, added[i],
 					"addition failed, device not added.");

