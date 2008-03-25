From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] fix media change events for polled devices
Date: Mon, 24 Mar 2008 20:18:11 -0700
Message-ID: <1206415091.3494.90.camel@localhost.localdomain>
References: <200803211559.m2LFxPi6017869@hera.kernel.org>
	 <47E3EC67.4050404@garzik.org>
	 <1206128662.2961.37.camel@localhost.localdomain>
	 <47E41C50.4020406@garzik.org>
	 <1206133280.2961.45.camel@localhost.localdomain>
	 <47E422F1.7080806@garzik.org>
	 <1206133787.2961.52.camel@localhost.localdomain>
	 <47E424E2.1030801@garzik.org>
	 <1206136150.2961.79.camel@localhost.localdomain>
	 <47E4383F.4030804@garzik.org>
	 <1206139925.2961.94.camel@localhost.localdomain>
	 <47E86CD4.7040502@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40005 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754590AbYCYDSV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 23:18:21 -0400
In-Reply-To: <47E86CD4.7040502@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Mon, 2008-03-24 at 23:09 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > The current published API is the media_events file.  HAL is using that
> > to indicate support for AN.  This is why we can't simply change it to 1
> > wholesale because we'll confuse HAL (HAL still has to send polling
> > events if AN isn't supported).
> > 
> > So, the best fix for 2.6.25 at the current -rc6 is to keep the meaning
> > of the media_change file the same (0 for no AN, 1 for AN) and let HAL
> > take the polled events via udev, which basically means it's preserving
> > the behaviour and isn't a regression.
> > 
> > For 2.6.26 we can add a new media_events_polled (or some other name)
> > file, fix the sysfs ro attribute and make them true writeable filters so
> > some raving user can turn off polled events if they want and everyone
> > will be happy.
> 
> 
> So version 3 of the interface will be the first stable and usable one... 
> sigh :/

Well, it's open source ... this interface has had a better passage than
some of the block ones I could name.

> It's just disheartening that the userspace filtering stuff (including 
> interface) was disabled rather than fixed, given that that change came 
> first and arguably the follow-on change (285e9670) was an abuse of the 
> API that was never corrected -- which seems to be tacitly acknowledged 
> since everyone seems to agree more than one flag is needed.

I think the current hack is the simplest way to fix up 2.6.25, given the
lateness in the -rc cycle ... we can do a far better job in 2.6.26 and
still be backwards compatible with the 2.6.25 hack.  In fact, I
committed to Kay that we would ... although if you want to do it
instead, that would be easier for me.

Thanks,

James


