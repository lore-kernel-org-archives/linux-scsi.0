From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 13/43] hpsa: print accurate SSD Smart Path Enabled status
Date: Sat, 21 Feb 2015 16:18:42 -0600
Message-ID: <20150221221842.21954.15063.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:57230 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbbBUWUA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:20:00 -0500
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 4FE0260552
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2015 22:20:00 +0000 (UTC)
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
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
 drivers/scsi/hpsa.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index accfede..e151662 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1065,7 +1065,7 @@ lun_assigned:
 		device->raid_level > RAID_UNKNOWN ?
 			"RAID-?" : raid_label[device->raid_level],
 		device->offload_config ? '+' : '-',
-		device->offload_enabled ? '+' : '-',
+		device->offload_to_be_enabled ? '+' : '-',
 		device->expose_state);
 	return 0;
 }
@@ -1116,7 +1116,7 @@ static void hpsa_scsi_update_entry(struct ctlr_info *h, int hostno,
 		h->dev[entry]->raid_level > RAID_UNKNOWN ?
 			"RAID-?" : raid_label[h->dev[entry]->raid_level],
 		h->dev[entry]->offload_config ? '+' : '-',
-		h->dev[entry]->offload_enabled ? '+' : '-',
+		h->dev[entry]->offload_to_be_enabled ? '+' : '-',
 		h->dev[entry]->expose_state);
 }
 
@@ -1154,7 +1154,7 @@ static void hpsa_scsi_replace_entry(struct ctlr_info *h, int hostno,
 		new_entry->raid_level > RAID_UNKNOWN ?
 			"RAID-?" : raid_label[new_entry->raid_level],
 		new_entry->offload_config ? '+' : '-',
-		new_entry->offload_enabled ? '+' : '-',
+		new_entry->offload_to_be_enabled ? '+' : '-',
 		new_entry->expose_state);
 }
 

