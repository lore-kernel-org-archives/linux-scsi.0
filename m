From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/2 2.6.29-rc] cxgb3i - add handling of chip reset
Date: Wed, 25 Feb 2009 11:21:52 -0600
Message-ID: <49A57E30.7010001@cs.wisc.edu>
References: <200902250128.n1P1SJOD007746@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42010 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbZBYRWI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2009 12:22:08 -0500
In-Reply-To: <200902250128.n1P1SJOD007746@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

Karen Xie wrote:
> [PATCH 2/2 2.6.29-rc] cxgb3i - add support of chip reset
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> The cxgb3 driver would reset the chip due to an EEH event or a fatal error
> and notifies the upper layer modules (iscsi, rdma).
> Upon receiving the notification the cxgb3i driver would 
> - close all the iscsi tcp connections and mark the associated sessions as
>   failed due to connection error,
> - re-initialize its offload functions,
> - re-initialize the chip's ddp functions.
> 
> The iscsi error recovery mechanism will re-establish the tcp connection after
> reset. 
> 
> This patch requires the the following cxgb3 patch in the linux-next git tree
> (http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=cb0bc205959bf8c60acae9c71f3da0597e756f8e).
> 


>  
>  static inline int ddp_find_unused_entries(struct cxgb3i_ddp_info *ddp,
> @@ -439,14 +444,15 @@ EXPORT_SYMBOL_GPL(cxgb3i_ddp_tag_reserve);
>   * @tag: ddp tag
>   * ddp cleanup for a given ddp tag and release all the resources held
>   */
> -void cxgb3i_ddp_tag_release(struct t3cdev *tdev, u32 tag)
> +int cxgb3i_ddp_tag_release(struct t3cdev *tdev, u32 tag)
>  {
>  	struct cxgb3i_ddp_info *ddp = tdev->ulp_iscsi;
>  	u32 idx;
> +	int err = -EINVAL;
>  
>  	if (!ddp) {
>  		ddp_log_error("release ddp tag 0x%x, ddp NULL.\n", tag);
> -		return;
> +		return err;
>  	}
>  
>  	idx = (tag >> PPOD_IDX_SHIFT) & ddp->idx_mask;
> @@ -457,17 +463,26 @@ void cxgb3i_ddp_tag_release(struct t3cdev *tdev, u32 tag)
>  		if (!gl) {
>  			ddp_log_error("release ddp 0x%x, idx 0x%x, gl NULL.\n",
>  				      tag, idx);
> -			return;
> +			return err;
>  		}
>  		npods = (gl->nelem + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
> +		if (!npods) {
> +			ddp_log_error("release ddp 0x%x, 0x%x, gl elem %u.\n",
> +				      tag, idx, gl->nelem);
> +			return err;
> +		}
>  		ddp_log_debug("ddp tag 0x%x, release idx 0x%x, npods %u.\n",
>  			      tag, idx, npods);
> -		clear_ddp_map(ddp, idx, npods);
> +		if (clear_ddp_map(ddp, tag, idx, npods) == npods)
> +			err = 0;
>  		ddp_unmark_entries(ddp, idx, npods);
>  		cxgb3i_ddp_release_gl(gl, ddp->pdev);


If this fails, do we leak this memory?

When is ddp_release called? Would it be called to clean up in situati 
this could fail?


> +/**
> + * cxgb3i_adapter_remove - release all the resources held and cleanup any
> + *	h/w settings

The docbook comment for the function description should only be one 
line. I think you did this in some other places.


>  
> -void cxgb3i_conn_closing(struct s3_conn *c3cn)
> +void cxgb3i_conn_closing(struct s3_conn *c3cn, int error)
>  {
>  	struct iscsi_conn *conn;
>  
>  	read_lock(&c3cn->callback_lock);
>  	conn = c3cn->user_data;
> -	if (conn && c3cn->state != C3CN_STATE_ESTABLISHED)
> -		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
> +	if (conn && c3cn->state != C3CN_STATE_ESTABLISHED) {
> +		if (error)
> +			iscsi_session_failure(conn->session,
> +						ISCSI_ERR_CONN_FAILED);
> +		else
> +			iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
> +	}
>  	read_unlock(&c3cn->callback_lock);


If you have a ref to the conn, you can just use iscsi_conn_failure here. 
I thought when you got the pci error event you were just going to use 
the host session iter and loop over the session and fail them.


