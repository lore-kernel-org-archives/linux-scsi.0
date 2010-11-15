From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] target: simplify memory allocation
Date: Mon, 15 Nov 2010 17:32:02 -0500
Message-ID: <20101115223202.GB21114@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60684 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676Ab0KOWcD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 17:32:03 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Whether we allocate a single buffer, an S/G list or nothing really only
depends on the command, and not the backend.  Unify all the allocation
code in a central place, keying of the cmd flags telling if it's an
S/G or linear buffer.  These were matching the function pointers in
all cases except for the WRITE SAME with unmap bit emulation, but that
one doesn't actually look at the payload anyway.

Handle the memory mapped ramdisk special inside the common code by
checking for the presence of a do_se_mem_map method.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2010-11-15 23:15:47.282004124 +0100
+++ lio-core/drivers/target/target_core_transport.c	2010-11-15 23:18:12.928004891 +0100
@@ -3080,14 +3080,8 @@ void transport_generic_request_timeout(s
 	transport_generic_remove(cmd, 0, 0);
 }
 
-/*	transport_generic_allocate_buf():
- *
- *	Called from transport_generic_new_cmd() in Transport Processing Thread.
- */
-int transport_generic_allocate_buf(
-	struct se_cmd *cmd,
-	u32 data_length,
-	u32 dma_size)
+static int
+transport_generic_allocate_buf(struct se_cmd *cmd, u32 data_length)
 {
 	unsigned char *buf;
 
@@ -3103,18 +3097,6 @@ int transport_generic_allocate_buf(
 	return 0;
 }
 
-/*	transport_generic_allocate_none():
- *
- *
- */
-static int transport_generic_allocate_none(
-	struct se_cmd *cmd,
-	u32 data_length,
-	u32 dma_size)
-{
-	return 0;
-}
-
 static inline u32 transport_lba_21(unsigned char *cdb)
 {
 	return ((cdb[1] & 0x1f) << 16) | (cdb[2] << 8) | cdb[3];
@@ -3870,24 +3852,17 @@ int transport_get_sense_data(struct se_c
 	return -1;
 }
 
-static inline void transport_dev_get_mem_buf(
-	struct se_device *dev,
-	struct se_cmd *cmd)
+static int transport_allocate_resources(struct se_cmd *cmd)
 {
-	cmd->transport_allocate_resources = (TRANSPORT(dev)->allocate_buf) ?
-		TRANSPORT(dev)->allocate_buf : &transport_generic_allocate_buf;
-	cmd->transport_free_resources = (TRANSPORT(dev)->free_buf) ?
-		TRANSPORT(dev)->free_buf : NULL;
-}
+	u32 length = cmd->data_length;
 
-static inline void transport_dev_get_mem_SG(
-	struct se_device *dev,
-	struct se_cmd *cmd)
-{
-	cmd->transport_allocate_resources = (TRANSPORT(dev)->allocate_DMA) ?
-		TRANSPORT(dev)->allocate_DMA : &transport_generic_get_mem;
-	cmd->transport_free_resources = (TRANSPORT(dev)->free_DMA) ?
-		TRANSPORT(dev)->free_DMA : NULL;
+	if ((cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
+	    (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB))
+		return transport_generic_get_mem(cmd, length, PAGE_SIZE);
+	else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB)
+		return transport_generic_allocate_buf(cmd, length);
+	else
+		return 0;
 }
 
 /*	transport_generic_cmd_sequencer():
@@ -3963,7 +3938,6 @@ static int transport_generic_cmd_sequenc
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_6;
 		cmd->transport_get_lba = &transport_lba_21;
 		ret = TGCS_DATA_SG_IO_CDB;
@@ -3973,7 +3947,6 @@ static int transport_generic_cmd_sequenc
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
 		cmd->transport_get_lba = &transport_lba_32;
 		ret = TGCS_DATA_SG_IO_CDB;
@@ -3983,7 +3956,6 @@ static int transport_generic_cmd_sequenc
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_12;
 		cmd->transport_get_lba = &transport_lba_32;
 		ret = TGCS_DATA_SG_IO_CDB;
@@ -3993,7 +3965,6 @@ static int transport_generic_cmd_sequenc
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_16;
 		cmd->transport_get_long_lba = &transport_lba_64;
 		ret = TGCS_DATA_SG_IO_CDB;
@@ -4003,7 +3974,6 @@ static int transport_generic_cmd_sequenc
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_6;
 		cmd->transport_get_lba = &transport_lba_21;
 		ret = TGCS_DATA_SG_IO_CDB;
@@ -4013,7 +3983,6 @@ static int transport_generic_cmd_sequenc
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
 		cmd->transport_get_lba = &transport_lba_32;
 		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
@@ -4024,7 +3993,6 @@ static int transport_generic_cmd_sequenc
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_12;
 		cmd->transport_get_lba = &transport_lba_32;
 		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
@@ -4035,7 +4003,6 @@ static int transport_generic_cmd_sequenc
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_16;
 		cmd->transport_get_long_lba = &transport_lba_64;
 		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
@@ -4049,7 +4016,6 @@ static int transport_generic_cmd_sequenc
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
 		cmd->transport_get_lba = &transport_lba_32;
 		passthrough = (TRANSPORT(dev)->transport_type ==
@@ -4081,7 +4047,6 @@ static int transport_generic_cmd_sequenc
 			if (sector_ret)
 				return TGCS_UNSUPPORTED_CDB;
 			size = transport_get_size(sectors, cdb, cmd);
-			transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 			/*
 			 * Use WRITE_32 and READ_32 opcodes for the emulated
 			 * XDWRITE_READ_32 logic.
@@ -4108,7 +4073,6 @@ static int transport_generic_cmd_sequenc
 			if (sector_ret)
 				return TGCS_UNSUPPORTED_CDB;
 			size = transport_get_size(sectors, cdb, cmd);
-			transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 			T_TASK(cmd)->t_task_lba = get_unaligned_be64(&cdb[12]);
 			/*
 			 * Skip the remaining assignments for TCM/PSCSI passthrough
@@ -4159,22 +4123,18 @@ static int transport_generic_cmd_sequenc
 			/* GPCMD_SEND_KEY from multi media commands */
 			size = (cdb[8] << 8) + cdb[9];
 		}
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case MODE_SELECT:
 		size = cdb[4];
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_SG_IO_CDB;
 		break;
 	case MODE_SELECT_10:
 		size = (cdb[7] << 8) + cdb[8];
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_SG_IO_CDB;
 		break;
 	case MODE_SENSE:
 		size = cdb[4];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case MODE_SENSE_10:
@@ -4183,12 +4143,10 @@ static int transport_generic_cmd_sequenc
 	case LOG_SELECT:
 	case LOG_SENSE:
 		size = (cdb[7] << 8) + cdb[8];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case READ_BLOCK_LIMITS:
 		size = READ_BLOCK_LEN;
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case GPCMD_GET_CONFIGURATION:
@@ -4196,7 +4154,6 @@ static int transport_generic_cmd_sequenc
 	case GPCMD_READ_DISC_INFO:
 	case GPCMD_READ_TRACK_RZONE_INFO:
 		size = (cdb[7] << 8) + cdb[8];
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_SG_IO_CDB;
 		break;
 	case PERSISTENT_RESERVE_IN:
@@ -4206,18 +4163,15 @@ static int transport_generic_cmd_sequenc
 			 SPC3_PERSISTENT_RESERVATIONS) ?
 			&core_scsi3_emulate_pr : NULL;
 		size = (cdb[7] << 8) + cdb[8];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case GPCMD_MECHANISM_STATUS:
 	case GPCMD_READ_DVD_STRUCTURE:
 		size = (cdb[8] << 8) + cdb[9];
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_SG_IO_CDB;
 		break;
 	case READ_POSITION:
 		size = READ_POSITION_LEN;
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case 0xa4:
@@ -4240,12 +4194,10 @@ static int transport_generic_cmd_sequenc
 			/* GPCMD_REPORT_KEY from multi media commands */
 			size = (cdb[8] << 8) + cdb[9];
 		}
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case INQUIRY:
 		size = (cdb[3] << 8) + cdb[4];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		/*
 		 * Do implict HEAD_OF_QUEUE processing for INQUIRY.
 		 * See spc4r17 section 5.3
@@ -4256,19 +4208,16 @@ static int transport_generic_cmd_sequenc
 		break;
 	case READ_BUFFER:
 		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case READ_CAPACITY:
 		size = READ_CAP_LEN;
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case READ_MEDIA_SERIAL_NUMBER:
 	case SECURITY_PROTOCOL_IN:
 	case SECURITY_PROTOCOL_OUT:
 		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case SERVICE_ACTION_IN:
@@ -4280,13 +4229,11 @@ static int transport_generic_cmd_sequenc
 	case WRITE_ATTRIBUTE:
 		size = (cdb[10] << 24) | (cdb[11] << 16) |
 		       (cdb[12] << 8) | cdb[13];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
 		size = (cdb[3] << 8) | cdb[4];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 /* #warning FIXME: Figure out correct GPCMD_READ_CD blocksize. */
@@ -4294,28 +4241,23 @@ static int transport_generic_cmd_sequenc
 	case GPCMD_READ_CD:
 		sectors = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
 		size = (2336 * sectors);
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 #endif
 	case READ_TOC:
 		size = cdb[8];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case REQUEST_SENSE:
 		size = cdb[4];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case READ_ELEMENT_STATUS:
 		size = 65536 * cdb[7] + 256 * cdb[8] + cdb[9];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case WRITE_BUFFER:
 		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case RESERVE:
@@ -4329,8 +4271,6 @@ static int transport_generic_cmd_sequenc
 		else
 			size = cmd->data_length;
 
-		cmd->transport_allocate_resources =
-				&transport_generic_allocate_none;
 		/*
 		 * Setup the legacy emulated handler for SPC-2 and
 		 * >= SPC-3 compatible reservation handling (CRH=1)
@@ -4355,8 +4295,6 @@ static int transport_generic_cmd_sequenc
 		else
 			size = cmd->data_length;
 
-		cmd->transport_allocate_resources =
-				&transport_generic_allocate_none;
 		cmd->transport_emulate_cdb =
 				(T10_RES(su_dev)->res_type !=
 				 SPC_PASSTHROUGH) ?
@@ -4365,8 +4303,6 @@ static int transport_generic_cmd_sequenc
 		break;
 	case SYNCHRONIZE_CACHE:
 	case 0x91: /* SYNCHRONIZE_CACHE_16: */
