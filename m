From: Arjan van de Ven <arjan@fenrus.demon.nl>
Subject: st.c page_to_pfn() usage
Date: Sat, 23 Oct 2004 13:35:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041023113547.GD5855@fenrus.demon.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from i31207.upc-i.chello.nl ([62.195.31.207]:56454 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S267350AbUJWLfy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Oct 2004 07:35:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org

Hi,

I'm auditing kernel uses of page_to_pfn() and I came across st.c. 
st.c uses page_to_pfn() twice, the first usage is:

if (page_to_pfn(STbp->sg[i].page) == page_to_pfn(STbp->sg[i-1].page) + 1)
	STp->nbr_combinable++;

which looks quite incorrect, I *think* the code wants to check "physically
contiguous" however pfn is the wrong thing to check there; with discontigmem
(which is basically true now for all 64 bit architectures), the assumption
"pfn and pfn+1 are physically next to each other" isn't per se true,
example:

|----- zone 1 ----------|     gap     |-------- zone 2 ----------|

the last page of zone 1 and the first page of zone 2 may be 1 pfn appart in the
discontigmem case, but physically far appart.


the other page_to_pfn() user is st_map_user_pages():
        for (i=0; i < nr_pages; i++) {
                if (page_to_pfn(sgl[i].page) > max_pfn)
                        goto out_unmap;
        }

and again I get the suspicion this is not the right thing to do...
it *looks* like you want to detect userspace mmaped vmalloc() pages or
mmaped pci mmio ranges and the like, however the test is entirely the wrong
thing for that, take an average x86 server PC with say 6Gb of memory:

0               3.5Gb              4Gb           6.5Gb
|-------------------||-- PCI GAP --||---------------|

and something similar happens for vmalloc; however I fully admit that I
don't quite entirely understand the purpose of this code yet, so maybe I'm
misreading the intention of the code
