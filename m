From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 09:29:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409210929.21373.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <20040921054626.GF19511@colo.lackof.org> <20040921064506.GA143950@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:48031 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267681AbUIUN3f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 09:29:35 -0400
In-Reply-To: <20040921064506.GA143950@sgi.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 2:45 am, Jeremy Higdon wrote:
> It was my understanding that this could be a problem on any
> MP machine where the CPUs use a write buffer (which is just
> about everything today).
>
> The question seems to be whether release semantics (or equivalent
> on other chips) in the IA64 apply to MMIO writes.  I believe that
> they do not.  It seems that you think that it does.

I think it's even more subtle than that.  Stores with release semantics will 
be visible on other CPUs if they're written to cacheable space, but in the 
case of MMIO writes, it's the local receiving Hub that can cause the problem.  
It'll try to send the PIO along to its destination Hub as soon as possible, 
but due to congestion, credit counts, etc., the write may be delayed and 
occur *after* a write from another CPU whose Hub is closer.  But then again, 
I could be confused.

> On Altix, we ran into a problem with the qla1280 driver (see
> version 1.56 in the scsi-misc-2.6 bk tree) because the spinunlock
> (apparently) did not imply a retirement of a previous mmio write.
> In that rev, I added an mmio read to so that the mmio write would
> be completed before releasing the spinlock (I believe the host
> lock held during the call to queuecommand).
>
> Before making that change, the problem was the two different CPUs
> would mmio write to the Request In register, and the ordering
> would flip, causing the qla1280 to think that it suddenly had
> an entire request queue.  We didn't see this problem on puny
> 64p machines (at least not under ordinary stress testing); we
> needed a 512p machine to see it, though odds are that it would
> have occurred very occasionally on smaller machines.

Good example, thanks for reminding me.

Jesse
