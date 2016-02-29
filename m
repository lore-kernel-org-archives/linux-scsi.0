From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Lsf-pc] [LSF/MM ATTEND] Online Logical Head Depop and SMR disks
 chunked writepages
Date: Mon, 29 Feb 2016 11:06:32 +0800
Message-ID: <56D3B5B8.5030601@suse.de>
References: <05353ADC-601C-412D-80E2-1F1972324A37@hgst.com>
 <56CBD878.4070600@sandisk.com>
 <20F4EEF6-8F58-42A0-99E9-E932B51D0387@hgst.com>
 <20160223084042.GA24086@quack.suse.cz>
 <4E5FED9C-0FE5-4C31-B3C2-7C6225AB8C62@hgst.com>
 <20160224084746.GD10096@quack.suse.cz>
 <1A7F5162-E47D-4E95-8004-8100C6CA231D@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbcB2DHI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Feb 2016 22:07:08 -0500
In-Reply-To: <1A7F5162-E47D-4E95-8004-8100C6CA231D@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@hgst.com>, Jan Kara <jack@suse.cz>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Matias Bjorling <m@bjorling.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/29/2016 10:02 AM, Damien Le Moal wrote:
>=20
>> On Wed 24-02-16 01:53:24, Damien Le Moal wrote:
>>>
>>>> On Tue 23-02-16 05:31:13, Damien Le Moal wrote:
>>>>>
>>>>>> On 02/22/16 18:56, Damien Le Moal wrote:
>>>>>>> 2) Write back of dirty pages to SMR block devices:
>>>>>>>
>>>>>>> Dirty pages of a block device inode are currently processed usi=
ng the
>>>>>>> generic_writepages function, which can be executed simultaneous=
ly
>>>>>>> by multiple contexts (e.g sync, fsync, msync, sync_file_range, =
etc).
>>>>>>> Mutual exclusion of the dirty page processing being achieved on=
ly at
>>>>>>> the page level (page lock & page writeback flag), multiple proc=
esses
>>>>>>> executing a "sync" of overlapping block ranges over the same zo=
ne of
>>>>>>> an SMR disk can cause an out-of-LBA-order sequence of write req=
uests
>>>>>>> being sent to the underlying device. On a host managed SMR disk=
, where
>>>>>>> sequential write to disk zones is mandatory, this result in err=
ors and
>>>>>>> the impossibility for an application using raw sequential disk =
write
>>>>>>> accesses to be guaranteed successful completion of its write or=
 fsync
>>>>>>> requests.
>>>>>>>
>>>>>>> Using the zone information attached to the SMR block device que=
ue
>>>>>>> (introduced by Hannes), calls to the generic_writepages functio=
n can
>>>>>>> be made mutually exclusive on a per zone basis by locking the z=
ones.
>>>>>>> This guarantees sequential request generation for each zone and=
 avoid
>>>>>>> write errors without any modification to the generic code imple=
menting
>>>>>>> generic_writepages.
>>>>>>>
>>>>>>> This is but one possible solution for supporting SMR host-manag=
ed
>>>>>>> devices without any major rewrite of page cache management and
>>>>>>> write-back processing. The opinion of the audience regarding th=
is
>>>>>>> solution and discussing other potential solutions would be grea=
tly
>>>>>>> appreciated.
>>>>>>
>>>>>> Hello Damien,
>>>>>>
>>>>>> Is it sufficient to support filesystems like BTRFS on top of SMR=
 drives=20
>>>>>> or would you also like to see that filesystems like ext4 can use=
 SMR=20
>>>>>> drives ? In the latter case: the behavior of SMR drives differs =
so=20
>>>>>> significantly from that of other block devices that I'm not sure=
 that we=20
>>>>>> should try to support these directly from infrastructure like th=
e page=20
>>>>>> cache. If we look e.g. at NAND SSDs then we see that the charact=
eristics=20
>>>>>> of NAND do not match what filesystems expect (e.g. large erase b=
locks).=20
>>>>>> That is why every SSD vendor provides an FTL (Flash Translation =
Layer),=20
>>>>>> either inside the SSD or as a separate software driver. An FTL=20
>>>>>> implements a so-called LFS (log-structured filesystem). With wha=
t I know=20
>>>>>> about SMR this technology looks also suitable for implementation=
 of a=20
