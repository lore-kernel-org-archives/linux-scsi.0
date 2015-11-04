From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 01/27] hpsa: remove unused parameter hostno
Date: Wed, 04 Nov 2015 15:50:01 -0600
Message-ID: <20151104215001.15472.10879.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53240 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965397AbbKDVxy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:53:54 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

This parameter was once used before scan_start was defined
but now it is no longer used.

Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 40669f8..815dc7f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -243,7 +243,7 @@ static int hpsa_slave_alloc(struct scsi_device *sdev);
 static int hpsa_slave_configure(struct scsi_device *sdev);
 static void hpsa_slave_destroy(struct scsi_device *sdev);
 
-static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno);
+static void hpsa_update_scsi_devices(struct ctlr_info *h);
 static int check_for_unit_attention(struct ctlr_info *h,
 	struct CommandList *c);
 static void check_ioctl_unit_attention(struct ctlr_info *h,
@@ -1152,7 +1152,7 @@ static inline void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
 }
 
 /* Add an entry into h->dev[] array. */
-static int hpsa_scsi_add_entry(struct ctlr_info *h, int hostno,
+static int hpsa_scsi_add_entry(struct ctlr_info *h,
 		struct hpsa_scsi_dev_t *device,
 		struct hpsa_scsi_dev_t *added[], int *nadded)
 {
@@ -1228,7 +1228,7 @@ lun_assigned:
 }
 
 /* Update an entry in h->dev[] array. */
-static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
+static void hpsa_scsi_update_entry(struct ctlr_info *h,
 	int entry, struct hpsa_scsi_dev_t *new_entry)
 {
 	int offload_enabled;
@@ -1276,7 +1276,7 @@ static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
 }
 
 /* Replace an entry from h->dev[] array. */
-static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
+static void hpsa_scsi_replace_entry(struct ctlr_info *h,
 	int entry, struct hpsa_scsi_dev_t *new_entry,
 	struct hpsa_scsi_dev_t *added[], int *nadded,
 	struct hpsa_scsi_dev_t *removed[], int *nremoved)
@@ -1304,7 +1304,7 @@ static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
 }
 
 /* Remove an entry from h->dev[] array. */
-static void hpsa_scsi_remove_entry(struct ctlr_info *h, int hostno, int entry,
+static void hpsa_scsi_remove_entry(struct ctlr_info *h, int entry,
 	struct hpsa_scsi_dev_t *removed[], int *nremoved)
 {
 	/* assumes h->devlock is held */
@@ -1638,7 +1638,7 @@ static void hpsa_update_log_drive_phys_drive_ptrs(struct ctlr_info *h,
 	}
 }
 
-static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
+static void adjust_hpsa_scsi_table(struct ctlr_info *h,
 	struct hpsa_scsi_dev_t *sd[], int nsds)
 {
 	/* sd contains scsi3 addresses and devtypes, and inquiry
@@ -1678,19 +1678,18 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 		device_change = hpsa_scsi_find_entry(csd, sd, nsds, &entry);
 		if (device_change == DEVICE_NOT_FOUND) {
 			changes++;
-			hpsa_scsi_remove_entry(h, hostno, i,
-				removed, &nremoved);
+			hpsa_scsi_remove_entry(h, i, removed, &nremoved);
 			continue; /* remove ^^^, hence i not incremented */
 		} else if (device_change == DEVICE_CHANGED) {
 			changes++;
-			hpsa_scsi_replace_entry(h, hostno, i, sd[entry],
+			hpsa_scsi_replace_entry(h, i, sd[entry],
 				added, &nadded, removed, &nremoved);
 			/* Set it to NULL to prevent it from being freed
 			 * at the bottom of hpsa_update_scsi_devices()
 			 */
 			sd[entry] = NULL;
 		} else if (device_change == DEVICE_UPDATED) {
-			hpsa_scsi_update_entry(h, hostno, i, sd[entry]);
+			hpsa_scsi_update_entry(h, i, sd[entry]);
 		}
 		i++;
 	}
@@ -1718,8 +1717,7 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 					h->ndevices, &entry);
 		if (device_change == DEVICE_NOT_FOUND) {
 			changes++;
-			if (hpsa_scsi_add_entry(h, hostno, sd[i],
-				added, &nadded) != 0)
+			if (hpsa_scsi_add_entry(h, sd[i], added, &nadded) != 0)
 				break;
 			sd[i] = NULL; /* prevent from being freed later. */
 		} else if (device_change == DEVICE_CHANGED) {
@@ -1755,7 +1753,7 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	 * (or if there are no changes) scsi_scan_host will do it later the
 	 * first time through.
 	 */
-	if (hostno == -1 || !changes)
+	if (!changes)
 		goto free_and_out;
 
 	sh = h->scsi_host;
@@ -3702,7 +3700,7 @@ static void hpsa_get_path_info(struct hpsa_scsi_dev_t *this_device,
 		sizeof(this_device->bay));
 }
 
-static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
+static void hpsa_update_scsi_devices(struct ctlr_info *h)
 {
 	/* the idea here is we could get notified
 	 * that some devices have changed, so we do a report
@@ -3865,7 +3863,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		if (ncurrent >= HPSA_MAX_DEVICES)
 			break;
 	}
-	adjust_hpsa_scsi_table(h, hostno, currentsd, ncurrent);
+	adjust_hpsa_scsi_table(h, currentsd, ncurrent);
 out:
 	kfree(tmpdevice);
 	for (i = 0; i < ndev_allocated; i++)
@@ -4947,7 +4945,7 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 	if (unlikely(lockup_detected(h)))
 		return hpsa_scan_complete(h);
 
-	hpsa_update_scsi_devices(h, h->scsi_host->host_no);
+	hpsa_update_scsi_devices(h);
 
 	hpsa_scan_complete(h);
 }

