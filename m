From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v3 4/5] target: Fix remote-port TMR ABORT + se_cmd
	fabric stop
Date: Tue, 2 Feb 2016 11:54:37 +0100
Message-ID: <20160202105437.GA28143@lst.de>
References: <1454132222-29009-1-git-send-email-nab@daterainc.com> <1454132222-29009-5-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454132222-29009-5-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

> +	bool aborted = false, tas = false;
>  
>  	/*
>  	 * Allocate an struct iscsi_conn_recovery for this connection.
> @@ -398,7 +399,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
>  
>  		iscsit_free_all_datain_reqs(cmd);
>  
> -		transport_wait_for_tasks(&cmd->se_cmd);
> +		transport_wait_for_tasks(&cmd->se_cmd, false, &aborted, &tas);

please keep the existing transport_wait_for_tasks prototype and factor
out a new helper for the transport_generic_free_cmd special case to avoid
all this boiler plate.

> +	ret = kref_get_unless_zero(&se_cmd->cmd_kref);
> +	if (ret)
> +		se_cmd->cmd_wait_set = 1;

I don't like the dual use of cmd_wait_set and the combination
with CMD_T_FABRIC_STOP.

How about the following alternative:

pull in my prep patch to rewrite target_sess_cmd_list_set_waiting so
that it doesn't need to iterate over all commands and set cmd_wait_set:

	http://www.spinics.net/lists/target-devel/msg11446.html

This gives us a free hand use a different completion for per-command
waiting.  Now your new usage of cmd_wait_set can be simplified as we
don't need a CMD_T_FABRIC_STOP to undo it, it can simply be cleared.
While we're at it I'd suggest using a CMD_T_ flag instead of a bitfield
for it.

>  	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD)) {
>  		if (wait_for_tasks && (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
> -			transport_wait_for_tasks(cmd);
> +			transport_wait_for_tasks(cmd, true, &aborted, &tas);
>  
> -		ret = transport_put_cmd(cmd);
> +		if (!aborted || tas)
> +			ret = transport_put_cmd(cmd);
>  	} else {
>  		if (wait_for_tasks)
> -			transport_wait_for_tasks(cmd);
> +			transport_wait_for_tasks(cmd, true, &aborted, &tas);
>  		/*
>  		 * Handle WRITE failure case where transport_generic_new_cmd()
>  		 * has already added se_cmd to state_list, but fabric has
> @@ -2454,9 +2456,21 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
>  		if (cmd->se_lun)
>  			transport_lun_remove_cmd(cmd);
>  
> -		ret = transport_put_cmd(cmd);
> +		if (!aborted || tas)
> +			ret = transport_put_cmd(cmd);
>  	}

FYI, this can be simplified a bit more.

Call transport_wait_for_tasks

	if (wait_for_tasks &&
	    (cmd->se_cmd_flags & (SCF_SE_LUN_CMD | SCF_SCSI_TMR_CDB))) {

and then the

	if (!aborted || tas)
		et = transport_put_cmd(cmd);

can be moved behind the conditional for LUN_CMDs as well.

> -	return ret;
> +	/*
> +	 * If the task has been internally aborted due to TMR ABORT_TASK
> +	 * or LUN_RESET, target_core_tmr.c is responsible for performing
> +	 * the remaining calls to target_put_sess_cmd(), and not the
> +	 * callers of this function.
> +	 */
> +	if (aborted) {
> +		pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
> +		wait_for_completion(&cmd->cmd_wait_comp);
> +		cmd->se_tfo->release_cmd(cmd);
> +	}
> +	return (aborted) ? 1 : ret;

This could be simplified to:

	if (aborted) {
		...

		ret = 1;
	}

	return ret;

> +	if (cmd->transport_state & CMD_T_ABORTED)
> +		*aborted = true;
> +	else
> +		*aborted = false;
> +
> +	if (cmd->transport_state & CMD_T_TAS)
> +		*tas = true;
> +	else
> +		*tas = false;

All callers already initialize these two to false, so the else
branches seem superflous.
