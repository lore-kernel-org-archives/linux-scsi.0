From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 15:10:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211510.19330.jbarnes@engr.sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0DD04DD@AVEXCH02.qlogic.org> <20040921185908.GG11446@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:23481 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S267976AbUIUTKa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 15:10:30 -0400
In-Reply-To: <20040921185908.GG11446@parcelfarce.linux.theplanet.co.uk>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@steeleye.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 2:59 pm, Matthew Wilcox wrote:
> On Tue, Sep 21, 2004 at 10:33:36AM -0700, Andrew Vasquez wrote:
> > Hmm...adding more confusion to the mix.  I apologize -- my reply was
> > not written correctly, yes, the config-read will flush any pending
> > writes.  But, the same problem persists -- the RISC will still stop
> > responding to requests (config or MMIO) during the soft-reset --
> > potentially resulting in a MAC (as seen by SGI).
>
> Aha!  SGI's wacky PCI controllers must be able to cope with a PCI
> config space fail, otherwise they wouldn't be able to do a PCI bus walk.

Ok, you got me!  Yes, we need to fail PCI config space read failures, but we 
don't at the moment.  Our bridge chips generate MCAs when this occurs, so we 
have to recover from them somehow.  Current PCI discovery code does this by 
making a PROM call for PCI config space access.  I expect our I/O code 
rewrite will use the standard SAL config space access routines, which should 
make this easy.

Jesse
