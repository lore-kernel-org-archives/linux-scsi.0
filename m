From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [20/21] Finally kill unchecked_isa_dma
Date: Sun, 16 Nov 2008 00:11:20 +0100 (CET)
Message-ID: <20081115231120.B06EA3E6619@basil.firstfloor.org>
References: <200811161211.212948789@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44222 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYKOXLR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Nov 2008 18:11:17 -0500
In-Reply-To: <200811161211.212948789@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org


Now that all users are gone it can be safely completely removed.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/scsi/scsi_mid_low_api.txt |    3 ---
 drivers/scsi/hosts.c                    |    1 -
 include/scsi/scsi_host.h                |    6 ------
 3 files changed, 10 deletions(-)

Index: linux/Documentation/scsi/scsi_mid_low_api.txt
===================================================================
--- linux.orig/Documentation/scsi/scsi_mid_low_api.txt	2008-11-15 22:37:12.000000000 +0100
+++ linux/Documentation/scsi/scsi_mid_low_api.txt	2008-11-15 22:37:12.000000000 +0100
@@ -1254,9 +1254,6 @@
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
--- linux.orig/drivers/scsi/hosts.c	2008-11-15 22:37:12.000000000 +0100
+++ linux/drivers/scsi/hosts.c	2008-11-15 22:37:12.000000000 +0100
@@ -352,7 +352,6 @@
 	shost->can_queue = sht->can_queue;
 	shost->sg_tablesize = sht->sg_tablesize;
 	shost->cmd_per_lun = sht->cmd_per_lun;
-	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
 
Index: linux/include/scsi/scsi_host.h
===================================================================
--- linux.orig/include/scsi/scsi_host.h	2008-11-15 22:37:12.000000000 +0100
+++ linux/include/scsi/scsi_host.h	2008-11-15 22:37:12.000000000 +0100
@@ -417,11 +417,6 @@
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
@@ -590,7 +585,6 @@
 	unsigned long cmd_serial_number;
 	
 	unsigned active_mode:2;
-	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
 	unsigned use_blk_tcq:1;
 
