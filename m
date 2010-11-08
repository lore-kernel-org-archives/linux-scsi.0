From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/9] target: remove never changing indirections in
	se_cmd
Date: Mon, 08 Nov 2010 13:57:24 -0800
Message-ID: <1289253444.27226.69.camel@haakon2.linux-iscsi.org>
References: <20101108155601.872926000@canuck.infradead.org>
	 <20101108155646.884985268@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52432 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab0KHWCh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 17:02:37 -0500
In-Reply-To: <20101108155646.884985268@canuck.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-08 at 10:56 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-cleanup-transform)
> De-virtualize various function pointers in struct se_cmd that never change, and
> remove the transport_add_cmd_to_dev_queue wrapper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Committed as bf8b39d.  Thanks for taking care of this long overdue
cleanup of this legacy cruft..

--nab

> Index: lio-core-2.6/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_transport.c	2010-11-06 19:54:02.380003811 +0100
> +++ lio-core-2.6/drivers/target/target_core_transport.c	2010-11-06 20:17:24.519255311 +0100
> @@ -207,6 +207,8 @@ typedef int (*map_func_t)(struct se_task
>  
>  static int transport_generic_write_pending(struct se_cmd *);
>  static int transport_processing_thread(void *);
> +static int transport_new_cmd_obj(struct se_cmd *cmd,
> +		struct se_transform_info *ti, int post_execute);
>  
>  static char *transport_passthrough_get_fabric_name(void)
>  {
> @@ -1036,9 +1038,10 @@ void transport_cmd_finish_abort_tmr(stru
>  
>  int transport_add_cmd_to_queue(
>  	struct se_cmd *cmd,
> -	struct se_queue_obj *qobj,
>  	int t_state)
>  {
> +	struct se_device *dev = cmd->se_dev;
> +	struct se_queue_obj *qobj = dev->dev_queue_obj;
>  	struct se_queue_req *qr;
>  	unsigned long flags;
>  
> @@ -1070,13 +1073,6 @@ int transport_add_cmd_to_queue(
>  	return 0;
>  }
>  
> -static int transport_add_cmd_to_dev_queue(struct se_cmd *cmd, int t_state)
> -{
> -	struct se_device *dev = cmd->se_dev;
> -
> -	return transport_add_cmd_to_queue(cmd, dev->dev_queue_obj, t_state);
> -}
> -
>  /*
>   * Called with struct se_queue_obj->cmd_queue_lock held.
>   */
> @@ -1173,7 +1169,7 @@ void transport_complete_cmd(struct se_cm
>  	atomic_set(&T_TASK(cmd)->t_transport_complete, 1);
>  	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
>  
> -	cmd->transport_add_cmd_to_queue(cmd, t_state);
> +	transport_add_cmd_to_queue(cmd, t_state);
>  }
>  
>  /*
> @@ -1272,7 +1268,7 @@ check_task_stop:
>  		t_state = TRANSPORT_COMPLETE_TIMEOUT;
>  		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
>  
> -		cmd->transport_add_cmd_to_queue(cmd, t_state);
> +		transport_add_cmd_to_queue(cmd, t_state);
>  		return;
>  	}
>  	atomic_dec(&T_TASK(cmd)->t_task_cdbs_timeout_left);
> @@ -1315,7 +1311,7 @@ check_task_stop:
>  	}
>  	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
>  
> -	cmd->transport_add_cmd_to_queue(cmd, t_state);
> +	transport_add_cmd_to_queue(cmd, t_state);
>  }
>  EXPORT_SYMBOL(transport_complete_task);
>  
> @@ -1457,7 +1453,8 @@ void transport_add_tasks_from_cmd(struct
>   *
>   *	Called with dev->execute_task_lock held.
>   */
> -struct se_task *transport_get_task_from_execute_queue(struct se_device *dev)
> +static struct se_task *
> +transport_get_task_from_execute_queue(struct se_device *dev)
>  {
>  	struct se_task *task;
>  
> @@ -2604,8 +2601,8 @@ static int transport_process_control_sg_
>  		return -1;
>  	}
>  
> -	task = cmd->transport_get_task(ti, cmd, ti->se_obj_ptr,
> -				cmd->data_direction);
> +	task = transport_generic_get_task(ti, cmd, ti->se_obj_ptr,
> +					  cmd->data_direction);
>  	if (!(task))
>  		return -1;
>  
> @@ -2646,8 +2643,8 @@ static int transport_process_control_non
>  	unsigned char *cdb;
>  	struct se_task *task;
>  
> -	task = cmd->transport_get_task(ti, cmd, ti->se_obj_ptr,
> -				cmd->data_direction);
> +	task = transport_generic_get_task(ti, cmd, ti->se_obj_ptr,
> +					  cmd->data_direction);
>  	if (!(task))
>  		return -1;
>  
> @@ -2682,8 +2679,8 @@ static int transport_process_non_data_tr
>  	unsigned char *cdb;
>  	struct se_task *task;
>  
> -	task = cmd->transport_get_task(ti, cmd, ti->se_obj_ptr,
> -				cmd->data_direction);
> +	task = transport_generic_get_task(ti, cmd, ti->se_obj_ptr,
> +					  cmd->data_direction);
>  	if (!(task))
>  		return -1;
>  
> @@ -2709,7 +2706,6 @@ static int transport_generic_cmd_sequenc
>  
>  void transport_device_setup_cmd(struct se_cmd *cmd)
>  {
> -	cmd->transport_add_cmd_to_queue = &transport_add_cmd_to_dev_queue;
>  	cmd->se_dev = SE_LUN(cmd)->lun_se_dev;
>  }
>  EXPORT_SYMBOL(transport_device_setup_cmd);
> @@ -3018,7 +3014,7 @@ int transport_generic_handle_cdb(
>  		return -1;
>  	}
>  
> -	cmd->transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD);
> +	transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD);
>  	return 0;
>  }
>  EXPORT_SYMBOL(transport_generic_handle_cdb);
> @@ -3034,7 +3030,7 @@ int transport_generic_handle_data(
>  	 * Make sure that the transport has been disabled by
>  	 * transport_write_pending() before readding this struct se_cmd to the
>  	 * processing queue.  If it has not yet been reset to zero by the
> -	 * processing thread in cmd->transport_add_cmd_to_queue(), let other
> +	 * processing thread in transport_add_cmd_to_queue(), let other
>  	 * processes run.  If a signal was received, then we assume the
>  	 * connection is being failed/shutdown, so we return a failure.
>  	 */
> @@ -3053,7 +3049,7 @@ int transport_generic_handle_data(
>  	if (transport_check_aborted_status(cmd, 1) != 0)
>  		return 0;
>  
> -	cmd->transport_add_cmd_to_queue(cmd, TRANSPORT_PROCESS_WRITE);
> +	transport_add_cmd_to_queue(cmd, TRANSPORT_PROCESS_WRITE);
>  	return 0;
>  }
>  EXPORT_SYMBOL(transport_generic_handle_data);
> @@ -3071,7 +3067,7 @@ int transport_generic_handle_tmr(
>  	cmd->transport_wait_for_tasks = &transport_generic_wait_for_tasks;
>  	transport_device_setup_cmd(cmd);
>  
> -	cmd->transport_add_cmd_to_queue(cmd, TRANSPORT_PROCESS_TMR);
> +	transport_add_cmd_to_queue(cmd, TRANSPORT_PROCESS_TMR);
>  	return 0;
>  }
>  EXPORT_SYMBOL(transport_generic_handle_tmr);
> @@ -3600,11 +3596,7 @@ static void iscsi_check_iovec_map(
>  #define iscsi_check_iovec_map(a, b, c, d)
>  #endif
>  
> -/*	transport_generic_set_iovec_ptrs():
> - *
> - *
> - */
> -static int transport_generic_set_iovec_ptrs(
> +int transport_generic_set_iovec_ptrs(
>  	struct se_map_sg *map_sg,
>  	struct se_unmap_sg *unmap_sg)
>  {
> @@ -3732,6 +3724,7 @@ static int transport_generic_set_iovec_p
>  
>  	return i;
>  }
> +EXPORT_SYMBOL(transport_generic_set_iovec_ptrs);
>  
>  /*	transport_generic_allocate_buf():
>   *
> @@ -3914,7 +3907,7 @@ void transport_task_timeout_handler(unsi
>  	cmd->t_state = TRANSPORT_COMPLETE_FAILURE;
>  	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
>  
> -	cmd->transport_add_cmd_to_queue(cmd, TRANSPORT_COMPLETE_FAILURE);
> +	transport_add_cmd_to_queue(cmd, TRANSPORT_COMPLETE_FAILURE);
>  }
>  
>  u32 transport_get_default_task_timeout(struct se_device *dev)
> @@ -4285,7 +4278,6 @@ void transport_new_cmd_failure(struct se
>  	CMD_TFO(se_cmd)->new_cmd_failure(se_cmd);
>  }
>  
> -static int transport_generic_map_buffers_to_tasks(struct se_cmd *);
>  static void transport_nop_wait_for_tasks(struct se_cmd *, int, int);
>  
>  static inline u32 transport_get_sectors_6(
> @@ -5683,18 +5675,6 @@ static inline void transport_dev_get_mem
>  		TRANSPORT(dev)->free_DMA : NULL;
>  }
>  
> -/*
> - * Generic function pointers for target_core_mod/ConfigFS
> - */
> -#define SET_GENERIC_TRANSPORT_FUNCTIONS(cmd)				\
> -do {									\
> -	cmd->transport_get_task = &transport_generic_get_task;		\
> -	cmd->transport_map_buffers_to_tasks =				\
> -			&transport_generic_map_buffers_to_tasks;	\
> -	cmd->transport_set_iovec_ptrs =					\
> -			&transport_generic_set_iovec_ptrs;		\
> -} while (0)
> -
>  /*	transport_generic_cmd_sequencer():
>   *
>   *	Generic Command Sequencer that should work for most DAS transport
> @@ -5767,7 +5747,6 @@ static int transport_generic_cmd_sequenc
>  
>  	switch (cdb[0]) {
>  	case READ_6:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		sectors = transport_get_sectors_6(cdb, cmd, &sector_ret);
>  		if (sector_ret)
>  			return TGCS_UNSUPPORTED_CDB;
> @@ -5779,7 +5758,6 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case READ_10:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
>  		if (sector_ret)
>  			return TGCS_UNSUPPORTED_CDB;
> @@ -5791,7 +5769,6 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case READ_12:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		sectors = transport_get_sectors_12(cdb, cmd, &sector_ret);
>  		if (sector_ret)
>  			return TGCS_UNSUPPORTED_CDB;
> @@ -5803,7 +5780,6 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case READ_16:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
>  		if (sector_ret)
>  			return TGCS_UNSUPPORTED_CDB;
> @@ -5815,7 +5791,6 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case WRITE_6:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		sectors = transport_get_sectors_6(cdb, cmd, &sector_ret);
>  		if (sector_ret)
>  			return TGCS_UNSUPPORTED_CDB;
> @@ -5827,7 +5802,6 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case WRITE_10:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
>  		if (sector_ret)
>  			return TGCS_UNSUPPORTED_CDB;
> @@ -5840,7 +5814,6 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case WRITE_12:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		sectors = transport_get_sectors_12(cdb, cmd, &sector_ret);
>  		if (sector_ret)
>  			return TGCS_UNSUPPORTED_CDB;
> @@ -5853,7 +5826,6 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case WRITE_16:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
>  		if (sector_ret)
>  			return TGCS_UNSUPPORTED_CDB;
> @@ -5866,7 +5838,6 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case XDWRITEREAD_10:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		if ((cmd->data_direction != DMA_TO_DEVICE) ||
>  		    !(T_TASK(cmd)->t_tasks_bidi))
>  			return TGCS_INVALID_CDB_FIELD;
> @@ -5893,7 +5864,6 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case VARIABLE_LENGTH_CMD:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		service_action = get_unaligned_be16(&cdb[8]);
>  		/*
>  		 * Check the additional CDB length (+ 8 bytes for header) does
> @@ -5983,7 +5953,6 @@ static int transport_generic_cmd_sequenc
>  		}
>  		break;
>  	case 0xa3:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
>  			/* MAINTENANCE_IN from SCC-2 */
>  			/*
> @@ -6007,21 +5976,18 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case MODE_SELECT:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = cdb[4];
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_SG_IO_CDB;
>  		break;
>  	case MODE_SELECT_10:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = (cdb[7] << 8) + cdb[8];
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_SG_IO_CDB;
>  		break;
>  	case MODE_SENSE:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = cdb[4];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
> @@ -6032,14 +5998,12 @@ static int transport_generic_cmd_sequenc
>  	case GPCMD_SEND_OPC:
>  	case LOG_SELECT:
>  	case LOG_SENSE:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = (cdb[7] << 8) + cdb[8];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_BLOCK_LIMITS:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = READ_BLOCK_LEN;
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
> @@ -6049,7 +6013,6 @@ static int transport_generic_cmd_sequenc
>  	case GPCMD_READ_FORMAT_CAPACITIES:
>  	case GPCMD_READ_DISC_INFO:
>  	case GPCMD_READ_TRACK_RZONE_INFO:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = (cdb[7] << 8) + cdb[8];
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
> @@ -6057,7 +6020,6 @@ static int transport_generic_cmd_sequenc
>  		break;
>  	case PERSISTENT_RESERVE_IN:
>  	case PERSISTENT_RESERVE_OUT:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		cmd->transport_emulate_cdb =
>  			(T10_RES(su_dev)->res_type ==
>  			 SPC3_PERSISTENT_RESERVATIONS) ?
> @@ -6069,21 +6031,18 @@ static int transport_generic_cmd_sequenc
>  		break;
>  	case GPCMD_MECHANISM_STATUS:
>  	case GPCMD_READ_DVD_STRUCTURE:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = (cdb[8] << 8) + cdb[9];
>  		transport_dev_get_mem_SG(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_SG_IO_CDB;
>  		break;
>  	case READ_POSITION:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = READ_POSITION_LEN;
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case 0xa4:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
>  			/* MAINTENANCE_OUT from SCC-2
>  			 *
> @@ -6108,7 +6067,6 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case INQUIRY:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = (cdb[3] << 8) + cdb[4];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
> @@ -6121,14 +6079,12 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_BUFFER:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_CAPACITY:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = READ_CAP_LEN;
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
> @@ -6137,7 +6093,6 @@ static int transport_generic_cmd_sequenc
>  	case READ_MEDIA_SERIAL_NUMBER:
>  	case SECURITY_PROTOCOL_IN:
>  	case SECURITY_PROTOCOL_OUT:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
> @@ -6150,7 +6105,6 @@ static int transport_generic_cmd_sequenc
>  	case READ_ATTRIBUTE:
>  	case RECEIVE_COPY_RESULTS:
>  	case WRITE_ATTRIBUTE:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = (cdb[10] << 24) | (cdb[11] << 16) |
>  		       (cdb[12] << 8) | cdb[13];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> @@ -6159,7 +6113,6 @@ static int transport_generic_cmd_sequenc
>  		break;
>  	case RECEIVE_DIAGNOSTIC:
>  	case SEND_DIAGNOSTIC:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = (cdb[3] << 8) | cdb[4];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
> @@ -6168,7 +6121,6 @@ static int transport_generic_cmd_sequenc
>  /* #warning FIXME: Figure out correct GPCMD_READ_CD blocksize. */
>  #if 0
>  	case GPCMD_READ_CD:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		sectors = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
>  		size = (2336 * sectors);
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
> @@ -6177,28 +6129,24 @@ static int transport_generic_cmd_sequenc
>  		break;
>  #endif
>  	case READ_TOC:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = cdb[8];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case REQUEST_SENSE:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = cdb[4];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_ELEMENT_STATUS:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = 65536 * cdb[7] + 256 * cdb[8] + cdb[9];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case WRITE_BUFFER:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
>  		transport_dev_get_mem_buf(cmd->se_orig_obj_ptr, cmd);
>  		transport_get_maps(cmd);
> @@ -6215,7 +6163,6 @@ static int transport_generic_cmd_sequenc
>  		else
>  			size = cmd->data_length;
>  
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		cmd->transport_allocate_resources =
>  				&transport_generic_allocate_none;
>  		transport_get_maps(cmd);
> @@ -6243,7 +6190,6 @@ static int transport_generic_cmd_sequenc
>  		else
>  			size = cmd->data_length;
>  
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		cmd->transport_allocate_resources =
>  				&transport_generic_allocate_none;
>  		transport_get_maps(cmd);
> @@ -6255,7 +6201,6 @@ static int transport_generic_cmd_sequenc
>  		break;
>  	case SYNCHRONIZE_CACHE:
>  	case 0x91: /* SYNCHRONIZE_CACHE_16: */
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		cmd->transport_allocate_resources =
>  				&transport_generic_allocate_none;
>  		transport_get_maps(cmd);
> @@ -6292,7 +6237,6 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_INVALID_CDB_FIELD;
>  		break;
>  	case UNMAP:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		cmd->transport_allocate_resources =
>  				&transport_generic_allocate_buf;
>  		size = get_unaligned_be16(&cdb[7]);
> @@ -6313,7 +6257,6 @@ static int transport_generic_cmd_sequenc
>  		ret = TGCS_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case WRITE_SAME_16:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		cmd->transport_allocate_resources =
>  				&transport_generic_allocate_buf;
>  		sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
> @@ -6365,14 +6308,12 @@ static int transport_generic_cmd_sequenc
>  	case VERIFY:
>  	case WRITE_FILEMARKS:
>  	case MOVE_MEDIUM:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		cmd->transport_allocate_resources =
>  				&transport_generic_allocate_none;
>  		transport_get_maps(cmd);
>  		ret = TGCS_NON_DATA_CDB;
>  		break;
>  	case REPORT_LUNS:
> -		SET_GENERIC_TRANSPORT_FUNCTIONS(cmd);
>  		cmd->transport_emulate_cdb =
>  				&transport_core_report_lun_response;
>  		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
> @@ -7258,23 +7199,6 @@ non_scsi_data:
>  	return 0;
>  }
>  
> -/*	transport_generic_do_transform():
> - *
> - *
> - */
> -int transport_generic_do_transform(struct se_cmd *cmd, struct se_transform_info *ti)
> -{
> -	if (!(cmd->transport_cdb_transform)) {
> -		dump_stack();
> -		return -1;
> -	}
> -	
> -	if (cmd->transport_cdb_transform(cmd, ti) < 0)
> -		return -1;
> -
> -	return 0;
> -}
> -
>  static inline long long transport_dev_end_lba(struct se_device *dev)
>  {
>  	return dev->dev_sectors_total + 1;
> @@ -7306,7 +7230,7 @@ int transport_get_sectors(struct se_cmd
>  	return 0;
>  }
>  
> -int transport_new_cmd_obj(
> +static int transport_new_cmd_obj(
>  	struct se_cmd *cmd,
>  	struct se_transform_info *ti,
>  	int post_execute)
> @@ -7365,7 +7289,6 @@ int transport_new_cmd_obj(
>  #endif
>  	}
>  
> -	cmd->transport_do_transform = &transport_generic_do_transform;
>  	if (!post_execute) {
>  		atomic_set(&T_TASK(cmd)->t_task_cdbs_left, task_cdbs);
>  		atomic_set(&T_TASK(cmd)->t_task_cdbs_ex_left, task_cdbs);
> @@ -8016,12 +7939,7 @@ u32 transport_generic_get_cdb_count(
>  			CMD_TFO(cmd)->get_task_tag(cmd), lba, sectors,
>  			transport_dev_end_lba(dev));
>  
> -		if (!(cmd->transport_get_task)) {
> -			dump_stack();
> -			goto out;
> -		}
> -
> -		task = cmd->transport_get_task(ti, cmd, dev, data_direction);
> +		task = transport_generic_get_task(ti, cmd, dev, data_direction);
>  		if (!(task))
>  			goto out;
>  
> @@ -8158,21 +8076,27 @@ int transport_generic_new_cmd(struct se_
>  			}
>  		}
>  	}
> -	/*
> -	 * This is dependent upon the storage processing algorithm.
> -	 */
> -	if (cmd->transport_do_transform(cmd, &ti) < 0) {
> +
> +	if (!(cmd->transport_cdb_transform)) {
> +		dump_stack();
> +		ret = PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> +		goto failure;
> +	}
> +
> +	if (cmd->transport_cdb_transform(cmd, &ti) < 0) {
>  		ret = PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
>  		goto failure;
>  	}
> +
>  	/*
>  	 * Set the correct (usually DMAable) buffer pointers from the master
>  	 * buffer list in struct se_cmd to the transport task's native
>  	 * buffers format.
>  	 */
> -	ret = cmd->transport_map_buffers_to_tasks(cmd);
> +	ret = transport_generic_map_buffers_to_tasks(cmd);
>  	if (ret < 0)
>  		goto failure;
> +
>  	/*
>  	 * For WRITEs, let the iSCSI Target RX Thread know its buffer is ready..
>  	 * This WRITE struct se_cmd (and all of its associated struct se_task's)
> Index: lio-core-2.6/include/target/target_core_base.h
> ===================================================================
> --- lio-core-2.6.orig/include/target/target_core_base.h	2010-11-06 19:54:02.404025601 +0100
> +++ lio-core-2.6/include/target/target_core_base.h	2010-11-06 20:12:40.348261038 +0100
> @@ -608,25 +608,16 @@ struct se_cmd {
>  	struct se_transport_task *t_task;
>  	struct se_transport_task t_task_backstore;
>  	struct target_core_fabric_ops *se_tfo;
> -	int (*transport_add_cmd_to_queue)(struct se_cmd *, int);
>  	int (*transport_allocate_resources)(struct se_cmd *, u32, u32);
>  	int (*transport_cdb_transform)(struct se_cmd *,
>  					struct se_transform_info *);
> -	int (*transport_do_transform)(struct se_cmd *,
> -					struct se_transform_info *);
>  	int (*transport_emulate_cdb)(struct se_cmd *);
>  	void (*transport_free_resources)(struct se_cmd *);
>  	u32 (*transport_get_lba)(unsigned char *);
>  	unsigned long long (*transport_get_long_lba)(unsigned char *);
> -	struct se_task *(*transport_get_task)(struct se_transform_info *,
> -					struct se_cmd *, void *,
> -					enum dma_data_direction);
> -	int (*transport_map_buffers_to_tasks)(struct se_cmd *);
>  	void (*transport_map_SG_segments)(struct se_unmap_sg *);
>  	void (*transport_passthrough_done)(struct se_cmd *);
>  	void (*transport_unmap_SG_segments)(struct se_unmap_sg *);
> -	int (*transport_set_iovec_ptrs)(struct se_map_sg *,
> -					struct se_unmap_sg *);
>  	void (*transport_split_cdb)(unsigned long long, u32 *, unsigned char *);
>  	void (*transport_wait_for_tasks)(struct se_cmd *, int, int);
>  	void (*transport_complete_callback)(struct se_cmd *);
> Index: lio-core-2.6/include/target/target_core_transport.h
> ===================================================================
> --- lio-core-2.6.orig/include/target/target_core_transport.h	2010-11-06 19:54:02.416004160 +0100
> +++ lio-core-2.6/include/target/target_core_transport.h	2010-11-06 20:16:00.956255873 +0100
> @@ -159,8 +159,7 @@ extern void transport_task_dev_remove_st
>  						struct se_device *);
>  extern void transport_cmd_finish_abort(struct se_cmd *, int);
>  extern void transport_cmd_finish_abort_tmr(struct se_cmd *);
> -extern int transport_add_cmd_to_queue(struct se_cmd *,
> -					struct se_queue_obj *, int);
> +extern int transport_add_cmd_to_queue(struct se_cmd *, int);
>  extern struct se_queue_req *__transport_get_qr_from_queue(
>  					struct se_queue_obj *);
>  extern void transport_remove_cmd_from_queue(struct se_cmd *,
> @@ -172,8 +171,6 @@ extern void transport_add_task_to_execut
>  						struct se_task *,
>  						struct se_device *);
>  extern void transport_add_tasks_from_cmd(struct se_cmd *);
> -extern struct se_task *transport_get_task_from_execute_queue(
> -						struct se_device *);
>  extern struct se_queue_req *transport_get_qr_from_queue(struct se_queue_obj *);
>  extern int transport_check_device_tcq(struct se_device *, u32, u32);
>  unsigned char *transport_dump_cmd_direction(struct se_cmd *);
> @@ -272,11 +269,7 @@ extern void transport_send_task_abort(st
>  extern void transport_release_cmd_to_pool(struct se_cmd *);
>  extern void transport_generic_free_cmd(struct se_cmd *, int, int, int);
>  extern void transport_generic_wait_for_cmds(struct se_cmd *, int);
> -extern int transport_generic_do_transform(struct se_cmd *,
> -					struct se_transform_info *);
>  extern int transport_get_sectors(struct se_cmd *);
> -extern int transport_new_cmd_obj(struct se_cmd *,
> -				struct se_transform_info *, int);
>  extern unsigned char *transport_get_vaddr(struct se_mem *);
>  extern struct list_head *transport_init_se_mem_list(void);
>  extern void transport_free_se_mem_list(struct list_head *);
> @@ -296,6 +289,8 @@ extern u32 transport_generic_get_cdb_cou
>  extern int transport_generic_new_cmd(struct se_cmd *);
>  extern void transport_generic_process_write(struct se_cmd *);
>  extern int transport_generic_do_tmr(struct se_cmd *);
> +extern int transport_generic_set_iovec_ptrs(struct se_map_sg *map_sg,
> +	struct se_unmap_sg *unmap_sg);
>  /* From target_core_alua.c */
>  extern int core_alua_check_nonop_delay(struct se_cmd *);
>  
> Index: lio-core-2.6/drivers/target/lio-target/iscsi_target.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/lio-target/iscsi_target.c	2010-11-06 19:54:02.387010236 +0100
> +++ lio-core-2.6/drivers/target/lio-target/iscsi_target.c	2010-11-06 20:12:40.361004229 +0100
> @@ -1944,7 +1944,7 @@ static inline int iscsi_handle_data_out(
>  	unmap_sg.fabric_cmd = (void *)cmd;
>  	unmap_sg.se_cmd = SE_CMD(cmd);
>  
> -	iov_ret = SE_CMD(cmd)->transport_set_iovec_ptrs(&map_sg, &unmap_sg);
> +	iov_ret = transport_generic_set_iovec_ptrs(&map_sg, &unmap_sg);
>  	if (iov_ret < 0)
>  		return -1;
>  
> @@ -1989,8 +1989,7 @@ static inline int iscsi_handle_data_out(
>  		map_sg.data_length = hdr->length;
>  		map_sg.data_offset = hdr->offset;
>  
> -		if (SE_CMD(cmd)->transport_set_iovec_ptrs(
> -					&map_sg, &unmap_sg) < 0)
> +		if (transport_generic_set_iovec_ptrs(&map_sg, &unmap_sg) < 0)
>  			return -1;
>  
>  		crypto_hash_init(&conn->conn_rx_hash);
> @@ -2971,7 +2970,7 @@ static int iscsi_handle_immediate_data(
>  	unmap_sg.fabric_cmd = (void *)cmd;
>  	unmap_sg.se_cmd = SE_CMD(cmd);
>  
> -	iov_ret = SE_CMD(cmd)->transport_set_iovec_ptrs(&map_sg, &unmap_sg);
> +	iov_ret = transport_generic_set_iovec_ptrs(&map_sg, &unmap_sg);
>  	if (iov_ret < 0)
>  		return IMMEDIDATE_DATA_CANNOT_RECOVER;
>  
> @@ -3019,8 +3018,7 @@ static int iscsi_handle_immediate_data(
>  		map_sg.data_length = length;
>  		map_sg.data_offset = cmd->write_data_done;
>  
> -		if (SE_CMD(cmd)->transport_set_iovec_ptrs(&map_sg,
> -					&unmap_sg) < 0)
> +		if (transport_generic_set_iovec_ptrs(&map_sg, &unmap_sg) < 0)
>  			return IMMEDIDATE_DATA_CANNOT_RECOVER;
>  
>  		crypto_hash_init(&conn->conn_rx_hash);
> @@ -3454,7 +3452,7 @@ static inline int iscsi_send_data_in(
>  	map_sg.data_length = datain.length;
>  	map_sg.data_offset = datain.offset;
>  
> -	iov_ret = SE_CMD(cmd)->transport_set_iovec_ptrs(&map_sg, unmap_sg);
> +	iov_ret = transport_generic_set_iovec_ptrs(&map_sg, unmap_sg);
>  	if (iov_ret < 0)
>  		return -1;
>  
> Index: lio-core-2.6/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c	2010-11-06 19:54:02.395010935 +0100
> +++ lio-core-2.6/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c	2010-11-06 20:12:40.367032166 +0100
> @@ -122,11 +122,8 @@ static struct se_cmd *tcm_loop_allocate_
>  				se_cmd->scsi_sense_reason, 0);
>  		return 0;
>  	}
> -	/*
> -	 * Make early call to setup se_cmd->transport_add_cmd_to_queue() pointer
> -	 */
> -	transport_device_setup_cmd(se_cmd);
>  
> +	transport_device_setup_cmd(se_cmd);
>  	return se_cmd;
>  }
>  
> @@ -353,7 +350,7 @@ static int tcm_loop_queuecommand(
>  	/*
>  	 * Queue up the newly allocated to be processed in TCM thread context.
>  	*/
> -	se_cmd->transport_add_cmd_to_queue(se_cmd, TRANSPORT_NEW_CMD_MAP);
> +	transport_add_cmd_to_queue(se_cmd, TRANSPORT_NEW_CMD_MAP);
>  	/*
>  	 * Reaquire the the struct scsi_host->host_lock before returning
>  	 */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

