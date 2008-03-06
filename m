From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [1/21] Add new sense_buffer_mask host template field
Date: Thu,  6 Mar 2008 21:51:14 +0100 (CET)
Message-ID: <20080306205116.50E2A1B419C@basil.firstfloor.org>
References: <20080306951.147874949@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:15033 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760555AbYCFUv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 15:51:26 -0500
In-Reply-To: <20080306951.147874949@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


sense buffers are something that still needs to be explicitely 
bounced in the scsi layer. Instead of using the global unchecked_isa_dma
flag define a special fine grained mask for this.

I decided to use a full dma mask because that is most useful for some future
infrastructure work I'm doing.

Needed for followup patches.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/scsi/scsi_mid_low_api.txt |    4 ++++
 drivers/scsi/hosts.c                    |    1 +
 drivers/scsi/scsi.c                     |   12 +++++++++++-
 include/scsi/scsi_host.h                |   10 +++++++++-
 4 files changed, 25 insertions(+), 2 deletions(-)

Index: linux/drivers/scsi/scsi.c
===================================================================
--- linux.orig/drivers/scsi/scsi.c
+++ linux/drivers/scsi/scsi.c
@@ -299,6 +299,15 @@ void scsi_put_command(struct scsi_cmnd *
 }
 EXPORT_SYMBOL(scsi_put_command);
 
+static int sense_buffer_isa(struct Scsi_Host *shost)
+{
+	if (!shost->sense_buffer_mask)
+		return 0;
+	if (~shost->sense_buffer_mask & BLK_BOUNCE_HIGH)
+		return 1;
+	return 0;
+}
+
 /**
  * scsi_setup_command_freelist - Setup the command freelist for a scsi host.
  * @shost: host to allocate the freelist for.
@@ -322,7 +331,8 @@ int scsi_setup_command_freelist(struct S
 	 * yet existent.
 	 */
 	mutex_lock(&host_cmd_pool_mutex);
-	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
+	pool = (shost->unchecked_isa_dma || sense_buffer_isa(shost)) ?
+			&scsi_cmd_dma_pool : &scsi_cmd_pool;
 	if (!pool->users) {
 		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
 						   sizeof(struct scsi_cmnd), 0,
Index: linux/include/scsi/scsi_host.h
===================================================================
--- linux.orig/include/scsi/scsi_host.h
+++ linux/include/scsi/scsi_host.h
@@ -484,6 +484,14 @@ struct scsi_host_template {
 	 * module_init/module_exit.
 	 */
 	struct list_head legacy_hosts;
+
+	/*
+	 * DMA Mask of the sense buffer.
+	 * 0 means any in lowmem and subject to the pci device mask
+	 * This should only be set by ISA drivers doing direct DMA to the sense buffer
+	 * Status: optional.
+	 */
+	u64 sense_buffer_mask;
 };
 
 /*
@@ -649,7 +657,7 @@ struct Scsi_Host {
 	unsigned char n_io_port;
 	unsigned char dma_channel;
 	unsigned int  irq;
-	
+	u64 sense_buffer_mask;
 
 	enum scsi_host_state shost_state;
 
Index: linux/Documentation/scsi/scsi_mid_low_api.txt
===================================================================
--- linux.orig/Documentation/scsi/scsi_mid_low_api.txt
+++ linux/Documentation/scsi/scsi_mid_low_api.txt
@@ -1268,6 +1268,10 @@ of interest:
                    instances (currently ordered by ascending host_no)
     my_devices   - a double linked list of pointers to struct scsi_device 
                    instances that belong to this host.
+    sense_buffer_mask - dma mask for the sense buffer. Only needed when
+		   the dma mask is below the minimum supported by the
+		   PCI IOMMU on that platform.
+		   Ignored when 0. Normally only needed on ISA host adapters.
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
+	shost->sense_buffer_mask = sht->sense_buffer_mask;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
