From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/5] make sg always send scatterlists take 2
Date: Fri, 16 Sep 2005 14:28:39 -0500
Message-ID: <432B1CE7.6010005@cs.wisc.edu>
References: <1126845593.9276.43.camel@max> <20050916111005.GA27045@infradead.org> <432AE22C.4060702@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50638 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750888AbVIPV2y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 17:28:54 -0400
In-Reply-To: <432AE22C.4060702@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Mike Christie wrote:
> Christoph Hellwig wrote:
> 
>> On Thu, Sep 15, 2005 at 11:39:53PM -0500, Mike Christie wrote:
>>
>>> Convert sg to always use scatterlists.
>>>
>>> I made the scsi api take scatterlists now so HighMem is supported
>>> for DIO.
>>
>>
>>
>> Looks pretty nice.  There's lots of page_address() calls left, two
> 
> 
> yeah I was going to change them to kmaps for Doug and Kai, but thought I 
> should do that in another patch in case I mees up. I thought in the 
> paths they use page_address are the indirect or mmap paths which 
> allocate the pages from GFP_KERNEL or GFP_DMA.
> 

Oh so I guess using kmap makes no sense with these patches. For direct 
IO we never do a page_address on a page so that is why we get to support 
highmem for free (block layer bounces the buffer for us), but for the 
non-direct IO (sg's indirect and mmap paths) we have to allocate blocks 
of contigous pages with alloc_pages/__get_free_pages so that we can 
build those really large segments and and large requessts (same for st's 
large requests).

In my first patches where I broke a bunch of stuff but ripped out a lot 
of duplicated code, I converted sg to use the block layer 
blk_rq_map_user* functions (but just killed mmap support since there was 
no blk_rq_map* helper) which do single bio requests and only perform 
alloc_page (a bio_vec maps to just one page) so requests from those 
functions were too small and normally limited by the BIO_MAX_PAGES limit 
or one of the queues segment limits (doing alloc_page a bunch of times 
typically did not get enough contigous pages to make large segments like 
when we just do alloc_pages).
