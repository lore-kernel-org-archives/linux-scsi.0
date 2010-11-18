From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] target: simplify cmd to task mapping
Date: Thu, 18 Nov 2010 14:07:17 +0200
Message-ID: <4CE516F5.10400@panasas.com>
References: <20101117213857.GB26557@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:39845 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab0KRMHT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 07:07:19 -0500
In-Reply-To: <20101117213857.GB26557@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On 11/17/2010 11:38 PM, Christoph Hellwig wrote:
> The cmd to task mapping is almost the same for all control CDBs,
> except for calling different backend methods to do the backed-specific
> mapping.  Merge the code performing the mapping into a single
> new transport_map_control_cmd_to_task helper, and kill the
> transport_map_task callback by simplify calling the backend methods
> directly for the single task for a control CDB, and hardcoding
> ->map_task_SG for data CDBs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

<>

> +static int
> +transport_map_control_cmd_to_task(struct se_cmd *cmd,
> +		struct se_transform_info *ti)
> +{
> +	struct se_device *dev = SE_DEV(cmd);
> +	unsigned char *cdb;
> +	struct se_task *task;
> +	int ret;
> +
> +	task = transport_generic_get_task(ti, cmd, ti->se_obj_ptr,
> +				  cmd->data_direction);
> +	if (!task)
> +		return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> +
> +	cdb = TRANSPORT(dev)->get_cdb(task);
> +	if (cdb)
> +		memcpy(cdb, cmd->t_task->t_task_cdb,
> +			scsi_command_size(cmd->t_task->t_task_cdb));
> +
> +	task->task_size = cmd->data_length;
> +	task->task_sg_num =
> +		(cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) ? 1 : 0;
> +
> +	atomic_inc(&cmd->t_task->t_fe_count);
> +	atomic_inc(&cmd->t_task->t_se_count);
> +
> +	if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) {
> +		struct se_mem *se_mem, *se_mem_lout = NULL;
> +		u32 se_mem_cnt = 0, task_offset = 0;
> +
> +		BUG_ON(list_empty(cmd->t_task->t_mem_list));
> +
> +		ret = transport_do_se_mem_map(dev, task,
> +				cmd->t_task->t_mem_list, NULL, se_mem,
> +				&se_mem_lout, &se_mem_cnt, &task_offset);
> +		if (ret < 0)
> +			return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> +
> +		if (dev->transport->map_task_SG)
> +			return dev->transport->map_task_SG(task);
> +		return 0;
> +	} else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
> +		if (dev->transport->map_task_non_SG(task))
> +			return dev->transport->map_task_non_SG(task);
> +		return 0;
> +	} else if (cmd->se_cmd_flags & SCF_SCSI_NON_DATA_CDB) {
> +		if (dev->transport->cdb_none(task))
> +			return dev->transport->cdb_none(task);
> +		return 0;

If all these are mutual exclusive (if..elseif..else) can we not make
them an enum and switch() for costless-ness and clarity?

Boaz
> +	} else {
> +		BUG();
> +		return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> +	}
> +}
> +

<>
