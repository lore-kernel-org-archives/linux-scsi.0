From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 12/14] ib_srp: Rework error handling
Date: Sun, 18 Dec 2011 22:36:29 -0500
Message-ID: <1324265791.17849.92.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012010.37276.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112012010.37276.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-12-01 at 20:10 +0100, Bart Van Assche wrote:
> Add the necessary functions in the SRP transport module to allow
> an SRP initiator driver to implement transport layer recovery.
> 
> Convert srp_target_port.qp_in_error into a target port state.

This part should probably be folded into patch 7.

> Factor out the code for removing an SRP target into the new function
> srp_remove_target().

This could be a separate patch, making that easy to review.

> In the ib_srp IB completion handlers, do not stop processing
> completions after the first error completion or a CM DREQ has been
> received.

Why do this? It seems like you're just going to create a flurry of error
messages when one would suffice, and we've got to tear down and
reconnect anyway.

> Block the SCSI target as soon as the first IB error
> completion has been received. Eliminate the SCSI target state test
> from srp_queuecommand().

I think you still want to check the SRP target state in
srp_queuecommand() -- you schedule the blocking of the queue, but it
could be a while before it happens. No sense sending down more commands
when you know they are going to fail -- and if you're worried about the
performance of the conditional in the hot path, we can make it
unlikely(). Cleaning up the target states lets us just check for
SRP_TARGET_LIVE, though you would want to change the creation sequence
so that isn't the birth state of the target.

> Rework ib_srp transport layer error handling. Instead of letting SCSI
> commands time out if a transport layer error occurs,

This is good, but should probably be part of the initial disconnect. We
want to run the receive queue dry, processing responses to avoid
unnecessarily resetting a command that was successful.

> block the SCSI
> host and try to reconnect until the reconnect timeout elapses or until
> the maximum number of reconnect attempts has been exceeded, whichever
> happens first.

When we're blocked for a disconnected target, we may want to call the
state something other than SRP_TARGET_BLOCKED. I'd like to eventually
handle the case where the target leaves the fabric temporarily -- we
don't necessarily disconnect in that case, but we need to block commands
until it comes back or we give up on it.

>  /*
>   * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> + * Copyright (c) 2010-2011 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>.

You've tried to add this in the past; I don't mean to deny you credit,
and I certainly value your work, but I'm not sure where the threshold is
for adding a copyright line.

Roland, care to comment here?


> +static void srp_remove_target(struct srp_target_port *target)
>  {

>  	srp_del_scsi_host_attr(target->scsi_host);
> +	cancel_work_sync(&target->block_work);
> +	mutex_lock(&target->mutex);
> +	mutex_unlock(&target->mutex);

You lock and unlock here without doing anything in the critical section.


>  static int srp_reset_host(struct scsi_cmnd *scmnd)
>  {
>  	struct srp_target_port *target = host_to_target(scmnd->device->host);
> +	struct srp_host *host = target->srp_host;
>  	int ret = FAILED;
> +	bool remove = false;
>  
>  	shost_printk(KERN_ERR, target->scsi_host, PFX "SRP reset_host called\n");
>  
> -	if (!srp_reconnect_target(target))
> +	if (!srp_reconnect_target(target)) {
>  		ret = SUCCESS;
> +	} else {
> +		/*
> +		 * We couldn't reconnect, so kill our target port off.
> +		 * However, we have to defer the real removal because we
> +		 * are in the context of the SCSI error handler now, which
> +		 * will deadlock if we call scsi_remove_host().

Part of me wonders if killing the SCSI host on a failed reconnect is the
correct thing to do. Certainly, the checks in scsi_eh_test_devices() are
going to kick the drives to offline state, but the FC transport blocks
the error handling to avoid that.

I think we need to give our error behavior a bit more thought.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