-		cmd->transport_allocate_resources =
-				&transport_generic_allocate_none;
 		/*
 		 * Extract LBA and range to be flushed for emulated SYNCHRONIZE_CACHE
 		 */
@@ -4400,10 +4336,7 @@ static int transport_generic_cmd_sequenc
 			return TGCS_INVALID_CDB_FIELD;
 		break;
 	case UNMAP:
-		cmd->transport_allocate_resources =
-				&transport_generic_allocate_buf;
 		size = get_unaligned_be16(&cdb[7]);
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		passthrough = (TRANSPORT(dev)->transport_type ==
 				TRANSPORT_PLUGIN_PHBA_PDEV);
 		/*
@@ -4419,13 +4352,10 @@ static int transport_generic_cmd_sequenc
 		ret = TGCS_CONTROL_NONSG_IO_CDB;
 		break;
 	case WRITE_SAME_16:
-		cmd->transport_allocate_resources =
-				&transport_generic_allocate_buf;
 		sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
 		if (sector_ret)
 			return TGCS_UNSUPPORTED_CDB;
 		size = transport_get_size(sectors, cdb, cmd);
-		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
 		T_TASK(cmd)->t_task_lba = get_unaligned_be16(&cdb[2]);
 		passthrough = (TRANSPORT(dev)->transport_type ==
 				TRANSPORT_PLUGIN_PHBA_PDEV);
@@ -4469,15 +4399,12 @@ static int transport_generic_cmd_sequenc
 	case VERIFY:
 	case WRITE_FILEMARKS:
 	case MOVE_MEDIUM:
-		cmd->transport_allocate_resources =
-				&transport_generic_allocate_none;
 		ret = TGCS_NON_DATA_CDB;
 		break;
 	case REPORT_LUNS:
 		cmd->transport_emulate_cdb =
 				&transport_core_report_lun_response;
 		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
-		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
 		/*
 		 * Do implict HEAD_OF_QUEUE processing for REPORT_LUNS
 		 * See spc4r17 section 5.3
@@ -4597,8 +4524,7 @@ struct se_cmd *transport_allocate_passth
 	DEBUG_SO("ti.se_obj_ptr: %p\n", ti.se_obj_ptr);
 
 	if (!mem) {
-		if (cmd->transport_allocate_resources(cmd, cmd->data_length,
-					PAGE_SIZE) < 0)
+		if (transport_allocate_resources(cmd) < 0)
 			goto fail;
 	} else {
 		/*
@@ -5023,8 +4949,12 @@ void transport_free_dev_tasks(struct se_
 static inline void transport_free_pages(struct se_cmd *cmd)
 {
 	struct se_mem *se_mem, *se_mem_tmp;
-	int free_page =
-		((cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) == 0);
+	int free_page = 1;
+
+	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)
+		free_page = 0;
+	if (cmd->se_dev->transport->do_se_mem_map)
+		free_page = 0;
 
 	if (T_TASK(cmd)->t_task_buf) {
 		kfree(T_TASK(cmd)->t_task_buf);
@@ -5032,10 +4962,6 @@ static inline void transport_free_pages(
 		return;
 	}
 
-	if (cmd->transport_free_resources) {
-		cmd->transport_free_resources(cmd);
-		return;
-	}
 	/*
 	 * Caller will handle releasing of struct se_mem.
 	 */
