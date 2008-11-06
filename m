From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: thin provisioned LUN support
Date: Thu, 06 Nov 2008 17:55:37 -0500
Message-ID: <491375E9.7020707@redhat.com>
References: <4913028B.6010405@redhat.com> <20081106223605.GC2373@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39188 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYKFWzt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2008 17:55:49 -0500
In-Reply-To: <20081106223605.GC2373@disturbed>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kerne

Dave Chinner wrote:
> On Thu, Nov 06, 2008 at 09:43:23AM -0500, Ric Wheeler wrote:
>   
>> After talking to some vendors, one issue that came up is that the arrays  
>> all have a different size that is used internally to track the SCSI  
>> equivalent of TRIM commands (POKE/unmap).
>>
>> What they would like is for us to coalesce these commands into aligned  
>> multiples of these chunks. If not, the target device will most likely  
>> ignore the bits at the beginning and end (and all small requests).
>>     
>
> There's lots of questions that need to be answered here. e.g:
>
> Where are these free spaces going to be aggregated before dispatch?
>
> What happens if they are re-allocated and re-written by the
> filesystem before they've been dispatched?
>
> How is the chunk size going to be passed to the aggregation layer?
>
> What about passing itto the filesystem so it can align all it's
> allocations in a manner that simplifies the dispatch problem?
>
> What happens if a crash occurs before the aggregated free space is
> dispatched?
>
> Are there coherency problems with filesystem recovery after a crash?
>   

The good thing about these "unmap" commands (SCSI speak this week for 
TRIM) is that we can drop them if we have to without data integrity 
concerns.

The only thing that you cannot do is to send down an unmap for a block 
still in use (including ones that have not been committed in a transaction).

In SCSI, they plan to zero those blocks so that you will always read a 
block of zeros back if you try to read an unmapped sector.

I have no idea how we can pass the aggregation size up from the block 
layer since it is not currently exported in a uniform way from SCSI. 
Even if it is, we have struggled to get RAID stripe alignment handled so 
far.

>   
>> I have been thinking about whether or not we can (and should) do  
>> anything more than our current best effort to send down large chunks  
>> (note that the "chunk" size can range from reasonable sizes like 8KB or  
>> so up to close to 1MB!).
>>     
>
> Any aggregation is only as good as the original allocation the
> filesystem did. Look as the mess ext3 extracting untarring a kernel
> tarball creates - blocks are written to all over the place. You'd
> need to fix that to have any hope of behaviour nicely for a RAID
> that has a sub-optimal thin provisioning algorithm.
>
> The problem is not with the filesystem, the block layer or the OS.
> If they array vendors have optimised themselves into a corner,
> then they shoul dbe fixing their problem, not asking the rest of
> the world to expend large amounts of effort to work around the
> shortcomings of their products.....
>   

I agree - I think that eventually vendors will end up having to cache 
the requests internally. The problem is with the customers who will be 
getting the first generation of gear and have had their expectations set 
already....

>   
>> One suggestion is that a modified defrag sweep could be used
>> periodically to update the device (a proposal I am not keen on).
>>     
>
> No thanks. That needs an implementation per filesystem, and it will
> need to be done with the filesystem on line which means it will
> still need substantial help from the kernel.
>
> Cheers,
>
> Dave.
>   

It does seem to be a mess - especially since people have already gone to 
the trouble to put the hooks in to inform the storage in a consistent 
and timely way :-)

Ric

