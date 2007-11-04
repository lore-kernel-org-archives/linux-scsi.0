From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/3] ieee1394: sbp2: enable s/g chaining
Date: Sun, 4 Nov 2007 14:58:43 +0100 (CET)
Message-ID: <tkrat.2a470664250af864@s5r6.in-berlin.de>
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com>
 <472BA567.8040301@s5r6.in-berlin.de>
 <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com>
 <472C88E9.60103@s5r6.in-berlin.de> <20071103160404.GH28340@kernel.dk>
 <20071104084456.GJ28340@kernel.dk>
 <64bb37e0711040251w4d08ac83n1e090a8fab19d3d8@mail.gmail.com>
 <20071104130315.GL28340@kernel.dk> <472DC6DE.6050402@s5r6.in-berlin.de>
 <20071104132621.GM28340@kernel.dk>
 <tkrat.4947ae1f5baa964f@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45623 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbXKDN67 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Nov 2007 08:58:59 -0500
In-Reply-To: <tkrat.4947ae1f5baa964f@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -326,6 +326,7 @@ static struct scsi_host_template sbp2_sh
 	.this_id		 = -1,
 	.sg_tablesize		 = SG_ALL,
 	.use_clustering		 = ENABLE_CLUSTERING,
+	.use_sg_chaining	 = ENABLE_SG_CHAINING,
 	.cmd_per_lun		 = SBP2_MAX_CMDS,
 	.can_queue		 = SBP2_MAX_CMDS,
 	.sdev_attrs		 = sbp2_sysfs_sdev_attrs,
@@ -1489,7 +1490,7 @@ static void sbp2_prep_command_orb_sg(str
 
 		/* loop through and fill out our SBP-2 page tables
 		 * (and split up anything too large) */
-		for (i = 0, sg_count = 0 ; i < count; i++, sgpnt++) {
+		for (i = 0, sg_count = 0; i < count; i++, sgpnt = sg_next(sgpnt)) {
 			sg_len = sg_dma_len(sgpnt);
 			sg_addr = sg_dma_address(sgpnt);
 			while (sg_len) {

-- 
Stefan Richter
-=====-=-=== =-== --=--
http://arcgraph.de/sr/

