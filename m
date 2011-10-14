From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 37/37] target: remove the ->transport_split_cdb callback in se_cmd
Date: Fri, 14 Oct 2011 00:42:09 +0000
Message-ID: <1318552929-13341-38-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Add a switch statement implementing the CDB LBA/len update directly
in target_get_task_cdb and remove the old ->transport_split_cdb
callback and all its implementations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Makefile                |    1 -
 drivers/target/target_core_cdb.c       |   39 +++++++++++-
 drivers/target/target_core_scdb.c      |  105 --------------------------------
 drivers/target/target_core_scdb.h      |   10 ---
 drivers/target/target_core_transport.c |   11 ---
 include/target/target_core_base.h      |    1 -
 6 files changed, 36 insertions(+), 131 deletions(-)
 delete mode 100644 drivers/target/target_core_scdb.c
 delete mode 100644 drivers/target/target_core_scdb.h

diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 1060c7b..62e5405 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -6,7 +6,6 @@ target_core_mod-y		:= target_core_configfs.o \
 				   target_core_hba.o \
 				   target_core_pr.o \
 				   target_core_alua.o \
-				   target_core_scdb.o \
 				   target_core_tmr.o \
 				   target_core_tpg.o \
 				   target_core_transport.o \
diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index fb0b630..575cf72 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1273,11 +1273,44 @@ transport_emulate_control_cdb(struct se_task *task)
 void target_get_task_cdb(struct se_task *task, unsigned char *cdb)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
+	unsigned int cdb_len = scsi_command_size(cmd->t_task_cdb);
 
-	memcpy(cdb, cmd->t_task_cdb, scsi_command_size(cmd->t_task_cdb));
+	memcpy(cdb, cmd->t_task_cdb, cdb_len);
 	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
-		cmd->transport_split_cdb(task->task_lba, task->task_sectors,
-					 cdb);
+		unsigned long long lba = task->task_lba;
+		u32 sectors = task->task_sectors;
+
+		switch (cdb_len) {
+		case 6:
+			/* 21-bit LBA and 8-bit sectors */
+			cdb[1] = (lba >> 16) & 0x1f;
+			cdb[2] = (lba >> 8) & 0xff;
+			cdb[3] = lba & 0xff;
+			cdb[4] = sectors & 0xff;
+			break;
+		case 10:
+			/* 32-bit LBA and 16-bit sectors */
+			put_unaligned_be32(lba, &cdb[2]);
+			put_unaligned_be16(sectors, &cdb[7]);
+			break;
+		case 12:
+			/* 32-bit LBA and 32-bit sectors */
+			put_unaligned_be32(lba, &cdb[2]);
+			put_unaligned_be32(sectors, &cdb[6]);
+			break;
+		case 16:
+			/* 64-bit LBA and 32-bit sectors */
+			put_unaligned_be64(lba, &cdb[2]);
+			put_unaligned_be32(sectors, &cdb[10]);
+			break;
+		case 32:
+			/* 64-bit LBA and 32-bit sectors, extended CDB */
+			put_unaligned_be64(lba, &cdb[12]);
+			put_unaligned_be32(sectors, &cdb[28]);
+			break;
+		default:
+			BUG();
+		}
 	}
 }
 EXPORT_SYMBOL(target_get_task_cdb);
