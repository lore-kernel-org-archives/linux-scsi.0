From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Wed, 11 Dec 2002 16:23:18 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021211162318.A24958@infradead.org>
References: <hch@infradead.org> <200212101602.gBAG2Hi02930@localhost.localdomain> <20021211135855.A19325@infradead.org> <1266570000.1039619906@aslan.scsiguy.com> <20021211153935.A23704@infradead.org> <1313340000.1039622906@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1313340000.1039622906@aslan.scsiguy.com>; from gibbs@scsiguy.com on Wed, Dec 11, 2002 at 09:08:26AM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Wed, Dec 11, 2002 at 09:08:26AM -0700, Justin T. Gibbs wrote:
> >> Why is this based on Alpha1 and not Alpha2.
> > 
> > Because that's a) what James put in the BK tree and b) that's what I
> > downloaded from your website today for reference.
> 
> Where did you download it from.  This file is Alpha2 based:
> 
> http://people.FreeBSD.org/~gibbs/linux/SRC/aic79xx-linux-2.5.tar.gz

Yes, from exactly that location.  But it seems like a broken proxy cached
the old version, I've downloaded it on another host now and it's uptodate.

> >> driver has to build all the way back to 2.4.7 (RedHat 7.2 support).
> > 
> > RedHat only supports kernel 2.4.18 for RH7.2/i386 and 2.4.9 with tons of
> > hacks for the other arches, so your argument is void.
> 
> Tell that to the OEMs that Adaptec has to support.  They still test and
> require 7.2 drivers.

RedHat's current, supported kernels for RHL7.2 are 2.4.18-18.7.x (i386),
2.4.9-40 (ia64) and 2.4.9-38 (s390, but that one doesn't support pci
scsi cards anyway..).

> I have no problem with interfaces changing for good reason, but, for
> example,
> a driver that alread sets unchecked_isa_dma to 0 and uses the PCI dma mask
> shouldn't have to set addition flags (with different names in different
> vendor's trees) to enable HIGHIO.  It's yet-another *stupid* interface
> change.

Maybe you could have complained about that more than one year ago when the
patch came up first?

> > Interestingly only vendor driver use that shitty scheme.
> 
> Yes, because the vendor actually has to support all of those versions
> unlike some guy who hacks this stuff in his spare time and could care
> less about anyone else's requirements but his own.

Umm, if you would properly feed your patches upstream vendors could include
current versions easily and there would be no need for extra applied patches.

It's pretty simple.    If on the other hand the vendor thinks he should
support every stupid RedHat and SuSE release (and it really hurts to see
what these companies do to their release kernels) it's their problem.  But
having all those ifdefs in the source in mainline is horribly ugly.  Note
that there are a few drivers that properly use the newest API and use
a compat header to map it to older interface on older kernels (that's not
always possible for scsi because the interface is still to crappy to keep it,
I hope that will change once 2.6 is done).

Okay, let's stop that discussion that doesn't bring us forward anyway,
and try to get your changes in the mainline kernel.  I'll merge your
new driver into the BK tree where I did the other work and send your the full
diff to your release.  IT would be nice if you could submit small
incremental diffs for each new release after that, okay?

