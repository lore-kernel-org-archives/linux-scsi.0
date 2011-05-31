From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 10/42] target: Rewrite transport_init_task_sg()
Date: Tue, 31 May 2011 00:08:49 -0700
Message-ID: <1306825729.8193.77.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
	 <1306523240-15543-11-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47317 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab1EaHRO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2011 03:17:14 -0400
In-Reply-To: <1306523240-15543-11-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2011-05-27 at 12:06 -0700, Andy Grover wrote:
> Don't set task->task_sg_num until task_sg is successfully alloced, to
> prevent it from possibly being out of sync.
> 
> Simplify loop counting sgs needed. Handle possible (?) case of offset
> greater than se_mem->se_len. Remove some cluttering debugprints. Reduce
> local variable usage.
> 
> Do not set termination bit in padded-1 entry in the padded_sg case. If
> something barfs on an extra zeroed sg, (will happen if chain-capable sgs
> don't actually get chained) then it's broken.
> 
> Remove unneeded parens.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---

So I am not exactly sure there is an issue here with task->task_sg_num
assignment in the failure case, as nothing depends AFAICT upon
task->task_sg_num in the release path before an possible
transport_init_task_sg() failure..

However, my main concern is the removal of sg_mark_end() calls  to
signify the end of task->task_sg[] memory for individual task I/O
dispatch.  As you have noticed this looks OK with existing code wrt to
backend *_map_task_sg() and *_do_task() using for_each_sg() w/
task->task_sg_num, but am wondering if it really makes sense to remove
this for the actual scatterlist dispatch for all backends..?  Is there
any possible code below TCM backend drivers where HW drivers can pose an
issue..?

I am happy to merge this for tcm v4.1 along with patch #11 if this is
really safe to do, but will defer for the moment until we can get a few
more ACKs on these two..

Thank you,

--nab

>  drivers/target/target_core_transport.c |  104 ++++++++++----------------------
>  1 files changed, 32 insertions(+), 72 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index c8e61d7..7b97c6b 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -4122,116 +4122,76 @@ out:
>  	return -ENOMEM;
>  }
>  
> +/*
> + * Allocate and init task->task_sg and ->task_sg_bidi so they are large enough
> + * to handle task->task_size bytes, and based on t_mem_list se_mem chunking.
> + */
>  int transport_init_task_sg(
>  	struct se_task *task,
> -	struct se_mem *in_se_mem,
> +	struct se_mem *se_mem,
>  	u32 task_offset)
>  {
>  	struct se_cmd *se_cmd = task->task_se_cmd;
>  	struct se_device *se_dev = se_cmd->se_dev;
> -	struct se_mem *se_mem = in_se_mem;
> -	struct target_core_fabric_ops *tfo = se_cmd->se_tfo;
> -	u32 sg_length, task_size = task->task_size, task_sg_num_padded;
> -
> -	while (task_size != 0) {
> -		DEBUG_SC("se_mem->se_page(%p) se_mem->se_len(%u)"
> -			" se_mem->se_off(%u) task_offset(%u)\n",
> -			se_mem->se_page, se_mem->se_len,
> -			se_mem->se_off, task_offset);
> -
> -		if (task_offset == 0) {
> -			if (task_size >= se_mem->se_len) {
> -				sg_length = se_mem->se_len;
> +	u32 task_size = task->task_size;
> +	u32 sgs_needed = 0;
>  
> -				if (!(list_is_last(&se_mem->se_list,
> -						&se_cmd->t_mem_list)))
> -					se_mem = list_entry(se_mem->se_list.next,
> -							struct se_mem, se_list);
> -			} else {
> -				sg_length = task_size;
> -				task_size -= sg_length;
> -				goto next;
> -			}
> +	/* count how many sgs we need */
> +	while (1) {
> +		/* handle if offset is greater than se_mem->se_len */
> +		u32 se_mem_offset = min_t(u32, task_offset, se_mem->se_len);
> +		u32 se_mem_length = (se_mem->se_len - se_mem_offset);
>  
> -			DEBUG_SC("sg_length(%u) task_size(%u)\n",
> -					sg_length, task_size);
> -		} else {
> -			if ((se_mem->se_len - task_offset) > task_size) {
> -				sg_length = task_size;
> -				task_size -= sg_length;
> -				goto next;
> -			 } else {
> -				sg_length = (se_mem->se_len - task_offset);
> +		sgs_needed++;
>  
> -				if (!(list_is_last(&se_mem->se_list,
> -						&se_cmd->t_mem_list)))
> -					se_mem = list_entry(se_mem->se_list.next,
> -							struct se_mem, se_list);
> -			}
> +		if (se_mem_length >= task_size)
> +			break;
>  
> -			DEBUG_SC("sg_length(%u) task_size(%u)\n",
> -					sg_length, task_size);
> +		task_offset -= se_mem_offset;
> +		task_size -= se_mem_length;
>  
> -			task_offset = 0;
> -		}
> -		task_size -= sg_length;
> -next:
> -		DEBUG_SC("task[%u] - Reducing task_size to(%u)\n",
> -			task->task_no, task_size);
> +		BUG_ON(list_is_last(&se_mem->se_list, &se_cmd->t_mem_list));
>  
> -		task->task_sg_num++;
> +		se_mem = list_entry(se_mem->se_list.next, struct se_mem, se_list);
>  	}
> +
>  	/*
>  	 * Check if the fabric module driver is requesting that all
>  	 * struct se_task->task_sg[] be chained together..  If so,
>  	 * then allocate an extra padding SG entry for linking and
>  	 * marking the end of the chained SGL.
>  	 */
> -	if (tfo->task_sg_chaining) {
> -		task_sg_num_padded = (task->task_sg_num + 1);
> +	if (se_cmd->se_tfo->task_sg_chaining) {
> +		sgs_needed++;
>  		task->task_padded_sg = 1;
> -	} else
> -		task_sg_num_padded = task->task_sg_num;
> +	}
>  
> -	task->task_sg = kzalloc(task_sg_num_padded *
> +	task->task_sg = kzalloc(sgs_needed *
>  			sizeof(struct scatterlist), GFP_KERNEL);
>  	if (!(task->task_sg)) {
>  		printk(KERN_ERR "Unable to allocate memory for"
>  				" task->task_sg\n");
>  		return -ENOMEM;
>  	}
> -	sg_init_table(&task->task_sg[0], task_sg_num_padded);
> +	sg_init_table(task->task_sg, sgs_needed);
> +	task->task_sg_num = sgs_needed;
> +
>  	/*
>  	 * Setup task->task_sg_bidi for SCSI READ payload for
>  	 * TCM/pSCSI passthrough if present for BIDI-COMMAND
>  	 */
>  	if (!list_empty(&se_cmd->t_mem_bidi_list) &&
>  	    (se_dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)) {
> -		task->task_sg_bidi = kzalloc(task_sg_num_padded *
> +		task->task_sg_bidi = kzalloc(sgs_needed *
>  				sizeof(struct scatterlist), GFP_KERNEL);
> -		if (!(task->task_sg_bidi)) {
> +		if (!task->task_sg_bidi) {
>  			kfree(task->task_sg);
>  			task->task_sg = NULL;
>  			printk(KERN_ERR "Unable to allocate memory for"
>  				" task->task_sg_bidi\n");
>  			return -ENOMEM;
>  		}
> -		sg_init_table(&task->task_sg_bidi[0], task_sg_num_padded);
> -	}
> -	/*
> -	 * For the chaining case, setup the proper end of SGL for the
> -	 * initial submission struct task into struct se_subsystem_api.
> -	 * This will be cleared later by transport_do_task_sg_chain()
> -	 */
> -	if (task->task_padded_sg) {
> -		sg_mark_end(&task->task_sg[task->task_sg_num - 1]);
> -		/*
> -		 * Added the 'if' check before marking end of bi-directional
> -		 * scatterlist (which gets created only in case of request
> -		 * (RD + WR).
> -		 */
> -		if (task->task_sg_bidi)
> -			sg_mark_end(&task->task_sg_bidi[task->task_sg_num - 1]);
> +		sg_init_table(task->task_sg_bidi, sgs_needed);
>  	}
>  
>  	DEBUG_SC("Successfully allocated task->task_sg_num(%u),"
> -- 
> 1.7.1
> 

