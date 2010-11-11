From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] target: remove dead DF_* flags
Date: Thu, 11 Nov 2010 05:40:57 -0500
Message-ID: <20101111104056.GB21472@infradead.org>
References: <20101111104040.GA21472@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34423 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab0KKKk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 05:40:57 -0500
Content-Disposition: inline
In-Reply-To: <20101111104040.GA21472@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core-2.6/drivers/target/target_core_iblock.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_iblock.c	2010-11-11 11:32:33.198165135 +0100
+++ lio-core-2.6/drivers/target/target_core_iblock.c	2010-11-11 11:33:55.878165135 +0100
@@ -180,7 +180,6 @@ static struct se_device *iblock_create_v
 	dev_limits.hw_queue_depth = IBLOCK_MAX_DEVICE_QUEUE_DEPTH;
 	dev_limits.queue_depth = IBLOCK_DEVICE_QUEUE_DEPTH;
 
-	dev_flags = DF_CLAIMED_BLOCKDEV;
 	ib_dev->ibd_major = MAJOR(bd->bd_dev);
 	ib_dev->ibd_minor = MINOR(bd->bd_dev);
 	ib_dev->ibd_bd = bd;
Index: lio-core-2.6/drivers/target/target_core_rd.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_rd.c	2010-11-11 11:32:33.214831800 +0100
+++ lio-core-2.6/drivers/target/target_core_rd.c	2010-11-11 11:33:55.878165135 +0100
@@ -272,9 +272,6 @@ static struct se_device *rd_create_virtd
 
 	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
 
-	if (rd_dev->rd_direct)
-		dev_flags |= DF_TRANSPORT_DMA_ALLOC;
-
 	if (rd_build_device_space(rd_dev) < 0)
 		goto fail;
 
Index: lio-core-2.6/drivers/target/target_core_transport.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_transport.c	2010-11-11 11:32:57.781498467 +0100
+++ lio-core-2.6/drivers/target/target_core_transport.c	2010-11-11 11:33:55.881498468 +0100
@@ -1983,13 +1983,6 @@ static void core_setup_task_attr_emulati
 		TRANSPORT(dev)->get_device_rev(dev));
 }
 
-/*	transport_add_device_to_core_hba():
- *
- *	Note that some plugins (IBLOCK) will pass device_flags ==
- *	DF_CLAIMED_BLOCKDEV signifying OS that a dependent block_device
- *	has been claimed.  In exception cases we will release said
- *	block_device ourselves.
- */
 struct se_device *transport_add_device_to_core_hba(
 	struct se_hba *hba,
 	struct se_subsystem_api *transport,
Index: lio-core-2.6/include/target/target_core_transport.h
===================================================================
--- lio-core-2.6.orig/include/target/target_core_transport.h	2010-11-11 11:32:57.788165135 +0100
+++ lio-core-2.6/include/target/target_core_transport.h	2010-11-11 11:34:28.824831800 +0100
@@ -59,16 +59,9 @@
 /*
  * struct se_device->dev_flags
  */
-#define DF_READAHEAD_ACTIVE                     0x00000001
-#define DF_TRANSPORT_DMA_ALLOC			0x00000002
-#define DF_TRANSPORT_BUF_ALLOC			0x00000004
-#define DF_DEV_DEBUG				0x00000008
-#define DF_CLAIMED_BLOCKDEV			0x00000010
-#define DF_PERSISTENT_CLAIMED_BLOCKDEV		0x00000020
-#define DF_READ_ONLY				0x00000040
-#define DF_SPC3_PERSISTENT_RESERVE		0x00000080
-#define DF_SPC2_RESERVATIONS			0x00000100
-#define DF_SPC2_RESERVATIONS_WITH_ISID		0x00000200
+#define DF_READ_ONLY				0x00000001
+#define DF_SPC2_RESERVATIONS			0x00000002
+#define DF_SPC2_RESERVATIONS_WITH_ISID		0x00000004
 
 /*
  * Used as return values from transport_generic_cmd_sequencer()
