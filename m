From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][RFC] scsi: Use W_LUN for scanning
Date: Sun, 07 Apr 2013 15:31:51 +0200
Message-ID: <51617547.7040201@suse.de>
References: <1363340771-46925-1-git-send-email-hare@suse.de> <1365239280.2787.11.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933434Ab3DGMcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Apr 2013 08:32:01 -0400
In-Reply-To: <1365239280.2787.11.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, George Martin <marting@netapp.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>

On 04/06/2013 11:08 AM, James Bottomley wrote:
> On Fri, 2013-03-15 at 10:46 +0100, Hannes Reinecke wrote:
>> SAM advertises the use of a Well-known LUN (W_LUN) for scanning.
>> As this avoids exposing LUN 0 (which might be a valid LUN) for
>> all initiators it is the preferred method for LUN scanning on
>> some arrays.
>> So we should be using W_LUN for scanning, too. If the W_LUN is
>> not supported we'll fall back to use LUN 0.
>> For broken W_LUN implementations a new blacklist flag
>> 'BLIST_NO_WLUN' is added.
>
> Well, we could do this, but I don't really see the point.  By the time
> we get into the report lun code, we've already probed LUN 0, so it's as
> goeod as any for a REPORT LUN scan.
>
Did we? I thought I had avoided that and directly went for probing
W_LUN _first_.
Will be cross-checking.

> What worries me slightly about the W-LUN is that for the first time
> we'll  be assuming a device supports a particular address method
> (Extended Logical Unit addressing) rather than treating LUNs as opaque
> handles we keep and pass back to the target.  I appreciate you now have
> a blacklist for failures, but if we didn't use W-LUNs we wouldn't need
> that blacklist.
>
> So could you answer two questions clearly:
>
>       1. What does this buy us over the current LUN0 method?  I don't see
>          LUN0 might be a valid LUN being a convincing reason.

LUN masking.
Some HBAs / virtualised devices use LUN masking to forward LUNs to the 
virtual machines.
So for LUN0 you have the choice of exposing it to every virtual machine,
meaning you cannot assign a device to LUN0, or have LUN0 as a no-device
LUN which then can be exposed to every virtual machine.

At which point you run into hardware limitations, as not every storage 
array allow for the first option.
And not every LUN masking implementation allows you to expose a single 
LUN to several virtual machines. So you might be screwed either way.

This was the main reason why zfcp could not use the standard LUN 
scanning method like every other HBA LLDD and had to resort to manual 
LUN activation.

>       2. What devices have you actually tested this on?
>
Netapp FAS, HP EVA, HP P2000 / MSA, EMC Clariion.

But as mentioned, I'll be rechecking the patch.
We should _not_ try to probe LUN0 first, but rather send REPORT_LUNS to 
the W_LUN directly. If it responds, good. If not, we'll fall back to LUN0.

Cheers,

Hannes

