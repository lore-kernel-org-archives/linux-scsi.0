From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/3] target: always assign t_task_lba in
	transport_generic_cmd_sequencer
Date: Mon, 29 Nov 2010 14:18:09 -0800
Message-ID: <1291069089.17194.35.camel@haakon2.linux-iscsi.org>
References: <20101129215734.GA19703@infradead.org>
	 <20101129215804.GA19726@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41389 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0K2WXn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2010 17:23:43 -0500
In-Reply-To: <20101129215804.GA19726@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-29 at 16:58 -0500, Christoph Hellwig wrote:
> We already sometimes directly calculate the lba in
> transport_generic_cmd_sequencer, but sometimes use the transport_get_long_lba /
> transport_get_lba callback in the se_cmd.  Unify the code to always assign
> it directly and remove the callbacks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

A nice simplification, commited as 2c0284d.

Thanks!

> Index: lio-core/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_transport.c	2010-11-29 19:42:05.046003633 +0100
> +++ lio-core/drivers/target/target_core_transport.c	2010-11-29 19:47:31.670254576 +0100
> @@ -1952,15 +1952,6 @@ int transport_generic_allocate_tasks(
>  		DEBUG_CDB_H("Set cdb[0]: 0x%02x to "
>  				"SCF_SCSI_DATA_SG_IO_CDB\n", cdb[0]);
>  		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
> -
> -		/*
> -		 * Get the initial Logical Block Address from the Original
> -		 * Command Descriptor Block that arrived on the iSCSI wire.
> -		 */
> -		T_TASK(cmd)->t_task_lba = (cmd->transport_get_long_lba) ?
> -			cmd->transport_get_long_lba(cdb) :
> -			cmd->transport_get_lba(cdb);
> -
>  		break;
>  	case TGCS_CONTROL_SG_IO_CDB:
>  		DEBUG_CDB_H("Set cdb[0]: 0x%02x to"
> @@ -3184,7 +3175,7 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_6;
> -		cmd->transport_get_lba = &transport_lba_21;
> +		T_TASK(cmd)->t_task_lba = transport_lba_21(cdb);
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case READ_10:
> @@ -3193,7 +3184,7 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_10;
> -		cmd->transport_get_lba = &transport_lba_32;
> +		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case READ_12:
> @@ -3202,7 +3193,7 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_12;
> -		cmd->transport_get_lba = &transport_lba_32;
> +		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case READ_16:
> @@ -3211,7 +3202,7 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_16;
> -		cmd->transport_get_long_lba = &transport_lba_64;
> +		T_TASK(cmd)->t_task_lba = transport_lba_64(cdb);
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case WRITE_6:
> @@ -3220,7 +3211,7 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_6;
> -		cmd->transport_get_lba = &transport_lba_21;
> +		T_TASK(cmd)->t_task_lba = transport_lba_21(cdb);
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
>  	case WRITE_10:
> @@ -3229,7 +3220,7 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_10;
> -		cmd->transport_get_lba = &transport_lba_32;
> +		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
>  		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
> @@ -3239,7 +3230,7 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_12;
> -		cmd->transport_get_lba = &transport_lba_32;
> +		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
>  		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
> @@ -3249,7 +3240,7 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_16;
> -		cmd->transport_get_long_lba = &transport_lba_64;
> +		T_TASK(cmd)->t_task_lba = transport_lba_64(cdb);
>  		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
>  		ret = TGCS_DATA_SG_IO_CDB;
>  		break;
> @@ -3262,7 +3253,7 @@ static int transport_generic_cmd_sequenc
>  			return TGCS_UNSUPPORTED_CDB;
>  		size = transport_get_size(sectors, cdb, cmd);
>  		cmd->transport_split_cdb = &split_cdb_XX_10;
> -		cmd->transport_get_lba = &transport_lba_32;
> +		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
>  		passthrough = (TRANSPORT(dev)->transport_type ==
>  				TRANSPORT_PLUGIN_PHBA_PDEV);
>  		/*
> @@ -3297,7 +3288,7 @@ static int transport_generic_cmd_sequenc
>  			 * XDWRITE_READ_32 logic.
>  			 */
>  			cmd->transport_split_cdb = &split_cdb_XX_32;
> -			cmd->transport_get_long_lba = &transport_lba_64_ext;
> +			T_TASK(cmd)->t_task_lba = transport_lba_64_ext(cdb);
>  			/*
>  			 * Skip the remaining assignments for TCM/PSCSI passthrough
>  			 */
> Index: lio-core/include/target/target_core_base.h
> ===================================================================
> --- lio-core.orig/include/target/target_core_base.h	2010-11-29 19:45:26.207004193 +0100
> +++ lio-core/include/target/target_core_base.h	2010-11-29 19:45:30.786254087 +0100
> @@ -531,8 +531,6 @@ struct se_cmd {
>  	struct se_transport_task t_task_backstore;
>  	struct target_core_fabric_ops *se_tfo;
>  	int (*transport_emulate_cdb)(struct se_cmd *);
> -	u32 (*transport_get_lba)(unsigned char *);
> -	unsigned long long (*transport_get_long_lba)(unsigned char *);
>  	void (*transport_split_cdb)(unsigned long long, u32 *, unsigned char *);
>  	void (*transport_wait_for_tasks)(struct se_cmd *, int, int);
>  	void (*transport_complete_callback)(struct se_cmd *);

