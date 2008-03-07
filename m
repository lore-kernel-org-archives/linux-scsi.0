From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [19/20] Finally kill unchecked_isa_dma
Date: Fri,  7 Mar 2008 18:54:19 +0100 (CET)
Message-ID: <20080307175419.1F6271B41AE@basil.firstfloor.org>
References: <20080307653.720459648@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:56579 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758409AbYCGRyV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 12:54:21 -0500
In-Reply-To: <20080307653.720459648@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


Now that all users are gone it can be safely completely removed.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/scsi/scsi_mid_low_api.txt |    3 ---
 drivers/scsi/hosts.c                    |    1 -
 include/scsi/scsi_host.h                |    6 ------
 3 files changed, 10 deletions(-)

Index: linux/Documentation/scsi/scsi_mid_low_api.txt
===================================================================
--- linux.orig/Documentation/scsi/scsi_mid_low_api.txt
+++ linux/Documentation/scsi/scsi_mid_low_api.txt
@@ -1254,9 +1254,6 @@ of interest:
     cmd_per_lun  - maximum number of commands that can be queued on devices
                    controlled by the host. Overridden by LLD calls to
                    scsi_adjust_queue_depth().
-    unchecked_isa_dma - 1=>only use bottom 16 MB of ram (ISA DMA addressing
-                   restriction), 0=>can use full 32 bit (or better) DMA
-                   address space
     use_clustering - 1=>SCSI commands in mid level's queue can be merged,
                      0=>disallow SCSI command merging
     hostt        - pointer to driver's struct scsi_host_template from which
Index: linux/drivers/scsi/hosts.c
===================================================================
--- linux.orig/drivers/scsi/hosts.c
+++ linux/drivers/scsi/hosts.c
@@ -335,7 +335,6 @@ struct Scsi_Host *scsi_host_alloc(struct
 	shost->can_queue = sht->can_queue;
 	shost->sg_tablesize = sht->sg_tablesize;
 	shost->cmd_per_lun = sht->cmd_per_lun;
-	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
 	shost->active_mode = sht->supported_mode;
Index: linux/include/scsi/scsi_host.h
===================================================================
--- linux.orig/include/scsi/scsi_host.h
+++ linux/include/scsi/scsi_host.h
@@ -423,11 +423,6 @@ struct scsi_host_template {
 	unsigned supported_mode:2;
 
 	/*
-	 * True if this host adapter uses unchecked DMA onto an ISA bus.
-	 */
-	unsigned unchecked_isa_dma:1;
-
-	/*
 	 * True if this host adapter can make good use of clustering.
 	 * I originally thought that if the tablesize was large that it
 	 * was a waste of CPU cycles to prepare a cluster list, but
@@ -601,7 +596,6 @@ struct Scsi_Host {
 	unsigned long cmd_serial_number;
 	
 	unsigned active_mode:2;
-	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
 	unsigned use_blk_tcq:1;
 
