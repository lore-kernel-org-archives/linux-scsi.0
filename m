From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Wed, 11 Dec 2002 15:39:35 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021211153935.A23704@infradead.org>
References: <hch@infradead.org> <200212101602.gBAG2Hi02930@localhost.localdomain> <20021211135855.A19325@infradead.org> <1266570000.1039619906@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1266570000.1039619906@aslan.scsiguy.com>; from gibbs@scsiguy.com on Wed, Dec 11, 2002 at 08:18:26AM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Wed, Dec 11, 2002 at 08:18:26AM -0700, Justin T. Gibbs wrote:
> > Okay, here's a lightly tested patch to get it in shape and
> > compile/useable..
> 
> Why is this based on Alpha1 and not Alpha2.

Because that's a) what James put in the BK tree and b) that's what I downloaded
from your website today for reference.

> driver has to build all the way back to 2.4.7 (RedHat 7.2 support).

RedHat only supports kernel 2.4.18 for RH7.2/i386 and 2.4.9 with tons of
hacks for the other arches, so your argument is void.  Not to mention the only
support that is dropped by my changes is for builtin support < 2.2.18.

> Removing ifdefs just makes it harder for me to merge in changes from
> external trees.  Yes, the ifdefs are ugly, but so is the Linux SCSI layer
> and the unmanaged way that interfaces have been changed without any
> consideration to backwards compatibility (eg. the HIGHIO stuff could have
> been done with 0 impact to drivers, but wasn't for some strange reason).

linux driver interface change between stable series, face it.  And a driver
with tons of ifdefs is utter crap.  Interestingly only vendor driver use
that shitty scheme.

> 
> >   - fix kbuild integration
> 
> Can you explain what failed before?  I don't mind using aic7xxx-y
> or aic79xx-y instead of *-obj, but I would like to understand what
> bug this fixes.

AIC79xx support could be selected without PCI beeing set, letting
the makefile silently not build it, the driver wouldn't compile with
objdir != srcdir and it used more makefile code then nessecary.

