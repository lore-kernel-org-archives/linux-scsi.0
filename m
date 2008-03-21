From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] fix media change events for polled devices
Date: Fri, 21 Mar 2008 16:49:10 -0500
Message-ID: <1206136150.2961.79.camel@localhost.localdomain>
References: <200803211559.m2LFxPi6017869@hera.kernel.org>
	 <47E3EC67.4050404@garzik.org>
	 <1206128662.2961.37.camel@localhost.localdomain>
	 <47E41C50.4020406@garzik.org>
	 <1206133280.2961.45.camel@localhost.localdomain>
	 <47E422F1.7080806@garzik.org>
	 <1206133787.2961.52.camel@localhost.localdomain>
	 <47E424E2.1030801@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55522 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755872AbYCUVtO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 17:49:14 -0400
In-Reply-To: <47E424E2.1030801@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Fri, 2008-03-21 at 17:13 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > On Fri, 2008-03-21 at 17:04 -0400, Jeff Garzik wrote:
> >> James Bottomley wrote:
> >>> It's fixed, and nothing else is additionally broken by the current fix.
> >> Other than the newly-inconsistent, exported-to-userspace interface, ITYM.
> > 
> > How is it newly inconsistent?  It can still be used in the manner you
> > intended it, namely to tell if the CD supports AN or not.  When we add
> > the new bit, we'll have to add a new file for it anyway.
> 
> Previously, the events could be expected to be sent (or sent) in strict 
> accordance with supported_events.

we don't publish supported_events; we publish a single file called
media_change.  Right at the moment its meaning is I have a 1 if AN is
supported and 0 if it's not.

Before the fix, its meaning was  1 if AN is supported and 0 if it's not.

The file name now looks wrong ... it should probably be an_media_change
or something if we have to introduce a new file called poll_media_chage
to distinguish them ... but nothing's changed about the way it works.

> Now, you are essentially sending out-of-band events, because the 
> receiver requested supported_events -- but is getting much more than that!
> 
> You broke a fundamental assumption of the interface -- that 
> supported_events accurately and fully represented all events sent via 
> the new API.

Anyway, realistically, since no CD or DVD on the market today seems to
support the AHCI AN method, this argument is really moot ... we just
need polling to work.

James


