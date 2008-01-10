From: Nick Warne <nick@ukfsn.org>
Subject: Re: Driver 'sd' needs updating
Date: Thu, 10 Jan 2008 18:51:51 +0000
Message-ID: <20080110185151.5945f650@linuxamd.linicks.net>
References: <20080110085150.53addacf@linuxamd.linicks.net>
	<20080110203845E.fujita.tomonori@lab.ntt.co.jp>
	<1199989642.3141.66.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.ukfsn.org ([77.75.108.10]:45019 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755944AbYAJSv7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 13:51:59 -0500
In-Reply-To: <1199989642.3141.66.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>

On Thu, 10 Jan 2008 12:27:22 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:


> > > OK, updated to git rc7 yesterday - I now see this in syslog:
>
>    "Driver 'sd' needs updating - please use bus_type methods"
>
> > > Do I need to fix up something here?
> > 
> > No, you don't. It's harmless, a side effect of:
> > 
> > commit 751bf4d7865e4ced406be93b04c7436d866d3684
> > Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date:   Wed Jan 2 11:14:30 2008 -0600
> > 
> >     [SCSI] scsi_sysfs: restore prep_fn when ULD is removed
> > 
> > 
> > It would be better to silence this warning.
> > 
> > James, we need to reset prep_fn in each ULD? though it's not nice...
> 
> Really not nice ... to the extent that we shouldn't do it.  The reset
> is in exactly the correct place currently.  If we make it a
> requirement of the ULDs its duplication and someone is bound to
> forget.
> 
> It looks like the problem is the warning in
> base/driver.c:driver_register() apparently it wants an either/or for
> ->remove methods (either bus type or driver).  We're actually using
> the bus_type methods, but we also have a driver component, sigh.  I
> suppose what it's wanting is for me to add a scsi_driver type with
> remove methods ... which looks a bit silly since all of the SCSI
> drivers want different remove methods.

OK, actually, this is wierd for me now.  Is this warning ONLY generated
on modules?

I build with no modules, but do have modules enabled due to nVidia.  I
did post about a module called 'scsi_wait' being built, even though I
didn't want it/need it but can't stop it - please refer:

http://marc.info/?t=119705493500007&r=1&w=2

If this is true, what I have now is a module being built I don't
want/need and can't stop it being built, and a warning about it not
using bus_type methods anyway.

Nick
-- 
Free Software Foundation Associate Member 5508
