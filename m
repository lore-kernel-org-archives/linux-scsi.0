From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 34/48] hpsa: remove incorrect BUG_ONs checking for raid
 offload enable
Date: Fri, 23 Jan 2015 16:44:01 -0600
Message-ID: <20150123224401.14919.3533.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43553 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbbAWWo4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:44:56 -0500
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id E8F1661751
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2015 22:44:55 +0000 (UTC)
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

In set_encrypt_ioaccel2() and in hpsa_scsi_ioaccel_raid_map
there were BUG_ONs that looked like this:

	BUG_ON(!(dev->offload_config && dev->offload_enabled));

But, In hpsa_ack_ctlr_events() we have this,

	/* Stop sending new RAID offload reqs via the IO accelerator */
	scsi_block_requests(h->scsi_host);
	for (i = 0; i < h->ndevices; i++)
		h->dev[i]->offload_enabled = 0;
	hpsa_drain_accel_commands(h);

So, we set offload_enabled = 0 for all drives, then do this
drain_accel_commands, so that means accel commands could still
be in flight, ie. perhaps having just been submitted into
hpsa_scsi_ioaccel_raid_map concurrent with ->offload_enabled
having just been set to zero.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index bae3759..5abd49d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3456,8 +3456,6 @@ static void set_encrypt_ioaccel2(struct ctlr_info *h,
 	struct raid_map_data *map = &dev->raid_map;
 	u64 first_block;
 
-	BUG_ON(!(dev->offload_config && dev->offload_enabled));
-
 	/* Are we doing encryption on this device */
 	if (!(le16_to_cpu(map->flags) & RAID_MAP_FLAG_ENCRYPT_ON))
 		return;
@@ -3688,8 +3686,6 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 #endif
 	int offload_to_mirror;
 
-	BUG_ON(!(dev->offload_config && dev->offload_enabled));
-
 	/* check for valid opcode, get LBA and block count */
 	switch (cmd->cmnd[0]) {
 	case WRITE_6:

