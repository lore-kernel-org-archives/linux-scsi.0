From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: Investigating potential flaw in scsi error handling
Date: Sun, 10 Feb 2008 13:54:31 +0100
Message-ID: <87ejblnf94.fsf@denkblock.local>
References: <87bq6pkczj.fsf@denkblock.local>
	<1202599854.4254.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:48411 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbYBJMyk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Feb 2008 07:54:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Sat, 2008-02-09 at 22:59 +0100, Elias Oltmanns wrote:
>> Hi there,
>> 
>> I'm experiencing system lockups with 2.6.24 which I believe to be
>> related to scsi error handling. Actually, I have patched the mainline
>> kernel with a disk shock protection patch [1] and in my case it is indeed
>> the shock protection mechanism that triggers the lockups. However, some
>> rather lengthy investigations have lead me to the conclusion that this
>> additional patch is just the means to reproduce the error condition
>> fairly reliably rather than the origin of the problem.
>> 
>> The problem has only become apparent since Tejun's commit
>> 31cc23b34913bc173680bdc87af79e551bf8cc0d. More precisely, libata now
>> sets max_host_blocked and max_device_blocked to 1 for all ATA devices.
>> Various tests I've conducted so far have lead me to the conclusion that
>> a non zero return code from scsi_dispatch_command is sufficient to
>> trigger the problem I'm seeing provided that max_host_blocked and
>> max_device_blocked are set to 1.
>
> There's nothing inherently incorrect with setting max_device_blocked to
> 1 but it is suboptimal: it means that for a single queue device
> returning a wait causes an immediate reissue.

Thanks for rubbing that in again. It should have been clear to me all
along but I've only just realised the consequences and found the
problem, I think. We are, in fact, faced with a situation where the
->request_fn() is being called recursively forever.

Consider this: The ->request_fn() of a single queue device is called
which in turn calls scsi_dispatch_cmd(). Assume that the device is
either in SDEV_BLOCK state or ->queuecommand() returns
SCSI_MLQUEUE_DEVICE_BUSY for some reason. In either case
scsi_queue_insert() will be called. Eventually, blk_run_queue() will be
called with the same device queue not plugged yet. This way we directly
reenter q->request_fn(). Now, remember that libata sets
sdev->max_device_blocked to 1. Consequently, the function
scsi_dev_queue_ready() will immediately give a positive response and we
go ahead calling scsi_dispatch_cmd() again. Note that at this stage the
lld will not have had a chance yet to clear the SDEV_BLOCK state or the
condition that caused the SCSI_MLQUEUE_DEVICE_BUSY return code from
->queuecommand(). Hence the infinite recursion. A similar recursion can
also occur due to a SCSI_MLQUEUE_HOST_BUSY response from
->queuecommand().

Unless I have overlooked some unwanted implications, please consider
applying the patch that I'm going to send you as a follow up to this
email.

Regards,

Elias
