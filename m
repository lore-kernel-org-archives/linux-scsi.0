From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] 2.6.3 qla2xxx driver -- use readX_relaxed
Date: Mon, 1 Mar 2004 17:02:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040302010227.GA583940@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060EE25@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:54696 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S261525AbUCBBDV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2004 20:03:21 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060EE25@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, jbarnes@sgi.com

On Mon, Mar 01, 2004 at 04:45:49PM -0800, Andrew Vasquez wrote:
> On Wednesday, February 25, 2004 8:06 PM,
> linux-scsi-owner@vger.kernel.org wrote:  (really me)
> > For those to whom this is new (it was discussed on linux-kernel and
> > linux-ia64 I believe), normal PCI register reads imply that PCI DMA
> > writes that occured prior to the PCI MMR (memory mapped register)
> > read (on the PCI bus) will be reflected in system memory once the
> > MMR read is complete.
> > 
> > On our platforms, we can speed up the MMR read significantly if that
> > ordering requirement is "relaxed".
> > 
> 
> Interesting...but this implementation seems to be applying a different
> set of semantic rules to the term 'relaxed' in comparison to the
> 'relaxed ordering' rules defined by PCI-X and PCI-Express, no?

It is similar, but not the same, unfortunately.
We could have used, for example, readb_nodmasync, or readb_nosync.  I
think I like _relaxed better, but ultimately, I'd be willing to bend.

> > So I attempted to find the common register reads that don't have a
> > need for this ordering so that I could make them use this faster
> > read.
> > 
> > I did not change this line (111 of drivers/scsi/qla2xxx/qla_isr.c),
> > because it may in some cases imply that a DMA write has completed.
> > 
> > 		stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
> > 
> 
> Yes in several cases it would.
> 
> > Andrew, if you have a chance to look at this and incorporate it in
> > the driver, it would be great.  Also, any comments would be welcome.
> > 
> 
> Sounds good, I just wish I had an Altix machine to test with.  You
> seem to have covered most of the fast-path cases, I'll look some more
> tonight for any others.  I guess my only nit-pick is the lowercase
> _relaxed() suffix applied to RD_REG* #defines.

You can certainly change the #defines in the driver to match what you
want.  If you want to change the underlying pci codes, we'd have to
patch the kernel a bit.  If there's a good consensus that _relaxed
is bad and something else is better, we could do that, right Jesse?  :-)

In any case, thanks for taking a look at this.

jeremy
