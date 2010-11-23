From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/8] target: mark the transport_complete method optional
Date: Tue, 23 Nov 2010 17:31:00 -0500
Message-ID: <20101123223110.999266276@bombadil.infradead.org>
References: <20101123223053.574330460@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0KWWbL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 17:31:11 -0500
Content-Disposition: inline; filename=lio-optional-transport_complete
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_file.c
===================================================================
--- lio-core.orig/drivers/target/target_core_file.c	2010-11-23 22:44:40.326254018 +0100
+++ lio-core/drivers/target/target_core_file.c	2010-11-23 22:44:45.087253459 +0100
@@ -261,15 +261,6 @@ static void fd_free_device(void *p)
 	kfree(fd_dev);
 }
 
-/*	fd_transport_complete(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static int fd_transport_complete(struct se_task *task)
-{
-	return 0;
-}
-
 static inline struct fd_request *FILE_REQ(struct se_task *task)
 {
 	return container_of(task, struct fd_request, fd_task);
@@ -675,7 +666,6 @@ static struct se_subsystem_api fileio_te
 	.fua_write_emulated	= fd_emulated_fua_write,
 	.fua_read_emulated	= fd_emulated_fua_read,
 	.write_cache_emulated	= fd_emulated_write_cache,
-	.transport_complete	= fd_transport_complete,
 	.alloc_task		= fd_alloc_task,
 	.do_task		= fd_do_task,
 	.do_sync_cache		= fd_emulate_sync_cache,
Index: lio-core/drivers/target/target_core_iblock.c
===================================================================
--- lio-core.orig/drivers/target/target_core_iblock.c	2010-11-23 22:44:40.326254018 +0100
+++ lio-core/drivers/target/target_core_iblock.c	2010-11-23 22:44:45.088253739 +0100
@@ -225,11 +225,6 @@ static void iblock_free_device(void *p)
 	kfree(ib_dev);
 }
 
-static int iblock_transport_complete(struct se_task *task)
-{
-	return 0;
-}
-
 static inline struct iblock_req *IBLOCK_REQ(struct se_task *task)
 {
 	return container_of(task, struct iblock_req, ib_task);
@@ -786,7 +781,6 @@ static struct se_subsystem_api iblock_te
 	.fua_write_emulated	= iblock_emulated_fua_write,
 	.fua_read_emulated	= iblock_emulated_fua_read,
 	.write_cache_emulated	= iblock_emulated_write_cache,
-	.transport_complete	= iblock_transport_complete,
 	.alloc_task		= iblock_alloc_task,
 	.do_task		= iblock_do_task,
 	.do_discard		= iblock_do_discard,
Index: lio-core/drivers/target/target_core_rd.c
===================================================================
--- lio-core.orig/drivers/target/target_core_rd.c	2010-11-23 22:44:40.334255135 +0100
+++ lio-core/drivers/target/target_core_rd.c	2010-11-23 22:44:45.096254158 +0100
@@ -324,15 +324,6 @@ static void rd_free_device(void *p)
 	kfree(rd_dev);
 }
 
-/*	rd_transport_complete(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static int rd_transport_complete(struct se_task *task)
-{
-	return 0;
-}
-
 static inline struct rd_request *RD_REQ(struct se_task *task)
 {
 	return container_of(task, struct rd_request, rd_task);
@@ -1052,7 +1043,6 @@ static struct se_subsystem_api rd_dr_tem
 	.allocate_virtdevice	= rd_DIRECT_allocate_virtdevice,
 	.create_virtdevice	= rd_DIRECT_create_virtdevice,
 	.free_device		= rd_free_device,
-	.transport_complete	= rd_transport_complete,
 	.alloc_task		= rd_alloc_task,
 	.do_task		= rd_DIRECT_do_task,
 	.free_task		= rd_free_task,
@@ -1075,7 +1065,6 @@ static struct se_subsystem_api rd_mcp_te
 	.allocate_virtdevice	= rd_MEMCPY_allocate_virtdevice,
 	.create_virtdevice	= rd_MEMCPY_create_virtdevice,
 	.free_device		= rd_free_device,
-	.transport_complete	= rd_transport_complete,
 	.alloc_task		= rd_alloc_task,
 	.do_task		= rd_MEMCPY_do_task,
 	.free_task		= rd_free_task,
Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2010-11-23 22:44:40.351254018 +0100
+++ lio-core/drivers/target/target_core_transport.c	2010-11-23 22:44:45.101253809 +0100
@@ -1007,20 +1007,18 @@ void transport_complete_task(struct se_t
 	 * Also check for any other post completion work that needs to be
 	 * done by the plugins.
 	 */
-	if (!dev)
-		goto check_task_stop;
-
-	if (TRANSPORT(dev)->transport_complete(task) != 0) {
-		cmd->se_cmd_flags |= SCF_TRANSPORT_TASK_SENSE;
-		task->task_sense = 1;
-		success = 1;
+	if (dev && dev->transport->transport_complete) {
+		if (dev->transport->transport_complete(task) != 0) {
+			cmd->se_cmd_flags |= SCF_TRANSPORT_TASK_SENSE;
+			task->task_sense = 1;
+			success = 1;
+		}
 	}
 
 	/*
 	 * See if we are waiting for outstanding struct se_task
 	 * to complete for an exception condition
 	 */
-check_task_stop:
 	if (atomic_read(&task->task_stop)) {
 		/*
 		 * Decrement T_TASK(cmd)->t_se_count if this task had

