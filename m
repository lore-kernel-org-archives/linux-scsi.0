From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] fix media change events for polled devices
Date: Fri, 21 Mar 2008 17:52:04 -0500
Message-ID: <1206139925.2961.94.camel@localhost.localdomain>
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
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39913 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932141AbYCUWwJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 18:52:09 -0400
In-Reply-To: <47E4383F.4030804@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Fri, 2008-03-21 at 18:35 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > Anyway, realistically, since no CD or DVD on the market today seems to
> > support the AHCI AN method, this argument is really moot ...
> 
> No, it's not.  This information is published to userspace EVEN WHEN AN 
> SUPPORT IS ABSENT.  As any sane interface would do -- report a zero value.

Right, it still does this.  Currently hal is taking 0 in the
media_change file to mean I don't support AN.

> Thus, the interface is useful even in the absence of AN.

Yes, that's why we're having the argument ... it's the use of the event
in the absence of AN that people care about.

> Anyway, to recap...
> 
> before your "fix":
> 
> 	userspace interface always reflected list of events sent
> 	via my new API

It didn't show a list to userspace ... it's a single file with a 0 or 1
value.  0 means doesn't support AN, 1 means does.

> after your "fix":
> 
> 	events may or may not be reflected in userspace interface,
> 	who knows?

It's still a single file with a 0 or 1 value.  0 means doesn't support
AN, 1 means does.

> Is that distinction so difficult to see?

Well, if they have the same userspace effect, and display the same
information to userspace, it's a bit hard to see how a user would
distinguish them, yes.

> This interface, like it or not, is in 2.6.24, which means its published 
> and "out there."
> 
> This is a clear regression from 2.6.24.
> 
> supported_events' value was accurate in 2.6.24.  Now it is not.

The current published API is the media_events file.  HAL is using that
to indicate support for AN.  This is why we can't simply change it to 1
wholesale because we'll confuse HAL (HAL still has to send polling
events if AN isn't supported).

So, the best fix for 2.6.25 at the current -rc6 is to keep the meaning
of the media_change file the same (0 for no AN, 1 for AN) and let HAL
take the polled events via udev, which basically means it's preserving
the behaviour and isn't a regression.

For 2.6.26 we can add a new media_events_polled (or some other name)
file, fix the sysfs ro attribute and make them true writeable filters so
some raving user can turn off polled events if they want and everyone
will be happy.

James


