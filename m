From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] Remove of old NCR53C9x/esp family of drivers
Date: Thu, 03 Jan 2008 13:19:52 -0600
Message-ID: <1199387992.3122.31.camel@localhost.localdomain>
References: <477CFC97.2010201@panasas.com>  <477D0209.2000609@panasas.com>
	 <1199384189.3122.22.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801032003170.27528@anakin>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38670 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273AbYACTUD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 14:20:03 -0500
In-Reply-To: <Pine.LNX.4.64.0801032003170.27528@anakin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>


On Thu, 2008-01-03 at 20:05 +0100, Geert Uytterhoeven wrote:
> On Thu, 3 Jan 2008, James Bottomley wrote:
> > On Thu, 2008-01-03 at 17:40 +0200, Boaz Harrosh wrote:
> > > As recommended by Christoph Hellwig. There is no use
> > >  of Fixing these drivers, since there is a much simpler
> > >  and modern esp infrastructure with David Miller's esp_scsi
> > > 
> > >   - Remove all driver files dependent on NCR53C9x.c
> > >         deleted:    drivers/scsi/NCR53C9x.c
> > >         deleted:    drivers/scsi/NCR53C9x.h
> > >         deleted:    drivers/scsi/blz1230.c
> > >         deleted:    drivers/scsi/blz2060.c
> > >         deleted:    drivers/scsi/cyberstorm.c
> > >         deleted:    drivers/scsi/cyberstormII.c
> > >         deleted:    drivers/scsi/dec_esp.c
> > >         deleted:    drivers/scsi/fastlane.c
> > >         deleted:    drivers/scsi/mac_esp.c
> > >         deleted:    drivers/scsi/mca_53c9x.c
> > >         deleted:    drivers/scsi/oktagon_esp.c
> > >         deleted:    drivers/scsi/oktagon_io.S
> > >         deleted:    drivers/scsi/sun3x_esp.c
> > > 
> > >   - Remove above list from drivers/scsi/Kconfig &&
> > > drivers/scsi/Makefile
> > 
> > OK, I'll split this into four pieces for scsi-pending, since there are
> > three separate interest groups with signoffs to collect (MCA, m68k and
> > alpha) plus the core removal.
> 
> Anybody who can look into converting the m68k NCR53C9x drivers and has
> hardware to test (some of) them? I don't think we can afford losing one
> third of our SCSI drivers...
> 
> You can use the following as guidance:
> 
> commit 5ff263667798946abc15314eae3f341345877d7a
> Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Date:   Tue May 22 17:03:44 2007 -0700
> 
>     [SCSI] jazz_esp: Converted to use esp_core.
>         
> 	    Use new esp_scsi for JAZZ SCSI host adapter driver

I can also offer help to anyone who tries this.  It's also a good
opportunity to let die drivers that have no committed users.

Just to be clear on why we're doing this:  the NCR53C9x driver on which
these are all based is in a pretty horrendous state of repair.  The
esp_scsi one is much nicer, actually nicely tested and has a host of
features the old driver didn't.  However, the principle driving force is
the conversion of the SCSI subsystem to the sg_list accessors.  esp_scsi
is already coverted.  NCR53C9x looks like a nasty job.  Thus, the moment
the conversion patch goes in, all your drivers will break.  However,
since breakage excites a whole bunch of kernel compile checkers (and
lands me with a flood of email), I'm prepared to remove them to prevent
this from happening ... unless we can get them converted over to
esp_scsi.

I'll put the removal in the scsi-pending tree, so it won't be picked up
by -mm, but we need to get this situation resolved by 2.6.25 at the
latest.

James


