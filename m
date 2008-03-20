From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] fix media change events for polled devices
Date: Wed, 19 Mar 2008 20:25:57 -0500
Message-ID: <1205976357.11527.63.camel@localhost.localdomain>
References: <1205928287.8810.18.camel@lov.site>
	 <1205945642.11527.23.camel@localhost.localdomain>
	 <1205975933.5498.11.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57904 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbYCTB0G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 21:26:06 -0400
In-Reply-To: <1205975933.5498.11.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: scsi <linux-scsi@vger.kernel.org>, David Zeuthen <david@fubar.dk>, kristen accardi <kaccardi@gmail.com>, Jeff Garzik <jeff@garzik.org>

On Thu, 2008-03-20 at 02:18 +0100, Kay Sievers wrote:
> On Wed, 2008-03-19 at 11:54 -0500, James Bottomley wrote:
> > On Wed, 2008-03-19 at 13:04 +0100, Kay Sievers wrote:
> > > we like to see this in 2.6.25, as "change" events for polled devices are
> > > broken at the moment.
> > 
> > I'm not happy just killing the code, since when the AN infrastructure
> > gets fixed, it will work.
> 
> Who is going to fix what and when? Jeff did not even reply the last two
> weeks to the simple question why he added this filter, and why events
> need to dropped if something wants to send them. :)

Oh ... who else ... I'll fix it.  It looks pretty simple: we need two
separate events for the filter: polled and AN media change notifies.  We
should be able to turn either of them off, so two separate flags.  They
need to be unified into the single media change event at the top of the
stack before we call udev.

This will allow us to turn off the AN notifies if we get a problem,
which was the original idea.

> These events are for non-AN devices, which we still poll for media
> changes. Userspace wants the same kind of events for both types of
> devices.
> 
> > How about this instead as a fix for 2.6.25?
> 
> We are currently working on a the next generation of the storage part of
> the hal daemon, which needs these events. So it would be nice, if we can
> make them working now, like they worked with Kristens original patches.

If we emit the same event at the top of the stack, what more needs be
done?  I take it all you want is an indication that we will be using AN
instead of polling, which you will be able to get from the sysfs file.

James


