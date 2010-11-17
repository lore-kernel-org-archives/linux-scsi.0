From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] target: simplify cmd transformation
Date: Wed, 17 Nov 2010 16:38:48 -0500
Message-ID: <20101117213847.GA26557@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab0KQVis (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 16:38:48 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

There is no need for the transport_cdb_transform function pointer,
we can simply call the right code based on the cmd flags.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2010-11-16 18:52:11.887253809 +0100
+++ lio-core/drivers/target/target_core_transport.c	2010-11-16 18:55:26.414004751 +0100
@@ -2258,16 +2258,6 @@ static struct se_task *transport_generic
 	return task;
 }
 
-static int transport_process_data_sg_transform(
-	struct se_cmd *cmd,
-	struct se_transform_info *ti)
-{
-	/*
-	 * Already handled in transport_generic_get_cdb_count()
-	 */
-	return 0;
-}
-
 static int transport_do_se_mem_map(struct se_device *, struct se_task *,
 	struct list_head *, void *, struct se_mem *, struct se_mem **,
 	u32 *, u32 *);
@@ -2635,22 +2625,16 @@ int transport_generic_allocate_tasks(
 		DEBUG_CDB_H("Set cdb[0]: 0x%02x to"
 				" SCF_SCSI_CONTROL_SG_IO_CDB\n", cdb[0]);
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
-		cmd->transport_cdb_transform =
-				&transport_process_control_sg_transform;
 		break;
 	case TGCS_CONTROL_NONSG_IO_CDB:
 		DEBUG_CDB_H("Set cdb[0]: 0x%02x to "
 				"SCF_SCSI_CONTROL_NONSG_IO_CDB\n", cdb[0]);
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
-		cmd->transport_cdb_transform =
-				&transport_process_control_nonsg_transform;
 		break;
 	case TGCS_NON_DATA_CDB:
 		DEBUG_CDB_H("Set cdb[0]: 0x%02x to "
 				"SCF_SCSI_NON_DATA_CDB\n", cdb[0]);
 		cmd->se_cmd_flags |= SCF_SCSI_NON_DATA_CDB;
-		cmd->transport_cdb_transform =
-				&transport_process_non_data_transform;
 		break;
 	case TGCS_UNSUPPORTED_CDB:
 		DEBUG_CDB_H("Set cdb[0]: 0x%02x to"
@@ -5280,8 +5264,6 @@ static int transport_new_cmd_obj(
 		}
 		T_TASK(cmd)->t_task_cdbs += task_cdbs;
 
-		cmd->transport_cdb_transform =
-				&transport_process_data_sg_transform;
 #if 0
 		printk(KERN_INFO "data_length: %u, LBA: %llu t_tasks_sectors:"
 			" %u, t_task_cdbs: %u\n", obj_ptr, cmd->data_length,
@@ -6084,13 +6066,16 @@ int transport_generic_new_cmd(struct se_
 		}
 	}
 
-	if (!(cmd->transport_cdb_transform)) {
-		dump_stack();
-		ret = PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
-		goto failure;
-	}
+	if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)
+		ret = transport_process_control_sg_transform(cmd, &ti);
+	else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB)
+		ret = transport_process_control_nonsg_transform(cmd, &ti);
+	else if (cmd->se_cmd_flags & SCF_SCSI_NON_DATA_CDB)
+		ret = transport_process_non_data_transform(cmd, &ti);
+	else
+		BUG_ON(!(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB));
 
-	if (cmd->transport_cdb_transform(cmd, &ti) < 0) {
+	if (ret < 0) {
 		ret = PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
 		goto failure;
 	}
Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2010-11-16 18:52:11.891253040 +0100
+++ lio-core/include/target/target_core_base.h	2010-11-16 18:55:26.415004611 +0100
@@ -574,8 +574,6 @@ struct se_cmd {
 	struct se_transport_task *t_task;
 	struct se_transport_task t_task_backstore;
 	struct target_core_fabric_ops *se_tfo;
-	int (*transport_cdb_transform)(struct se_cmd *,
-					struct se_transform_info *);
 	int (*transport_emulate_cdb)(struct se_cmd *);
 	u32 (*transport_get_lba)(unsigned char *);
 	unsigned long long (*transport_get_long_lba)(unsigned char *);
