From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 4/5] target: Fix remote-port TMR ABORT + se_cmd
 fabric stop
Date: Tue, 02 Feb 2016 17:33:27 -0800
Message-ID: <1454463207.25549.61.camel@haakon3.risingtidesystems.com>
References: <1454132222-29009-1-git-send-email-nab@daterainc.com>
	 <1454132222-29009-5-git-send-email-nab@daterainc.com>
	 <20160202105437.GA28143@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57906 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbcBCBda (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2016 20:33:30 -0500
In-Reply-To: <20160202105437.GA28143@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>

On Tue, 2016-02-02 at 11:54 +0100, Christoph Hellwig wrote:
> > +	bool aborted = false, tas = false;
> >  
> >  	/*
> >  	 * Allocate an struct iscsi_conn_recovery for this connection.
> > @@ -398,7 +399,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
> >  
> >  		iscsit_free_all_datain_reqs(cmd);
> >  
> > -		transport_wait_for_tasks(&cmd->se_cmd);
> > +		transport_wait_for_tasks(&cmd->se_cmd, false, &aborted, &tas);
> 
> please keep the existing transport_wait_for_tasks prototype and factor
> out a new helper for the transport_generic_free_cmd special case to avoid
> all this boiler plate.

Seems reasonable enough.

Moved existing code to __transport_wait_for_tasks() minus
taking/dropping the lock on entry/exit so a transport_wait_for_tasks()
wrapper works for existing callers, plus adding a new
target_wait_free_cmd() for transport_generic_free_cmd() special case.

> 
> > +	ret = kref_get_unless_zero(&se_cmd->cmd_kref);
> > +	if (ret)
> > +		se_cmd->cmd_wait_set = 1;
> 
> I don't like the dual use of cmd_wait_set and the combination
> with CMD_T_FABRIC_STOP.
> 

The dual use is required because there needs to be a mechanism for the
TMR path to release the command, but at the same time must also be aware
when the front-end driver needs to shutdown the command (from it's
calling context) at the same time, due to session reset.

For the session reset case, the key aspect is the fabric driver calling
target_wait_for_sess_cmds() or transport_generic_free_cmd() MUST NOT
return until se_cmd->se_tfo->release_cmd() has completed.

This is why the caller who sets ->cmd_wait_set is responsible for
calling ->release_cmd(), and not target_release_cmd_kref() callback
itself.

> How about the following alternative:
> 
> pull in my prep patch to rewrite target_sess_cmd_list_set_waiting so
> that it doesn't need to iterate over all commands and set cmd_wait_set:
> 
> 	http://www.spinics.net/lists/target-devel/msg11446.html
> 

Your patch has one key assumption incorrect.

That is, it's not safe for target_wait_for_sess_cmds() to return until
all se_cmd->se_tfo->release_cmd() callbacks have been invoked.  This is
because current code assumes that once this function completes, all
possible se_cmd related dereferences to se_session are finished.

The patch mentioned above ignores this requirement, and allows
target_wait_for_sess_cmds() to return before all ->release_cmd() calls
finish, while target_release_cmd_kref() completes in the back-ground
resulting in a sure-fire use-after-free.

> This gives us a free hand use a different completion for per-command
> waiting.  Now your new usage of cmd_wait_set can be simplified as we
> don't need a CMD_T_FABRIC_STOP to undo it, it can simply be cleared.
> While we're at it I'd suggest using a CMD_T_ flag instead of a bitfield
> for it.
> 
> >  	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD)) {
> >  		if (wait_for_tasks && (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
> > -			transport_wait_for_tasks(cmd);
> > +			transport_wait_for_tasks(cmd, true, &aborted, &tas);
> >  
> > -		ret = transport_put_cmd(cmd);
> > +		if (!aborted || tas)
> > +			ret = transport_put_cmd(cmd);
> >  	} else {
> >  		if (wait_for_tasks)
> > -			transport_wait_for_tasks(cmd);
> > +			transport_wait_for_tasks(cmd, true, &aborted, &tas);
> >  		/*
> >  		 * Handle WRITE failure case where transport_generic_new_cmd()
> >  		 * has already added se_cmd to state_list, but fabric has
> > @@ -2454,9 +2456,21 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
> >  		if (cmd->se_lun)
> >  			transport_lun_remove_cmd(cmd);
> >  
> > -		ret = transport_put_cmd(cmd);
> > +		if (!aborted || tas)
> > +			ret = transport_put_cmd(cmd);
> >  	}
> 
> FYI, this can be simplified a bit more.
> 
> Call transport_wait_for_tasks
> 
> 	if (wait_for_tasks &&
> 	    (cmd->se_cmd_flags & (SCF_SE_LUN_CMD | SCF_SCSI_TMR_CDB))) {
> 
> and then the
> 
> 	if (!aborted || tas)
> 		et = transport_put_cmd(cmd);
> 
> can be moved behind the conditional for LUN_CMDs as well.
> 

That doesn't quite work, because target_remove_from_state_list() +
transport_lun_remove_cmd() must be called before the potentially final
transport_put_cmd() -> target_put_sess_cmd() callback.

Also, SCF_SCSI_TMR_CDB is still slightly different in this regard, as it
doesn't take se_lun->lun_ref atm.

That said, I'm in agreement that this can be cleaned up further, but
given this patch will need to back-ported stable, I'd prefer to keep
additional cleanups as separate post bug-fix improvements.

> > -	return ret;
> > +	/*
> > +	 * If the task has been internally aborted due to TMR ABORT_TASK
> > +	 * or LUN_RESET, target_core_tmr.c is responsible for performing
> > +	 * the remaining calls to target_put_sess_cmd(), and not the
> > +	 * callers of this function.
> > +	 */
> > +	if (aborted) {
> > +		pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
> > +		wait_for_completion(&cmd->cmd_wait_comp);
> > +		cmd->se_tfo->release_cmd(cmd);
> > +	}
> > +	return (aborted) ? 1 : ret;
> 
> This could be simplified to:
> 
> 	if (aborted) {
> 		...
> 
> 		ret = 1;
> 	}
> 
> 	return ret;
> 

Done.

> > +	if (cmd->transport_state & CMD_T_ABORTED)
> > +		*aborted = true;
> > +	else
> > +		*aborted = false;
> > +
> > +	if (cmd->transport_state & CMD_T_TAS)
> > +		*tas = true;
> > +	else
> > +		*tas = false;
> 
> All callers already initialize these two to false, so the else
> branches seem superflous.

Dropped.

