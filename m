From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 18:33:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211833.55343.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <20040921211108.GA16153@parcelfarce.linux.theplanet.co.uk> <20040921214302.GG146363@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:12777 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S266613AbUIUWe0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 18:34:26 -0400
In-Reply-To: <20040921214302.GG146363@sgi.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Grant Grundler <grundler@parisc-linux.org>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 5:43 pm, Jeremy Higdon wrote:
> > > CPUA: writel(value_X, common_register)
> > >  sn_mmiob()
> > >  spin_unlock(common_lock)
> > >
> > > CPUB: spin_lock(common_lock)
> > >  writel(value_Y, common_register)
> > >
> > > would strongly order the writes.
> >
> > I think your _raw_spin_unlock() should include an sn_mmiob().
>
> That could be very painful.
> On Irix, we actually had a separate spinunlock (io_spin_unlock) that
> added the MIPS equivalent.  I'm assuming we don't want to entertain
> that here :-)  (Though tell me if I'm wrong)

It's worth noting that this affects some MIPS systems as well, so that's at 
least two Linux arches that would benefit from a nice solution to this 
problem.

Jesse
