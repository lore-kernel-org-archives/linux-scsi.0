From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Date: Sat, 19 Apr 2008 17:27:56 -0500
Message-ID: <1208644076.3280.54.camel@localhost.localdomain>
References: <1208540517.3063.18.camel@localhost.localdomain>
	 <20080419151934.GA17089@elte.hu>
	 <1208620484.3280.23.camel@localhost.localdomain>
	 <20080419170530.GD1595@cs181133002.pp.htv.fi>
	 <1208626496.3280.40.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48142 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbYDSW2A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Apr 2008 18:28:00 -0400
In-Reply-To: <alpine.LFD.1.10.0804191305360.2779@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>

On Sat, 2008-04-19 at 13:14 -0700, Linus Torvalds wrote:
> On Sat, 19 Apr 2008, James Bottomley wrote:
> > 
> > Well, we already had this argument on linux-scsi when the interface was
> > first proposed:  Apart from select being very nasty and should only be
> > sparingly used
> 
> I'm still not understanding people who say that.

Well, I can ... even though SCSI is one of the major users of select in
the tree.

The argument goes that abuse of select is very easy to do ... just over
select on a lot of options.  The result is pieces of the kernel get
built in and you have a devil of a time trying to work out how to get
them to be turned off (this is annoying when you get bugs that say
without feature X enabled, Y bug happens).

Conversely depends has the opposite problem: config options disappear
for no readily apparent reason (at least until you read the Kconfig
file, then it becomes apparent).

What I try to do in SCSI is sort our Kconfig features into primary and
subsidiary, so primary features (like HBA drivers) are allowed to select
subsidiary features (like transport classes).  However, for most other
cases, we use depends instead.


> Yes, select has problems, in that it doesn't guarantee dependencies.

Yes, over use of select trips across this fairly quickly.

> But that said, select is a whole lot better than having simply *different* 
> behaviour (or build errors) depending on totally unrelated config options.
> 
> So people: stop this total *idiocy* with "select is bad". It's not. The 
> lack of select is *much* worse.
> 
> If you want LIBSAS to have two different modes, how about just making that 
> explicit in the configuration, ie using something like
> 
> 	config LIBSAS_SET_ADDR
> 		bool "Provide user-settable SAS address" 
> 		depends on SCSI_SAS_LIBSAS
> 		help
> 		  This allows a runtime "firmware" loader that loads the 
> 		  SAS address
> 
> 	config LIBSAS_SET_ADDR_FWLOAD
> 		tristate
> 		depends on SCSI_SAS_LIBSAS && LIBSAS_SET_ADDR
> 		default y
> 		select FW_LOADER

Yes, that works for libsas ... but what do we do about the prototypes in
firmware.h ... just take away the stub and force everything relying on
it to break so we can put in a Kconfig sequence like the above?

> and now you have the explicit option to turn it on or off - and FW_LOADER 
> is loaded appropriately.
> 
> > Even if I changed it to select, a user could still defeat it by making
> > CONFIG_SCSI_AIC94XX=y (because now the initialisation is before early
> > boot userland, so the request always fails).
> 
> Not true. That's why we have initrd and ramdisks etc.

They don't currently seem to work for compiled in drivers ... we have
the same issue with drivers that actually need firmware (like aic94xx or
qla2xxx): no-one seems to have figured out how to provide it for them;
it seems the device is already initialised and has failed to find its
firmware before the initrd/initramfs is running.

> Not that any normal people will ever care about LIBSAS, but anyway.. The 
> ones that do care about these kinds of things are probably happy to have 
> special initrd images.

Right ... that's more or less my argument about how far do we really
need to go to make Kconfig foolproof.

James


