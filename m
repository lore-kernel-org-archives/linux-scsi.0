From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v5 13/42] hpsa: print accurate SSD Smart Path Enabled status
Date: Thu, 23 Apr 2015 09:32:54 -0500
Message-ID: <20150423143254.18832.91711.stgit@brunhilda>
References: <20150423141637.18832.35621.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:37634 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965008AbbDWOeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 10:34:03 -0400
In-Reply-To: <20150423141637.18832.35621.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

offload_enabled changes are deferred until after the
added/updated prints occur, so the values are incorrect.

defer printing SSD Smart Path Enabled status information until the
information is correct

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@Suse.de>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 350a76a..1aa36e6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1060,12 +1060,12 @@ lun_assigned:
 
 	h->dev[n] = device;
 	h->ndevices++;
-	device->offload_to_be_enabled = device->offload_enabled;
-	device->offload_enabled = 0;
 	added[*nadded] = device;
 	(*nadded)++;
 	hpsa_show_dev_msg(KERN_INFO, h, device,
 		device->expose_state & HPSA_SCSI_ADD ? "added" : "masked");
+	device->offload_to_be_enabled = device->offload_enabled;
+	device->offload_enabled = 0;
 	return 0;
 }
 
@@ -1073,6 +1073,7 @@ lun_assigned:
 static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
 	int entry, struct hpsa_scsi_dev_t *new_entry)
 {
+	int offload_enabled;
 	/* assumes h->devlock is held */
 	BUG_ON(entry < 0 || entry >= HPSA_MAX_DEVICES);
 
@@ -1105,7 +1106,10 @@ static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
 	if (!new_entry->offload_enabled)
 		h->dev[entry]->offload_enabled = 0;
 
+	offload_enabled = h->dev[entry]->offload_enabled;
+	h->dev[entry]->offload_enabled = h->dev[entry]->offload_to_be_enabled;
 	hpsa_show_dev_msg(KERN_INFO, h, h->dev[entry], "updated");
+	h->dev[entry]->offload_enabled = offload_enabled;
 }
 
 /* Replace an entry from h->dev[] array. */
@@ -1128,12 +1132,12 @@ static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
 		new_entry->lun = h->dev[entry]->lun;
 	}
 
-	new_entry->offload_to_be_enabled = new_entry->offload_enabled;
-	new_entry->offload_enabled = 0;
 	h->dev[entry] = new_entry;
 	added[*nadded] = new_entry;
 	(*nadded)++;
 	hpsa_show_dev_msg(KERN_INFO, h, new_entry, "replaced");
+	new_entry->offload_to_be_enabled = new_entry->offload_enabled;
+	new_entry->offload_enabled = 0;
 }
 
 /* Remove an entry from h->dev[] array. */