>>>>>> LFS. Has it already been considered to implement an LFS driver f=
or SMR=20
>>>>>> drives ? That would make it possible for any filesystem to acces=
s an SMR=20
>>>>>> drive as any other block device. I'm not sure of this but maybe =
it will=20
>>>>>> be possible to share some infrastructure with the LightNVM drive=
r=20
>>>>>> (directory drivers/lightnvm in the Linux kernel tree). This driv=
er=20
>>>>>> namely implements an FTL.
>>>>>
>>>>> I totally agree with you that trying to support SMR disks by only=
 modifying
>>>>> the page cache so that unmodified standard file systems like BTRF=
S or ext4
>>>>> remain operational is not realistic at best, and more likely simp=
ly impossible.
>>>>> For this kind of use case, as you said, an FTL or a device mapper=
 driver are
>>>>> much more suitable.
>>>>>
>>>>> The case I am considering for this discussion is for raw block de=
vice accesses
>>>>> by an application (writes from user space to /dev/sdxx). This is =
a very likely
>>>>> use case scenario for high capacity SMR disks with applications l=
ike distributed
>>>>> object stores / key value stores.
>>>>>
>>>>> In this case, write-back of dirty pages in the block device file =
inode mapping
>>>>> is handled in fs/block_dev.c using the generic helper function ge=
neric_writepages.
>>>>> This does not guarantee the generation of the required sequential=
 write pattern
>>>>> per zone necessary for host-managed disks. As I explained, aligni=
ng calls of this
>>>>> function to zone boundaries while locking the zones under write-b=
ack solves
>>>>> simply the problem (implemented and tested). This is of course on=
ly one possible
>>>>> solution. Pushing modifications deeper in the code or providing a
>>>>> "generic_sequential_writepages" helper function are other potenti=
al solutions
>>>>> that in my opinion are worth discussing as other types of devices=
 may benefit also
>>>>> in terms of performance (e.g. regular disk drives prefer sequenti=
al writes, and
>>>>> SSDs as well) and/or lighten the overhead on an underlying FTL or=
 device mapper
>>>>> driver.
>>>>>
>>>>> For a file system, an SMR compliant implementation of a file inod=
e mapping
>>>>> writepages method should be provided by the file system itself as=
 the sequentiality
>>>>> of the write pattern depends further on the block allocation mech=
anism of the file
>>>>> system.
>>>>>
>>>>> Note that the goal here is not to hide to applications the sequen=
tial write
>>>>> constraint of SMR disks. The page cache itself (the mapping of th=
e block
>>>>> device inode) remains unchanged. But the modification proposed gu=
arantees that
>>>>> a well behaved application writing sequentially to zones through =
the page cache
>>>>> will see successful sync operations.
>>>>
>>>> So the easiest solution for the OS, when the application is alread=
y aware
>>>> of the storage constraints, would be for an application to use dir=
ect IO.
>>>> Because when using page-cache and writeback there are all sorts of
>>>> unexpected things that can happen (e.g. writeback decides to skip =
a page
>>>> because someone else locked it temporarily). So it will work in 99=
=2E9% of
>>>> cases but sometimes things will be out of order for hard-to-track =
down
>>>> reasons. And for ordinary drives this is not an issue because we j=
ust slow
>>>> down writeback a bit but rareness of this makes it non-issue. But =
for host
>>>> managed SMR the IO fails and that is something the application doe=
s not
>>>> expect.
>>>>
>>>> So I would really say just avoid using page-cache when you are usi=
ng SMR
>>>> drives directly without a translation layer. For writes your throu=
ghput
>>>> won't suffer anyway since you have to do big sequential writes. Us=
ing
>>>> page-cache for reads may still be beneficial and if you are carefu=
l enough
>>>> not to do direct IO writes to the same range as you do buffered re=
ads, this
>>>> will work fine.
>>>>
>>>> Thinking some more - if you want to make it foolproof, you could i=
mplement
>>>> something like read-only page cache for block devices. Any write w=
ill be in
>>>> fact direct IO write, writeable mmaps will be disallowed, reads wi=
ll honor
>>>> O_DIRECT flag.
>>>
>>> Hi Jan,
>>>
>>> Indeed, using O_DIRECT for raw block device write is an obvious sol=
ution to
>>> guarantee the application successful sequential writes within a zon=
e. However,
>>> host-managed SMR disks (and to a lesser extent host-aware drives to=
o) already
>>> put on applications the constraint of ensuring sequential writes. A=
dding to this
>>> further mandatory rewrite to support direct I/Os is in my opinion a=
sking a lot,
>>> if not too much.
>>
>> So I don't think adding O_DIRECT to open flags is such a burden -
>> sequential writes are IMO much harder to do :). And furthermore this=
 could
