From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: st.c page_to_pfn() usage
Date: Sat, 23 Oct 2004 23:20:51 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.61.0410232255030.6707@kai.makisara.local>
References: <20041023113547.GD5855@fenrus.demon.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep32-0.kolumbus.fi ([193.229.0.63]:34038 "EHLO
	fep32-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261303AbUJWUU4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Oct 2004 16:20:56 -0400
In-Reply-To: <20041023113547.GD5855@fenrus.demon.nl>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@fenrus.demon.nl>
Cc: William Lee Irwin III <wli@holomorphy.com>, linux-scsi@vger.kernel.org

On Sat, 23 Oct 2004, Arjan van de Ven wrote:

> Hi,
> 
> I'm auditing kernel uses of page_to_pfn() and I came across st.c. 
> st.c uses page_to_pfn() twice, the first usage is:
> 
> if (page_to_pfn(STbp->sg[i].page) == page_to_pfn(STbp->sg[i-1].page) + 1)
> 	STp->nbr_combinable++;
> 
> which looks quite incorrect, I *think* the code wants to check "physically
> contiguous" however pfn is the wrong thing to check there; with discontigmem
> (which is basically true now for all 64 bit architectures), the assumption
> "pfn and pfn+1 are physically next to each other" isn't per se true,
> example:
> 
> |----- zone 1 ----------|     gap     |-------- zone 2 ----------|
> 
> the last page of zone 1 and the first page of zone 2 may be 1 pfn appart in the
> discontigmem case, but physically far appart.
> 
The code is inside DEB(), i.e., it is debugging code. The purpose of the 
code is to count the occasions where physically contiguous pages could be 
combined to a single scatter/gather segment. No decisions are made based 
on the result. My experiments suggested that combining is not usually 
possible and it is not worth trying. I did not rip off the code in case it 
would prove useful later. If it is incorrect, the easiest solution is to 
rip off everything related to STp->nbr_combinable.

> 
> the other page_to_pfn() user is st_map_user_pages():
>         for (i=0; i < nr_pages; i++) {
>                 if (page_to_pfn(sgl[i].page) > max_pfn)
>                         goto out_unmap;
>         }
> 
> and again I get the suspicion this is not the right thing to do...
> it *looks* like you want to detect userspace mmaped vmalloc() pages or
> mmaped pci mmio ranges and the like, however the test is entirely the wrong
> thing for that, take an average x86 server PC with say 6Gb of memory:
> 
> 0               3.5Gb              4Gb           6.5Gb
> |-------------------||-- PCI GAP --||---------------|
> 
> and something similar happens for vmalloc; however I fully admit that I
> don't quite entirely understand the purpose of this code yet, so maybe I'm
> misreading the intention of the code

The purpose of the code is to check if the pages are directly reachable by 
the SCSI HBA. If not, the driver reverts to bouncing all pages of this 
request. As William points out, a better name for the field would
have been bounce_pfn. The value is computed by the code fragment:

        bounce_limit = scsi_calculate_bounce_limit(SDp->host) >> PAGE_SHIFT;
        if (bounce_limit > ULONG_MAX)
                bounce_limit = ULONG_MAX;
        tpnt->max_pfn = bounce_limit;

I have never been quite sure that this is correct in all architectures. 
However, I have copied the usage from ll_rw_blk.c. If you suggest a 
better method, please see that ll_rw_blk.c is also fixed (unless I have 
read ll_rw_blk.c incorrectly).

-- 
Kai
