From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 13/42] hpsa: print accurate SSD Smart Path Enabled status
Date: Tue, 17 Mar 2015 15:03:36 -0500
Message-ID: <20150317200336.19856.35859.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:42488 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbbCQUGA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:06:00 -0400
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id B174A60E02
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2015 20:05:15 +0000 (UTC)
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
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
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 813f3c8..e9d3d71 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1090,12 +1090,12 @@ lun_assigned:
 
 	h->dev[n] = device;
 	h->ndevices++;
-	device->offload_to_be_enabled = device->offload_enabled;
-	device->offload_enabled = 0;
 	added[*nadded] = device;
 	(*nadded)++;
 	hpsa_show_dev_msg(HPSA_INFO, h, device,
 		device->expose_state & HPSA_SCSI_ADD ? "added" : "masked");
+	device->offload_to_be_enabled = device->offload_enabled;
+	device->offload_enabled = 0;
 	return 0;
 }
 
@@ -1103,6 +1103,7 @@ lun_assigned:
 static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
 	int entry, struct hpsa_scsi_dev_t *new_entry)
 {
+	int offload_enabled;
 	/* assumes h->devlock is held */
 	BUG_ON(entry < 0 || entry >= HPSA_MAX_DEVICES);
 
@@ -1135,7 +1136,10 @@ static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
 	if (!new_entry->offload_enabled)
 		h->dev[entry]->offload_enabled = 0;
 
+	offload_enabled = h->dev[entry]->offload_enabled;
+	h->dev[entry]->offload_enabled = h->dev[entry]->offload_to_be_enabled;
 	hpsa_show_dev_msg(HPSA_INFO, h, h->dev[entry], "updated");
+	h->dev[entry]->offload_enabled = offload_enabled;
 }
 
 /* Replace an entry from h->dev[] array. */
@@ -1158,12 +1162,12 @@ static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
 		new_entry->lun = h->dev[entry]->lun;
 	}
 
-	new_entry->offload_to_be_enabled = new_entry->offload_enabled;
-	new_entry->offload_enabled = 0;
 	h->dev[entry] = new_entry;
 	added[*nadded] = new_entry;
 	(*nadded)++;
 	hpsa_show_dev_msg(HPSA_INFO, h, new_entry, "replaced");
+	new_entry->offload_to_be_enabled = new_entry->offload_enabled;
+	new_entry->offload_enabled = 0;
 }
 
 /* Remove an entry from h->dev[] array. */

