From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [14/21] Don't disable direct_io for unchecked_isa_dma in st.c
Date: Thu,  6 Mar 2008 21:51:35 +0100 (CET)
Message-ID: <20080306205135.754211B419C@basil.firstfloor.org>
References: <20080306951.147874949@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:53297 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762230AbYCFUvs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 15:51:48 -0500
In-Reply-To: <20080306951.147874949@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


Block layer bounces anyways.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/scsi/st.c
===================================================================
--- linux.orig/drivers/scsi/st.c
+++ linux/drivers/scsi/st.c
@@ -3990,7 +3990,7 @@ static int st_probe(struct device *dev)
 	tpnt->nbr_partitions = 0;
 	tpnt->device->timeout = ST_TIMEOUT;
 	tpnt->long_timeout = ST_LONG_TIMEOUT;
-	tpnt->try_dio = try_direct_io && !SDp->host->unchecked_isa_dma;
+	tpnt->try_dio = try_direct_io;
 
 	for (i = 0; i < ST_NBR_MODES; i++) {
 		STm = &(tpnt->modes[i]);