>> happen magically inside the kernel in which case app needn't be awar=
e about
>> this at all (similarly to how we handle writes to persistent memory)=
=2E
>>
>>> The example you mention above of writeback skipping a locked page a=
nd resulting
>>> in I/O errors is precisely what the proposed patch avoids by first =
locking the
>>> zone the page belongs to. In the same spirit as the writeback page =
locking, if
>>> the zone is already locked, it is skipped. That is, zones are treat=
ed in a sense
>>> as gigantic pages, ensuring that the actual dirty pages within each=
 one are
>>> processed in one go, sequentially.
>>
>> But you cannot rule out mm subsystem locking a page to do something =
(e.g.
>> migrate the page to help with compaction of large order pages). Thes=
e other
>> places accessing and locking pages are what I'm worried about. Furth=
ermore
>> kswapd can decide to writeback particular page under memory pressure=
 and
>> that will just make SMR disk freak out.
>>
>>> This allows preserving all possible application level accesses (buf=
fered,
>>> direct or mmapped). The only constraint is the one the disk imposes=
:
>>> writes must be sequential.
>>>
>>> Granted, this view may be too simplistic and may be overlooking som=
e hard
>>> to track page locking paths which will compete with this. But I thi=
nk
>>> that this can be easily solved by forcing the zone-aligned
>>> generic_writepages calls to not skip any page (a flag in struct
>>> writeback_control would do the trick). And no modification is neces=
sary
>>> on the read side (i.e. page locking only is enough) since reading a=
n SMR
>>> disks blocks after a zone write-pointer position does not make sens=
e (in
>>> Hannes code, this is possible, but the request does not go to the d=
isk
>>> and returns garbage data).
>>>
>>> Bottom line: no fundamental change to the page caching mechanism, o=
nly
>>> how it is being used/controlled for writeback makes this work.
>>> Considering the benefits on the application side, it is in my opini=
on a
>>> valid modification to have.
>>
>> See above, there are quite a few places which will break your assump=
tions.
>> And I don't think changing them all to handle SMR is worth it. IMO c=
aching
>> sequential writes to SMR disks has low effect (if any) anyway so I w=
ould
>> just avoid that. We can talk about how to make this as seamless to
>> applications as possible. The only thing which I don't think is reas=
onably
>> doable without dirtying pagecache are writeable mmaps of an SMR devi=
ce so
>> applications would have to avoid that.
>=20
> Jan,
>=20
> Thank you for your insight.
> These "few places" breaking sequential write sequences are indeed pro=
blematic
> for SMR drives. At the same time, I wonder how these paths would reac=
t to an I/O
> error generated by the check "write at write pointer" in the request =
submission
> path at the SCSI level. Could these be ignored in the case of an "una=
ligned write
> error" ? That is, the page is left dirty and hopefully the regular wr=
iteback path
> catches them later in the proper sequence. This may however be danger=
ous as there
> is no way to determine if the unaligned error is due to kswapd or oth=
er kernel
> threads trying to write back the "wrong" page, or the application hav=
ing submitted
> an out of sequence write.
>=20
> Until now, the discussion has focused on avoiding unaligned write err=
ors for cached
> writes. But this happens only on host-managed SMR disks. Another aspe=
ct of the SMR
> support should also be to avoid random write to zones on host-aware d=
isks. These will
> not return an error on unaligned writes and silently process them as =
a regular disk.
> However, this can over time degrade performance as the disk FW has to=
 handle more and
> more internal zone defragmentation.
>=20
To chime in here, we _might_ be able to fix this via a totally differen=
t
route.
If we were allow to pass _linked_ bios to ->make_request_fn (ie bios
where the ->bi_next field was already populated) we would have an easy
marker for merging those requests. At the same time we would be able to
process these linked bios as a single unit, allowing other bios only to
be added to the front or the back of these linked bios.
That would guarantee in-order delivery for SMR, and at the same time
allow us to get merging running for block-mq.

Alternatively one could try to use plugging here, but I'm not sure if
that would be sufficient; will need to test.

> If possible, I look forward to more discussions about this at LSF/MM.
>=20
Same here.
Btw, I do like the idea of Online logical head depop.
No idea how we could implement that, but the idea is nice.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
