From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Investigating potential flaw in scsi error handling
Date: Sun, 10 Feb 2008 08:22:55 -0600
Message-ID: <1202653375.3136.24.camel@localhost.localdomain>
References: <87bq6pkczj.fsf@denkblock.local>
	 <1202599854.4254.43.camel@localhost.localdomain>
	 <87ejblnf94.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59509 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbYBJOW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Feb 2008 09:22:58 -0500
In-Reply-To: <87ejblnf94.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>


On Sun, 2008-02-10 at 13:54 +0100, Elias Oltmanns wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Sat, 2008-02-09 at 22:59 +0100, Elias Oltmanns wrote:
> >> Hi there,
> >> 
> >> I'm experiencing system lockups with 2.6.24 which I believe to be
> >> related to scsi error handling. Actually, I have patched the mainline
> >> kernel with a disk shock protection patch [1] and in my case it is indeed
> >> the shock protection mechanism that triggers the lockups. However, some
> >> rather lengthy investigations have lead me to the conclusion that this
> >> additional patch is just the means to reproduce the error condition
> >> fairly reliably rather than the origin of the problem.
> >> 
> >> The problem has only become apparent since Tejun's commit
> >> 31cc23b34913bc173680bdc87af79e551bf8cc0d. More precisely, libata now
> >> sets max_host_blocked and max_device_blocked to 1 for all ATA devices.
> >> Various tests I've conducted so far have lead me to the conclusion that
> >> a non zero return code from scsi_dispatch_command is sufficient to
> >> trigger the problem I'm seeing provided that max_host_blocked and
> >> max_device_blocked are set to 1.
> >
> > There's nothing inherently incorrect with setting max_device_blocked to
> > 1 but it is suboptimal: it means that for a single queue device
> > returning a wait causes an immediate reissue.
> 
> Thanks for rubbing that in again. It should have been clear to me all
> along but I've only just realised the consequences and found the
> problem, I think. We are, in fact, faced with a situation where the
> ->request_fn() is being called recursively forever.

This happens on a device_max_blocked of 1 if there's a programmatic
defer return of non zero at zero outstanding commands.  If you want to
set a max blocked of one, you need to ensure that doesn't happen.

> Consider this: The ->request_fn() of a single queue device is called
> which in turn calls scsi_dispatch_cmd(). Assume that the device is
> either in SDEV_BLOCK state or ->queuecommand() returns
> SCSI_MLQUEUE_DEVICE_BUSY for some reason. In either case
> scsi_queue_insert() will be called. Eventually, blk_run_queue() will be
> called with the same device queue not plugged yet. This way we directly
> reenter q->request_fn(). Now, remember that libata sets
> sdev->max_device_blocked to 1. Consequently, the function
> scsi_dev_queue_ready() will immediately give a positive response and we
> go ahead calling scsi_dispatch_cmd() again. Note that at this stage the
> lld will not have had a chance yet to clear the SDEV_BLOCK state or the
> condition that caused the SCSI_MLQUEUE_DEVICE_BUSY return code from
> ->queuecommand(). Hence the infinite recursion. A similar recursion can
> also occur due to a SCSI_MLQUEUE_HOST_BUSY response from
> ->queuecommand().
> 
> Unless I have overlooked some unwanted implications, please consider
> applying the patch that I'm going to send you as a follow up to this
> email.

No.  We have a fix for this, it's called setting device_max_blocked to 2
or greater.  All your patch does is make this seem to be the case, plus
it eliminates the instant reissue case for drivers with queuecommands
that do obey all the rules.

If you can prove that IDE doesn't obey the rules (no defer returns) then
ask them to revert their setting of device_max_blocked to 1; if they do,
then you have to come up with an alternative for your patch.

James


James


