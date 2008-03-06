From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [8/21] Remove random noop unchecked_isa_dma users
Date: Thu,  6 Mar 2008 21:51:28 +0100 (CET)
Message-ID: <20080306205128.9BA7F1B419C@basil.firstfloor.org>
References: <20080306951.147874949@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:53297 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762069AbYCFUvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 15:51:36 -0500
In-Reply-To: <20080306951.147874949@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk


Lots of drivers set it to 0. Remove that. Patch should be a nop.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/arm/acornscsi.c |    1 -
 drivers/scsi/arm/cumana_1.c  |    1 -
 drivers/scsi/dc395x.c        |    1 -
 drivers/scsi/eata_pio.c      |    2 --
 drivers/scsi/hptiop.c        |    1 -
 drivers/scsi/ips.c           |    1 -
 drivers/scsi/mac_scsi.c      |    1 -
 drivers/scsi/scsi_debug.c    |    1 -
 8 files changed, 9 deletions(-)

Index: linux/drivers/scsi/arm/acornscsi.c
===================================================================
--- linux.orig/drivers/scsi/arm/acornscsi.c
+++ linux/drivers/scsi/arm/acornscsi.c
@@ -2983,7 +2983,6 @@ static struct scsi_host_template acornsc
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
-	.unchecked_isa_dma	= 0,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.proc_name		= "acornscsi",
 };
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c
+++ linux/drivers/scsi/arm/cumana_1.c
@@ -222,7 +222,6 @@ static struct scsi_host_template cumanas
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 2,
-	.unchecked_isa_dma	= 0,
 	.use_clustering		= DISABLE_CLUSTERING,
 	.proc_name		= "CumanaSCSI-1",
 };
Index: linux/drivers/scsi/dc395x.c
===================================================================
--- linux.orig/drivers/scsi/dc395x.c
+++ linux/drivers/scsi/dc395x.c
@@ -4761,7 +4761,6 @@ static struct scsi_host_template dc395x_
 	.cmd_per_lun            = DC395x_MAX_CMD_PER_LUN,
 	.eh_abort_handler       = dc395x_eh_abort,
 	.eh_bus_reset_handler   = dc395x_eh_bus_reset,
-	.unchecked_isa_dma      = 0,
 	.use_clustering         = DISABLE_CLUSTERING,
 };
 
Index: linux/drivers/scsi/eata_pio.c
===================================================================
--- linux.orig/drivers/scsi/eata_pio.c
+++ linux/drivers/scsi/eata_pio.c
@@ -815,8 +815,6 @@ static int register_pio_HBA(long base, s
 	else
 		hd->primary = 1;
 
-	sh->unchecked_isa_dma = 0;	/* We can only do PIO */
-
 	hd->next = NULL;	/* build a linked list of all HBAs */
 	hd->prev = last_HBA;
 	if (hd->prev != NULL)
Index: linux/drivers/scsi/hptiop.c
===================================================================
--- linux.orig/drivers/scsi/hptiop.c
+++ linux/drivers/scsi/hptiop.c
@@ -903,7 +903,6 @@ static struct scsi_host_template driver_
 	.eh_device_reset_handler    = hptiop_reset,
 	.eh_bus_reset_handler       = hptiop_reset,
 	.info                       = hptiop_info,
-	.unchecked_isa_dma          = 0,
 	.emulated                   = 0,
 	.use_clustering             = ENABLE_CLUSTERING,
 	.proc_name                  = driver_name,
Index: linux/drivers/scsi/ips.c
===================================================================
--- linux.orig/drivers/scsi/ips.c
+++ linux/drivers/scsi/ips.c
@@ -6842,7 +6842,6 @@ ips_register_scsi(int index)
 	sh->sg_tablesize = sh->hostt->sg_tablesize;
 	sh->can_queue = sh->hostt->can_queue;
 	sh->cmd_per_lun = sh->hostt->cmd_per_lun;
-	sh->unchecked_isa_dma = sh->hostt->unchecked_isa_dma;
 	sh->use_clustering = sh->hostt->use_clustering;
 	sh->max_sectors = 128;
 
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c
+++ linux/drivers/scsi/mac_scsi.c
@@ -592,7 +592,6 @@ static struct scsi_host_template driver_
 	.this_id			= 7,
 	.sg_tablesize			= SG_ALL,
 	.cmd_per_lun			= CMD_PER_LUN,
-	.unchecked_isa_dma		= 0,
 	.use_clustering			= DISABLE_CLUSTERING
 };
 
Index: linux/drivers/scsi/scsi_debug.c
===================================================================
--- linux.orig/drivers/scsi/scsi_debug.c
+++ linux/drivers/scsi/scsi_debug.c
@@ -221,7 +221,6 @@ static struct scsi_host_template sdebug_
 	.sg_tablesize =		256,
 	.cmd_per_lun =		16,
 	.max_sectors =		0xffff,
-	.unchecked_isa_dma = 	0,
 	.use_clustering = 	DISABLE_CLUSTERING,
 	.module =		THIS_MODULE,
 };
