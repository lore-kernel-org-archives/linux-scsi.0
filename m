From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.25
Date: Sat, 19 Apr 2008 18:42:02 +0200
Message-ID: <20080419164202.GA28328@elte.hu>
References: <1208540517.3063.18.camel@localhost.localdomain> <20080419151934.GA17089@elte.hu> <1208620484.3280.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761916AbYDSQm3@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1208620484.3280.23.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

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
> want to.  It just wants to use it if it's available.  The definitions 
> in include/linux/firmware.h have stubs to facilitate this.
> 
> However, CONFIG_FW_LOADER=m defeats the stubs.
> 
> This is a bit nasty to fix; however, I think this patch does.  I've 
> also put a large comment in to explain what's going on.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

thanks James - your fix works fine here.

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
