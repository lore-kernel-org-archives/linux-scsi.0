From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC] relaxed barrier semantics
Date: Tue, 27 Jul 2010 14:51:28 -0400
Message-ID: <4C4F2AB0.4090003@redhat.com>
References: <20100727165627.GA474@lst.de>	 <20100727175418.GF6820@quack.suse.cz>  <20100727183546.GG7347@redhat.com> <1280256165.2833.238.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab0G0SxB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 14:53:01 -0400
In-Reply-To: <1280256165.2833.238.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, tj@kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On 07/27/2010 02:42 PM, James Bottomley wrote:
> On Tue, 2010-07-27 at 14:35 -0400, Vivek Goyal wrote:
>    
>> On Tue, Jul 27, 2010 at 07:54:19PM +0200, Jan Kara wrote:
>>      
>>>    Hi,
>>>
>>> On Tue 27-07-10 18:56:27, Christoph Hellwig wrote:
>>>        
>>>> I've been dealin with reports of massive slowdowns due to the barrier
>>>> option if used with storage arrays that use do not actually have a
>>>> volatile write cache.
>>>>
>>>> The reason for that is that sd.c by default sets the ordered mode to
>>>> QUEUE_ORDERED_DRAIN when the WCE bit is not set.  This is in accordance
>>>> with Documentation/block/barriers.txt but missed out on an important
>>>> point: most filesystems (at least all mainstream ones) couldn't care
>>>> less about the ordering semantics barrier operations provide.  In fact
>>>> they are actively harmful as they cause us to stall the whole I/O
>>>> queue while otherwise we'd only have to wait for a rather limited
>>>> amount of I/O.
>>>>          
>>>    OK, let me understand one thing. So the storage arrays have some caches
>>> and queues of requests and QUEUE_ORDERED_DRAIN forces them flush all this
>>> to the platter, right?
>>>        
>> IIUC, QUEUE_ORDERED_DRAIN will be set only for storage which either does
>> not support write caches or which advertises himself as having no write
>> caches (it has write caches but is batter backed up and is capable of
>> flushing requests upon power failure).
>>
>> IIUC, what Christoph is trying to address is that if write cache is
>> not enabled then we don't need flushing semantics. We can get rid of
>> need of request ordering semantics by waiting on dependent request to
>> finish instead of issuing a barrier. That way we will not issue barriers
>> no request queue drains and that possibly will help with throughput.
>>      
> I hope not ... I hope that if the drive reports write through or no
> cache that we don't enable (flush) barriers by default.
>
> The problem case is NV cache arrays (usually an array with a battery
> backed cache).  There's no consistency issue since the array will
> destage the cache on power fail but it reports a write back cache and we
> try to use barriers.  This is wrong because we don't need barriers for
> consistency and they really damage throughput.
>
> James
>
>    

This is the case we are trying to address. Some (most?) of these NV 
cache arrays hopefully advertise write through caches and we can 
automate disabling the unneeded bits here....

ric

