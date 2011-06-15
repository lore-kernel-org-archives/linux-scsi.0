From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Make transport_lookup_cmd_lun() locking
	IRQ-safe
Date: Wed, 15 Jun 2011 10:06:36 -0700
Message-ID: <1308157596.20109.28.camel@haakon2.linux-iscsi.org>
References: <1308023045-5257-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60296 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1FORPU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 13:15:20 -0400
In-Reply-To: <1308023045-5257-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Mon, 2011-06-13 at 20:44 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> transport_lookup_cmd_lun() may be called from interrupt context (eg
> tcm_loop_allocate_core_cmd() calls it, and it has a comment that says,
> "Can be called from interrupt context"), so it needs to use
> spin_lock_irqsave() instead of spin_lock_irq() to avoid enabling
> interrupts at the wrong time.
> 
> (And indeed the last set of lock operations, on lun_cmd_lock, were
> already using spin_lock_irqsave(), so we just need to fix the other
> two locks we take)
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
> Not sure if this is causing anything other than lockdep reports at
> the moment, so I don't think it's worth trying to get into 3.0.0-rc...
> 

<nod>  Committed as f39cc7c3da62.

Btw, I think the same type of conversion may need to happen for
transport_lookup_tmr_lun() as well, as I believe qla_target.c can call
this directly from interrupt context in certain situations.

--nab

>  drivers/target/target_core_device.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index fcb8161..ca0ba71 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -72,7 +72,7 @@ int transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
>  		return -ENODEV;
>  	}
>  
> -	spin_lock_irq(&se_sess->se_node_acl->device_list_lock);
> +	spin_lock_irqsave(&se_sess->se_node_acl->device_list_lock, flags);
>  	se_cmd->se_deve = &se_sess->se_node_acl->device_list[unpacked_lun];
>  
>  	if (se_cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
> @@ -89,7 +89,7 @@ int transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
>  			       " Access for 0x%08x\n",
>  			       se_cmd->se_tfo->get_fabric_name(),
>  			       unpacked_lun);
> -			spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
> +			spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
>  			return -EACCES;
>  		}
>  
> @@ -107,7 +107,7 @@ int transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
>  		se_cmd->se_orig_obj_ptr = se_cmd->se_lun->lun_se_dev;
>  		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
>  	}
> -	spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
> +	spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
>  
>  	if (!se_lun) {
>  		/*
> @@ -156,13 +156,13 @@ int transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
>  
>  	/* TODO: get rid of this and use atomics for stats */
>  	dev = se_lun->lun_se_dev;
> -	spin_lock_irq(&dev->stats_lock);
> +	spin_lock_irqsave(&dev->stats_lock, flags);
>  	dev->num_cmds++;
>  	if (se_cmd->data_direction == DMA_TO_DEVICE)
>  		dev->write_bytes += se_cmd->data_length;
>  	else if (se_cmd->data_direction == DMA_FROM_DEVICE)
>  		dev->read_bytes += se_cmd->data_length;
> -	spin_unlock_irq(&dev->stats_lock);
> +	spin_unlock_irqrestore(&dev->stats_lock, flags);
>  
>  	/*
>  	 * Add the iscsi_cmd_t to the struct se_lun's cmd list.  This list is used
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

