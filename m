From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Mon, 02 Aug 2010 23:01:53 +0400
Message-ID: <4C571621.8070007@vlnb.net>
References: <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca> <20100729230406.GI4506@thunk.org> <4C52CBFF.6090406@vlnb.net> <20100730130957.GA26894@lst.de> <4C52D2E0.5000609@vlnb.net> <20100730133410.GA27996@lst.de> <4C52D728.6070008@vlnb.net> <20100730142025.GA29341@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100730142025.GA29341@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig, on 07/30/2010 06:20 PM wrote:
> On Fri, Jul 30, 2010 at 05:44:08PM +0400, Vladislav Bolkhovitin wrote:
>> Yes, but why not to make step further and allow to completely eliminate
>> the waiting/draining using ORDERED requests? Current advanced storage
>> hardware allows that.
>
> There is a few caes where we could do that - the fsync without metadata
> changes above would be the prime example.  But there's a lot lower
> hanging fruit until we get to the point where it's worth trying.

Yes, but, since there is also interface and file systems update coming, 
why not to design the interface now and then gracefully fill it with 
implementation?

All barriers discussions are always very hot. It definitely means the 
current approach doesn't satisfy too many people, from FS developers to 
storage vendors and users. I believe this is because the whole barriers 
ideology is not natural, hence there are too many troubles to fit it in 
the real life. Apparently, this approach needs some redesign to get in a 
more acceptable form.

IMHO, all is needed are:

1. Allow to optionally combine requests in groups and set for groups 
optional properties: caching and ordering modes (see below). Each group 
would reflect a higher level operation.

2. Allow to chain requests groups. Each chain would reflect order 
dependency between groups, i.e. higher level operations.

This interface is a natural extension of the current interface. Natural 
for storage too. In the extreme, when a group is empty, it could be 
implemented as a barrier, although, since there would be no dependencies 
between not chained groups, they would be freely reordered between each 
other.

We would need grouping requests sooner or later anyway, because 
otherwise it is impossible to implement selective cache flushing instead 
of flushing cache for the whole device as currently. This is highly 
demanded feature, especially for shared and distributed devices.

The caching properties would be:

  - None (default) - no cache flushing needed.

  - "Flush after each request". It would be translated to FUA on write 
back devices with FUA, (write, sync_cache) sequence on write back 
devices without FUA, and to nothing on write through devices.

  - "Flush at once after all finished". It would be translated to one or 
more SYNC_CACHE commands, executed after all done and syncing _only_ 
what was modified in the group, not the whole device as now.

The order properties would be:

  - None (default) - there are no order dependency between requests in 
the group.

  - ORDERED - all requests in the group must be executed in order.

Additionally, if the backend device supported ORDERED commands, this 
facility would be used to eliminate extra queue draining. For instance, 
"flush after each request" on WB devices without FUA would be a sequence 
of ORDERED commands: [(write, sync_cache) ... (write, sync_cache) wait]. 
Compare to [(write, wait, sync_cache, wait) ... (write, wait, 
sync_cache, wait)] needed achieve the same without ORDERED commands support.

For instance, your example of the fsync in XFS would be:

1) Write out all the data blocks as a group with no caching and ordering 
properties.

2) Wait that group to finish

3) Propagate any I/O error to the inode so we can pick them up

4) Update the inode size in the shadow in-memory structure

5) Start a transaction to log the inode size in the new group with 
properties "Flush at once after all finished" and no ordering (or, if 
necessary, (it isn't clear from your text) ORDERED).

6) Write out a log buffer containing the inode and btree updates in the 
new group in a chain after the group from (5) with necessary cache 
flushing and ordering properties.

I believe, it can be implemented acceptably simply and effectively, 
including the I/O scheduler level, and have some ideas for that.

Just my 5c from the storage vendors side.

> But in most cases we don't just drain an imaginary queue but actually
> need to modify software state before finishing one class of I/O and
> submitting the next.
>
> Again, take the example of fsync, but this time we have actually
> extended the file and need to log an inode size update, as well
> as a modification to to the btree blocks.
>
> Now the fsync in XFS looks like this:
>
> 1) write out all the data blocks using WRITE
> 2) wait for these to finish
> 3) propagate any I/O error to the inode so we can pick them up
> 4) update the inode size in the shadow in-memory structure
> 5) start a transaction to log the inode size
> 6) flush the write cache to make sure the data really is on disk

Here should be "6.1) wait for it to finish" which can be eliminated if 
requests sent ordered, correct?

> 7) write out a log buffer containing the inode and btree updates
> 8) if the FUA bit is not support flush the cache again
>
> and yes, the flush in 6) is important so that we don't happen
> to log the inode size update before all data has made it to disk
> in case the cache flush in 8) is interrupted
