From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 02/13] hpsa: remove dev_warn prints from RAID-1ADM
Date: Fri, 14 Nov 2014 17:26:33 -0600
Message-ID: <20141114232633.20808.30112.stgit@don-ProLiant-MicroServer-Gen8>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2354.austin.hp.com ([15.217.128.53]:37068 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935395AbaKNXY6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:24:58 -0500
In-Reply-To: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

RAID-1ADM is unusable with dev_warn called on every command.

Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Stephen M. Cameron <stephenmcameron@gmail.com>
Reviewed-by: Webb Scales <webbnh@hp.com>
---
 drivers/scsi/hpsa.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f345cc5..e24b304 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3811,11 +3811,6 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 		offload_to_mirror =
 			(offload_to_mirror >= map->layout_map_count - 1)
 			? 0 : offload_to_mirror + 1;
-		/* FIXME: remove after debug/dev */
-		BUG_ON(offload_to_mirror >= map->layout_map_count);
-		dev_warn(&h->pdev->dev,
-			"DEBUG: Using physical disk map index %d from mirror group %d\n",
-			map_index, offload_to_mirror);
 		dev->offload_to_mirror = offload_to_mirror;
 		/* Avoid direct use of dev->offload_to_mirror within this
 		 * function since multiple threads might simultaneously

