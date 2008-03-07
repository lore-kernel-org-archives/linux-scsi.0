From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [14/20] Don't disable direct_io for unchecked_isa_dma in st.c
Date: Fri,  7 Mar 2008 18:54:14 +0100 (CET)
Message-ID: <20080307175414.08C981B41AE@basil.firstfloor.org>
References: <20080307653.720459648@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:14690 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758840AbYCGRyQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 12:54:16 -0500
In-Reply-To: <20080307653.720459648@firstfloor.org>
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