@@ -5453,6 +5379,13 @@ int transport_generic_get_mem(struct se_
 	T_TASK(cmd)->t_mem_list = transport_init_se_mem_list();
 	if (!(T_TASK(cmd)->t_mem_list))
 		return -ENOMEM;
+
+	/*
+	 * If the device uses memory mapping this is enough.
+	 */
+	if (cmd->se_dev->transport->do_se_mem_map)
+		return 0;
+
 	/*
 	 * Setup BIDI-COMMAND READ list of struct se_mem elements
 	 */
@@ -6159,9 +6092,7 @@ int transport_generic_new_cmd(struct se_
 		 * T_TASK(cmd)->t_mem_list of struct se_mem->se_page
 		 */
 		if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
-			/* #warning FIXME v3.2: Enable > PAGE_SIZE usage */
-			ret = cmd->transport_allocate_resources(cmd,
-					cmd->data_length, PAGE_SIZE);
+			ret = transport_allocate_resources(cmd);
 			if (ret < 0)
 				goto failure;
 		}
Index: lio-core/include/target/target_core_transport.h
===================================================================
--- lio-core.orig/include/target/target_core_transport.h	2010-11-15 23:15:47.303009432 +0100
+++ lio-core/include/target/target_core_transport.h	2010-11-15 23:16:04.074003356 +0100
@@ -198,7 +198,6 @@ extern void transport_generic_request_fa
 						int, int);
 extern void transport_direct_request_timeout(struct se_cmd *);
 extern void transport_generic_request_timeout(struct se_cmd *);
-extern int transport_generic_allocate_buf(struct se_cmd *, u32, u32);
 extern int __transport_execute_tasks(struct se_device *);
 extern void transport_new_cmd_failure(struct se_cmd *);
 extern void transport_set_supported_SAM_opcode(struct se_cmd *);
