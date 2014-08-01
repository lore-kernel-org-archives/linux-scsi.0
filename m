From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Interrupt strangeness in scsi_request_fn()
Date: Fri, 01 Aug 2014 18:00:03 -0400
Message-ID: <1406930403.2654.40.camel@jarvis>
References: <20140801204848.GE7525@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59892 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756441AbaHAWAH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2014 18:00:07 -0400
In-Reply-To: <20140801204848.GE7525@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: linux-scsi@vger.kernel.org

On Fri, 2014-08-01 at 22:48 +0200, Jan Kara wrote:
>   Hello,
> 
>   when debugging one bug, I've noticed one strangeness in
> scsi_request_fn(). We enter it with interrupts disabled and queue_lock
> held. In the function we do stuff like:
>                 spin_unlock_irq(shost->host_lock);
>                 /*
>                  * Finally, initialize any error handling parameters, and
>                  * set up
>                  * the timers for timeouts.
>                  */
>                 scsi_init_cmd_errh(cmd);
> 
>                 /*
>                  * Dispatch the command to the low-level driver.
>                  */
>                 rtn = scsi_dispatch_cmd(cmd);
>                 spin_lock_irq(q->queue_lock);
> 
> Why do we enable interrupts there? The thing is that scsi_request_fn() can
> be called from IO completion (thus softirq context) and if we enable
> interrupts there, another HW interrupt can interrupt softirq processing
> which seems wrong to me.

According to my reading of kernel/softirq.c, it looks like interrupts
*are* already enabled when softirq functions are called by design.  That
doesn't mean your patch is necessarily wrong, it just means the premise
above isn't quite right.

> Now to admit my motivation I have reports from one customer (SLES kernel so
> too old to be really interesting upstream but still of some value I
> believe) where he's seeing softlockup reports when fully loading his SAN
> and from the crash dumps it seems the machine simply spends too long in IO
> completion because HW interrupts keep interrupting it plus there's
> contention on shost->host_lock. If I change scsi_request_fn() to never
> enable interrupts problems go away.
> 
> So what would people say to something like the attached patch?

I think the theory for enabling interrupts here is that the path is
rather long ... it goes through the driver to the hardware and that the
problem you describe above *should* be self correcting.  If we keep
interrupting dispatch, then we're throttling the outbound I/O which
should reduce the returning interrupts.

I'm not immovably opposed, I'd just like to see better justification.

James


