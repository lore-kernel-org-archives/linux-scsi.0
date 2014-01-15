From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 27/41] hpsa: make device update copy the raid map also
Date: Wed, 15 Jan 2014 16:38:37 -0600
Message-ID: <20140115223837.5061.25843.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:33020 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaAOVs1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:48:27 -0500
Received: from g5t0007.atlanta.hp.com (g5t0007.atlanta.hp.com [15.192.0.44])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id B859760B6D
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2014 21:38:47 +0000 (UTC)
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Otherwise we could wind up using incorrect raid map data, and
then very bad things would likely happen.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6a6026b..cf208e5 100644
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

