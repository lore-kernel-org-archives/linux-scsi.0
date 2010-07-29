From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 16:58:24 -0400
Message-ID: <4C51EB70.9090209@redhat.com>
References: <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de>	 <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de>	 <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de>	 <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de>	 <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com>	 <20100729194904.GA17098@lst.de>  <4C51DCF1.3010507@redhat.com> <1280433591.4441.393.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1280433591.4441.393.camel@mulgrave.site>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On 07/29/2010 03:59 PM, James Bottomley wrote:
> On Thu, 2010-07-29 at 15:56 -0400, Ric Wheeler wrote:
>    
>> On 07/29/2010 03:49 PM, Christoph Hellwig wrote:
>>      
>>> On Thu, Jul 29, 2010 at 03:44:31PM -0400, Ric Wheeler wrote:
>>>
>>>        
>>>> I confess that I am a bit fuzzy on FUA, but think that it means that any
>>>> FUA tagged IO will go down to persistent store before returning.
>>>>
>>>>          
>>> Exactly.
>>>
>>>
>>>        
>>>> If so, then all order dependent IO would need to be issued in order and
>>>> tagged with FUA. It would not suffice to tag just the commit record as
>>>> FUA, or do I misunderstand what FUA does?
>>>>
>>>>          
>>> The commit record is ext3/4 specific terminalogy.  In xfs we just have
>>> one type of log buffers, and we could tag that as FUA.  There is very
>>> little other depenent I/O, but if that is present we need a pre-flush
>>> for it anyway.
>>>
>>>
>>>        
>> I assume that for ext3 it would get more complicated depending on the
>> journal mode. In ordered or data journal mode, we would have to write
>> the dependent non-journal data tagged with FUA, then the FUA tagged
>> transaction and finally the FUA tagged commit block.
>>
>> Not sure how FUA performs, but writing lots of small tagged writes is
>> probably not good for performance...
>>      
> That's basically everything FUA ... you might just as well switch your
> cache to write through and have done.
>    

I think that for data ordered mode that is all of the data more or less 
would get tagged. For data journal, would we have to send 2x the write 
workload down with tags?  I agree that this would be dubious at best.

Note that using the non-FUA cache flush commands, while brute force, 
does have a clear win on slower devices (S-ATA specifically).  Each time 
I have looked, using the write cache enabled on S-ATA was a win (big win 
on streaming write performance, not sure why).

On SAS drives, the flush barriers were not as large a delta (do not 
remember which won out).

> This, by the way, is one area I'm hoping to have researched on SCSI
> (where most devices do obey the caching directives).  Actually see if
> write through without flush barriers is faster than writeback with flush
> barriers.  I really suspect it is.
>
> James
>    

There are clearly much better ways to do this. Even the flushes, if we 
could flush ranges that matched the partition under the file system, 
would be better than today where we flush the entire physical device.

Ric



