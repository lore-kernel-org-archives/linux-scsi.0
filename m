From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 12:18:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211218.00809.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211205.22575.jbarnes@engr.sgi.com> <1095783077.2467.145.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:36575 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267806AbUIUQS3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 12:18:29 -0400
In-Reply-To: <1095783077.2467.145.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>, Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 12:11 pm, James Bottomley wrote:
> On Tue, 2004-09-21 at 12:05, Jesse Barnes wrote:
> > Reading from the closest bridge won't be enough?  If not, then dealing
> > with posting in a nice way is simply impossible for some devices.  We'd
> > be stuck with udelay().
>
> That's correct.  The posted write is held somewhere in one of the
> bridges, but the PCI ordering rules only require it to be ordered with
> other MMIO reads to the *device*; so you only guarantee that the posted
> write is flushed by doing a device read....obviously, there exist
> bridges with looser ideas than this, but we need to follow the PCI
> specs.
>
> udelay() isn't a viable solution because the PCI specs have no upper
> bound on the length of time a write may remain posted.

Well then.  Sounds like we're hosed for the qla2xxx case at least.  I think we 
still need pioflush for the case of writes from different CPUs (described in 
the document).  Using it *should* make the window pretty small for qla2xxx 
type problems too, but we have no guarantee.

Jesse
