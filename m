From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/35] hpsa: update raid offload status on device rescan
Date: Tue, 18 Feb 2014 13:55:38 -0600
Message-ID: <20140218195538.15787.92017.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:56654 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaBRT4j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:56:39 -0500
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id E14F01A90
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:56:31 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

When rescanning for logical drives, store information about whather
raid offload is enabled for each logical drive, and update the driver's
internal record of this.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f6727f4..92662e6 100644
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
 

