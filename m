From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] libsas: fix error handling
Date: Wed, 20 Feb 2008 21:51:51 -0800 (PST)
Message-ID: <541691.92554.qm@web31804.mail.mud.yahoo.com>
References: <1203523670.3109.23.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:34610 "HELO
	web31804.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762467AbYBUFvw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Feb 2008 00:51:52 -0500
In-Reply-To: <1203523670.3109.23.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

A similar change went into the SAS/SATL layer I support
shortly after I posted the version which you forked off.
The git date of the commit is: Tue Feb 7 22:14:54 2006 -0800.

BTW, the problem you're "debugging" may require a protocol
trace and a sequencer update by Adaptec.

    Luben

--- On Wed, 2/20/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Subject: [PATCH] libsas: fix error handling
> To: "linux-scsi" <linux-scsi@vger.kernel.org>
> Date: Wednesday, February 20, 2008, 8:07 AM
> The libsas error handler has two fairly fatal bugs
> 
> 1. scsi_sas_task_done calls scsi_eh_finish_cmd() too early.
>  This
>    happens if the task completes after it has been aborted
> but before
>    the error handler starts up.  Because
> scsi_eh_finish_cmd()
>    decrements host_failed and adds the task to the done
> list, the
>    error handler start check (host_failed == host_busy)
> never passes
>    and the eh never starts.
> 
> 2. The multiple task completion paths
> sas_scsi_clear_queue_... all
>    simply delete the task from the error queue.  This
> causes it to
>    disappear into the ether, since a command must be placed
> on the
>    done queue to be finished off by the error handler. 
> This behaviour
>    causes the HBA to hang on pending commands.
> 
> Fix 1. by removing the SAS_TASK_STATE_ABORTED check and
> calling
> ->scsi_done() unconditionally (it is a nop if the timer
> has fired).
> This keeps the task in the error handling queue until the
> eh starts.
> 
> Fix 2. by making sure every task goes through task complete
> followed
> by scsi_eh_finish_cmd().
> 
> Tested this by firing resets across a disk running a hammer
> test (now
> it actually survives without hanging the system)
> 
> Signed-off-by: James Bottomley
> <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/libsas/sas_scsi_host.c |   53
> +++++++++++++++++++----------------
>  1 files changed, 29 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c
> b/drivers/scsi/libsas/sas_scsi_host.c
> index f869fba..b656e29 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -51,8 +51,6 @@ static void sas_scsi_task_done(struct
> sas_task *task)
>  {
>  	struct task_status_struct *ts =
> &task->task_status;
>  	struct scsi_cmnd *sc = task->uldd_task;
> -	struct sas_ha_struct *sas_ha =
> SHOST_TO_SAS_HA(sc->device->host);
> -	unsigned ts_flags = task->task_state_flags;
>  	int hs = 0, stat = 0;
>  
>  	if (unlikely(!sc)) {
> @@ -120,11 +118,7 @@ static void sas_scsi_task_done(struct
> sas_task *task)
>  	sc->result = (hs << 16) | stat;
>  	list_del_init(&task->list);
>  	sas_free_task(task);
> -	/* This is very ugly but this is how SCSI Core works. */
> -	if (ts_flags & SAS_TASK_STATE_ABORTED)
> -		scsi_eh_finish_cmd(sc, &sas_ha->eh_done_q);
> -	else
> -		sc->scsi_done(sc);
> +	sc->scsi_done(sc);
>  }
>  
>  static enum task_attribute sas_scsi_get_task_attr(struct
> scsi_cmnd *cmd)
> @@ -255,13 +249,27 @@ out:
>  	return res;
>  }
>  
> +static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
> +{
> +	struct sas_task *task = TO_SAS_TASK(cmd);
> +	struct sas_ha_struct *sas_ha =
> SHOST_TO_SAS_HA(cmd->device->host);
> +
> +	/* First off call task_done.  However, task will
> +	 * be free'd after this */
> +	task->task_done(task);
> +	/* now finish the command and move it on to the error
> +	 * handler done list, this also takes it off the
> +	 * error handler pending list */
> +	scsi_eh_finish_cmd(cmd, &sas_ha->eh_done_q);
> +}
> +
>  static void sas_scsi_clear_queue_lu(struct list_head
> *error_q, struct scsi_cmnd *my_cmd)
>  {
>  	struct scsi_cmnd *cmd, *n;
>  
>  	list_for_each_entry_safe(cmd, n, error_q, eh_entry) {
>  		if (cmd == my_cmd)
> -			list_del_init(&cmd->eh_entry);
> +			sas_eh_finish_cmd(cmd);
>  	}
>  }
>  
> @@ -274,7 +282,7 @@ static void
> sas_scsi_clear_queue_I_T(struct list_head *error_q,
>  		struct domain_device *x = cmd_to_domain_dev(cmd);
>  
>  		if (x == dev)
> -			list_del_init(&cmd->eh_entry);
> +			sas_eh_finish_cmd(cmd);
>  	}
>  }
>  
> @@ -288,7 +296,7 @@ static void
> sas_scsi_clear_queue_port(struct list_head *error_q,
>  		struct asd_sas_port *x = dev->port;
>  
>  		if (x == port)
> -			list_del_init(&cmd->eh_entry);
> +			sas_eh_finish_cmd(cmd);
>  	}
>  }
>  
> @@ -528,14 +536,14 @@ Again:
>  		case TASK_IS_DONE:
>  			SAS_DPRINTK("%s: task 0x%p is done\n",
> __FUNCTION__,
>  				    task);
> -			task->task_done(task);
> +			sas_eh_finish_cmd(cmd);
>  			if (need_reset)
>  				try_to_reset_cmd_device(shost, cmd);
>  			continue;
>  		case TASK_IS_ABORTED:
>  			SAS_DPRINTK("%s: task 0x%p is aborted\n",
>  				    __FUNCTION__, task);
> -			task->task_done(task);
> +			sas_eh_finish_cmd(cmd);
>  			if (need_reset)
>  				try_to_reset_cmd_device(shost, cmd);
>  			continue;
> @@ -547,7 +555,7 @@ Again:
>  					    "recovered\n",
>  					    SAS_ADDR(task->dev),
>  					    cmd->device->lun);
> -				task->task_done(task);
> +				sas_eh_finish_cmd(cmd);
>  				if (need_reset)
>  					try_to_reset_cmd_device(shost, cmd);
>  				sas_scsi_clear_queue_lu(work_q, cmd);
> @@ -562,7 +570,7 @@ Again:
>  			if (tmf_resp == TMF_RESP_FUNC_COMPLETE) {
>  				SAS_DPRINTK("I_T %016llx recovered\n",
>  					    SAS_ADDR(task->dev->sas_addr));
> -				task->task_done(task);
> +				sas_eh_finish_cmd(cmd);
>  				if (need_reset)
>  					try_to_reset_cmd_device(shost, cmd);
>  				sas_scsi_clear_queue_I_T(work_q, task->dev);
> @@ -577,7 +585,7 @@ Again:
>  				if (res == TMF_RESP_FUNC_COMPLETE) {
>  					SAS_DPRINTK("clear nexus port:%d "
>  						    "succeeded\n", port->id);
> -					task->task_done(task);
> +					sas_eh_finish_cmd(cmd);
>  					if (need_reset)
>  						try_to_reset_cmd_device(shost, cmd);
>  					sas_scsi_clear_queue_port(work_q,
> @@ -591,10 +599,10 @@ Again:
>  				if (res == TMF_RESP_FUNC_COMPLETE) {
>  					SAS_DPRINTK("clear nexus ha "
>  						    "succeeded\n");
> -					task->task_done(task);
> +					sas_eh_finish_cmd(cmd);
>  					if (need_reset)
>  						try_to_reset_cmd_device(shost, cmd);
> -					goto out;
> +					goto clear_q;
>  				}
>  			}
>  			/* If we are here -- this means that no amount
> @@ -606,21 +614,18 @@ Again:
>  				    SAS_ADDR(task->dev->sas_addr),
>  				    cmd->device->lun);
>  
> -			task->task_done(task);
> +			sas_eh_finish_cmd(cmd);
>  			if (need_reset)
>  				try_to_reset_cmd_device(shost, cmd);
>  			goto clear_q;
>  		}
>  	}
> -out:
>  	return list_empty(work_q);
>  clear_q:
>  	SAS_DPRINTK("--- Exit %s -- clear_q\n",
> __FUNCTION__);
> -	list_for_each_entry_safe(cmd, n, work_q, eh_entry) {
> -		struct sas_task *task = TO_SAS_TASK(cmd);
> -		list_del_init(&cmd->eh_entry);
> -		task->task_done(task);
> -	}
> +	list_for_each_entry_safe(cmd, n, work_q, eh_entry)
> +		sas_eh_finish_cmd(cmd);
> +
>  	return list_empty(work_q);
>  }
>  
> -- 
> 1.5.4.1
> 
> 
> 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
