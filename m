From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [13/22] Don't disable direct_io for unchecked_isa_dma in st.c
Date: Mon, 25 Feb 2008 00:35:26 +0100 (CET)
Message-ID: <20080224233526.36B071B4183@basil.firstfloor.org>
References: <200802251235.889863872@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:19737 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413AbYBXXfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 18:35:32 -0500
In-Reply-To: <200802251235.889863872@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


Block layer bounces anyways.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/scsi/st.c
===================================================================
--- linux.orig/drivers/scsi/st.c
+++ linux/drivers/scsi/st.c
@@ -3993,7 +3993,7 @@ static int st_probe(struct device *dev)
 	tpnt->nbr_partitions = 0;
 	tpnt->device->timeout = ST_TIMEOUT;
 	tpnt->long_timeout = ST_LONG_TIMEOUT;
-	tpnt->try_dio = try_direct_io && !SDp->host->unchecked_isa_dma;
+	tpnt->try_dio = try_direct_io;
 
 	for (i = 0; i < ST_NBR_MODES; i++) {
 		STm = &(tpnt->modes[i]);
