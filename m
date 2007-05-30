From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: kexec and aacraid broken
Date: Wed, 30 May 2007 09:57:08 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01A54FEE@otce2k301.adaptec.com>
References: <20070530132430.GA3773@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:52891 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbXE3N5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2007 09:57:11 -0400
Content-class: urn:content-classes:message
In-reply-to: <20070530132430.GA3773@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vgoyal@in.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yhlu.kernel@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

This is clouding the issue, Vivek.

There should be no harm, except to time, resetting the adapter. I do
want to optimize for boot time, but do not view this as a 'bug' if the
Adapter should reset during the initialization procedure. We need
instead to harden the driver to deal with Adapters that behave in an
untimely manner as a result of the reset since this generically deals
with all possible transitions (boot w/o BIOS, w/BIOS, kexec and kdump).

I will look into a possibility the driver is not performing the clean
shutdown as a result of a kexec, but that is a refinement and should not
be considered a fix for *this* reported problem; it merely moves the
problem to a kdump. The driver only disables the interrupts when the
driver is .remove'd (aac_remove_one) and not for .shutdown
(aac_shutdown). The later merely tells the firmware to stop performing
builds if in progress, flush the cache, and all subsequent writes are
performed in write-through mode; it does not clear out the driver
resources and leaves that to the .remove function only. The failure of
.remove being called may be a result of this being a boot driver?

Also, the code:

        dev->OIMR = status = rx_readb (dev, MUnit.OIMR);
        if ((((status & 0x0c) != 0x0c) . . .

detects if the adapter's interrupts were disabled, as would happen on a
clean shutdown. Some of the Adapters can NOT disable their interrupts,
and some have a default state with the interrupts enabled. If the
Adapter still has active interrupts, then there is no telling what
transpired before and it is considered a safety measure to reset the
Adapter in these cases. I'd prefer to err on the side of resetting the
Adapter superfluously than deal with a condition where the Adapter could
be in an unknown state with a possibility of sustaining an outstanding
command and associated interrupt (which was the whole reason this code
was introduced).

In time I am sure, I will refine this code to incorporate Quirks for
adapters that have unusual conditions for the above stated interrupt and
remove the possible superfluous reset.

Yinghai, can you please provide the Adapter designation just in case it
could be the first in this refined list. I will NOT consider this
refinement a bugfix for the same reasons stated above.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@in.ibm.com] 
> Sent: Wednesday, May 30, 2007 9:25 AM
> To: Salyzyn, Mark
> Cc: Andrew Morton; Yinghai Lu; Eric W. Biederman; Linux 
> Kernel Mailing List; linux-scsi@vger.kernel.org; Michal Piotrowski
> Subject: Re: kexec and aacraid broken
> 
> 
> On Wed, May 30, 2007 at 07:44:02AM -0400, Salyzyn, Mark wrote:
> > I believe this issue is a result of the 
> aacraid_commit_reset patch (as
> > posted for scsi-misc-2.6, enclosed to permit testing) not 
> yet propagated
> > to the 2.6.22-rc3 tree.
> > 
> > This is the adapter taking longer than 3 minutes to start 
> after a reset.
> > I seriously doubt either of these patches suggested below 
> will have an
> > affect. And if they do, they are not root cause, one 
> reduces the chances
> > that the card will be reset during initialization (thus 
> applied would
> > likely mitigate this problem), the other prevents a panic when the
> > Adapter is reset (removed, would result in dogs and cats 
> sleeping with
> > each other).
> > 
> > Please use kernel parameter aacraid.startup_timeout=540 
> (merely larger
> > than the default 180 seconds) when spawning the kexec or see if the
> > aacraid_commit_reset.patch resolves the issue to confirm my hunch.
> > 
> 
> Hi Mark,
> 
> During a normal kexec (not kdump) adapter reset should not have taken
> place at all. device_shutdown() routines should have taken care to
> bring the device to a known sane state in first kernel so that second
> kernel can initialize it without doing a reset.
> 
> With reset patch, now reset triggers on every kexec. Previously
> that was not the case with kexec and adapter used to come up. I think
> this needs to be looked into.
> 
> Thanks
> Vivek
> 
