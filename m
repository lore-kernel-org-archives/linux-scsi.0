From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/20] target: Eliminate usage of struct se_mem
Date: Fri, 8 Jul 2011 16:13:31 -0400
Message-ID: <20110708201331.GD12288@infradead.org>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
 <1310078011-15504-7-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36015
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754909Ab1GHUNd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 16:13:33 -0400
Content-Disposition: inline
In-Reply-To: <1310078011-15504-7-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

>  
>  	iov_count += TRANSPORT_IOV_DATA_BUFFER;
>  
> @@ -815,7 +815,7 @@ static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
>  
>  	/* BIDI ops not supported */
>  
> -	/* make se_mem list from the memory */
> +	/* Tell the core about our preallocated memory */
>  	transport_generic_map_mem_to_cmd(&cmd->se_cmd, sgl, nents, NULL, 0);

Probably not worth it for this series, but for a next one, but what
about killing transport_generic_map_mem_to_cmd?  The drivers can do the
assignment just as fine, and we could probably set
SCF_SCSI_CONTROL_NONSG_IO_CDB automatically when the fabric sets the S/G
list before calling in for processing.

Or maybe we should stop calling transport_generic_get_mem from the
core entirely and just export it as a helper to the fabrics as the
default implementation.  This actually sounds like the nicest option
to me.

>  	struct se_task *task;
>  	struct se_device *dev = cmd->se_dev;
> -	unsigned long flags;
>  
>  	task = dev->transport->alloc_task(cmd);
>  	if (!task) {
> @@ -1723,10 +1707,6 @@ transport_generic_get_task(struct se_cmd *cmd,
>  	task->se_dev = dev;
>  	task->task_data_direction = data_direction;
>  
> -	spin_lock_irqsave(&cmd->t_state_lock, flags);
> -	list_add_tail(&task->t_list, &cmd->t_task_list);
> -	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> -

How is moving the task <-> cmd linkage related to the rest of the patch?
It probably should be a separate preparatory patch, but at least needs
some good documentation.

>  static int transport_new_cmd_obj(struct se_cmd *cmd)
>  {
>  	struct se_device *dev = cmd->se_dev;
>  	u32 task_cdbs;
>  	u32 rc;
> +	int set_counts = 1;
>  
> +	/*
> +	 * Setup any BIDI READ tasks and memory from
> +	 * cmd->t_mem_bidi_list so the READ struct se_tasks
> +	 * are queued first for the non pSCSI passthrough case.
> +	 */
> +	if (cmd->t_bidi_data_sg &&
> +	    (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV)) {

no need for braces around the comparism.

> +static u32 transport_allocate_tasks(
> +	struct se_cmd *cmd,
> +	unsigned long long lba,
> +	enum dma_data_direction data_direction,
> +	struct scatterlist *sgl,
> +	unsigned int sgl_nents)
> +{
> +	int ret;
> +
> +	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
> +		return transport_allocate_data_tasks(cmd, lba, data_direction,
> +						     sgl, sgl_nents);
> +	} else {
> +		ret = transport_allocate_control_task(cmd);
> +		if (ret < 0)
> +			return ret;
> +		else
> +			return 1;

Any reason you don't directly return the expected value from
transport_allocate_control_task?

>  	 * Determine is the TCM fabric module has already allocated physical
>  	 * memory, and is directly calling transport_generic_map_mem_to_cmd()
> -	 * to setup beforehand the linked list of physical memory at
> -	 * cmd->t_mem_list of struct se_mem->se_page
> +	 * beforehand.
>  	 */
>  	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
>  		ret = transport_generic_get_mem(cmd);
> @@ -4868,19 +4400,13 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
>  	if (ret < 0)
>  		return ret;
>  
> -	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
> -		list_for_each_entry(task, &cmd->t_task_list, t_list) {
> -			if (atomic_read(&task->task_sent))
> -				continue;
> -			if (!dev->transport->map_task_SG)
> -				continue;
> -
> -			ret = dev->transport->map_task_SG(task);
> -			if (ret < 0)
> -				return ret;
> -		}
> -	} else {
> -		ret = transport_map_control_cmd_to_task(cmd);
> +	list_for_each_entry(task, &cmd->t_task_list, t_list) {
> +		if (atomic_read(&task->task_sent))
> +			continue;
> +		if (!dev->transport->map_task_SG)
> +			continue;
> + 
> +		ret = dev->transport->map_task_SG(task);
>  		if (ret < 0)
>  			return ret;
>  	}

This still looks incorrect to me as control CDBs might have to
end up in ->cdb_none.  Or did I miss how this gets handled now?

