From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [19/21] Finally remove unchecked_isa_dma support for Cmnds
Date: Thu,  6 Mar 2008 21:51:41 +0100 (CET)
Message-ID: <20080306205141.5AA741B419C@basil.firstfloor.org>
References: <20080306951.147874949@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:15069 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762974AbYCFUvr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 15:51:47 -0500
In-Reply-To: <20080306951.147874949@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


No drivers need it anymore

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/scsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/scsi/scsi.c
===================================================================
--- linux.orig/drivers/scsi/scsi.c
+++ linux/drivers/scsi/scsi.c
@@ -336,8 +336,7 @@ int scsi_setup_command_freelist(struct S
 			goto fail;
 	}
 
-	pool = (shost->unchecked_isa_dma || sense_buffer_isa(shost)) ?
-			&scsi_cmd_dma_pool : &scsi_cmd_pool;
+	pool = sense_buffer_isa(shost) ? &scsi_cmd_dma_pool : &scsi_cmd_pool;
 	if (!pool->users) {
 		pool->sense_slab = kmem_cache_create(pool->sense_name,
 						     SCSI_SENSE_BUFFERSIZE, 0,
