From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 2/3] ps3: BD/DVD/CD-ROM Storage Driver
Date: Thu, 19 Jul 2007 11:41:01 +0200
Message-ID: <20070719094100.GF11657@kernel.dk>
References: <20070716161539.075822000@pademelon.sonytel.be> <20070716162206.529280000@pademelon.sonytel.be> <20070718164351.a92ec032.akpm@linux-foundation.org> <Pine.LNX.4.62.0707191100270.8661@pademelon.sonytel.be> <20070719021752.35cb7daa.akpm@linux-foundation.org> <Pine.LNX.4.62.0707191137470.8661@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:2954 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763530AbXGSJlW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2007 05:41:22 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0707191137470.8661@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Mackerras <paulus@samba.org>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>

On Thu, Jul 19 2007, Geert Uytterhoeven wrote:
> On Thu, 19 Jul 2007, Andrew Morton wrote:
> > On Thu, 19 Jul 2007 11:02:07 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> > 
> > > On Wed, 18 Jul 2007, Andrew Morton wrote:
> > > > > +struct ps3rom_private {
> > > > > +	struct ps3_storage_device *dev;
> > > > > +	struct scsi_cmnd *curr_cmd;
> > > > > +};
> > > > > +#define ps3rom_priv(dev)	((dev)->sbd.core.driver_data)
> > > > > +
> > > > 
> > > > Someone should invent a keyboard which delivers an electric shock when the
> > > > operator types "#define".   In the meanwhile, I get to do the honours.
> > > > 
> > > > Please don't implement in a macro anything which can be implemented in C.
> > > 
> > > All I needed was a shorthand to access driver_data, for both read and write
> > > access (you cannot do the latter with C, unless you decouple read and write).
> > 
> > Oh dear.
> > 
> > 	ps3rom_priv(dev) = host;
> > 
> > that's 'orrid.  We have an identifier pretending to be a function, only we
> > go and treat it as an lvalue.
> > 
> > I mean, C code should look like C code, and the above just doesn't.
> > 
> > Sigh.
> 
> Do you prefer
> 
> static inline struct ps3rom_private *ps3rom_priv_get(struct ps3_storage_device
> *dev)
> {
> 	return dev->sbd.core.driver_data;
> }
> 
> static inline void ps3rom_priv_set(struct ps3_storage_device *dev,
> 				   struct ps3rom_private *priv)
> {
> 	dev->sbd.core.driver_data = priv;
> }

how about just killing them? it makes the code harder to read, what is
the point of abstracting something like that out?

-- 
Jens Axboe

