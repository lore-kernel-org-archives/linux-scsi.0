From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [4/21] SCSI-ISA-DMA: Add sense_buffer_isa to host template
Date: Thu,  2 Oct 2008 09:58:42 +0200 (CEST)
Message-ID: <20081002075842.286373E6A07@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57084 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYJBH6o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:44 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


Instead of having the global "unchecked_isa_dma" bit add a single
bit that tells the mid layer that the sense buffer needs to be ISA
DMA'able.

Right now when the bit is set we still force all commands to the ISA
DMA zone too, but that can change in the future.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/scsi/scsi_mid_low_api.txt |    1 +
 drivers/scsi/hosts.c                    |    1 +
 drivers/scsi/scsi.c                     |   10 ++++++----
 include/scsi/scsi_host.h                |    8 ++++++++
 4 files changed, 16 insertions(+), 4 deletions(-)

Index: linux/include/scsi/scsi_host.h
===================================================================
--- linux.orig/include/scsi/scsi_host.h
+++ linux/include/scsi/scsi_host.h
@@ -454,6 +454,11 @@ struct scsi_host_template {
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
@@ -614,6 +619,9 @@ struct Scsi_Host {
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
@@ -364,6 +364,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 		shost->active_mode = MODE_INITIATOR;
 	else
 		shost->active_mode = sht->supported_mode;
+	shost->sense_buffer_isa = sht->sense_buffer_isa;
 
 	if (sht->max_host_blocked)
 		shost->max_host_blocked = sht->max_host_blocked;
Index: linux/drivers/scsi/scsi.c
===================================================================
--- linux.orig/drivers/scsi/scsi.c
+++ linux/drivers/scsi/scsi.c
@@ -363,7 +363,7 @@ scsi_get_host_cmd_pool(struct Scsi_Host 
 	 */
 	mutex_lock(&host_cmd_pool_mutex);
 	pool = &scsi_cmd_pool;
-	if (shost && shost->unchecked_isa_dma)
+	if (shost && (shost->unchecked_isa_dma || shost->sense_buffer_isa))
 		pool = &scsi_cmd_dma_pool;
 	if (!pool->users) {
 		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
@@ -393,8 +393,8 @@ static void scsi_put_host_cmd_pool(struc
 	struct scsi_host_cmd_pool *pool;
 
 	mutex_lock(&host_cmd_pool_mutex);
-	pool = (shost && shost->unchecked_isa_dma) ? &scsi_cmd_dma_pool :
-		&scsi_cmd_pool;
+	pool = (shost && (shost->unchecked_isa_dma || shost->sense_buffer_isa)) ?
+		&scsi_cmd_dma_pool : &scsi_cmd_pool;
 	/*
 	 * This may happen if a driver has a mismatched get and put
 	 * of the command pool; the driver should be implicated in
@@ -489,7 +489,9 @@ EXPORT_SYMBOL(scsi_free_command);
 int scsi_setup_command_freelist(struct Scsi_Host *shost)
 {
 	struct scsi_cmnd *cmd;
-	const gfp_t gfp_mask = shost->unchecked_isa_dma ? GFP_DMA : GFP_KERNEL;
+	gfp_t gfp_mask = GFP_KERNEL;
+	if (shost->unchecked_isa_dma || shost->sense_buffer_isa)
+		gfp_mask = GFP_DMA;
 
 	spin_lock_init(&shost->free_list_lock);
 	INIT_LIST_HEAD(&shost->free_list);