diff --git a/drivers/target/target_core_scdb.c b/drivers/target/target_core_scdb.c
deleted file mode 100644
index 7284344..0000000
--- a/drivers/target/target_core_scdb.c
+++ /dev/null
@@ -1,105 +0,0 @@
-/*******************************************************************************
- * Filename:  target_core_scdb.c
- *
- * This file contains the generic target engine Split CDB related functions.
- *
- * Copyright (c) 2004-2005 PyX Technologies, Inc.
- * Copyright (c) 2005, 2006, 2007 SBE, Inc.
- * Copyright (c) 2007-2010 Rising Tide Systems
- * Copyright (c) 2008-2010 Linux-iSCSI.org
- *
- * Nicholas A. Bellinger <nab@kernel.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- ******************************************************************************/
-
-#include <linux/net.h>
-#include <linux/string.h>
-#include <scsi/scsi.h>
-#include <asm/unaligned.h>
-
-#include <target/target_core_base.h>
-#include <target/target_core_transport.h>
-
-#include "target_core_scdb.h"
-
-/*	split_cdb_XX_6():
- *
- *      21-bit LBA w/ 8-bit SECTORS
- */
-void split_cdb_XX_6(
-	unsigned long long lba,
-	u32 sectors,
-	unsigned char *cdb)
-{
-	cdb[1] = (lba >> 16) & 0x1f;
-	cdb[2] = (lba >> 8) & 0xff;
-	cdb[3] = lba & 0xff;
-	cdb[4] = sectors & 0xff;
-}
-
-/*	split_cdb_XX_10():
- *
- *	32-bit LBA w/ 16-bit SECTORS
- */
-void split_cdb_XX_10(
-	unsigned long long lba,
-	u32 sectors,
-	unsigned char *cdb)
-{
-	put_unaligned_be32(lba, &cdb[2]);
-	put_unaligned_be16(sectors, &cdb[7]);
-}
-
-/*	split_cdb_XX_12():
- *
- *	32-bit LBA w/ 32-bit SECTORS
- */
-void split_cdb_XX_12(
-	unsigned long long lba,
-	u32 sectors,
-	unsigned char *cdb)
-{
-	put_unaligned_be32(lba, &cdb[2]);
-	put_unaligned_be32(sectors, &cdb[6]);
-}
-
-/*	split_cdb_XX_16():
- *
- *	64-bit LBA w/ 32-bit SECTORS
- */
-void split_cdb_XX_16(
-	unsigned long long lba,
-	u32 sectors,
-	unsigned char *cdb)
-{
-	put_unaligned_be64(lba, &cdb[2]);
-	put_unaligned_be32(sectors, &cdb[10]);
-}
-
-/*
- *	split_cdb_XX_32():
- *
- * 	64-bit LBA w/ 32-bit SECTORS such as READ_32, WRITE_32 and emulated XDWRITEREAD_32
- */
-void split_cdb_XX_32(
-	unsigned long long lba,
-	u32 sectors,
-	unsigned char *cdb)
-{
-	put_unaligned_be64(lba, &cdb[12]);
-	put_unaligned_be32(sectors, &cdb[28]);
-}
diff --git a/drivers/target/target_core_scdb.h b/drivers/target/target_core_scdb.h
deleted file mode 100644
index 48e9ccc..0000000
--- a/drivers/target/target_core_scdb.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef TARGET_CORE_SCDB_H
-#define TARGET_CORE_SCDB_H
-
-extern void split_cdb_XX_6(unsigned long long, u32, unsigned char *);
-extern void split_cdb_XX_10(unsigned long long, u32, unsigned char *);
-extern void split_cdb_XX_12(unsigned long long, u32, unsigned char *);
-extern void split_cdb_XX_16(unsigned long long, u32, unsigned char *);
-extern void split_cdb_XX_32(unsigned long long, u32, unsigned char *);
-
-#endif /* TARGET_CORE_SCDB_H */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3025a6f..cb022a1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -54,7 +54,6 @@
 #include "target_core_alua.h"
 #include "target_core_hba.h"
 #include "target_core_pr.h"
-#include "target_core_scdb.h"
 #include "target_core_ua.h"
 
 static int sub_api_initialized;
@@ -2851,7 +2850,6 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
-		cmd->transport_split_cdb = &split_cdb_XX_6;
 		cmd->t_task_lba = transport_lba_21(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
@@ -2860,7 +2858,6 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
-		cmd->transport_split_cdb = &split_cdb_XX_10;
 		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
@@ -2869,7 +2866,6 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
-		cmd->transport_split_cdb = &split_cdb_XX_12;
 		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
@@ -2878,7 +2874,6 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
-		cmd->transport_split_cdb = &split_cdb_XX_16;
 		cmd->t_task_lba = transport_lba_64(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
@@ -2887,7 +2882,6 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
-		cmd->transport_split_cdb = &split_cdb_XX_6;
 		cmd->t_task_lba = transport_lba_21(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
@@ -2896,7 +2890,6 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
-		cmd->transport_split_cdb = &split_cdb_XX_10;
 		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->t_tasks_fua = (cdb[1] & 0x8);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
@@ -2906,7 +2899,6 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
-		cmd->transport_split_cdb = &split_cdb_XX_12;
 		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->t_tasks_fua = (cdb[1] & 0x8);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
@@ -2916,7 +2908,6 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
-		cmd->transport_split_cdb = &split_cdb_XX_16;
 		cmd->t_task_lba = transport_lba_64(cdb);
 		cmd->t_tasks_fua = (cdb[1] & 0x8);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
@@ -2929,7 +2920,6 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
-		cmd->transport_split_cdb = &split_cdb_XX_10;
 		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		passthrough = (dev->transport->transport_type ==
@@ -2964,7 +2954,6 @@ static int transport_generic_cmd_sequencer(
 			 * Use WRITE_32 and READ_32 opcodes for the emulated
 			 * XDWRITE_READ_32 logic.
 			 */
-			cmd->transport_split_cdb = &split_cdb_XX_32;
 			cmd->t_task_lba = transport_lba_64_ext(cdb);
 			cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index a6c2348..16d7a49 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -470,7 +470,6 @@ struct se_cmd {
 	struct list_head	se_queue_node;
 	struct target_core_fabric_ops *se_tfo;
 	int (*transport_emulate_cdb)(struct se_cmd *);
-	void (*transport_split_cdb)(unsigned long long, u32, unsigned char *);
 	void (*transport_complete_callback)(struct se_cmd *);
 	int (*transport_qf_callback)(struct se_cmd *);
 
-- 
1.5.6.5
