From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.8+ merge window
Date: Fri, 01 Mar 2013 12:03:08 -0500
Message-ID: <5130DF4C.2090002@interlog.com>
References: <1362129599.2384.13.camel@dabdike.int.hansenpartnership.com>  <5130ACBE.8080300@interlog.com> <1362150419.2384.29.camel@dabdike.int.hansenpartnership.com> <5130C8C4.3020501@tributary.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:37745 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab3CARDM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Mar 2013 12:03:12 -0500
In-Reply-To: <5130C8C4.3020501@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On 13-03-01 10:27 AM, Jeremy Linton wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 3/1/2013 9:06 AM, James Bottomley wrote:
>
>>> The results were "interesting", there are some really strange things that
>>> happen in some of the LLD error paths. Its obvious that error injection
>>> is not part of testing many of them, and what at first glance should be a
>>> fairly straightforward error can create quite a mess. So anyone sending
>>> any kind of reset (especially without the ESCALATE flag which tends to
>>> isolate the error handling) to the LLD's should be aware that behavior
>>> between them can vary significantly.
>>>
>> So the patch does seem to have dangerous side effects.
>
> 	Those are due to "bugs" in the LLD's that actually are there regardless of
> that patch. For example the lpfc patch I posted a couple days ago, fixes the
> LPFC driver so that it actually checks the return status from the task
> management IOCB's being sent to the firmware. As it stands the reset paths in
> the lpfc driver always return SUCCESS independently of the status of any
> aborts, resets, being sent as part of the reset handlers. This is completely
> non obvious at first glance at the code.
>
>
> 	This means that the error handling behavior of lpfc is significantly
> different (and not necessarily better) than the zfcp and qlogic drivers I also
> tested.
>
> 	I didn't find any cases where this patch makes the problem worse, in fact in
> general the behavior is significantly better.

My testing of this patch was against scsi_debug and SAS.
It was relatively simple with scsi_debug and did what
was advertised.

SAS was much more difficult with my LSI controllers and an
expander. I was trying to set up a situation where Linux
thought there was a LU present but a phy to it in the expander
was disabled, breaking the path. These days broadcast(change)
is working too well to get away with that. Next attempt was
SAS zoning with two initiators and blind-side one initiator's
path to a LU via SAS zoning functions sent from the other
initiator. That works but when I issued the LU resets
(non-escalating or the existing escalating) strange things
happened in the LSI mptsas (first generation) LLD. I found
myself in a similar situation to Jeremy with his testing:
I'm certain the reset was being issued and failing
but the resulting mess was caused by the mptsas LLD **. I
don't have the time or equipment to delve into that LLD. And I
suspect that that LLD is bypassing mid-level error handling
to do its own.


Mike Christie had doubts about this patch as well but I hope
that I convinced him (via posts to this list) that there
wasn't a problem. All that is happening is that additional,
non-escalating versions of the existing user space reset options
are being added.


The bottom line is that when escalating device (LU) and target
(I_T Nexus) resets are issued on modern transports you can
never be 100% sure that they will get through (e.g. due to
congestion). And escalating that reset to the next level
could cause significant collateral damage.

Doug Gilbert

** And the HBA was never officially sold by LSI (IBM sold it)
    so the firmware is pretty old (as in 4 years old).

