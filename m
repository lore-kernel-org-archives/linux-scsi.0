From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: Investigating potential flaw in scsi error handling
Date: Sun, 10 Feb 2008 17:04:25 +0100
Message-ID: <87r6fk4x2u.fsf@denkblock.local>
References: <87bq6pkczj.fsf@denkblock.local>
	<1202599854.4254.43.camel@localhost.localdomain>
	<87ejblnf94.fsf@denkblock.local>
	<1202653375.3136.24.camel@localhost.localdomain>
	<8763ww6da0.fsf@denkblock.local>
	<1202658246.3136.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:34793 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYBJQEi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Feb 2008 11:04:38 -0500
In-Reply-To: <1202658246.3136.45.camel@localhost.localdomain> (James
	Bottomley's message of "Sun, 10 Feb 2008 09:44:06 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Sun, 2008-02-10 at 16:29 +0100, Elias Oltmanns wrote:
>> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
[...]
>> > No.  We have a fix for this, it's called setting device_max_blocked to 2
>> > or greater.  All your patch does is make this seem to be the case, plus
>> > it eliminates the instant reissue case for drivers with queuecommands
>> > that do obey all the rules.
>> >
>> > If you can prove that IDE doesn't obey the rules (no defer returns)
>> 
>> In fact, I can prove that scsi midlayer itself doesn't exactly comply
>> with this rule by design. The comment explaining the SDEV_BLOCK state in
>> scsi_device.h suggests that the low level driver is supposed to control
>> whether a device is switched to or from SDEV_BLOCK. However, with
>> max_device_blocked set to 1 we have an infinite loop where the low level
>> driver never gets even called since scsi_dispatch_cmd will requeue the
>> request instantly.
>> 
>> IDE doesn't obey the rule either but this can be fixed easily. So, what
>> about SDEV_BLOCK?
>
> Well, nothing.  It's an API a HBA may not use (per previous rule) if it
> wants to set max_device_blocked to 1.

Right. Thanks for the clarification.

Regards,

Elias