@@ -387,22 +386,6 @@ struct se_subsystem_api {
 	int (*transport_complete)(struct se_task *task);
 	struct se_task *(*alloc_task)(struct se_cmd *);
 	/*
-	 * allocate_buf():
-	 */
-	int (*allocate_buf)(struct se_cmd *, u32, u32);
-	/*
-	 * allocate_DMA();
-	 */
-	int (*allocate_DMA)(struct se_cmd *, u32, u32);
-	/*
-	 * free_buf():
-	 */
-	void (*free_buf)(struct se_cmd *);
-	/*
-	 * free_DMA():
-	 */
-	void (*free_DMA)(struct se_cmd *);
-	/*
 	 * do_task():
 	 */
 	int (*do_task)(struct se_task *);
Index: lio-core/drivers/target/target_core_rd.c
===================================================================
--- lio-core.orig/drivers/target/target_core_rd.c	2010-11-15 23:15:47.296003565 +0100
+++ lio-core/drivers/target/target_core_rd.c	2010-11-15 23:16:04.078003635 +0100
@@ -900,11 +900,6 @@ static int rd_DIRECT_do_se_mem_map(
 	 * we setup struct se_task->task_sg[], as it will be used by
 	 * transport_do_task_sg_chain() for creating chainged SGLs
 	 * across multiple struct se_task->task_sg[].
-	 *
-	 * Note that kfree(task->task_sg); does not need to be called
-	 * in rd_DIRECT_free_DMA(), because transport_free_dev_tasks()
-	 * will already be taking care of this for all TCM subsystem
-	 * plugins.
 	 */
 	if (!(transport_calc_sg_num(task,
 			list_entry(T_TASK(cmd)->t_mem_list->next,
@@ -918,49 +913,6 @@ static int rd_DIRECT_do_se_mem_map(
 			out_se_mem, se_mem_cnt, task_offset_in);
 }
 
-/*	rd_DIRECT_free_DMA():
- *
- *
- */
-static void rd_DIRECT_free_DMA(struct se_cmd *cmd)
-{
-	struct se_mem *se_mem, *se_mem_tmp;
-
-	if (!(T_TASK(cmd)->t_mem_list))
-		return;
-	/*
-	 * The scatterlists in the RAMDISK DIRECT case are using the pages
-	 * from the rd_device_t's scatterlist table. They are referencing
-	 * valid memory that is held within the RD transport plugin, so we
-	 * only free the struct se_mem elements.
-	 */
-	list_for_each_entry_safe(se_mem, se_mem_tmp, T_TASK(cmd)->t_mem_list,
-				se_list) {
-		 list_del(&se_mem->se_list);
-		 kmem_cache_free(se_mem_cache, se_mem);
-	}
-	kfree(T_TASK(cmd)->t_mem_list);
-	T_TASK(cmd)->t_mem_list = NULL;
-	T_TASK(cmd)->t_tasks_se_num = 0;
-}
-
-/*	rd_DIRECT_allocate_DMA():
- *
- *	Note that rd_DIRECT_do_se_mem_map() actually does the real work.
- */
-static int rd_DIRECT_allocate_DMA(struct se_cmd *cmd, u32 length, u32 dma_size)
-{
-	T_TASK(cmd)->t_mem_list = kzalloc(sizeof(struct list_head), GFP_KERNEL);
-	if (!(T_TASK(cmd)->t_mem_list)) {
-		printk(KERN_ERR "Unable to allocate memory for T_TASK(cmd)"
-				"->t_mem_list\n");
-		return -1;
-	}
-	INIT_LIST_HEAD(T_TASK(cmd)->t_mem_list);
-
-	return 0;
-}
-
 /*	rd_DIRECT_do_task(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1263,8 +1215,6 @@ static struct se_subsystem_api rd_dr_tem
 	.create_virtdevice	= rd_DIRECT_create_virtdevice,
 	.free_device		= rd_free_device,
 	.transport_complete	= rd_transport_complete,
-	.allocate_DMA		= rd_DIRECT_allocate_DMA,
-	.free_DMA		= rd_DIRECT_free_DMA,
 	.alloc_task		= rd_alloc_task,
 	.do_task		= rd_DIRECT_do_task,
 	.free_task		= rd_free_task,
Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2010-11-15 23:15:47.313003914 +0100
+++ lio-core/include/target/target_core_base.h	2010-11-15 23:16:04.082003425 +0100
@@ -573,11 +573,9 @@ struct se_cmd {
 	struct se_transport_task *t_task;
 	struct se_transport_task t_task_backstore;
 	struct target_core_fabric_ops *se_tfo;
-	int (*transport_allocate_resources)(struct se_cmd *, u32, u32);
 	int (*transport_cdb_transform)(struct se_cmd *,
 					struct se_transform_info *);
 	int (*transport_emulate_cdb)(struct se_cmd *);
-	void (*transport_free_resources)(struct se_cmd *);
 	u32 (*transport_get_lba)(unsigned char *);
 	unsigned long long (*transport_get_long_lba)(unsigned char *);
 	void (*transport_passthrough_done)(struct se_cmd *);
