From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 14/41] hpsa: update raid offload status on device rescan
Date: Wed, 15 Jan 2014 16:37:30 -0600
Message-ID: <20140115223730.5061.27248.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:40622 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaAOVhb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:37:31 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

When rescanning for logical drives, store information about whather
raid offload is enabled for each logical drive, and update the driver's
internal record of this.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c7e3d4d..4c9dd2e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -787,6 +787,11 @@ static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
 
 	/* Raid level changed. */
 	h->dev[entry]->raid_level = new_entry->raid_level;
+
+	/* Raid offload parameters changed. */
+	h->dev[entry]->offload_config = new_entry->offload_config;
+	h->dev[entry]->offload_enabled = new_entry->offload_enabled;
+
 	dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d updated.\n",
 		scsi_device_type(new_entry->devtype), hostno, new_entry->bus,
 		new_entry->target, new_entry->lun);
@@ -907,6 +912,10 @@ static inline int device_updated(struct hpsa_scsi_dev_t *dev1,
 	 */
 	if (dev1->raid_level != dev2->raid_level)
 		return 1;
+	if (dev1->offload_config != dev2->offload_config)
+		return 1;
+	if (dev1->offload_enabled != dev2->offload_enabled)
+		return 1;
 	return 0;
 }
 

