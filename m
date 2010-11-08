From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 9/9] target: remove dead call to transport_emulate_control_cdb in rd driver
Date: Mon, 08 Nov 2010 10:56:10 -0500
Message-ID: <20101108155649.134552948@canuck.infradead.org>
References: <20101108155601.872926000@canuck.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([134.117.69.58]:44180 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab0KHP4t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 10:56:49 -0500
Content-Disposition: inline; filename=lio-mark-target_core_transport-static
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

We'll never reach a non-pscsi backend for non-data CDBs these days.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core-2.6/drivers/target/target_core_rd.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_rd.c	2010-11-08 16:31:38.968196346 +0100
+++ lio-core-2.6/drivers/target/target_core_rd.c	2010-11-08 16:31:42.041529681 +0100
@@ -972,9 +972,6 @@ static int rd_DIRECT_allocate_DMA(struct
  */
 static int rd_DIRECT_do_task(struct se_task *task)
 {
-	if (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB))
-		return transport_emulate_control_cdb(task);
-
 	/*
 	 * At this point the locally allocated RD tables have been mapped
 	 * to struct se_mem elements in rd_DIRECT_do_se_mem_map().
Index: lio-core-2.6/drivers/target/target_core_transport.c
===================================================================
--- lio-core-2.6.orig/drivers/target/target_core_transport.c	2010-11-08 16:31:58.868196346 +0100
+++ lio-core-2.6/drivers/target/target_core_transport.c	2010-11-08 16:32:42.158196349 +0100
@@ -209,6 +209,7 @@ static int transport_generic_write_pendi
 static int transport_processing_thread(void *);
 static int transport_new_cmd_obj(struct se_cmd *cmd,
 		struct se_transform_info *ti, int post_execute);
+static int transport_emulate_control_cdb(struct se_task *task);
 
 static char *transport_passthrough_get_fabric_name(void)
 {
@@ -5462,7 +5463,7 @@ static int transport_generic_write_same(
  * Used by TCM subsystem plugins IBLOCK, FILEIO, and RAMDISK as a
  * generic non SCF_SCSI_DATA_SG_IO_CDB ops.
  */
-int transport_emulate_control_cdb(struct se_task *task)
+static int transport_emulate_control_cdb(struct se_task *task)
 {
 	struct se_cmd *cmd = TASK_CMD(task);
 	struct se_device *dev = SE_DEV(cmd);
Index: lio-core-2.6/include/target/target_core_transport.h
===================================================================
--- lio-core-2.6.orig/include/target/target_core_transport.h	2010-11-08 16:31:49.168196346 +0100
+++ lio-core-2.6/include/target/target_core_transport.h	2010-11-08 16:31:51.141529681 +0100
@@ -232,7 +232,6 @@ extern int transport_generic_emulate_mod
 extern int transport_generic_emulate_request_sense(struct se_cmd *,
 						   unsigned char *);
 extern int transport_get_sense_data(struct se_cmd *);
-extern int transport_emulate_control_cdb(struct se_task *);
 extern struct se_cmd *transport_allocate_passthrough(unsigned char *, int, u32,
 						void *, u32, u32, void *);
 extern void transport_passthrough_release(struct se_cmd *);

