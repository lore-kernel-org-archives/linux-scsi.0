From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [18/22] Finally remove unchecked_isa_dma support for Cmnds
Date: Mon, 25 Feb 2008 00:35:31 +0100 (CET)
Message-ID: <20080224233531.4F17D1B4183@basil.firstfloor.org>
References: <200802251235.889863872@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:15963 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYBXXvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 18:51:36 -0500
In-Reply-To: <200802251235.889863872@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


No drivers need it anymore

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/scsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/scsi/scsi.c
===================================================================
--- linux.orig/drivers/scsi/scsi.c
+++ linux/drivers/scsi/scsi.c
@@ -337,8 +337,7 @@ int scsi_setup_command_freelist(struct S
 			goto fail;
 	}
 
-	pool = (shost->unchecked_isa_dma || sense_buffer_isa(shost)) ?
-			&scsi_cmd_dma_pool : &scsi_cmd_pool;
+	pool = sense_buffer_isa(shost) ? &scsi_cmd_dma_pool : &scsi_cmd_pool;
 	if (!pool->users) {
 		pool->sense_slab = kmem_cache_create(pool->sense_name,
 						     SCSI_SENSE_BUFFERSIZE, 0,
