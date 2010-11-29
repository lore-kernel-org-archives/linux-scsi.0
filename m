From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] target: always assign se_cmd flags in
	transport_generic_cmd_sequencer
Date: Mon, 29 Nov 2010 14:26:28 -0800
Message-ID: <1291069588.17194.41.camel@haakon2.linux-iscsi.org>
References: <20101129215734.GA19703@infradead.org>
	 <20101129215828.GB19726@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50074 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab0K2WcE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2010 17:32:04 -0500
In-Reply-To: <20101129215828.GB19726@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-29 at 16:58 -0500, Christoph Hellwig wrote:
> Assign the flags and in case of errors the sense code in
> transport_generic_cmd_sequencer, and pass through the return value from it in
> transport_generic_allocate_tasks.  This gets rid of a special set of return
> codes and a switch statement in the fast path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

A very nice cleanup as well, everything looks correct and committed as
a1a31bf.  The total for the series is:

 drivers/target/target_core_alua.c      |    4 +-
 drivers/target/target_core_file.c      |   10 -
 drivers/target/target_core_iblock.c    |    6 -
 drivers/target/target_core_pscsi.c     |   10 -
 drivers/target/target_core_rd.c        |   11 --
 drivers/target/target_core_stgt.c      |   10 -
 drivers/target/target_core_transport.c |  295 ++++++++++++++------------------
 include/target/target_core_base.h      |    2 -
 include/target/target_core_transport.h |   18 --
 9 files changed, 127 insertions(+), 239 deletions(-)


Pushing into lio-4.0 now, and will be testing shortly and pushing into
master as well.

Thanks!

--nab


