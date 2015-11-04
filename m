From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 06/27] hpsa: fix null device issues
Date: Wed, 04 Nov 2015 15:50:31 -0600
Message-ID: <20151104215031.15472.40572.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60719 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965397AbbKDVyY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:54:24 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Manoj Kumar <manoj@linux.vnet.ibm.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b64913f..4468166 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1135,7 +1135,7 @@ static int hpsa_find_target_lun(struct ctlr_info *h,
 	return !found;
 }
 
-static inline void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
+static void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
 	struct hpsa_scsi_dev_t *dev, char *description)
 {
 	if (h == NULL || h->pdev == NULL || h->scsi_host == NULL)
@@ -1419,6 +1419,9 @@ static int hpsa_scsi_find_entry(struct hpsa_scsi_dev_t *needle,
 #define DEVICE_CHANGED 1
 #define DEVICE_SAME 2
 #define DEVICE_UPDATED 3
+	if (needle == NULL)
+		return DEVICE_NOT_FOUND;
+
 	for (i = 0; i < haystack_size; i++) {
 		if (haystack[i] == NULL) /* previously removed. */
 			continue;
@@ -1581,6 +1584,8 @@ static void hpsa_figure_phys_disk_ptrs(struct ctlr_info *h,
 		if (!logical_drive->offload_config)
 			continue;
 		for (j = 0; j < ndevices; j++) {
+			if (dev[j] == NULL)
+				continue;
 			if (dev[j]->devtype != TYPE_DISK)
 				continue;
 			if (is_logical_dev_addr_mode(dev[j]->scsi3addr))
@@ -1624,6 +1629,8 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
 	int i;
 
 	for (i = 0; i < ndevices; i++) {
+		if (dev[i] == NULL)
+			continue;
 		if (dev[i]->devtype != TYPE_DISK)
 			continue;
 		if (!is_logical_dev_addr_mode(dev[i]->scsi3addr))
@@ -1737,8 +1744,11 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 	/* Now that h->dev[]->phys_disk[] is coherent, we can enable
 	 * any logical drives that need it enabled.
 	 */
-	for (i = 0; i < h->ndevices; i++)
+	for (i = 0; i < h->ndevices; i++) {
+		if (h->dev[i] == NULL)
+			continue;
 		h->dev[i]->offload_enabled = h->dev[i]->offload_to_be_enabled;
+	}
 
 	spin_unlock_irqrestore(&h->devlock, flags);
 
@@ -1763,6 +1773,8 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 	sh = h->scsi_host;
 	/* Notify scsi mid layer of any removed devices */
 	for (i = 0; i < nremoved; i++) {
+		if (removed[i] == NULL)
+			continue;
 		if (removed[i]->expose_state & HPSA_SCSI_ADD) {
 			struct scsi_device *sdev =
 				scsi_device_lookup(sh, removed[i]->bus,
@@ -1786,18 +1798,18 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 
 	/* Notify scsi mid layer of any added devices */
 	for (i = 0; i < nadded; i++) {
+		if (added[i] == NULL)
+			continue;
 		if (!(added[i]->expose_state & HPSA_SCSI_ADD))
 			continue;
 		if (scsi_add_device(sh, added[i]->bus,
 			added[i]->target, added[i]->lun) == 0)
 			continue;
-		hpsa_show_dev_msg(KERN_WARNING, h, added[i],
-					"addition failed, device not added.");
+		dev_warn(&h->pdev->dev, "addition failed, device not added.");
 		/* now we have to remove it from h->dev,
 		 * since it didn't get added to scsi mid layer
 		 */
 		fixup_botched_add(h, added[i]);
-		added[i] = NULL;
 	}
 
 free_and_out:

