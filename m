From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Fri, 17 Sep 2004 16:10:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409171610.09323.jbarnes@engr.sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0DD04CA@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:18830 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S269037AbUIQXLc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 19:11:32 -0400
Received: from omx3.sgi.com (omx3-ext.sgi.com [192.48.171.20])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id i8HNBV8e006109
	for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2004 16:11:31 -0700
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD04CA@AVEXCH02.qlogic.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jeremy Higdon <jeremy@sgi.com>, Paul Jackson <pj@sgi.com>, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Friday, September 17, 2004 3:55 pm, Andrew Vasquez wrote:
> On Thursday, September 16, 2004 4:14 PM, Jeremy Higdon wrote:
> > On Thu, Sep 16, 2004 at 01:56:50PM -0700, Andrew Vasquez wrote:
> > > Interesting, the only changes in reset_chip() are for PCI posting
> > > issues.  Relevant diff attached.
> >
> > Are all of those reads really necessary?  Generally the only reason
> > for doing a read to flush a posted write is for timing issues (in
> > which the read may not be good enough, according to a thread I saw
> > from Grant Grundler), or to enforce ordering before releasing a lock
> > (sleeping or spinning).
>
> The reads are there to ensure ordering of the writes at each stage of
> the reset (in qla_init.c) and fw dumps (qla_dbg.c).  After speaking
> with the hardware and firmware folks, the readw() after the
> soft-reset in qla_init.c was probably what triggered the MCA.  Seems
> we will have to settle for some sort of udelay() as what was done in
> reset_chip().

Typically you'll only need the reads right before your code leaves a critical 
section that's done writes.  If hardware reorders the writes in a single 
threaded section, it's likely buggy, and I don't think we should code for 
that.  IOW, I think a majority of the reads in the patch are superfluous (not 
really harmful aside from the one, just slows things down).

> > Have you run into platforms in which two I/O writes from one CPU are
> > retired out of order?
>
> Again, only for completeness.

Please check out the doc I pointed you at to see if it makes sense.

Thanks,
Jesse
