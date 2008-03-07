From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [1/20] Add sense_buffer_isa to host template
Date: Fri,  7 Mar 2008 18:54:00 +0100 (CET)
Message-ID: <20080307175400.B99741B41AE@basil.firstfloor.org>
References: <20080307653.720459648@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:56515 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369AbYCGRyE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 12:54:04 -0500
In-Reply-To: <20080307653.720459648@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


Instead of having the global "unchecked_isa_dma" bit add a single
bit that tells the mid layer that the sense buffer needs to be ISA
DMA'able.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/include/scsi/scsi_host.h
===================================================================
--- linux.orig/include/scsi/scsi_host.h
+++ linux/include/scsi/scsi_host.h
@@ -453,6 +453,11 @@ struct scsi_host_template {
 	unsigned ordered_tag:1;
 
 	/*
+	 * True if sense buffers need to be ISA-DMAable
+	 */
+	unsigned sense_buffer_isa:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;
@@ -615,6 +620,9 @@ struct Scsi_Host {
 	 */
 	unsigned ordered_tag:1;
 
+	/* Sense buffer needs to be ISA dma'able */
+	unsigned sense_buffer_isa:1;
+
 	/* Task mgmt function in progress */
 	unsigned tmf_in_progress:1;
 
Index: linux/Documentation/scsi/scsi_mid_low_api.txt
===================================================================
--- linux.orig/Documentation/scsi/scsi_mid_low_api.txt
+++ linux/Documentation/scsi/scsi_mid_low_api.txt
@@ -1268,6 +1268,7 @@ of interest:
                    instances (currently ordered by ascending host_no)
     my_devices   - a double linked list of pointers to struct scsi_device 
                    instances that belong to this host.
+    sense_buffer_isa - bit flag; true when the sense buffer needs to be ISA DMAable
     hostdata[0]  - area reserved for LLD at end of struct Scsi_Host. Size
                    is set by the second argument (named 'xtr_bytes') to
                    scsi_host_alloc() or scsi_register().
Index: linux/drivers/scsi/hosts.c
===================================================================
--- linux.orig/drivers/scsi/hosts.c
+++ linux/drivers/scsi/hosts.c
@@ -342,6 +342,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
 	shost->active_mode = sht->supported_mode;
+	shost->sense_buffer_isa = sht->sense_buffer_isa;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
Index: linux/drivers/scsi/scsi.c
===================================================================
--- linux.orig/drivers/scsi/scsi.c
+++ linux/drivers/scsi/scsi.c
@@ -322,7 +322,8 @@ int scsi_setup_command_freelist(struct S
 	 * yet existent.
 	 */
 	mutex_lock(&host_cmd_pool_mutex);
-	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
+	pool = ((shost->unchecked_isa_dma || shost->sense_buffer_isa) ?
+			&scsi_cmd_dma_pool : &scsi_cmd_pool);
 	if (!pool->users) {
 		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
 						   sizeof(struct scsi_cmnd), 0,
