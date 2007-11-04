From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/3] firewire: fw-sbp2: enable s/g chaining
Date: Sun, 4 Nov 2007 14:58:11 +0100 (CET)
Message-ID: <tkrat.4947ae1f5baa964f@s5r6.in-berlin.de>
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com>
 <472BA567.8040301@s5r6.in-berlin.de>
 <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com>
 <472C88E9.60103@s5r6.in-berlin.de> <20071103160404.GH28340@kernel.dk>
 <20071104084456.GJ28340@kernel.dk>
 <64bb37e0711040251w4d08ac83n1e090a8fab19d3d8@mail.gmail.com>
 <20071104130315.GL28340@kernel.dk> <472DC6DE.6050402@s5r6.in-berlin.de>
 <20071104132621.GM28340@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45603 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbXKDN61 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Nov 2007 08:58:27 -0500
In-Reply-To: <20071104132621.GM28340@kernel.dk>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1100,9 +1100,9 @@ sbp2_map_scatterlist(struct sbp2_command
 	 * elements larger than 65535 bytes, some IOMMUs may merge sg elements
 	 * during DMA mapping, and Linux currently doesn't prevent this.
 	 */
-	for (i = 0, j = 0; i < count; i++) {
-		sg_len = sg_dma_len(sg + i);
-		sg_addr = sg_dma_address(sg + i);
+	for (i = 0, j = 0; i < count; i++, sg = sg_next(sg)) {
+		sg_len = sg_dma_len(sg);
+		sg_addr = sg_dma_address(sg);
 		while (sg_len) {
 			/* FIXME: This won't get us out of the pinch. */
 			if (unlikely(j >= ARRAY_SIZE(orb->page_table))) {
@@ -1322,6 +1322,7 @@ static struct scsi_host_template scsi_dr
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.cmd_per_lun		= 1,
 	.can_queue		= 1,
 	.sdev_attrs		= sbp2_scsi_sysfs_attrs,

-- 
Stefan Richter
-=====-=-=== =-== --=--
http://arcgraph.de/sr/

