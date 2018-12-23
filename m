From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: remove exofs, the T10 OSD code and block/scsi bidi support V3
Date: Sun, 23 Dec 2018 14:57:07 +0200
Message-ID: <406d1a96-2a97-2e35-e52e-22525555fc09@electrozaur.com>
References: <20181111133211.13926-1-hch@lst.de>
 <4f4b6aff-6726-c500-e3e4-f8b73d641851@electrozaur.com>
 <20181219144347.GB23410@lst.de>
 <0e8b8d45-cfeb-ba9d-c92f-953cabede1ee@interlog.com>
 <20181220072656.GA10011@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181220072656.GA10011@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dgilbert@interlog.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 20/12/18 09:26, Christoph Hellwig wrote:
> On Wed, Dec 19, 2018 at 09:01:53PM -0500, Douglas Gilbert wrote:
>>>   1) reduce the size of every kernel with block layer support, and
>>>      even more for every kernel with scsi support
>>
>> By proposing the removal of bidi support from the block layer, it isn't
>> just the SCSI subsystem that will be impacted. Those NVMe documents
>> that you referred me to earlier in the year, in the command tables
>> in 1.3c and earlier you have noticed the 2 bit direction field and
>> what 11b means? Even if there aren't any bidi NVMe commands *** yet,
>> the fact that NVMe's 64 byte command format has provision for 4
>> (not 2) independent data transfers (data + meta, for each direction).
>> Surely NVMe will sooner or later take advantage of those ... a
>> command like READ GATHERED comes to mind.
> 
> NVMe on the other hand does have support for separate read and write
> buffers as in the current SCSI bidi support, as it encodes the data
> transfers in that SQE.  So IFF NVMe does bidi commands it would have
> to use a single buffer for data in/out, 

There is no such thing as "buffer" there is at first a bio, and after
virtual-to-iommu mapping a scatter-gather-list. All these are currently
governed by a struct request.
request, bio, and sgl, have a single direction, All API's expect a single
direction.

All BIDI did was to say. Lets not change any API or structure but just
use two of them at the same time.

All the wiser is the very high level user, and the very low HW driver like
iscsi. All the middlewere was never touched.

In the view of a bidi target like say an osd. It all stream looks like a single
"Buffer" on the wire, were some of it is read and some of it is written
to.

> which can be easily done

?? Did you try. It will take much more than an additional pointer sir

> in the block layer without the current bidi support that chains
> two struct request instances for data in and data out.
> 

That was the all trick of not changing a single API or structure
Just have two of the same thing, we already know how to handle

>>>   2) reduce the size of the critical struct request structure by
>>>      128 bits, thus reducing the memory used by every blk-mq driver
>>>      significantly, never mind the cache effects
>>
>> Hmm, one pointer (that is null in the non-bidi case) should be enough,
>> that's 64 or 32 bits.
> 
> Due to the way we use request chaining we need two fields at the
> moment.  ->special and ->next_rq.  

No! ->special is nothing to do with bidi. ->special is a field to be
used by LLD's only and are not to be touched by block layer or transports
or high level users.
 
Request has the single ->next_rq for bidi. And could be eliminated by
sharing space with the elevator info. Do you want a patch?

(So in effect it can be taking 0 bytes, and yes a little bit of code)

> If we'd refactor the whole thing
> for the basically non-existent user we could indeed probably get it
> down to a single pointer. 
> 
>> While on the subject of bidi, the order of transfers: is the data-out
>> (to the target) always before the data-in or is it the target device
>> that decides (depending on the semantics of the command) who is first?
> 
> The way I read SAM data needs to be transferred to the device for
> processing first, then the processing occurs and then it is transferred
> out, so the order seems fixed.
> 

Not sure what is the "SAM" above. But most of the BIDI commands I know,
osd and otherwise, the order is command specific, and many times it is
done in parallel.
Read some bits than write some bits, rinse and repeat ...

(You see in scsi the all OUT buffer is part of the actual CDB, so in effect
 any READ is a BIDI. The novelty here is the variable sizes and the SW stack
 memory targets for the different operations)

>>
>> Doug Gilbert
>>
>>  *** there could already be vendor specific bidi NVMe commands out
>>     there (ditto for SCSI)
> 
> For NVMe they'd need to transfer data in and out in the same buffer
> to sort work, and even then only if we don't happen to be bounce
> buffering using swiotlb, or using a network transport.  Similarly for
> SCSI only iSCSI at the moment supports bidi CDBs, so we could have
> applications using vendor specific bidi commands on iSCSI, which
> is exactly what we're trying to find out, but it is a bit of a very
> niche use case.
> 

Again bidi works NOW. Did not yet see the big gain, of throwing it
out.

Jai Maa
Boaz
