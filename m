From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Mon, 9 Jun 2008 18:36:23 +0900
Message-ID: <20080609183125W.fujita.tomonori@lab.ntt.co.jp>
References: <1212692488.4241.8.camel@localhost.localdomain>
	<20080606133955B.fujita.tomonori@lab.ntt.co.jp>
	<da824cf30806052248h3ac4ff21ocada15c376b399af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:44901 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758396AbYFIJgu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2008 05:36:50 -0400
In-Reply-To: <da824cf30806052248h3ac4ff21ocada15c376b399af@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: grundler@google.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org, alex.williamson@hp.com, bjorn.helgaas@hp.com

On Thu, 5 Jun 2008 22:48:13 -0700
"Grant Grundler" <grundler@google.com> wrote:

> On Thu, Jun 5, 2008 at 9:44 PM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> ...
> > The current Intel IOMMU scheme is a bit unbalanced. It invalidates the
> > translation table every time dma_unmap_* is called, but it does the
> > batching of the TLB flushes. But it's what the most of Linux's IOMMU
> > code does.
> >
> > I think that only PARISC (and IA64, of course) IOMMUs do the batching
> > of invalidating the translation table entries.
> 
> 1/2 correct. PARISC and IA64 could be the same in this regard but are not.
> See where sba_mark_invalid() is called in the respective sba_iommu.c.
> PARISC invalidates the IO Pdir entry immediately but batches the
> IO TLB shootdown and resource "free". IA64 could (and probably should)
> do the same. Added Alex Williamson and Bjorn Helgaas to CC list.
> Not an urgent issue though unless they are doing perf measurements
> with SSDs or other block device with equivalent IOPS.

Oops, thanks.

Seems that IA64 does the batching of sba_mark_invalid, sba_free_range,
and flushing TLB. IA64 and PARISC look different in this regard.
