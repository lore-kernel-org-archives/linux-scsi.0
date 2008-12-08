From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fc transport: pre-emptively terminate i/o upon	dev_loss_tmo
 timeout
Date: Mon, 08 Dec 2008 16:31:33 -0600
Message-ID: <493DA045.4050101@cs.wisc.edu>
References: <1228497483.8775.1.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51138 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbYLHWbm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2008 17:31:42 -0500
In-Reply-To: <1228497483.8775.1.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> Pre-emptively terminate i/o on the rport if dev_loss_tmo has fired.
> The desire is to terminate everything, so that the i/o is cleaned up
> prior to the sdev's being unblocked, thus any outstanding timeouts/aborts
> are avoided.
> 
> Also, we do this early enough such that the rport's port_id field is
> still valid. FCOE libFC code needs this info to find the i/o's to
> terminate.
> 
> -- james s
> 
>  Signed-off-by: James Smart <james.smart@emulex.com>
> 
>  ---
> 
>  scsi_transport_fc.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> 
> diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> --- a/drivers/scsi/scsi_transport_fc.c	2008-10-18 10:32:52.000000000 -0400
> +++ b/drivers/scsi/scsi_transport_fc.c	2008-12-05 12:13:54.000000000 -0500
> @@ -3012,6 +3012,16 @@ fc_timeout_deleted_rport(struct work_str
>  	rport->port_state = FC_PORTSTATE_NOTPRESENT;
>  	rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
>  
> +	/*
> +	 * Pre-emptively kill I/O rather than waiting for the work queue
> +	 * item to teardown the starget. (FCOE libFC folks prefer this
> +	 * and to have the rport_port_id still set when it's done).
> +	 */
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +	fc_terminate_rport_io(rport);
> +
> +	BUG_ON(rport->port_state != FC_PORTSTATE_NOTPRESENT);
> +

I think we could this this bug_on or we might hit a problem below where 
this thread is changing the port_id but some other thread is calling 
fc_remote_port_add and changging the port id.

I think the problem is that fc_remote_port_add only calls fc_flush_work 
which flushes the fc_host work_q:


struct fc_rport *
fc_remote_port_add(struct Scsi_Host *shost, int channel,
         struct fc_rport_identifiers  *ids)
{
         struct fc_internal *fci = to_fc_internal(shost->transportt);
         struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
         struct fc_rport *rport;
         unsigned long flags;
         int match = 0;

         /* ensure any stgt delete functions are done */
         fc_flush_work(shost);


But fc_timeout_deleted_rport dev_loss_work is running on the devloss_work_q.

So if fc_timeout_deleted_rport grabs the host lock first, it will set 
the port state to FC_PORTSTATE_NOTPRESENT, then drop the lock.

Once fc_timeout_delete_rport drops the lock, fc_remote_port_add could 
have already passed the fc_flush_work() call because there was nothing 
on it. fc_remote_port_add would then drop down to the list search on the 
bindings array and see the remote port. It would then start setting the 
port state, id and port_name and node_name, but at the same time, 
because the host lock no longer guards it, fc_timedout_deleted_rport 
could be fiddling with the same fields and we could end up a mix of 
values or it could be running over the BUG_ON.

Is that right?

If so do we just want to flush the devloss_work_queue in fc_remote_port_add?



>  	/* remove the identifiers that aren't used in the consisting binding */
>  	switch (fc_host->tgtid_bind_type) {
>  	case FC_TGTID_BIND_BY_WWPN:
> @@ -3035,7 +3045,6 @@ fc_timeout_deleted_rport(struct work_str
>  	 * went away and didn't come back - we'll remove
>  	 * all attached scsi devices.
>  	 */
> -	spin_unlock_irqrestore(shost->host_lock, flags);
>  
>  	scsi_target_unblock(&rport->dev);
>  	fc_queue_work(shost, &rport->stgt_delete_work);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

