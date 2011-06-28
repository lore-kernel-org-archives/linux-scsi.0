From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/15] target: Eliminate usage of struct se_mem
Date: Tue, 28 Jun 2011 17:12:28 -0400
Message-ID: <20110628211228.GA7594@infradead.org>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com>
 <1309289377-8029-6-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55335
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733Ab1F1VMb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 17:12:31 -0400
Content-Disposition: inline
In-Reply-To: <1309289377-8029-6-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jun 28, 2011 at 12:29:27PM -0700, Andy Grover wrote:
> Both backstores and fabrics use arrays of struct scatterlist to describe
> data buffers. However TCM used struct se_mems, basically a linked list
> of scatterlist entries. We are able to simplify the code by eliminating
> this intermediate data structure and just using struct scatterlist[]
> throughout.

Nice!

> +	for_each_sg(cmd->t_data_sg, sg, cmd->t_data_nents, count) {
>  		/*
> +		 * Only called if
>  		 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
>  		 */
>  		if (free_page)
> +			__free_page(sg_page(sg));
>  
> +	if (free_page)
> +		kfree(cmd->t_data_sg);
> +	cmd->t_data_sg = NULL;
> +	cmd->t_data_nents = 0;
>  
> +	for_each_sg(cmd->t_bidi_data_sg, sg, cmd->t_bidi_data_nents, count) {
>  		/*
> +		 * Only called if
>  		 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
>  		 */
>  		if (free_page)
> +			__free_page(sg_page(sg));
>  
>  	}
> +	if (free_page)
> +		kfree(cmd->t_bidi_data_sg);
> +	cmd->t_bidi_data_sg = NULL;
> +	cmd->t_bidi_data_nents = 0;

Why bother going through the loops if we're not going to free
anything?  Might be worth to split this into a function doin the
clearing, which only gets condtionally called, and one zeroing out
the members, that also conditionally calls the low-level helper.

> @@ -4167,160 +4095,28 @@ transport_generic_get_mem(struct se_cmd *cmd)
>  	if (cmd->se_dev->transport->do_se_mem_map)
>  		return 0;
>  
> +	if (!length)
> +		return 0;
>  
> +	nents = DIV_ROUND_UP(length, PAGE_SIZE);
> +	cmd->t_data_sg = kmalloc(sizeof(struct scatterlist) * nents, GFP_KERNEL);
> +	if (!cmd->t_data_sg)
> +		return -ENOMEM;
>  
> +	cmd->t_data_nents = nents;
> +	sg_init_table(cmd->t_data_sg, nents);
>  
> +	while (length) {
> +		u32 page_len = min_t(u32, length, PAGE_SIZE);
> +		page = alloc_page(GFP_KERNEL);
> +		if (!page)
> +			return -ENOMEM;
>  
> +		sg_set_page(&cmd->t_data_sg[i], page, page_len, 0);
> +		length -= page_len;
> +		i++;
>  	}

This code pretty much is exactly the same as allocation in
iscsit_alloc_buffs.  If we can't switch iscsi to use internal buffers
directly we should at least export this helper so it can use it.

That also means killing the superflous t_mem_sg/t_mem_sg_nents members
in favour of t_data/t_data_nents.

> +		ret = transport_allocate_control_task(cmd);
> +		if (ret < 0)
> +			return ret;
> +		else
> +			return 1;

What about making transport_allocate_control_task return the expected
value directly?

> @@ -4863,19 +4395,13 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
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

transport_map_control_cmd_to_task might have called ->cdb_none
before.  While I'd love to kill that method I haven't seen any work
towards actually making that happen.  So for now I suspect you'll
still need the conditionally call to ->cdb_none.

