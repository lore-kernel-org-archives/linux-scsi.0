From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: SCSI QLA not working on latest *-mm SN2
Date: Fri, 17 Sep 2004 15:55:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD04CA@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:50663 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S269026AbUIQW7c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 18:59:32 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Jesse Barnes <jbarnes@engr.sgi.com>, Paul Jackson <pj@sgi.com>, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>


On Thursday, September 16, 2004 4:14 PM, Jeremy Higdon wrote:
> On Thu, Sep 16, 2004 at 01:56:50PM -0700, Andrew Vasquez wrote:
> > 
> > Interesting, the only changes in reset_chip() are for PCI posting
> > issues.  Relevant diff attached.
> > 
> 
> Are all of those reads really necessary?  Generally the only reason
> for doing a read to flush a posted write is for timing issues (in
> which the read may not be good enough, according to a thread I saw
> from Grant Grundler), or to enforce ordering before releasing a lock
> (sleeping or spinning). 
> 

The reads are there to ensure ordering of the writes at each stage of
the reset (in qla_init.c) and fw dumps (qla_dbg.c).  After speaking
with the hardware and firmware folks, the readw() after the
soft-reset in qla_init.c was probably what triggered the MCA.  Seems
we will have to settle for some sort of udelay() as what was done in
reset_chip().

> Have you run into platforms in which two I/O writes from one CPU are
> retired out of order? 
> 

Again, only for completeness.

Regards,
Andrew Vasquez
