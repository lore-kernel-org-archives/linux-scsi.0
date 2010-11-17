From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/3] target: simplify cmd to task mapping
Date: Wed, 17 Nov 2010 14:47:05 -0800
Message-ID: <1290034025.31890.75.camel@haakon2.linux-iscsi.org>
References: <20101117213857.GB26557@infradead.org>
	 <1290033607.31890.71.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53499 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935582Ab0KQWw2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 17:52:28 -0500
In-Reply-To: <1290033607.31890.71.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 2010-11-17 at 14:40 -0800, Nicholas A. Bellinger wrote:
> On Wed, 2010-11-17 at 16:38 -0500, Christoph Hellwig wrote:
> > The cmd to task mapping is almost the same for all control CDBs,
> > except for calling different backend methods to do the backed-specific
> > mapping.  Merge the code performing the mapping into a single
> > new transport_map_control_cmd_to_task helper, and kill the
> > transport_map_task callback by simplify calling the backend methods
> > directly for the single task for a control CDB, and hardcoding
> > ->map_task_SG for data CDBs.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This one looks very reasonable as the extra set of bitwise AND
> instructions is limited to control path code.
> 

Committed as 630eeda6.  Thanks hch!

> --nab
> 
> > 
> > Index: lio-core/drivers/target/target_core_transport.c
> > ===================================================================
> > --- lio-core.orig/drivers/target/target_core_transport.c	2010-11-16 18:55:26.414004751 +0100
> > +++ lio-core/drivers/target/target_core_transport.c	2010-11-16 18:55:30.075004681 +0100
> > @@ -2258,132 +2258,6 @@ static struct se_task *transport_generic
> >  	return task;
> >  }
> >  
> > -static int transport_do_se_mem_map(struct se_device *, struct se_task *,
> > -	struct list_head *, void *, struct se_mem *, struct se_mem **,
> > -	u32 *, u32 *);
> > -
> > -/*	transport_process_control_sg_transform():
> > - *
> > - *
> > - */
> > -static int transport_process_control_sg_transform(
> > -	struct se_cmd *cmd,
> > -	struct se_transform_info *ti)
> > -{
> > -	unsigned char *cdb;
> > -	struct se_task *task;
> > -	struct se_mem *se_mem, *se_mem_lout = NULL;
> > -	struct se_device *dev = SE_DEV(cmd);
> > -	int ret;
> > -	u32 se_mem_cnt = 0, task_offset = 0;
> > -
> > -	list_for_each_entry(se_mem, T_TASK(cmd)->t_mem_list, se_list)
> > -		break;
> > -
> > -	if (!se_mem) {
> > -		printk(KERN_ERR "se_mem is NULL!\n");
> > -		return -1;
> > -	}
> > -
> > -	task = transport_generic_get_task(ti, cmd, ti->se_obj_ptr,
> > -					  cmd->data_direction);
> > -	if (!(task))
> > -		return -1;
> > -
> > -	task->transport_map_task = ti->se_obj_ptr->transport->map_task_SG;
> > -
> > -	cdb = TRANSPORT(dev)->get_cdb(task);
> > -	if (cdb)
> > -		memcpy(cdb, T_TASK(cmd)->t_task_cdb,
> > -			scsi_command_size(T_TASK(cmd)->t_task_cdb));
> > -
> > -	task->task_size = cmd->data_length;
> > -	task->task_sg_num = 1;
> > -
> > -	atomic_inc(&T_TASK(cmd)->t_fe_count);
> > -	atomic_inc(&T_TASK(cmd)->t_se_count);
> > -
> > -	ret = transport_do_se_mem_map(ti->se_obj_ptr, task,
> > -			T_TASK(cmd)->t_mem_list, NULL, se_mem, &se_mem_lout,
> > -			&se_mem_cnt, &task_offset);
> > -	if (ret < 0)
> > -		return ret;
> > -
> > -	DEBUG_CDB_H("task_no[%u]: SCF_SCSI_CONTROL_SG_IO_CDB task_size: %d\n",
> > -			task->task_no, task->task_size);
> > -	return 0;
> > -}
> > -
> > -/*	transport_process_control_nonsg_transform():
> > - *
> > - *
> > - */
> > -static int transport_process_control_nonsg_transform(
> > -	struct se_cmd *cmd,
> > -	struct se_transform_info *ti)
> > -{
> > -	struct se_device *dev = SE_DEV(cmd);
> > -	unsigned char *cdb;
> > -	struct se_task *task;
> > -
> > -	task = transport_generic_get_task(ti, cmd, ti->se_obj_ptr,
> > -					  cmd->data_direction);
> > -	if (!(task))
> > -		return -1;
> > -
> > -	task->transport_map_task = ti->se_obj_ptr->transport->map_task_non_SG;
> > -
> > -	cdb = TRANSPORT(dev)->get_cdb(task);
> > -	if (cdb)
> > -		memcpy(cdb, T_TASK(cmd)->t_task_cdb,
> > -			scsi_command_size(T_TASK(cmd)->t_task_cdb));
> > -
> > -	task->task_size = cmd->data_length;
> > -	task->task_sg_num = 0;
> > -
> > -	atomic_inc(&T_TASK(cmd)->t_fe_count);
> > -	atomic_inc(&T_TASK(cmd)->t_se_count);
> > -
> > -	DEBUG_CDB_H("task_no[%u]: SCF_SCSI_CONTROL_NONSG_IO_CDB task_size:"
> > -			" %d\n", task->task_no, task->task_size);
> > -	return 0;
> > -}
> > -
> > -/*	transport_process_non_data_transform():
> > - *
> > - *
> > - */
> > -static int transport_process_non_data_transform(
> > -	struct se_cmd *cmd,
> > -	struct se_transform_info *ti)
> > -{
> > -	struct se_device *dev = SE_DEV(cmd);
> > -	unsigned char *cdb;
> > -	struct se_task *task;
> > -
> > -	task = transport_generic_get_task(ti, cmd, ti->se_obj_ptr,
> > -					  cmd->data_direction);
> > -	if (!(task))
> > -		return -1;
> > -
> > -	task->transport_map_task = ti->se_obj_ptr->transport->cdb_none;
> > -
> > -	cdb = TRANSPORT(dev)->get_cdb(task);
> > -	if (cdb)
> > -		memcpy(cdb, T_TASK(cmd)->t_task_cdb,
> > -			scsi_command_size(T_TASK(cmd)->t_task_cdb));
> > -
> > -	task->task_size = cmd->data_length;
> > -	task->task_sg_num = 0;
> > -
> > -	atomic_inc(&T_TASK(cmd)->t_fe_count);
> > -	atomic_inc(&T_TASK(cmd)->t_se_count);
> > -
> > -	DEBUG_CDB_H("task_no[%u]: SCF_SCSI_NON_DATA_CDB task_size: %d\n",
> > -			task->task_no, task->task_size);
> > -	return 0;
> > -}
> > -
> >  static int transport_generic_cmd_sequencer(struct se_cmd *, unsigned char *);
> >  
> >  void transport_device_setup_cmd(struct se_cmd *cmd)
> > @@ -5942,8 +5816,6 @@ u32 transport_generic_get_cdb_count(
> >  		task->task_size = (task->task_sectors *
> >  				   DEV_ATTRIB(dev)->block_size);
> >  
> > -		task->transport_map_task = dev->transport->map_task_SG;
> > -
> >  		cdb = TRANSPORT(dev)->get_cdb(task);
> >  		if ((cdb)) {
> >  			memcpy(cdb, T_TASK(cmd)->t_task_cdb,
> > @@ -6011,6 +5883,61 @@ out:
> >  	return 0;
> >  }
> >  
> > +static int
> > +transport_map_control_cmd_to_task(struct se_cmd *cmd,
> > +		struct se_transform_info *ti)
> > +{
> > +	struct se_device *dev = SE_DEV(cmd);
> > +	unsigned char *cdb;
> > +	struct se_task *task;
> > +	int ret;
> > +
> > +	task = transport_generic_get_task(ti, cmd, ti->se_obj_ptr,
> > +				  cmd->data_direction);
> > +	if (!task)
> > +		return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> > +
> > +	cdb = TRANSPORT(dev)->get_cdb(task);
> > +	if (cdb)
> > +		memcpy(cdb, cmd->t_task->t_task_cdb,
> > +			scsi_command_size(cmd->t_task->t_task_cdb));
> > +
> > +	task->task_size = cmd->data_length;
> > +	task->task_sg_num =
> > +		(cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) ? 1 : 0;
> > +
> > +	atomic_inc(&cmd->t_task->t_fe_count);
> > +	atomic_inc(&cmd->t_task->t_se_count);
> > +
> > +	if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) {
> > +		struct se_mem *se_mem, *se_mem_lout = NULL;
> > +		u32 se_mem_cnt = 0, task_offset = 0;
> > +
> > +		BUG_ON(list_empty(cmd->t_task->t_mem_list));
> > +
> > +		ret = transport_do_se_mem_map(dev, task,
> > +				cmd->t_task->t_mem_list, NULL, se_mem,
> > +				&se_mem_lout, &se_mem_cnt, &task_offset);
> > +		if (ret < 0)
> > +			return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> > +
> > +		if (dev->transport->map_task_SG)
> > +			return dev->transport->map_task_SG(task);
> > +		return 0;
> > +	} else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
> > +		if (dev->transport->map_task_non_SG(task))
> > +			return dev->transport->map_task_non_SG(task);
> > +		return 0;
> > +	} else if (cmd->se_cmd_flags & SCF_SCSI_NON_DATA_CDB) {
> > +		if (dev->transport->cdb_none(task))
> > +			return dev->transport->cdb_none(task);
> > +		return 0;
> > +	} else {
> > +		BUG();
> > +		return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> > +	}
> > +}
> > +
> >  /*	 transport_generic_new_cmd(): Called from transport_processing_thread()
> >   *
> >   *	 Allocate storage transport resources from a set of values predefined
> > @@ -6041,16 +5968,17 @@ int transport_generic_new_cmd(struct se_
> >  		if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
> >  			ret = transport_allocate_resources(cmd);
> >  			if (ret < 0)
> > -				goto failure;
> > +				return ret;
> >  		}
> >  
> >  		ret = transport_get_sectors(cmd);
> >  		if (ret < 0)
> > -			goto failure;
> > +			return ret;
> >  
> >  		ret = transport_new_cmd_obj(cmd, &ti, 0);
> >  		if (ret < 0)
> > -			goto failure;
> > +			return ret;
> > +
> >  		/*
> >  		 * Determine if the calling TCM fabric module is talking to
> >  		 * Linux/NET via kernel sockets and needs to allocate a
> > @@ -6059,41 +5987,26 @@ int transport_generic_new_cmd(struct se_
> >  		se_tpg = SE_LUN(cmd)->lun_sep->sep_tpg;
> >  		if (TPG_TFO(se_tpg)->alloc_cmd_iovecs != NULL) {
> >  			ret = TPG_TFO(se_tpg)->alloc_cmd_iovecs(cmd);
> > -			if (ret < 0) {
> > -				ret = PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> > -				goto failure;
> > -			}
> > +			if (ret < 0)
> > +				return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> >  		}
> >  	}
> >  
> > -	if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)
> > -		ret = transport_process_control_sg_transform(cmd, &ti);
> > -	else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB)
> > -		ret = transport_process_control_nonsg_transform(cmd, &ti);
> > -	else if (cmd->se_cmd_flags & SCF_SCSI_NON_DATA_CDB)
> > -		ret = transport_process_non_data_transform(cmd, &ti);
> > -	else
> > -		BUG_ON(!(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB));
> > -
> > -	if (ret < 0) {
> > -		ret = PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> > -		goto failure;
> > -	}
> > +	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
> > +		list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
> > +			if (atomic_read(&task->task_sent))
> > +				continue;
> > +			if (!ti.se_obj_ptr->transport->map_task_SG)
> > +				continue;
> >  
> > -	/*
> > -	 * Set the correct (usually DMAable) buffer pointers from the master
> > -	 * buffer list in struct se_cmd to the transport task's native
> > -	 * buffers format.
> > -	 */
> > -	list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
> > -		if (atomic_read(&task->task_sent))
> > -			continue;
> > -
> > -		if (task->transport_map_task) {
> > -			ret = task->transport_map_task(task);
> > +			ret = ti.se_obj_ptr->transport->map_task_SG(task);
> >  			if (ret < 0)
> > -				goto failure;
> > +				return ret;
> >  		}
> > +	} else {
> > +		ret = transport_map_control_cmd_to_task(cmd, &ti);
> > +		if (ret < 0)
> > +			return ret;
> >  	}
> >  
> >  	/*
> > @@ -6113,9 +6026,6 @@ int transport_generic_new_cmd(struct se_
> >  	 */
> >  	transport_execute_tasks(cmd);
> >  	return 0;
> > -
> > -failure:
> > -	return ret;
> >  }
> >  
> >  /*	transport_generic_process_write():
> > Index: lio-core/include/target/target_core_base.h
> > ===================================================================
> > --- lio-core.orig/include/target/target_core_base.h	2010-11-16 18:55:26.415004611 +0100
> > +++ lio-core/include/target/target_core_base.h	2010-11-16 18:55:30.076003773 +0100
> > @@ -499,7 +499,6 @@ struct se_task {
> >  	atomic_t	task_stop;
> >  	atomic_t	task_state_active;
> >  	struct timer_list	task_timer;
> > -	int (*transport_map_task)(struct se_task *);
> >  	struct se_device *se_obj_ptr;
> >  	struct list_head t_list;
> >  	struct list_head t_execute_list;
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

