From: Bryant G Ly <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix for hang of Ordered task in TCM
Date: Mon, 23 May 2016 19:17:35 -0400
Message-ID: <20160523191735.Horde.6wmWQ7EiiPavHDD7pNfVtQ1@ltc.linux.ibm.com>
References: <1463177741-4385-1-git-send-email-mikecyr@linux.vnet.ibm.com>
 <1463550825.22249.17.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1463550825.22249.17.camel@haakon3.risingtidesystems.com>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>, rjui@broadcom.com, sbranden@broadcom.com, jonmason@broadcom.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Quoting "Nicholas A. Bellinger" <nab@linux-iscsi.org>:

<SNIP>
>
> So AFAICT for delayed commands, the above patch ends up skipping these
> three checks subsequently when doing __target_execute_cmd() directly
> from target_restart_delayed_cmds(), no..?
>
> After pondering this some more, what about moving these checks into
> __target_execute_cmd() to handle both target_core_transport.c cases
> instead..?
>
> We'll also need a parameter for internal COMPARE_AND_WRITE usage
> within compare_and_write_callback(), to bypass checks upon secondary
> ->execute_cmd() WRITE payload submission after READ + COMPARE has
> completed successfully.
>
> WDYT..?
>
> diff --git a/drivers/target/target_core_internal.h  
> b/drivers/target/target_core_internal.h
> index fc91e85..e2c970a 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -146,6 +146,7 @@ sense_reason_t	target_cmd_size_check(struct  
> se_cmd *cmd, unsigned int size);
>  void	target_qf_do_work(struct work_struct *work);
>  bool	target_check_wce(struct se_device *dev);
>  bool	target_check_fua(struct se_device *dev);
> +void	__target_execute_cmd(struct se_cmd *, bool);
>
>  /* target_core_stat.c */
>  void	target_stat_setup_dev_default_groups(struct se_device *);
> diff --git a/drivers/target/target_core_sbc.c  
> b/drivers/target/target_core_sbc.c
> index a9057aa..04f616b 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -602,7 +602,7 @@ static sense_reason_t  
> compare_and_write_callback(struct se_cmd *cmd, bool succes
>  	cmd->transport_state |= CMD_T_ACTIVE|CMD_T_BUSY|CMD_T_SENT;
>  	spin_unlock_irq(&cmd->t_state_lock);
>
> -	__target_execute_cmd(cmd);
> +	__target_execute_cmd(cmd, false);
>
>  	kfree(buf);
>  	return ret;
> diff --git a/drivers/target/target_core_transport.c  
> b/drivers/target/target_core_transport.c
> index 6c089af..f3e93dd 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1761,20 +1761,45 @@ queue_full:
>  }
>  EXPORT_SYMBOL(transport_generic_request_failure);
>
> -void __target_execute_cmd(struct se_cmd *cmd)
> +void __target_execute_cmd(struct se_cmd *cmd, bool do_checks)
>  {
>  	sense_reason_t ret;
>
> -	if (cmd->execute_cmd) {
> -		ret = cmd->execute_cmd(cmd);
> -		if (ret) {
> -			spin_lock_irq(&cmd->t_state_lock);
> -			cmd->transport_state &= ~(CMD_T_BUSY|CMD_T_SENT);
> -			spin_unlock_irq(&cmd->t_state_lock);
> +	if (!cmd->execute_cmd) {
> +		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +		goto err;
> +	}
> +	if (do_checks) {
> +		/*
> +		 * Check for an existing UNIT ATTENTION condition after
> +		 * target_handle_task_attr() has done SAM task attr
> +		 * checking, and possibly have already defered execution
> +		 * out to target_restart_delayed_cmds() context.
> +		 */
> +		ret = target_scsi3_ua_check(cmd);
> +		if (ret)
> +			goto err;
>
> -			transport_generic_request_failure(cmd, ret);
> +		ret = target_alua_state_check(cmd);
> +		if (ret)
> +			goto err;
> +
> +		ret = target_check_reservation(cmd);
> +		if (ret) {
> +			cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
> +			goto err;
>  		}
>  	}
> +
> +	ret = cmd->execute_cmd(cmd);
> +	if (!ret)
> +		return;
> +err:
> +	spin_lock_irq(&cmd->t_state_lock);
> +	cmd->transport_state &= ~(CMD_T_BUSY|CMD_T_SENT);
> +	spin_unlock_irq(&cmd->t_state_lock);
> +
> +	transport_generic_request_failure(cmd, ret);
>  }
>
>  static int target_write_prot_action(struct se_cmd *cmd)
> @@ -1899,7 +1924,7 @@ void target_execute_cmd(struct se_cmd *cmd)
>  		return;
>  	}
>
> -	__target_execute_cmd(cmd);
> +	__target_execute_cmd(cmd, true);
>  }
>  EXPORT_SYMBOL(target_execute_cmd);
>
> @@ -1923,7 +1948,7 @@ static void target_restart_delayed_cmds(struct  
> se_device *dev)
>  		list_del(&cmd->se_delayed_node);
>  		spin_unlock(&dev->delayed_cmd_lock);
>
> -		__target_execute_cmd(cmd);
> +		__target_execute_cmd(cmd, true);
>
>  		if (cmd->sam_task_attr == TCM_ORDERED_TAG)
>  			break;
> diff --git a/include/target/target_core_fabric.h  
> b/include/target/target_core_fabric.h
> index ec79da3..334f107 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -163,7 +163,6 @@ int	core_tmr_alloc_req(struct se_cmd *, void *,  
> u8, gfp_t);
>  void	core_tmr_release_req(struct se_tmr_req *);
>  int	transport_generic_handle_tmr(struct se_cmd *);
>  void	transport_generic_request_failure(struct se_cmd *, sense_reason_t);
> -void	__target_execute_cmd(struct se_cmd *);
>  int	transport_lookup_tmr_lun(struct se_cmd *, u64);
>  void	core_allocate_nexus_loss_ua(struct se_node_acl *acl);
>

Looks good to me. Nick just to let you know I've been working with  
Mike on VSCSI
Target Fabric and we need this patch in kernel 4.4 do you know of the  
process in
getting that there?

Thanks

-Bryant

> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
