From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Fix thread termination for the SCSI error handler
Date: Sun, 18 Sep 2005 17:04:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509181638570.1209-100000@netrider.rowland.org>
References: <1127073224.4847.28.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:55313 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S932202AbVIRVEb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 17:04:31 -0400
In-Reply-To: <1127073224.4847.28.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 18 Sep 2005, James Bottomley wrote:

> On Thu, 2005-09-15 at 15:29 -0400, Alan Stern wrote:
> > Can you please check that the
> > 
> > 	if (shost->host_busy == shost->host_failed ...
> > 
> > condition for waking up is really correct?  Thanks.
> 
> Yes, it mirrors the one in the scsi_eh_scmd_add()  But it's not quite
> correct as a condition for sleeping since it may be true if they're both
> zero.

As we've seen.

One effect of the semaphore in the old code was that there was a
one-to-one relationship between successful calls to scsi_eh_wakeup and
runs of the error handler -- the thread was awakened exactly once for
every up you did on the semaphore.  Is that important/desirable?  Or would
it be okay for the error handler to go through a few unintended loop
iterations?

> Try the attached, I made our infrastructure as close as possible to
> other users of the kthread interface.  I junked the double loop and
> added back the check in the scsi_eh_scmd_add() routine for the error
> thread not running (this is a theoretical impossibility at the momen,
> but it will become relevant if people move the thread shutdown to
> earlier in the host removal cycle, so best to leave it in).  I also made
> the eh do a final sweep through the queues before shutdown, just in case
> (also theoretically not necessary, but it won't hurt anything).

Your patch isn't right.  You really _do_ need that double loop, otherwise 
you run the risk of losing wakeup calls:

> +	while (!kthread_should_stop()) {

> +		if (shost->host_failed == 0 ||
> +		    shost->host_failed != shost->host_busy) {
> +			SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
> +							  " scsi_eh_%d"
> +							  " sleeping\n",
> +							  shost->host_no));
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			/* Even though we are INTERRUPTIBLE, ignore signals */
> +			flush_signals(current);
> +			schedule();
> +		}
>  
>  		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler"
>  						  " scsi_eh_%d waking"

What happens if kthread_stop runs in between the "while" test and the
set_current_task call?  Of if a normal invocation arrives between the "if"
test and the set_current_task?  In wait loops like this, it's vital to
check the activation condition _after_ setting the state to
TASK_INTERRUPTIBLE.  And note also that it's possible for a thread to wake 
up even when the activation condition isn't true, in which case it should 
put itself right back to sleep.

I got rid of the check for the error handler thread no longer running
because it was racy (and it still is, with this patch).  It could be added
back in however, in a non-racy way.  Oh yes, and I asked Andrew Morton 
about the flush_signals call; he said it's not necessary.


At the moment I have two candidate patches for fixing this.  One involves
replacing the semaphore with an atomic_t variable that counts the number
of pending invocations.  It preserves the existing behavior of exactly one
loop iteration per invocation.  I don't really like it, though, because
the combination of atomic_t manipulations along with the double loop and
set_current_state looks like nothing so much as a poor-man's
implementation of a semaphore!

Better just to continue using a real semaphore.  So the other patch adds 
to the kthread API a new routine,

	int kthread_stop_sem(struct task_state *k, struct semaphore *s)

which does the same thing as kthread_stop except that it wakes up k by 
calling up(s) rather than wakeup_process(k).  Then scsi_host_dev_release 
simply calls kthread_stop_sem in place of kthread_stop.

If anyone is interested in seeing these patches I will post them.  Neither 
one is quite final, but they are in working condition.

Alan Stern

