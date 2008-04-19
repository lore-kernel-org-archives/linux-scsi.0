From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Date: Sat, 19 Apr 2008 12:34:55 -0500
Message-ID: <1208626496.3280.40.camel@localhost.localdomain>
References: <1208540517.3063.18.camel@localhost.localdomain>
	 <20080419151934.GA17089@elte.hu>
	 <1208620484.3280.23.camel@localhost.localdomain>
	 <20080419170530.GD1595@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58968 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753820AbYDSRfA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Apr 2008 13:35:00 -0400
In-Reply-To: <20080419170530.GD1595@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>

On Sat, 2008-04-19 at 20:05 +0300, Adrian Bunk wrote:
> On Sat, Apr 19, 2008 at 10:54:44AM -0500, James Bottomley wrote:
> > 
> > On Sat, 2008-04-19 at 17:19 +0200, Ingo Molnar wrote:
> > > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > 
> > > >       libsas: Provide a transport-level facility to request SAS addrs
> > > 
> > > this (or a nearby) commit caused a build regression:
> > > 
> > >  drivers/built-in.o: In function `sas_request_addr':
> > >  : undefined reference to `request_firmware'
> > >  drivers/built-in.o: In function `sas_request_addr':
> > >  : undefined reference to `release_firmware'
> > > 
> > > config can be found at:
> > > 
> > >    http://redhat.com/~mingo/misc/config-Sat_Apr_19_16_58_35_CEST_2008.bad
> > > 
> > > ... brought to you by x86.git's randconfig build and boot service ;-)
> > 
> > This one's fun.  The root cause is 
> > 
> > CONFIG_SCSI_SAS_LIBSAS=y
> > CONFIG_FW_LOADER=m
> > 
> > The problem is that libsas doesn't depend on the FW loader and doesn't
> > want to.  It just wants to use it if it's available.  The definitions in
> > include/linux/firmware.h have stubs to facilitate this.
> > 
> > However, CONFIG_FW_LOADER=m defeats the stubs.
> > 
> > This is a bit nasty to fix; however, I think this patch does.  I've also
> > put a large comment in to explain what's going on.
> >...
> 
> Your patch fixes the build error, but I'm not sure whether it's the
> correct fix:
> 
> CONFIG_SCSI_SAS_LIBSAS=y, CONFIG_FW_LOADER=m, CONFIG_SCSI_AIC94XX=m
> will now pass all randconfig tests, but the effects of the
> "select FW_LOADER" in the SCSI_AIC94XX driver would be lost in this 
> configuration, and we might get bug reports like "driver works built-in 
> but fails with 'No SAS Address provided for %s\n' when built modular."
> 
> IMHO SCSI_SAS_LIBSAS should simply select FW_LOADER.

Well, we already had this argument on linux-scsi when the interface was
first proposed:  Apart from select being very nasty and should only be
sparingly used, this interface is really only provided for specific OS
defined cases.  It's users are expected to know the pitfalls and the
dangers (it's only for boards with no fw in either pre-test or embedded
situations), so the casual user should never have to use it.

Even if I changed it to select, a user could still defeat it by making
CONFIG_SCSI_AIC94XX=y (because now the initialisation is before early
boot userland, so the request always fails).

James


