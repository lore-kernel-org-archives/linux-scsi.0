From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Tue, 14 Sep 2004 13:56:41 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <414730D9.3000003@pobox.com>
References: <41471163.10709@rtr.ca> <414723B0.1090600@pobox.com> <41472FA0.2090108@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S269660AbUINSMy@vger.kernel.org>
In-Reply-To: <41472FA0.2090108@rtr.ca>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
>  >In particular, releasing the lock and sleeping would be very wrong
>  >in the ->queuecommand and error handling paths
>  >(alas...  I would love to sleep in the fine-grained eh hooks)
> 
> Mmm.. definitely no sleeps in queuecommand(), but sleeping seems
> necessary in host_reset_handler() -- the alternative is to just
> busywait inline.. which would really not be good.
> 
> Isn't the protocol for the eh host_reset_handler() basically
> just "do the reset, and return whether it worked or not?".
> If so, the driver really has to hang around until the reset
> completes so that correct status can be returned.  This generally
> takes a couple of milliseconds in practice (measured it).
> 
> Is there a better way to do that?
> 
> I really would prefer never to have to reset the drives,
> but when they have a queuing error, many of them simply
> won't talk to us again without a reset.  The driver avoids
> the reset as much as it can for other situations, though.


James and I occasionally talk about this.  This is a _big_ reason why I 
use the ->eh_strategy_handler() rather than the more fine-grained ->eh 
hooks:  you get unlocked, unfettered sleep priveleges inside the scsi EH 
thread.

The SCSI LLD API really needs to -not- spinlock on the EH hooks, and 
instead simply guarantee that ->queuecommand and other hooks will not be 
called while the driver is in EH.

ISTR James didn't disagree, so maybe a patch can be worked out...

Of course, you could always just use ->eh_strategy_handler and do 100% 
of the error handling yourself.  That's the route libata chose.

	Jeff
