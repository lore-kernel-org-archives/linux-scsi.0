From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Thu, 16 Sep 2004 16:14:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040916231406.GA112738@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060EF48@AVEXCH02.qlogic.org> <1095362263.16326.12.camel@praka> <20040916125631.1f25dfdb.pj@sgi.com> <200409161305.02947.jbarnes@engr.sgi.com> <1095368210.16820.6.camel@praka>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:23237 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S268410AbUIPXPh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 19:15:37 -0400
Content-Disposition: inline
In-Reply-To: <1095368210.16820.6.camel@praka>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jesse Barnes <jbarnes@engr.sgi.com>, Paul Jackson <pj@sgi.com>, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Thu, Sep 16, 2004 at 01:56:50PM -0700, Andrew Vasquez wrote:
> On Thu, 2004-09-16 at 13:05, Jesse Barnes wrote:
> > On Thursday, September 16, 2004 12:56 pm, Paul Jackson wrote:
> > > Andrew Vasquez has been looking at this, via private email with just
> > > me (no progress yet).  Figured I update the larger list with this much ...
> > 
> > It seems to be failing on one of the accesses to PCI_COMMAND in config space 
> > in qla2x00_reset_chip().  I'm checking now to see if we're accessing the card 
> > right after a reset but before the card has finished.  That would cause a 
> > master abort, the symptom I'm seeing at least.
> > 
> 
> Interesting, the only changes in reset_chip() are for PCI posting
> issues.  Relevant diff attached.
> 
> --
> Andrew

Are all of those reads really necessary?  Generally the only reason
for doing a read to flush a posted write is for timing issues (in
which the read may not be good enough, according to a thread I saw
from Grant Grundler), or to enforce ordering before releasing a
lock (sleeping or spinning).

Have you run into platforms in which two I/O writes from one CPU are
retired out of order?

jeremy
