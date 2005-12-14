From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws, PCI coherency problem
Date: Wed, 14 Dec 2005 15:56:59 -0800
Message-ID: <20051214235659.GB44861@sgi.com>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com> <439DE50B.90007@sgi.com> <1134424057.3713.18.camel@mulgrave> <20051214012856.GA185272@sgi.com> <1134536377.3133.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:14574 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S965099AbVLNX5O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 18:57:14 -0500
Content-Disposition: inline
In-Reply-To: <1134536377.3133.13.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Michael Reed <mdr@sgi.com>, pazke@donpac.ru, Michael Joosten <michael.joosten@c-lab.de>, linux-scsi@vger.kernel.org

On Tue, Dec 13, 2005 at 08:59:37PM -0800, James Bottomley wrote:
> On Tue, 2005-12-13 at 17:28 -0800, Jeremy Higdon wrote:
> > On Mon, Dec 12, 2005 at 03:47:37PM -0600, James Bottomley wrote:
> > > Well, the idea was that mmiowb and posting flushes were orthogonal.
> > > mmiowb would be used in places where a posted write flush was done but
> > > was strictly unnnecessary.  This bug report is implying that the posted
> > > write flush was necessary, so it was incorrectly replaced with mmiowb
> > > (which is a nop on most platforms).
> > 
> > No, I don't think it was necessary here.  Though if a platform does
> > write posting yet has a null mmiowb() implementation, it will have
> > trouble.
> 
> Now you're worrying me: Every platform other than Altix does have a null
> mmiowb() implementation and, obviously, PCI posting flush requirements
> are within the province of the bridge rather than the platform (high end
> servers being the ones that have posting bridges).  If mmiowb() is
> meant to take the place of write posting flushes then we're in deep
> do-do.
>
> The only thing I thought mmiowb() was supposed to be used for is the
> case where the platform implements relaxed ordering and we want to
> enforce strong ordering on the PCI bus write transactions, but don't
> actually care when the write actually completes.

Let me try that again, as I was being imprecise.  The mmiowb is needed
there to ensure proper ordering of writes to that register from different
CPUs.  Obviously, if there is no write posting, write ordering is not
a problem (my imprecision above), as long as access to that register is
protected by a spinlock, which it is.

The driver/OS/chip don't really care when that write completes as long
as later writes from the same or other CPUs complete afterward.

> > Yes, the posting of PIO writes is the real problem with the VISWS.
> > Early ports of Linux for Altix had the same problem.
> > The current Altix outw looks like this:
> > 
> > static inline void
> > ___sn_outw (unsigned short val, unsigned long port)                                         
> > {
> >         volatile unsigned short *addr;
> > 
> >         if ((addr = sn_io_addr(port))) {
> >                 *addr = val;
> >                 __sn_mmiowb();
> >         }
> > }
> > 
> > 
> > There ought to be a similar facility in the VISWS, though finding
> > anyone who knows about it might be difficult (the last one was built
> > in 1999).
> > 
> > It sounds as though the VISWS should also implement the mmiowb(),
> > since it apparently needs it for write ordering.  Of course, you
> > can always do a readX for that, but that's quite a bit heavier weight
> > than necessary.
> 
> My primary concern in all of this is that the write posting flush was
> incorrectly removed.  In this case, a UP VISWS should still show the
> error (now we've established that it's posting even in the PIO case).
> If it doesn't, I'll be happy with a VISWS specific fix.

I'm a little surprised that the UP VisWS is showing the problem.  It
looks like it might be reordering writes from the same CPU, though that
seems really unlikely.  I think more debugging of the VisWS is in order
before we can draw any conclustions.

In any case, the flush is unnecessary; only ordering is needed at that
point in the driver.

Btw, the VisWS Linux port apparently uses non-coherent DMA.  Perhaps it
should be switched to coherent DMA, as there could be bugs in that area
with qla1280.

> James

jeremy