> Index: lio-core/drivers/target/target_core_alua.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_alua.c	2010-11-29 20:11:25.778254298 +0100
> +++ lio-core/drivers/target/target_core_alua.c	2010-11-29 20:16:02.436254646 +0100
> @@ -455,9 +455,9 @@ static int core_alua_state_check_nop(
>   * Also, this function can return three different return codes to
>   * signal transport_generic_cmd_sequencer()
>   *
> - * return 1: Is used to signal LUN not accecsable, and TGCS_CHECK_CONDITION_NOT_READY
> + * return 1: Is used to signal LUN not accecsable, and check condition/not ready
>   * return 0: Used to signal success
> - * reutrn -1: Used to signal failure, and TGCS_INVALID_CDB_FIELD
> + * reutrn -1: Used to signal failure, and invalid cdb field
>   */
>  static int core_alua_state_check(
>  	struct se_cmd *cmd,
> Index: lio-core/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_transport.c	2010-11-29 20:11:30.802004332 +0100
> +++ lio-core/drivers/target/target_core_transport.c	2010-11-29 20:17:20.321254787 +0100
> @@ -1886,7 +1886,7 @@ int transport_generic_allocate_tasks(
>  	struct se_cmd *cmd,
>  	unsigned char *cdb)
>  {
> -	int non_data_cdb;
> +	int ret;
>  
>  	transport_generic_prepare_cdb(cdb);
>  
> @@ -1900,9 +1900,9 @@ int transport_generic_allocate_tasks(
>  	 * See if this is a CDB which follows SAM, also grab a function
>  	 * pointer to see if we need to do extra work.
>  	 */
> -	non_data_cdb = transport_generic_cmd_sequencer(cmd, cdb);
> -	if (non_data_cdb < 0)
> -		return -1;
> +	ret = transport_generic_cmd_sequencer(cmd, cdb);
> +	if (ret < 0)
> +		return ret;
>  	/*
>  	 * Ensure that the received CDB is less than the max (252 + 8) bytes
>  	 * for VARIABLE_LENGTH_CMD
> @@ -1946,75 +1946,6 @@ int transport_generic_allocate_tasks(
>  	if (cmd->se_lun->lun_sep)
>  		cmd->se_lun->lun_sep->sep_stats.cmd_pdus++;
>  	spin_unlock(&cmd->se_lun->lun_sep_lock);
> -
> -	switch (non_data_cdb) {
> -	case TGCS_DATA_SG_IO_CDB:
> -		DEBUG_CDB_H("Set cdb[0]: 0x%02x to "
> -				"SCF_SCSI_DATA_SG_IO_CDB\n", cdb[0]);
> -		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
> -		break;
> -	case TGCS_CONTROL_SG_IO_CDB:
> -		DEBUG_CDB_H("Set cdb[0]: 0x%02x to"
> -				" SCF_SCSI_CONTROL_SG_IO_CDB\n", cdb[0]);
> -		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
> -		break;
> -	case TGCS_CONTROL_NONSG_IO_CDB:
> -		DEBUG_CDB_H("Set cdb[0]: 0x%02x to "
> -				"SCF_SCSI_CONTROL_NONSG_IO_CDB\n", cdb[0]);
> -		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
> -		break;
> -	case TGCS_NON_DATA_CDB:
> -		DEBUG_CDB_H("Set cdb[0]: 0x%02x to "
> -				"SCF_SCSI_NON_DATA_CDB\n", cdb[0]);
> -		cmd->se_cmd_flags |= SCF_SCSI_NON_DATA_CDB;
> -		break;
> -	case TGCS_UNSUPPORTED_CDB:
> -		DEBUG_CDB_H("Set cdb[0]: 0x%02x to"
> -				" SCF_SCSI_UNSUPPORTED_CDB\n", cdb[0]);
> -		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> -		cmd->scsi_sense_reason = TCM_UNSUPPORTED_SCSI_OPCODE;
> -		return -2;
> -	case TGCS_RESERVATION_CONFLICT:
> -		DEBUG_CDB_H("Set cdb[0]: 0x%02x to"
> -				" SCF_SCSI_RESERVATION_CONFLICT\n", cdb[0]);
> -		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> -		cmd->se_cmd_flags |= SCF_SCSI_RESERVATION_CONFLICT;
> -		cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
> -		/*
> -		 * For UA Interlock Code 11b, a RESERVATION CONFLICT will
> -		 * establish a UNIT ATTENTION with PREVIOUS RESERVATION
> -		 * CONFLICT STATUS.
> -		 *
> -		 * See spc4r17, section 7.4.6 Control Mode Page, Table 349
> -		 */
> -		if (SE_SESS(cmd) &&
> -		    DEV_ATTRIB(cmd->se_dev)->emulate_ua_intlck_ctrl == 2)
> -			core_scsi3_ua_allocate(SE_SESS(cmd)->se_node_acl,
> -				cmd->orig_fe_lun, 0x2C,
> -				ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
> -		return -2;
> -	case TGCS_INVALID_CDB_FIELD:
> -		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> -		cmd->scsi_sense_reason = TCM_INVALID_CDB_FIELD;
> -		return -2;
> -	case TGCS_ILLEGAL_REQUEST:
> -		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> -		cmd->scsi_sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> -		return -2;
> -	case TGCS_CHECK_CONDITION_UNIT_ATTENTION:
> -		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> -		cmd->scsi_sense_reason = TCM_CHECK_CONDITION_UNIT_ATTENTION;
> -		return -2;
> -	case TGCS_CHECK_CONDITION_NOT_READY:
> -		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> -		cmd->scsi_sense_reason = TCM_CHECK_CONDITION_NOT_READY;
> -		return -2;
> -	default:
> -		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> -		cmd->scsi_sense_reason = TCM_UNSUPPORTED_SCSI_OPCODE;
> -		return -2;
> -	}
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL(transport_generic_allocate_tasks);
> @@ -3101,6 +3032,28 @@ static int transport_allocate_resources(
>  		return 0;
>  }
>  
> +static int
> +transport_handle_reservation_conflict(struct se_cmd *cmd)
> +{
> +	cmd->transport_wait_for_tasks = &transport_nop_wait_for_tasks;
> +	cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> +	cmd->se_cmd_flags |= SCF_SCSI_RESERVATION_CONFLICT;
> +	cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
> +	/*
> +	 * For UA Interlock Code 11b, a RESERVATION CONFLICT will
> +	 * establish a UNIT ATTENTION with PREVIOUS RESERVATION
> +	 * CONFLICT STATUS.
> +	 *
> +	 * See spc4r17, section 7.4.6 Control Mode Page, Table 349
> +	 */
> +	if (SE_SESS(cmd) &&
> +	    DEV_ATTRIB(cmd->se_dev)->emulate_ua_intlck_ctrl == 2)
> +		core_scsi3_ua_allocate(SE_SESS(cmd)->se_node_acl,
> +			cmd->orig_fe_lun, 0x2C,
> +			ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
> +	return -2;
> +}
> +
>  /*	transport_generic_cmd_sequencer():
>   *
>   *	Generic Command Sequencer that should work for most DAS transport
> @@ -3117,7 +3070,7 @@ static int transport_generic_cmd_sequenc
>  {
>  	struct se_device *dev = SE_DEV(cmd);
>  	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
> -	int ret, sector_ret = 0, passthrough;
> +	int ret = 0, sector_ret = 0, passthrough;
>  	u32 sectors = 0, size = 0, pr_reg_type = 0;
>  	u16 service_action;
>  	u8 alua_ascq = 0;
> @@ -3127,7 +3080,9 @@ static int transport_generic_cmd_sequenc
>  	if (core_scsi3_ua_check(cmd, cdb) < 0) {
>  		cmd->transport_wait_for_tasks =
>  				&transport_nop_wait_for_tasks;
> -		return TGCS_CHECK_CONDITION_UNIT_ATTENTION;
> +		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> +		cmd->scsi_sense_reason = TCM_CHECK_CONDITION_UNIT_ATTENTION;
> +		return -2;
>  	}
>  	/*
>  	 * Check status of Asymmetric Logical Unit Assignment port
> @@ -3147,20 +3102,19 @@ static int transport_generic_cmd_sequenc
>  				CMD_TFO(cmd)->get_fabric_name(), alua_ascq);
>  #endif
>  			transport_set_sense_codes(cmd, 0x04, alua_ascq);
> -			return TGCS_CHECK_CONDITION_NOT_READY;
> +			cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> +			cmd->scsi_sense_reason = TCM_CHECK_CONDITION_NOT_READY;
> +			return -2;
>  		}
> -		return TGCS_INVALID_CDB_FIELD;
> +		goto out_invalid_cdb_field;
>  	}
>  	/*
>  	 * Check status for SPC-3 Persistent Reservations
>  	 */
>  	if (T10_PR_OPS(su_dev)->t10_reservation_check(cmd, &pr_reg_type) != 0) {
>  		if (T10_PR_OPS(su_dev)->t10_seq_non_holder(
> -					cmd, cdb, pr_reg_type) != 0) {
> -			cmd->transport_wait_for_tasks =
> -					&transport_nop_wait_for_tasks;
> -			return TGCS_RESERVATION_CONFLICT;
> -		}
> +					cmd, cdb, pr_reg_type) != 0)
> +			return transport_handle_reservation_conflict(cmd);
>  		/*
>  		 * This means the CDB is allowed for the SCSI Initiator port
>  		 * when said port is *NOT* holding the legacy SPC-2 or
> @@ -3172,88 +3126,89 @@ static int transport_generic_cmd_sequenc
>  	case READ_6:
>  		sectors = transport_get_sectors_6(cdb, cmd, &sector_ret);
>  		if (sector_ret)
> -			return TGCS_UNSUPPORTED_CDB;
> +			goto out_unsupported_cdb;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_6;
>  		T_TASK(cmd)->t_task_lba = transport_lba_21(cdb);
> -		ret = TGCS_DATA_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
>  		break;
>  	case READ_10:
>  		sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
>  		if (sector_ret)
> -			return TGCS_UNSUPPORTED_CDB;
> +			goto out_unsupported_cdb;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_10;
>  		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
> -		ret = TGCS_DATA_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
>  		break;
>  	case READ_12:
>  		sectors = transport_get_sectors_12(cdb, cmd, &sector_ret);
>  		if (sector_ret)
> -			return TGCS_UNSUPPORTED_CDB;
> +			goto out_unsupported_cdb;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_12;
>  		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
> -		ret = TGCS_DATA_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
>  		break;
>  	case READ_16:
>  		sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
>  		if (sector_ret)
> -			return TGCS_UNSUPPORTED_CDB;
> +			goto out_unsupported_cdb;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_16;
>  		T_TASK(cmd)->t_task_lba = transport_lba_64(cdb);
> -		ret = TGCS_DATA_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
>  		break;
>  	case WRITE_6:
>  		sectors = transport_get_sectors_6(cdb, cmd, &sector_ret);
>  		if (sector_ret)
> -			return TGCS_UNSUPPORTED_CDB;
> +			goto out_unsupported_cdb;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_6;
>  		T_TASK(cmd)->t_task_lba = transport_lba_21(cdb);
> -		ret = TGCS_DATA_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
>  		break;
>  	case WRITE_10:
>  		sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
>  		if (sector_ret)
> -			return TGCS_UNSUPPORTED_CDB;
> +			goto out_unsupported_cdb;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_10;
>  		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
>  		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
> -		ret = TGCS_DATA_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
>  		break;
>  	case WRITE_12:
>  		sectors = transport_get_sectors_12(cdb, cmd, &sector_ret);
>  		if (sector_ret)
> -			return TGCS_UNSUPPORTED_CDB;
> +			goto out_unsupported_cdb;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_12;
>  		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
>  		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
> -		ret = TGCS_DATA_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
>  		break;
>  	case WRITE_16:
>  		sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
>  		if (sector_ret)
> -			return TGCS_UNSUPPORTED_CDB;
> +			goto out_unsupported_cdb;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_16;
>  		T_TASK(cmd)->t_task_lba = transport_lba_64(cdb);
>  		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
> -		ret = TGCS_DATA_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
>  		break;
>  	case XDWRITEREAD_10:
>  		if ((cmd->data_direction != DMA_TO_DEVICE) ||
>  		    !(T_TASK(cmd)->t_tasks_bidi))
> -			return TGCS_INVALID_CDB_FIELD;
> +			goto out_invalid_cdb_field;
>  		sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
>  		if (sector_ret)
> -			return TGCS_UNSUPPORTED_CDB;
> +			goto out_unsupported_cdb;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_10;
>  		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
> +		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
>  		passthrough = (TRANSPORT(dev)->transport_type ==
>  				TRANSPORT_PLUGIN_PHBA_PDEV);
>  		/*
> @@ -3266,7 +3221,6 @@ static int transport_generic_cmd_sequenc
>  		 */
>  		cmd->transport_complete_callback = &transport_xor_callback;
>  		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
> -		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case VARIABLE_LENGTH_CMD:
>  		service_action = get_unaligned_be16(&cdb[8]);
> @@ -3281,7 +3235,7 @@ static int transport_generic_cmd_sequenc
>  		case XDWRITEREAD_32:
>  			sectors = transport_get_sectors_32(cdb, cmd, &sector_ret);
>  			if (sector_ret)
> -				return TGCS_UNSUPPORTED_CDB;
> +				goto out_unsupported_cdb;
>  			size = transport_get_size(sectors, cdb, cmd);
>  			/*
>  			 * Use WRITE_32 and READ_32 opcodes for the emulated
> @@ -3289,39 +3243,40 @@ static int transport_generic_cmd_sequenc
>  			 */
>  			cmd->transport_split_cdb = &split_cdb_XX_32;
>  			T_TASK(cmd)->t_task_lba = transport_lba_64_ext(cdb);
> +			cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
> +
>  			/*
>  			 * Skip the remaining assignments for TCM/PSCSI passthrough
>  			 */
> -			if (passthrough) {
> -				ret = TGCS_DATA_SG_IO_CDB;
> +			if (passthrough)
>  				break;
> -			}
> +
>  			/*
>  			 * Setup BIDI XOR callback to be run during
>  			 * transport_generic_complete_ok()
>  			 */
>  			cmd->transport_complete_callback = &transport_xor_callback;
>  			T_TASK(cmd)->t_tasks_fua = (cdb[10] & 0x8);
> -			ret = TGCS_DATA_SG_IO_CDB;	
>  			break;
>  		case WRITE_SAME_32:
>  			sectors = transport_get_sectors_32(cdb, cmd, &sector_ret);
>  			if (sector_ret)
> -				return TGCS_UNSUPPORTED_CDB;
> +				goto out_unsupported_cdb;
>  			size = transport_get_size(sectors, cdb, cmd);
>  			T_TASK(cmd)->t_task_lba = get_unaligned_be64(&cdb[12]);
> +			cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
> +
>  			/*
>  			 * Skip the remaining assignments for TCM/PSCSI passthrough
>  			 */
> -			if (passthrough) {
> -				ret = TGCS_CONTROL_SG_IO_CDB;
> +			if (passthrough)
>  				break;
> -			}
> +
>  			if ((cdb[10] & 0x04) || (cdb[10] & 0x02)) {
>  				printk(KERN_ERR "WRITE_SAME PBDATA and LBDATA"
>  					" bits not supported for Block Discard"
>  					" Emulation\n");
> -				return TGCS_INVALID_CDB_FIELD;
> +				goto out_invalid_cdb_field;
>  			}
>  			/*
>  			 * Currently for the emulated case we only accept
> @@ -3330,14 +3285,13 @@ static int transport_generic_cmd_sequenc
>  			if (!(cdb[10] & 0x08)) {
>  				printk(KERN_ERR "WRITE_SAME w/o UNMAP bit not"
>  					" supported for Block Discard Emulation\n");
> -				return TGCS_INVALID_CDB_FIELD;
> +				goto out_invalid_cdb_field;
>  			}
> -			ret = TGCS_CONTROL_SG_IO_CDB;
>  			break;
>  		default:
>  			printk(KERN_ERR "VARIABLE_LENGTH_CMD service action"
>  				" 0x%04x not supported\n", service_action);
> -			return TGCS_UNSUPPORTED_CDB;
> +			goto out_unsupported_cdb;
>  		}
>  		break;
>  	case 0xa3:
> @@ -3359,19 +3313,19 @@ static int transport_generic_cmd_sequenc
>  			/* GPCMD_SEND_KEY from multi media commands */
>  			size = (cdb[8] << 8) + cdb[9];
>  		}
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case MODE_SELECT:
>  		size = cdb[4];
> -		ret = TGCS_CONTROL_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
>  		break;
>  	case MODE_SELECT_10:
>  		size = (cdb[7] << 8) + cdb[8];
> -		ret = TGCS_CONTROL_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
>  		break;
>  	case MODE_SENSE:
>  		size = cdb[4];
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case MODE_SENSE_10:
>  	case GPCMD_READ_BUFFER_CAPACITY:
> @@ -3379,18 +3333,18 @@ static int transport_generic_cmd_sequenc
>  	case LOG_SELECT:
>  	case LOG_SENSE:
>  		size = (cdb[7] << 8) + cdb[8];
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_BLOCK_LIMITS:
>  		size = READ_BLOCK_LEN;
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case GPCMD_GET_CONFIGURATION:
>  	case GPCMD_READ_FORMAT_CAPACITIES:
>  	case GPCMD_READ_DISC_INFO:
>  	case GPCMD_READ_TRACK_RZONE_INFO:
>  		size = (cdb[7] << 8) + cdb[8];
> -		ret = TGCS_CONTROL_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
>  		break;
>  	case PERSISTENT_RESERVE_IN:
>  	case PERSISTENT_RESERVE_OUT:
> @@ -3399,16 +3353,16 @@ static int transport_generic_cmd_sequenc
>  			 SPC3_PERSISTENT_RESERVATIONS) ?
>  			&core_scsi3_emulate_pr : NULL;
>  		size = (cdb[7] << 8) + cdb[8];
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case GPCMD_MECHANISM_STATUS:
>  	case GPCMD_READ_DVD_STRUCTURE:
>  		size = (cdb[8] << 8) + cdb[9];
> -		ret = TGCS_CONTROL_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
>  		break;
>  	case READ_POSITION:
>  		size = READ_POSITION_LEN;
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case 0xa4:
>  		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
> @@ -3430,7 +3384,7 @@ static int transport_generic_cmd_sequenc
>  			/* GPCMD_REPORT_KEY from multi media commands */
>  			size = (cdb[8] << 8) + cdb[9];
>  		}
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case INQUIRY:
>  		size = (cdb[3] << 8) + cdb[4];
> @@ -3440,21 +3394,21 @@ static int transport_generic_cmd_sequenc
>  		 */
>  		if (SE_DEV(cmd)->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
>  			cmd->sam_task_attr = TASK_ATTR_HOQ;
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_BUFFER:
>  		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_CAPACITY:
>  		size = READ_CAP_LEN;
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_MEDIA_SERIAL_NUMBER:
>  	case SECURITY_PROTOCOL_IN:
>  	case SECURITY_PROTOCOL_OUT:
>  		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case SERVICE_ACTION_IN:
>  	case ACCESS_CONTROL_IN:
> @@ -3465,36 +3419,36 @@ static int transport_generic_cmd_sequenc
>  	case WRITE_ATTRIBUTE:
>  		size = (cdb[10] << 24) | (cdb[11] << 16) |
>  		       (cdb[12] << 8) | cdb[13];
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case RECEIVE_DIAGNOSTIC:
>  	case SEND_DIAGNOSTIC:
>  		size = (cdb[3] << 8) | cdb[4];
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  /* #warning FIXME: Figure out correct GPCMD_READ_CD blocksize. */
>  #if 0
>  	case GPCMD_READ_CD:
>  		sectors = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
>  		size = (2336 * sectors);
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  #endif
>  	case READ_TOC:
>  		size = cdb[8];
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case REQUEST_SENSE:
>  		size = cdb[4];
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case READ_ELEMENT_STATUS:
>  		size = 65536 * cdb[7] + 256 * cdb[8] + cdb[9];
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case WRITE_BUFFER:
>  		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case RESERVE:
>  	case RESERVE_10:
> @@ -3518,7 +3472,7 @@ static int transport_generic_cmd_sequenc
>  				(T10_RES(su_dev)->res_type !=
>  				 SPC_PASSTHROUGH) ?
>  				&core_scsi2_emulate_crh : NULL;
> -		ret = TGCS_NON_DATA_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_NON_DATA_CDB;
>  		break;
>  	case RELEASE:
>  	case RELEASE_10:
> @@ -3535,7 +3489,7 @@ static int transport_generic_cmd_sequenc
>  				(T10_RES(su_dev)->res_type !=
>  				 SPC_PASSTHROUGH) ?
>  				&core_scsi2_emulate_crh : NULL;
> -		ret = TGCS_NON_DATA_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_NON_DATA_CDB;
>  		break;
>  	case SYNCHRONIZE_CACHE:
>  	case 0x91: /* SYNCHRONIZE_CACHE_16: */
> @@ -3550,10 +3504,11 @@ static int transport_generic_cmd_sequenc
>  			T_TASK(cmd)->t_task_lba = transport_lba_64(cdb);
>  		}
>                  if (sector_ret)
> -                        return TGCS_UNSUPPORTED_CDB;
> +			goto out_unsupported_cdb;
>  
>                  size = transport_get_size(sectors, cdb, cmd);
> -		ret = TGCS_NON_DATA_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_NON_DATA_CDB;
> +
>  		/*
>  		 * For TCM/pSCSI passthrough, skip cmd->transport_emulate_cdb()
>  		 */
> @@ -3569,7 +3524,7 @@ static int transport_generic_cmd_sequenc
>  		 * device.
>  		 */
>  		if (transport_get_sectors(cmd) < 0)
> -			return TGCS_INVALID_CDB_FIELD;
> +			goto out_invalid_cdb_field;
>  		break;
>  	case UNMAP:
>  		size = get_unaligned_be16(&cdb[7]);
> @@ -3585,12 +3540,12 @@ static int transport_generic_cmd_sequenc
>  		if (!(passthrough))
>  			cmd->se_cmd_flags |= SCF_EMULATE_SYNC_UNMAP;
>  
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	case WRITE_SAME_16:
>  		sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
>  		if (sector_ret)
> -			return TGCS_UNSUPPORTED_CDB;
> +			goto out_unsupported_cdb;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		T_TASK(cmd)->t_task_lba = get_unaligned_be16(&cdb[2]);
>  		passthrough = (TRANSPORT(dev)->transport_type ==
> @@ -3607,7 +3562,7 @@ static int transport_generic_cmd_sequenc
>  				printk(KERN_ERR "WRITE_SAME PBDATA and LBDATA"
>  					" bits not supported for Block Discard"
>  					" Emulation\n");
> -				return TGCS_INVALID_CDB_FIELD;
> +				goto out_invalid_cdb_field;
>  			}
>  			/*
>  			 * Currently for the emulated case we only accept
> @@ -3616,10 +3571,10 @@ static int transport_generic_cmd_sequenc
>  			if (!(cdb[1] & 0x08)) {
>  				printk(KERN_ERR "WRITE_SAME w/o UNMAP bit not "
>  					" supported for Block Discard Emulation\n");
> -				return TGCS_INVALID_CDB_FIELD;
> +				goto out_invalid_cdb_field;
>  			}
>  		}
> -		ret = TGCS_CONTROL_SG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
>  		break;
>  	case ALLOW_MEDIUM_REMOVAL:
>  	case GPCMD_CLOSE_TRACK:
> @@ -3635,7 +3590,7 @@ static int transport_generic_cmd_sequenc
>  	case VERIFY:
>  	case WRITE_FILEMARKS:
>  	case MOVE_MEDIUM:
> -		ret = TGCS_NON_DATA_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_NON_DATA_CDB;
>  		break;
>  	case REPORT_LUNS:
>  		cmd->transport_emulate_cdb =
> @@ -3647,14 +3602,14 @@ static int transport_generic_cmd_sequenc
>  		 */
>  		if (SE_DEV(cmd)->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
>  			cmd->sam_task_attr = TASK_ATTR_HOQ;
> -		ret = TGCS_CONTROL_NONSG_IO_CDB;
> +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
>  		break;
>  	default:
>  		printk(KERN_WARNING "TARGET_CORE[%s]: Unsupported SCSI Opcode"
>  			" 0x%02x, sending CHECK_CONDITION.\n",
>  			CMD_TFO(cmd)->get_fabric_name(), cdb[0]);
>  		cmd->transport_wait_for_tasks = &transport_nop_wait_for_tasks;
> -		return TGCS_UNSUPPORTED_CDB;
> +		goto out_unsupported_cdb;
>  	}
>  
>  	if (size != cmd->data_length) {
> @@ -3668,7 +3623,7 @@ static int transport_generic_cmd_sequenc
>  		if (cmd->data_direction == DMA_TO_DEVICE) {
>  			printk(KERN_ERR "Rejecting underflow/overflow"
>  					" WRITE data\n");
> -			return TGCS_INVALID_CDB_FIELD;
> +			goto out_invalid_cdb_field;
>  		}
>  		/*
>  		 * Reject READ_* or WRITE_* with overflow/underflow for
> @@ -3679,7 +3634,7 @@ static int transport_generic_cmd_sequenc
>  				" CDB on non 512-byte sector setup subsystem"
>  				" plugin: %s\n", TRANSPORT(dev)->name);
>  			/* Returns CHECK_CONDITION + INVALID_CDB_FIELD */
> -			return TGCS_INVALID_CDB_FIELD;
> +			goto out_invalid_cdb_field;
>  		}
>  
>  		if (size > cmd->data_length) {
> @@ -3694,6 +3649,15 @@ static int transport_generic_cmd_sequenc
>  
>  	transport_set_supported_SAM_opcode(cmd);
>  	return ret;
> +
> +out_unsupported_cdb:
> +	cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> +	cmd->scsi_sense_reason = TCM_UNSUPPORTED_SCSI_OPCODE;
> +	return -2;
> +out_invalid_cdb_field:
> +	cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
> +	cmd->scsi_sense_reason = TCM_INVALID_CDB_FIELD;
> +	return -2;
>  }
>  
>  static inline void transport_release_tasks(struct se_cmd *);
> Index: lio-core/include/target/target_core_transport.h
> ===================================================================
> --- lio-core.orig/include/target/target_core_transport.h	2010-11-29 20:11:30.365253948 +0100
> +++ lio-core/include/target/target_core_transport.h	2010-11-29 20:11:31.452004192 +0100
> @@ -63,20 +63,6 @@
>  #define DF_SPC2_RESERVATIONS			0x00000002
>  #define DF_SPC2_RESERVATIONS_WITH_ISID		0x00000004
>  
> -/*
> - * Used as return values from transport_generic_cmd_sequencer()
> - */
> -#define TGCS_DATA_SG_IO_CDB			0
> -#define TGCS_CONTROL_SG_IO_CDB			1
> -#define TGCS_CONTROL_NONSG_IO_CDB		2
> -#define TGCS_NON_DATA_CDB			3
> -#define TGCS_UNSUPPORTED_CDB			4
> -#define TGCS_RESERVATION_CONFLICT		5
> -#define TGCS_INVALID_CDB_FIELD			6
> -#define TGCS_ILLEGAL_REQUEST			7
> -#define TGCS_CHECK_CONDITION_UNIT_ATTENTION	8
> -#define TGCS_CHECK_CONDITION_NOT_READY		9
> -
>  /* struct se_dev_attrib sanity values */
>  /* 10 Minutes */
>  #define DA_TASK_TIMEOUT_MAX			600

