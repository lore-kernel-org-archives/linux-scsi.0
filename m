From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 13:43:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921204336.GB146363@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0012AD90D@AVEXCH02.qlogic.org> <20040921162535.GB11446@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:26259 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S268042AbUIUUnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 16:43:50 -0400
Content-Disposition: inline
In-Reply-To: <20040921162535.GB11446@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 05:25:35PM +0100, Matthew Wilcox wrote:
> On Tue, Sep 21, 2004 at 08:58:23AM -0700, Andrew Vasquez wrote:
> > From what I can gather from the hw engineers, the config-read will not
> > guarantee a flush of posted writes.
> 
> I believe your hardware engineers to be mistaken.  See PCI 2.2, Appendix
> E, section E.2:
> 
> 2. Memory writes can be posted in both directions in a bridge. I/O and
>    Configuration writes are not posted. (I/O writes can be posted in the
>    Host Bridge, but some restrictions apply.) Read transactions (Memory,
>    I/O, or Configuration) are not posted.
> 
> 5. A read transaction must push ahead of it through the bridge any posted
>    writes originating on the same side of the bridge and posted before the
>    read. Before the read transaction can complete on its originating bus,
>    it must pull out of the bridge any posted writes that originated on
>    the opposite side and were posted before the read command completes
>    on the read-destination bus.


I would agree.  A config read should retire any posted I/O writes, whether
Port or Memory Mapped.

So, unless the qla2xxx chips also do not respond to config reads after
reset, the config read should be the answer . . .

. . . unless there is some sort of random delay within the chip itself
between a completion of the IO write on the PCI bus and the chip resetting
itself.  That's not a problem, is it, Andrew?

jeremy
