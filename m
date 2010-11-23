From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/8] target: remove the unused type field in struct se_subsystem_api
Date: Tue, 23 Nov 2010 17:30:59 -0500
Message-ID: <20101123223110.692950619@bombadil.infradead.org>
References: <20101123223053.574330460@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50179 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0KWWbL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 17:31:11 -0500
Content-Disposition: inline; filename=lio-kill-subsystem-type
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_file.c
===================================================================
--- lio-core.orig/drivers/target/target_core_file.c	2010-11-23 22:34:08.624253459 +0100
+++ lio-core/drivers/target/target_core_file.c	2010-11-23 22:44:40.326254018 +0100
@@ -665,7 +665,6 @@ static sector_t fd_get_blocks(struct se_
 static struct se_subsystem_api fileio_template = {
 	.name			= "fileio",
 	.owner			= THIS_MODULE,
-	.type			= FILEIO,
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_PDEV,
 	.attach_hba		= fd_attach_hba,
 	.detach_hba		= fd_detach_hba,
Index: lio-core/drivers/target/target_core_iblock.c
===================================================================
--- lio-core.orig/drivers/target/target_core_iblock.c	2010-11-23 22:34:08.629253809 +0100
+++ lio-core/drivers/target/target_core_iblock.c	2010-11-23 22:44:40.326254018 +0100
@@ -775,7 +775,6 @@ static void iblock_bio_done(struct bio *
 static struct se_subsystem_api iblock_template = {
 	.name			= "iblock",
 	.owner			= THIS_MODULE,
-	.type			= IBLOCK,
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_PDEV,
 	.map_task_SG		= iblock_map_task_SG,
 	.attach_hba		= iblock_attach_hba,
Index: lio-core/drivers/target/target_core_pscsi.c
===================================================================
--- lio-core.orig/drivers/target/target_core_pscsi.c	2010-11-23 22:34:08.634252901 +0100
+++ lio-core/drivers/target/target_core_pscsi.c	2010-11-23 22:44:40.330253948 +0100
@@ -1293,7 +1293,6 @@ static void pscsi_req_done(struct reques
 static struct se_subsystem_api pscsi_template = {
 	.name			= "pscsi",
 	.owner			= THIS_MODULE,
-	.type			= PSCSI,
 	.transport_type		= TRANSPORT_PLUGIN_PHBA_PDEV,
 	.cdb_none		= pscsi_CDB_none,
 	.map_task_non_SG	= pscsi_map_task_non_SG,
Index: lio-core/drivers/target/target_core_rd.c
===================================================================
--- lio-core.orig/drivers/target/target_core_rd.c	2010-11-23 22:34:08.640253390 +0100
+++ lio-core/drivers/target/target_core_rd.c	2010-11-23 22:44:40.334255135 +0100
@@ -1046,7 +1046,6 @@ static sector_t rd_get_blocks(struct se_
 
 static struct se_subsystem_api rd_dr_template = {
 	.name			= "rd_dr",
-	.type			= RAMDISK_DR,
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_VDEV,
 	.attach_hba		= rd_attach_hba,
 	.detach_hba		= rd_detach_hba,
@@ -1070,7 +1069,6 @@ static struct se_subsystem_api rd_dr_tem
 
 static struct se_subsystem_api rd_mcp_template = {
 	.name			= "rd_mcp",
-	.type			= RAMDISK_MCP,
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_VDEV,
 	.attach_hba		= rd_attach_hba,
 	.detach_hba		= rd_detach_hba,
Index: lio-core/drivers/target/target_core_stgt.c
===================================================================
--- lio-core.orig/drivers/target/target_core_stgt.c	2010-11-23 22:34:08.646253040 +0100
+++ lio-core/drivers/target/target_core_stgt.c	2010-11-23 22:44:40.339253808 +0100
@@ -592,7 +592,6 @@ static int stgt_transfer_response(struct
 static struct se_subsystem_api stgt_template = {
 	.name			= "stgt",
 	.owner			= THIS_MODULE,
-	.type			= STGT,
 	.transport_type		= TRANSPORT_PLUGIN_VHBA_PDEV,
 	.attach_hba		= stgt_attach_hba,
 	.detach_hba		= stgt_detach_hba,
Index: lio-core/include/target/target_core_transport.h
===================================================================
--- lio-core.orig/include/target/target_core_transport.h	2010-11-23 22:38:54.534253179 +0100
+++ lio-core/include/target/target_core_transport.h	2010-11-23 22:44:40.345253738 +0100
@@ -224,10 +224,6 @@ struct se_subsystem_api {
 	 */
 	char name[16];
 	/*
-	 * Plugin Type.
-	 */
-	u8 type;
-	/*
 	 * Transport Type.
 	 */
 	u8 transport_type;
Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2010-11-23 22:37:25.121253389 +0100
+++ lio-core/drivers/target/target_core_transport.c	2010-11-23 22:44:40.351254018 +0100
@@ -1904,7 +1904,6 @@ struct se_device *transport_add_device_t
 
 	dev->dev_flags		= device_flags;
 	dev->dev_status		|= TRANSPORT_DEVICE_DEACTIVATED;
-	dev->type		= transport->type;
 	dev->dev_ptr		= (void *) transport_dev;
 	dev->se_hba		= hba;
 	dev->se_sub_dev		= se_dev;
Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2010-11-23 22:37:20.333253110 +0100
+++ lio-core/include/target/target_core_base.h	2010-11-23 22:44:40.367272805 +0100
@@ -132,20 +132,6 @@ enum se_cmd_flags_table {
 	SCF_EMULATE_SYNC_UNMAP		= 0x04000000
 };
 	
-/* struct se_device->type for known subsystem plugins */
-enum se_device_type_table {
-	PSCSI		= 1,
-	STGT		= 2,
-	PATA		= 3,
-	IBLOCK		= 4,
-	RAMDISK_DR	= 5,
-	RAMDISK_MCP	= 6,
-	FILEIO		= 7,
-	VROM		= 8,
-	VTAPE		= 9,
-	MEDIA_CHANGER	= 10,
-};
-
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
 enum transport_lunflags_table {
 	TRANSPORT_LUNFLAGS_NO_ACCESS		= 0x00,
@@ -766,8 +752,6 @@ struct se_subsystem_dev {
 #define T10_PR_OPS(su_dev)	(&(su_dev)->t10_reservation.pr_ops)
 
 struct se_device {
-	/* Type of disk transport used for device, see se_device_type_table */
-	enum se_device_type_table type;
 	/* Set to 1 if thread is NOT sleeping on thread_sem */
 	u8			thread_active;
 	u8			dev_status_timer_flags;

