From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Date: Sat, 19 Apr 2008 20:05:30 +0300
Message-ID: <20080419170530.GD1595@cs181133002.pp.htv.fi>
References: <1208540517.3063.18.camel@localhost.localdomain> <20080419151934.GA17089@elte.hu> <1208620484.3280.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758364AbYDSRGF@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1208620484.3280.23.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Apr 19, 2008 at 10:54:44AM -0500, James Bottomley wrote:
> 
> On Sat, 2008-04-19 at 17:19 +0200, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > >       libsas: Provide a transport-level facility to request SAS addrs
> > 
> > this (or a nearby) commit caused a build regression:
> > 
> >  drivers/built-in.o: In function `sas_request_addr':
> >  : undefined reference to `request_firmware'
> >  drivers/built-in.o: In function `sas_request_addr':
> >  : undefined reference to `release_firmware'
> > 
> > config can be found at:
> > 
> >    http://redhat.com/~mingo/misc/config-Sat_Apr_19_16_58_35_CEST_2008.bad
> > 
> > ... brought to you by x86.git's randconfig build and boot service ;-)
> 
> This one's fun.  The root cause is 
> 
> CONFIG_SCSI_SAS_LIBSAS=y
> CONFIG_FW_LOADER=m
> 
> The problem is that libsas doesn't depend on the FW loader and doesn't
> want to.  It just wants to use it if it's available.  The definitions in
> include/linux/firmware.h have stubs to facilitate this.
> 
> However, CONFIG_FW_LOADER=m defeats the stubs.
> 
> This is a bit nasty to fix; however, I think this patch does.  I've also
> put a large comment in to explain what's going on.
>...

Your patch fixes the build error, but I'm not sure whether it's the
correct fix:

CONFIG_SCSI_SAS_LIBSAS=y, CONFIG_FW_LOADER=m, CONFIG_SCSI_AIC94XX=m
will now pass all randconfig tests, but the effects of the
"select FW_LOADER" in the SCSI_AIC94XX driver would be lost in this 
configuration, and we might get bug reports like "driver works built-in 
but fails with 'No SAS Address provided for %s\n' when built modular."

IMHO SCSI_SAS_LIBSAS should simply select FW_LOADER.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
