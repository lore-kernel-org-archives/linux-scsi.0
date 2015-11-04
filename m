From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 19/27] hpsa: move scsi_add_device and scsi_remove_device
 calls to new function
Date: Wed, 04 Nov 2015 15:51:51 -0600
Message-ID: <20151104215151.15472.78753.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60997 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030199AbbKDVzo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:55:44 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@pmcs.com>

preparation for adding the sas transport class

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   71 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c95ff8c..0af4c67 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1653,6 +1653,43 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
 	}
 }
 
+static int hpsa_add_device(struct ctlr_info *h, struct hpsa_scsi_dev_t *device)
+{
+	int rc = 0;
+
+	if (!h->scsi_host)
+		return 1;
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
+	if (!h->scsi_host)
+		return;
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
+		hpsa_show_dev_msg(KERN_WARNING, h, device,
+					"didn't find device for removal.");
+	}
+}
+
 static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 	struct hpsa_scsi_dev_t *sd[], int nsds)
 {
@@ -1665,7 +1702,6 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 	unsigned long flags;
 	struct hpsa_scsi_dev_t **added, **removed;
 	int nadded, nremoved;
-	struct Scsi_Host *sh = NULL;
 
 	/*
 	 * A reset can cause a device status to change
@@ -1783,46 +1819,29 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 	if (!changes)
 		goto free_and_out;
 
-	sh = h->scsi_host;
-	if (sh == NULL) {
-		dev_warn(&h->pdev->dev, "%s: scsi_host is null\n", __func__);
-		goto free_and_out;
-	}
 	/* Notify scsi mid layer of any removed devices */
 	for (i = 0; i < nremoved; i++) {
 		if (removed[i] == NULL)
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
-				hpsa_show_dev_msg(KERN_WARNING, h, removed[i],
-					"didn't find device for removal.");
-			}
-		}
+		if (removed[i]->expose_device)
+			hpsa_remove_device(h, removed[i]);
 		kfree(removed[i]);
 		removed[i] = NULL;
 	}
 
 	/* Notify scsi mid layer of any added devices */
 	for (i = 0; i < nadded; i++) {
+		int rc = 0;
+
 		if (added[i] == NULL)
 			continue;
 		if (!(added[i]->expose_device))
 			continue;
-		if (scsi_add_device(sh, added[i]->bus,
-			added[i]->target, added[i]->lun) == 0)
+		rc = hpsa_add_device(h, added[i]);
+		if (!rc)
 			continue;
-		dev_warn(&h->pdev->dev, "addition failed, device not added.");
+		dev_warn(&h->pdev->dev,
+			"addition failed %d, device not added.", rc);
 		/* now we have to remove it from h->dev,
 		 * since it didn't get added to scsi mid layer
 		 */

