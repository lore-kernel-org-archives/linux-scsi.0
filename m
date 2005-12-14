From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws, PCI coherency problem
Date: Tue, 13 Dec 2005 17:28:56 -0800
Message-ID: <20051214012856.GA185272@sgi.com>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com> <439DE50B.90007@sgi.com> <1134424057.3713.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:47304 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030332AbVLNB3S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2005 20:29:18 -0500
Content-Disposition: inline
In-Reply-To: <1134424057.3713.18.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Michael Reed <mdr@sgi.com>, pazke@donpac.ru, Michael Joosten <michael.joosten@c-lab.de>, linux-scsi@vger.kernel.org

On Mon, Dec 12, 2005 at 03:47:37PM -0600, James Bottomley wrote:
> > Given that I've been unable to unearth the chipset documentation
> > for the Vis WS, I can only hope that you've got some good ideas
> > on how this might be accomplished.
> 
> Well, the idea was that mmiowb and posting flushes were orthogonal.
> mmiowb would be used in places where a posted write flush was done but
> was strictly unnnecessary.  This bug report is implying that the posted
> write flush was necessary, so it was incorrectly replaced with mmiowb
> (which is a nop on most platforms).

No, I don't think it was necessary here.  Though if a platform does
write posting yet has a null mmiowb() implementation, it will have
trouble.

> > I agree that replacing the pio read which flushed the preceeding
> > pio write with mmiowb() is what has likely broken the driver.  If you
> > restore them,  please make it either mmiowb or pio read, but not both.
> > 
> > Perhaps something like this?  It's not the most elegant solution....
> 
> I'm tempted to say I think we need to put the write posting flush back
> in and dump the mmiowb(), but since the driver is supposedly doing PIO
> for VISWS, there's something else going on here (PIO writes aren't
> supposed to post).  I've cc'd the VISWS maintainer in case he can think
> of anything.

Yes, the posting of PIO writes is the real problem with the VISWS.
Early ports of Linux for Altix had the same problem.
The current Altix outw looks like this:

static inline void
___sn_outw (unsigned short val, unsigned long port)                                         
{
        volatile unsigned short *addr;

        if ((addr = sn_io_addr(port))) {
                *addr = val;
                __sn_mmiowb();
        }
}


There ought to be a similar facility in the VISWS, though finding
anyone who knows about it might be difficult (the last one was built
in 1999).

It sounds as though the VISWS should also implement the mmiowb(),
since it apparently needs it for write ordering.  Of course, you
can always do a readX for that, but that's quite a bit heavier weight
than necessary.

jeremy
