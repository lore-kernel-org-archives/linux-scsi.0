From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/9] target: remove
	transport_generic_map_buffers_to_tasks
Date: Mon, 08 Nov 2010 14:29:15 -0800
Message-ID: <1289255355.27226.86.camel@haakon2.linux-iscsi.org>
References: <20101108155601.872926000@canuck.infradead.org>
	 <20101108155647.704648200@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39024 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab0KHWe1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 17:34:27 -0500
In-Reply-To: <20101108155647.704648200@canuck.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2010-11-08 at 10:56 -0500, Christoph Hellwig wrote:
> plain text document attachment
> (lio-cleanup-transport_generic_map_buffers_to_tasks)
> transport_generic_map_buffers_to_tasks has three difference cases that all
> perform the same loop.  Remove the function and inline that small loop into
> the only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Committed as 2e20f790f.  Good catch on more unnecessary legacy cruft!!

--nab

> 
> Index: lio-core-2.6/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core-2.6.orig/drivers/target/target_core_transport.c	2010-11-06 20:44:44.378004019 +0100
> +++ lio-core-2.6/drivers/target/target_core_transport.c	2010-11-06 20:50:48.133255099 +0100
> @@ -7092,75 +7092,6 @@ int transport_generic_map_mem_to_cmd(
>  EXPORT_SYMBOL(transport_generic_map_mem_to_cmd);
>  	
>  
> -/*	transport_generic_map_buffers_to_tasks():
> - *
> - *	Called from transport_generic_new_cmd() in Transport Processing Thread.
> - */
> -static int transport_generic_map_buffers_to_tasks(struct se_cmd *cmd)
> -{
> -	struct se_task *task = NULL;
> -	int ret;
> -
> -	/*
> -	 * Deal with non [READ,WRITE]_XX CDBs here.
> -	 */
> -	if (cmd->se_cmd_flags & SCF_SCSI_NON_DATA_CDB)
> -		goto non_scsi_data;
> -	else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
> -		list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
> -			if (atomic_read(&task->task_sent))
> -				continue;
> -
> -			ret = task->transport_map_task(task, task->task_size);
> -			if (ret < 0)
> -				return ret;
> -
> -			DEBUG_CMD_M("Mapping SCF_SCSI_CONTROL_NONSG_IO_CDB"
> -				" task_size: %u\n", task->task_size);
> -		}
> -		return 0;
> -	}
> -
> -	/*
> -	 * Determine the scatterlist offset for each struct se_task,
> -	 * and segment and set pointers to storage transport buffers
> -	 * via task->transport_map_task().
> -	 */
> -	list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
> -		if (atomic_read(&task->task_sent))
> -			continue;
> -
> -		ret = task->transport_map_task(task, task->task_size);
> -		if (ret < 0)
> -			return ret;
> -
> -		DEBUG_CMD_M("Mapping task[%d]_se_obj_ptr[%p] %s_IO task_lba:"
> -			" %llu task_size: %u task_sg_num: %d\n",
> -			task->task_no, task->se_obj_ptr,
> -			(cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) ?
> -			"CONTROL" : "DATA", task->task_lba, task->task_size,
> -			task->task_sg_num);
> -	}
> -
> -	return 0;
> -
> -non_scsi_data:
> -	list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
> -		if (atomic_read(&task->task_sent))
> -			continue;
> -
> -		ret = task->transport_map_task(task, task->task_size);
> -		if (ret < 0)
> -			return ret;
> -
> -		DEBUG_CMD_M("Mapping SCF_SCSI_NON_DATA_CDB task_size: %u"
> -			" task->task_sg_num: %d\n", task->task_size,
> -				task->task_sg_num);
> -	}
> -
> -	return 0;
> -}
> -
>  static inline long long transport_dev_end_lba(struct se_device *dev)
>  {
>  	return dev->dev_sectors_total + 1;
> @@ -7993,6 +7924,7 @@ int transport_generic_new_cmd(struct se_
>  {
>  	struct se_portal_group *se_tpg;
>  	struct se_transform_info ti;
> +	struct se_task *task;
>  	int ret = 0;
>  	/*
>  	 * Generate struct se_task(s) and/or their payloads for this CDB.
> @@ -8055,9 +7987,14 @@ int transport_generic_new_cmd(struct se_
>  	 * buffer list in struct se_cmd to the transport task's native
>  	 * buffers format.
>  	 */
> -	ret = transport_generic_map_buffers_to_tasks(cmd);
> -	if (ret < 0)
> -		goto failure;
> +	list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
> +		if (atomic_read(&task->task_sent))
> +			continue;
> +
> +		ret = task->transport_map_task(task, task->task_size);
> +		if (ret < 0)
> +			goto failure;
> +	}
>  
>  	/*
>  	 * For WRITEs, let the iSCSI Target RX Thread know its buffer is ready..
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

