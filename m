From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: st.c page_to_pfn() usage
Date: Sat, 23 Oct 2004 06:14:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041023131438.GM17038@holomorphy.com>
References: <20041023113547.GD5855@fenrus.demon.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from holomorphy.com ([207.189.100.168]:7628 "EHLO holomorphy.com")
	by vger.kernel.org with ESMTP id S261168AbUJWNOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Oct 2004 09:14:47 -0400
Content-Disposition: inline
In-Reply-To: <20041023113547.GD5855@fenrus.demon.nl>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@fenrus.demon.nl>
Cc: Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org

On Sat, Oct 23, 2004 at 01:35:47PM +0200, Arjan van de Ven wrote:
> I'm auditing kernel uses of page_to_pfn() and I came across st.c. 
> st.c uses page_to_pfn() twice, the first usage is:
> if (page_to_pfn(STbp->sg[i].page) == page_to_pfn(STbp->sg[i-1].page) + 1)
> 	STp->nbr_combinable++;
> which looks quite incorrect, I *think* the code wants to check "physically
> contiguous" however pfn is the wrong thing to check there; with discontigmem
> (which is basically true now for all 64 bit architectures), the assumption
> "pfn and pfn+1 are physically next to each other" isn't per se true,
> example:

I'm rather hard pressed to see how contiguous pfn's would result in
discontiguous memory. They're meant to be truly physical; the only
abuses of this I'm aware of are for hypervisor-related use, whose IO
invariants are such that all these things about bouncing and most all
handling of physical limitations of devices are irrelevant anyway.


On Sat, Oct 23, 2004 at 01:35:47PM +0200, Arjan van de Ven wrote:
> |----- zone 1 ----------|     gap     |-------- zone 2 ----------|
> the last page of zone 1 and the first page of zone 2 may be 1 pfn
> appart in the discontigmem case, but physically far appart.

I'm not sure what the numbers described in that diagram have relations
to. The 2.4.x invariant was that within a zone pfn's were monotonically
increasing, the 2.6.x invariant is that zones are literally intervals
of pfn's, which as one might expect makes various machines unhappy.


On Sat, Oct 23, 2004 at 01:35:47PM +0200, Arjan van de Ven wrote:
> the other page_to_pfn() user is st_map_user_pages():
>         for (i=0; i < nr_pages; i++) {
>                 if (page_to_pfn(sgl[i].page) > max_pfn)
>                         goto out_unmap;
>         }
> and again I get the suspicion this is not the right thing to do...
> it *looks* like you want to detect userspace mmaped vmalloc() pages or
> mmaped pci mmio ranges and the like, however the test is entirely the wrong
> thing for that, take an average x86 server PC with say 6Gb of memory:

The name max_pfn is almost certainly an accident, as the name of the
formal parameter clashes with the global variable. This seems to be a
speculative attempt to do IO without bouncing for the direct IO case.


On Sat, Oct 23, 2004 at 01:35:47PM +0200, Arjan van de Ven wrote:
> 0               3.5Gb              4Gb           6.5Gb
> |-------------------||-- PCI GAP --||---------------|
> 
> and something similar happens for vmalloc; however I fully admit that I
> don't quite entirely understand the purpose of this code yet, so maybe I'm
> misreading the intention of the code

The max_pfn passed is STp->max_pfn, which I suppose is Hungarian notation
for some pfn stored in a structure meant to represent the bounce_pfn for
the tape device. I suppose one could hunt for where it's initialized.


-- wli
