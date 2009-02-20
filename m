From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/7] [Target_Core_Mod/IBLOCK]: Add 4k sector/block size
	emulation support
Date: Fri, 20 Feb 2009 00:03:17 -0800
Message-ID: <1235116997.12375.1041.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n4a.bullet.sp1.yahoo.com ([69.147.64.182]:22913 "HELO
	n4a.bullet.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752388AbZBTIGG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Feb 2009 03:06:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Alan Stern <stern@rowland.harvard.edu>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>

>From 55077269eecb5b7743bfbbb303547bcb029a91db Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 19 Feb 2009 19:37:51 -0800
Subject: [PATCH 4/7] [Target_Core_Mod/IBLOCK]: Add 4k sector/block size emulation support

This patch adds support for 4k (and all non 512 byte) sector sizes for the
Target_Core_Mod/ConfigFS interaction with Linux/Block struct block_device objects.

This patch adds iblock_emulate_read_cap_with_block_size() to generate
the total unsigned long long block count for READ_CAPACITY and READ_CAPACITY_16.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_iblock.c |  101 +++++++++++++++++++++++++++++++--
 drivers/lio-core/target_core_iblock.h |    1 -
 2 files changed, 95 insertions(+), 7 deletions(-)

diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index d71d766..bbb8e73 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -365,25 +365,109 @@ static int iblock_emulate_inquiry (se_task_t *task)
 	       se_location));
 }
 
+static unsigned long long iblock_emulate_read_cap_with_block_size (
+	se_device_t *dev,
+	struct block_device *bd,
+	struct request_queue *q)
+{
+	unsigned long long blocks_long = (get_capacity(bd->bd_disk) - 1);
+
+	if (q->hardsect_size == DEV_ATTRIB(dev)->block_size)
+		return(blocks_long);
+
+	switch (q->hardsect_size) {
+	case 4096:
+		switch (DEV_ATTRIB(dev)->block_size) {
+		case 2048:
+			blocks_long <<= 1;
+			break;	
+		case 1024:
+			blocks_long <<= 2;
+			break;
+		case 512:
+			blocks_long <<= 3;
+		default:
+			break;
+		}
+		break;
+	case 2048:
+		switch (DEV_ATTRIB(dev)->block_size) {
+		case 4096:
+			blocks_long >>= 1;
+			break;
+		case 1024:
+			blocks_long <<= 1;
+			break;
+		case 512:
+			blocks_long <<= 2;
+			break;
+		default:
+			break;
+		}
+		break;
+	case 1024:
+		switch (DEV_ATTRIB(dev)->block_size) {
+		case 4096:
+			blocks_long >>= 2;
+			break;
+		case 2048:
+			blocks_long >>= 1;
+			break;
+		case 512:
+			blocks_long <<= 1;
+			break;
+		default:
+			break;
+		}
+		break;
+	case 512:
+		switch (DEV_ATTRIB(dev)->block_size) {
+		case 4096:
+			blocks_long >>= 3;
+			break;
+		case 2048:
+			blocks_long >>= 2;
+			break;
+		case 1024:
+			blocks_long >>= 1;
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return(blocks_long);
+}
+
 static int iblock_emulate_read_cap (se_task_t *task)
 {
 	iblock_dev_t *ibd = (iblock_dev_t *) task->se_dev->dev_ptr;
 	struct block_device *bd = ibd->ibd_bd;
-	u32 blocks = (get_capacity(bd->bd_disk) - 1);
+	struct request_queue *q = bdev_get_queue(bd);
+	unsigned long long blocks_long = 0;
+	u32 blocks = 0;
 
-	if ((get_capacity(bd->bd_disk) - 1) >= 0x00000000ffffffff)
+	blocks_long = iblock_emulate_read_cap_with_block_size(task->se_dev, bd, q);
+	if (blocks_long >= 0x00000000ffffffff)
 		blocks = 0xffffffff;
+	else
+		blocks = (u32)blocks_long;
 
-	return(transport_generic_emulate_readcapacity(TASK_CMD(task), blocks, IBLOCK_BLOCKSIZE));
+	return(transport_generic_emulate_readcapacity(TASK_CMD(task), blocks));
 }
 
 static int iblock_emulate_read_cap16 (se_task_t *task)
 {
 	iblock_dev_t *ibd = (iblock_dev_t *) task->se_dev->dev_ptr;
 	struct block_device *bd = ibd->ibd_bd;
-	unsigned long long blocks_long = (get_capacity(bd->bd_disk) - 1);
+	struct request_queue *q = bdev_get_queue(bd);
+	unsigned long long blocks_long;
 
-	return(transport_generic_emulate_readcapacity_16(TASK_CMD(task), blocks_long, IBLOCK_BLOCKSIZE));;
+	blocks_long = iblock_emulate_read_cap_with_block_size(task->se_dev, bd, q);
+	return(transport_generic_emulate_readcapacity_16(TASK_CMD(task), blocks_long));
 }
 
 static int iblock_emulate_scsi_cdb (se_task_t *task)
@@ -831,7 +915,12 @@ extern unsigned char *iblock_get_cdb (se_task_t *task)
 
 extern u32 iblock_get_blocksize (se_device_t *dev)
 {
-	return(IBLOCK_BLOCKSIZE);
+	iblock_dev_t *ibd = (iblock_dev_t *) dev->dev_ptr;
+	struct request_queue *q = bdev_get_queue(ibd->ibd_bd);
+	/*
+	 * Set via blk_queue_hardsect_size() in drivers/scsi/sd.c:sd_read_capacity()
+	 */
+	return(q->hardsect_size);
 }
 
 extern u32 iblock_get_device_rev (se_device_t *dev)
diff --git a/drivers/lio-core/target_core_iblock.h b/drivers/lio-core/target_core_iblock.h
index ea5b8f3..ec00140 100644
--- a/drivers/lio-core/target_core_iblock.h
+++ b/drivers/lio-core/target_core_iblock.h
@@ -30,7 +30,6 @@
 
 #define IBLOCK_VERSION		"v3.0"
 
-#define IBLOCK_BLOCKSIZE	512
 #define IBLOCK_MAX_SECTORS	128
 #define IBLOCK_HBA_QUEUE_DEPTH	512
 #define IBLOCK_DEVICE_QUEUE_DEPTH	32
-- 
1.5.4.1




