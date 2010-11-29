From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] target: remove unused get_dma_length subsystem method
Date: Mon, 29 Nov 2010 16:57:34 -0500
Message-ID: <20101129215734.GA19703@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33565 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0K2V5f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2010 16:57:35 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_file.c
===================================================================
--- lio-core.orig/drivers/target/target_core_file.c	2010-11-29 19:33:01.688023888 +0100
+++ lio-core/drivers/target/target_core_file.c	2010-11-29 19:33:14.165258208 +0100
@@ -635,15 +635,6 @@ static u32 fd_get_device_type(struct se_
 	return TYPE_DISK;
 }
 
-/*	fd_get_dma_length(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static u32 fd_get_dma_length(u32 task_size, struct se_device *dev)
-{
-	return PAGE_SIZE;
-}
-
 static sector_t fd_get_blocks(struct se_device *dev)
 {
 	struct fd_dev *fd_dev = dev->dev_ptr;
@@ -676,7 +667,6 @@ static struct se_subsystem_api fileio_te
 	.get_cdb		= fd_get_cdb,
 	.get_device_rev		= fd_get_device_rev,
 	.get_device_type	= fd_get_device_type,
-	.get_dma_length		= fd_get_dma_length,
 	.get_blocks		= fd_get_blocks,
 };
 
Index: lio-core/drivers/target/target_core_iblock.c
===================================================================
--- lio-core.orig/drivers/target/target_core_iblock.c	2010-11-29 19:33:01.695009151 +0100
+++ lio-core/drivers/target/target_core_iblock.c	2010-11-29 19:33:14.165258208 +0100
@@ -705,11 +705,6 @@ static u32 iblock_get_device_type(struct
 	return TYPE_DISK;
 }
 
-static u32 iblock_get_dma_length(u32 task_size, struct se_device *dev)
-{
-	return PAGE_SIZE;
-}
-
 static sector_t iblock_get_blocks(struct se_device *dev)
 {
 	struct iblock_dev *ibd = dev->dev_ptr;
@@ -792,7 +787,6 @@ static struct se_subsystem_api iblock_te
 	.get_cdb		= iblock_get_cdb,
 	.get_device_rev		= iblock_get_device_rev,
 	.get_device_type	= iblock_get_device_type,
-	.get_dma_length		= iblock_get_dma_length,
 	.get_blocks		= iblock_get_blocks,
 };
 
Index: lio-core/drivers/target/target_core_rd.c
===================================================================
--- lio-core.orig/drivers/target/target_core_rd.c	2010-11-29 19:33:01.715003703 +0100
+++ lio-core/drivers/target/target_core_rd.c	2010-11-29 19:33:14.173020046 +0100
@@ -1017,15 +1017,6 @@ static u32 rd_get_device_type(struct se_
 	return TYPE_DISK;
 }
 
-/*	rd_get_dma_length(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static u32 rd_get_dma_length(u32 task_size, struct se_device *dev)
-{
-	return PAGE_SIZE;
-}
-
 static sector_t rd_get_blocks(struct se_device *dev)
 {
 	struct rd_dev *rd_dev = dev->dev_ptr;
@@ -1052,7 +1043,6 @@ static struct se_subsystem_api rd_dr_tem
 	.get_cdb		= rd_get_cdb,
 	.get_device_rev		= rd_get_device_rev,
 	.get_device_type	= rd_get_device_type,
-	.get_dma_length		= rd_get_dma_length,
 	.get_blocks		= rd_get_blocks,
 	.do_se_mem_map		= rd_DIRECT_do_se_mem_map,
 };
@@ -1074,7 +1064,6 @@ static struct se_subsystem_api rd_mcp_te
 	.get_cdb		= rd_get_cdb,
 	.get_device_rev		= rd_get_device_rev,
 	.get_device_type	= rd_get_device_type,
-	.get_dma_length		= rd_get_dma_length,
 	.get_blocks		= rd_get_blocks,
 };
 
Index: lio-core/drivers/target/target_core_stgt.c
===================================================================
--- lio-core.orig/drivers/target/target_core_stgt.c	2010-11-29 19:33:01.724003145 +0100
+++ lio-core/drivers/target/target_core_stgt.c	2010-11-29 19:33:14.177031221 +0100
@@ -514,15 +514,6 @@ static u32 stgt_get_device_type(struct s
 	return sd->type;
 }
 
-/*	stgt_get_dma_length():
- *
- *
- */
-static u32 stgt_get_dma_length(u32 task_size, struct se_device *dev)
-{
-	return PAGE_SIZE;
-}
-
 /*	stgt_handle_SAM_STATUS_failures():
  *
  *
@@ -609,7 +600,6 @@ static struct se_subsystem_api stgt_temp
 	.get_sense_buffer	= stgt_get_sense_buffer,
 	.get_device_rev		= stgt_get_device_rev,
 	.get_device_type	= stgt_get_device_type,
-	.get_dma_length		= stgt_get_dma_length,
 };
 
 static int __init stgt_module_init(void)
Index: lio-core/include/target/target_core_transport.h
===================================================================
--- lio-core.orig/include/target/target_core_transport.h	2010-11-29 19:33:01.676004681 +0100
+++ lio-core/include/target/target_core_transport.h	2010-11-29 19:33:14.182005379 +0100
@@ -342,10 +342,6 @@ struct se_subsystem_api {
 	 */
 	u32 (*get_device_type)(struct se_device *);
 	/*
-	 * get_dma_length():
-	 */
-	u32 (*get_dma_length)(u32, struct se_device *);
-	/*
 	 * Get the sector_t from a subsystem backstore..
 	 */
 	sector_t (*get_blocks)(struct se_device *);
Index: lio-core/drivers/target/target_core_pscsi.c
===================================================================
--- lio-core.orig/drivers/target/target_core_pscsi.c	2010-11-29 19:33:15.180003285 +0100
+++ lio-core/drivers/target/target_core_pscsi.c	2010-11-29 19:33:36.257004472 +0100
@@ -1361,15 +1361,6 @@ static u32 pscsi_get_device_type(struct
 	return sd->type;
 }
 
-/*	pscsi_get_dma_length():
- *
- *
- */
-static u32 pscsi_get_dma_length(u32 task_size, struct se_device *dev)
-{
-	return PAGE_SIZE;
-}
-
 static sector_t pscsi_get_blocks(struct se_device *dev)
 {
 	struct pscsi_dev_virt *pdv = dev->dev_ptr;
@@ -1459,7 +1450,6 @@ static struct se_subsystem_api pscsi_tem
 	.get_sense_buffer	= pscsi_get_sense_buffer,
 	.get_device_rev		= pscsi_get_device_rev,
 	.get_device_type	= pscsi_get_device_type,
-	.get_dma_length		= pscsi_get_dma_length,
 	.get_blocks		= pscsi_get_blocks,
 };
 
