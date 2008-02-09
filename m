From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Investigating potential flaw in scsi error handling
Date: Sat, 09 Feb 2008 17:30:54 -0600
Message-ID: <1202599854.4254.43.camel@localhost.localdomain>
References: <87bq6pkczj.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45671 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755034AbYBIXbA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 18:31:00 -0500
In-Reply-To: <87bq6pkczj.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

On Sat, 2008-02-09 at 22:59 +0100, Elias Oltmanns wrote:
> Hi there,
> 
> I'm experiencing system lockups with 2.6.24 which I believe to be
> related to scsi error handling. Actually, I have patched the mainline
> kernel with a disk shock protection patch [1] and in my case it is indeed
> the shock protection mechanism that triggers the lockups. However, some
> rather lengthy investigations have lead me to the conclusion that this
> additional patch is just the means to reproduce the error condition
> fairly reliably rather than the origin of the problem.
> 
> The problem has only become apparent since Tejun's commit
> 31cc23b34913bc173680bdc87af79e551bf8cc0d. More precisely, libata now
> sets max_host_blocked and max_device_blocked to 1 for all ATA devices.
> Various tests I've conducted so far have lead me to the conclusion that
> a non zero return code from scsi_dispatch_command is sufficient to
> trigger the problem I'm seeing provided that max_host_blocked and
> max_device_blocked are set to 1.

There's nothing inherently incorrect with setting max_device_blocked to
1 but it is suboptimal: it means that for a single queue device
returning a wait causes an immediate reissue.

> Unfortunately, I'm a bit at a loss as to how I should proceed to find
> the culprit. I can reliably reproduce the problem using the disk shock
> protection patch in order to cause non zero return values from
> scsi_dispatch_command. How can I find out where in the error handling of
> this condition things might go wrong?
> 
> Most likely you will need further information to help me solving this
> issue but perhaps you can already come up with some suggestions and tell
> me what else you'd like to know.

Well, the first case I'm not sure why you refer to non-zero return from
scsi_dispatch_command() since that's an internal API; the non zero
return should come from ->queuecommand().

However, if you've patched scsi_dispatch_command() I'd guess that would
be the problem.

James


