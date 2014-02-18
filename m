From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 20/35] hpsa: make device update copy the raid map also
Date: Tue, 18 Feb 2014 13:56:50 -0600
Message-ID: <20140218195650.15787.63888.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57073 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaBRT6S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:58:18 -0500
Received: from g5t1625.atlanta.hp.com (g5t1625.atlanta.hp.com [15.192.137.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id A2FC8CB5
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:58:09 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Otherwise we could wind up using incorrect raid map data, and
then very bad things would likely happen.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8880f54..bcb48b5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -891,6 +891,9 @@ static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
 	/* Raid offload parameters changed. */
 	h->dev[entry]->offload_config = new_entry->offload_config;
 	h->dev[entry]->offload_enabled = new_entry->offload_enabled;
+	h->dev[entry]->ioaccel_handle = new_entry->ioaccel_handle;
+	h->dev[entry]->offload_to_mirror = new_entry->offload_to_mirror;
+	h->dev[entry]->raid_map = new_entry->raid_map;
 
 	dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d updated.\n",
 		scsi_device_type(new_entry->devtype), hostno, new_entry->bus,

