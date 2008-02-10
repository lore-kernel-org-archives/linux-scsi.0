From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: Investigating potential flaw in scsi error handling
Date: Sun, 10 Feb 2008 16:29:11 +0100
Message-ID: <8763ww6da0.fsf@denkblock.local>
References: <87bq6pkczj.fsf@denkblock.local>
	<1202599854.4254.43.camel@localhost.localdomain>
	<87ejblnf94.fsf@denkblock.local>
	<1202653375.3136.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:33114 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYBJP3Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Feb 2008 10:29:24 -0500
In-Reply-To: <1202653375.3136.24.camel@localhost.localdomain> (James
	Bottomley's message of "Sun, 10 Feb 2008 08:22:55 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Sun, 2008-02-10 at 13:54 +0100, Elias Oltmanns wrote:
[...]
>> Consider this: The ->request_fn() of a single queue device is called
>> which in turn calls scsi_dispatch_cmd(). Assume that the device is
>> either in SDEV_BLOCK state or ->queuecommand() returns
>> SCSI_MLQUEUE_DEVICE_BUSY for some reason. In either case
>> scsi_queue_insert() will be called. Eventually, blk_run_queue() will be
>> called with the same device queue not plugged yet. This way we directly
>> reenter q->request_fn(). Now, remember that libata sets
>> sdev->max_device_blocked to 1. Consequently, the function
>> scsi_dev_queue_ready() will immediately give a positive response and we
>> go ahead calling scsi_dispatch_cmd() again. Note that at this stage the
>> lld will not have had a chance yet to clear the SDEV_BLOCK state or the
>> condition that caused the SCSI_MLQUEUE_DEVICE_BUSY return code from
>> ->queuecommand(). Hence the infinite recursion. A similar recursion can
>> also occur due to a SCSI_MLQUEUE_HOST_BUSY response from
>> ->queuecommand().
>> 
>> Unless I have overlooked some unwanted implications, please consider
>> applying the patch that I'm going to send you as a follow up to this
>> email.
>
> No.  We have a fix for this, it's called setting device_max_blocked to 2
> or greater.  All your patch does is make this seem to be the case, plus
> it eliminates the instant reissue case for drivers with queuecommands
> that do obey all the rules.
>
> If you can prove that IDE doesn't obey the rules (no defer returns)

In fact, I can prove that scsi midlayer itself doesn't exactly comply
with this rule by design. The comment explaining the SDEV_BLOCK state in
scsi_device.h suggests that the low level driver is supposed to control
whether a device is switched to or from SDEV_BLOCK. However, with
max_device_blocked set to 1 we have an infinite loop where the low level
driver never gets even called since scsi_dispatch_cmd will requeue the
request instantly.

IDE doesn't obey the rule either but this can be fixed easily. So, what
about SDEV_BLOCK?

Regards,

Elias
