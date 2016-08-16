From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v6 0/2] Block layer support ZAC/ZBC commands
Date: Tue, 16 Aug 2016 00:49:33 -0500
Message-ID: <CAJVOszAnq+bfkfQ4UWD8gERfOBP_eAyNdS_3cTM2ZtrDG+6Z1A@mail.gmail.com>
References: <1469818955-20568-1-git-send-email-shaun@tancheff.com>
 <20160801094116.GB14677@lst.de> <CAJVOszCAb4o5LWpJL8Yd66n9jPvy+EMQX2Xfr6awZCxfGJf_CA@mail.gmail.com>
 <6a4a27ac-009d-9825-bf77-0529da77cc36@suse.de> <C7B51F39-AC67-4D96-B1DE-45C70F99134D@hgst.com>
 <CAJVOszDt5HfSKTk_8a3AkqjjAXV_9RaA2TxeqgY5Gp90w89-Lg@mail.gmail.com>
 <2370d779-3f9b-28a2-7596-42b7b6a89c21@suse.de> <CAJVOszAHL55uOuD4MbCG0gWs3ko7tZVwtAeRBXxDhD-GuD2kGA@mail.gmail.com>
 <D1D04A20-893C-4FB2-9822-0DC6309C58C8@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D1D04A20-893C-4FB2-9822-0DC6309C58C8@hgst.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@hgst.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Josh Bingaman <josh.bingaman@seagate.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 15, 2016 at 11:00 PM, Damien Le Moal <Damien.LeMoal@hgst.com> w=
rote:
>
> Shaun,
>
>> On Aug 14, 2016, at 09:09, Shaun Tancheff <shaun.tancheff@seagate.com> w=
rote:
> [=E2=80=A6]
>>>>
>>> No, surely not.
>>> But one of the _big_ advantages for the RB tree is blkdev_discard().
>>> Without the RB tree any mkfs program will issue a 'discard' for every
>>> sector. We will be able to coalesce those into one discard per zone, bu=
t
>>> we still need to issue one for _every_ zone.
>>
>> How can you make coalesce work transparently in the
>> sd layer _without_ keeping some sort of a discard cache along
>> with the zone cache?
>>
>> Currently the block layer's blkdev_issue_discard() is breaking
>> large discard's into nice granular and aligned chunks but it is
>> not preventing small discards nor coalescing them.
>>
>> In the sd layer would there be way to persist or purge an
>> overly large discard cache? What about honoring
>> discard_zeroes_data? Once the discard is completed with
>> discard_zeroes_data you have to return zeroes whenever
>> a discarded sector is read. Isn't that a log more than just
>> tracking a write pointer? Couldn't a zone have dozens of holes?
>
> My understanding of the standards regarding discard is that it is not
> mandatory and that it is a hint to the drive. The drive can completely
> ignore it if it thinks that is a better choice. I may be wrong on this
> though. Need to check again.

But you are currently setting discard_zeroes_data=3D1 in your
current patches. I believe that setting discard_zeroes_data=3D1
effectively promotes discards to being mandatory.

I have a follow on patch to my SCT Write Same series that
handles the CMR zone case in the sd_zbc_setup_discard() handler.

> For reset write pointer, the mapping to discard requires that the calls
> to blkdev_issue_discard be zone aligned for anything to happen. Specify
> less than a zone and nothing will be done. This I think preserve the
> discard semantic.

Oh. If that is the intent then there is just a bug in the handler.
I have pointed out where I believe it to be in my response to
the zone cache patch being posted.

> As for the =E2=80=9Cdiscard_zeroes_data=E2=80=9D thing, I also think that=
 is a drive
> feature not mandatory. Drives may have it or not, which is consistent
> with the ZBC/ZAC standards regarding reading after write pointer (nothing
> says that zeros have to be returned). In any case, discard of CMR zones
> will be a nop, so for SMR drives, discard_zeroes_data=3D0 may be a better
> choice.

However I am still curious about discard's being coalesced.

>>> Which is (as indicated) really slow, and easily takes several minutes.
>>> With the RB tree we can short-circuit discards to empty zones, and spee=
d
>>> up processing time dramatically.
>>> Sure we could be moving the logic into mkfs and friends, but that would
>>> require us to change the programs and agree on a library (libzbc?) whic=
h
>>> should be handling that.
>>
>> F2FS's mkfs.f2fs is already reading the zone topology via SG_IO ...
>> so I'm not sure your argument is valid here.
>
> This initial SMR support patch is just that: a first try. Jaegeuk
> used SG_IO (in fact copy-paste of parts of libzbc) because the current
> ZBC patch-set has no ioctl API for zone information manipulation. We
> will fix this mkfs.f2fs once we agree on an ioctl interface.

Which again is my point. If mkfs.f2fs wants to speed up it's
discard pass in mkfs.f2fs by _not_ sending unneccessary
Reset WP for zones that are already empty it has all the
information it needs to do so.

Here it seems to me that the zone cache is _at_best_
doing double work. At works the zone cache could be
doing the wrong thing _if_ the zone cache got out of sync.
It is certainly possible (however unlikely) that someone was
doing some raw sg activity that is not seed by the sd path.

All I am trying to do is have a discussion about the reasons for
and against have a zone cache. Where it works and where it breaks
this should be entirely technical but I understand that we have all
spent a lot of time _not_ discussing this for various non-technical
reasons.

So far the only reason I've been able to ascertain is that
Host Manged drives really don't like being stuck with the
URSWRZ and would like to have a software hack to return
MUD rather than ship drives with some weird out-of-the box
config where the last zone is marked as FINISH'd thereby
returning MUD on reads as per spec.

I understand that it would be strange state to see of first
boot and likely people would just do a ResetWP and have
weird boot errors, which would probably just make matters
worse.

I just would rather the work around be a bit cleaner and/or
use less memory. I would also like a path available that
does not require SD_ZBC or BLK_ZONED for Host Aware
drives to work, hence this set of patches and me begging
for a single bit in struct bio.

>>
>> [..]
>>
>>>>> 3) Try to condense the blkzone data structure to save memory:
>>>>> I think that we can at the very least remove the zone length, and als=
o
>>>>> may be the per zone spinlock too (a single spinlock and proper state =
flags can
>>>>> be used).
>>>>
>>>> I have a variant that is an array of descriptors that roughly mimics t=
he
>>>> api from blk-zoned.c that I did a few months ago as an example.
>>>> I should be able to update that to the current kernel + patches.
>>>>
>>> Okay. If we restrict the in-kernel SMR drive handling to devices with
>>> identical zone sizes of course we can remove the zone length.
>>> And we can do away with the per-zone spinlock and use a global one inst=
ead.
>>
>> I don't think dropping the zone length is a reasonable thing to do.

REPEAT: I do _not_ think dropping the zone length is a good thing.

>> What I propose is an array of _descriptors_ it doesn't drop _any_
>> of the zone information that you are holding in an RB tree, it is
>> just a condensed format that _mostly_ plugs into your existing
>> API.
>
> I do not agree. The Seagate drive already has one zone (the last one)
> that is not the same length as the other zones. Sure, since it is the
> last one, we can had =E2=80=9Cif (last zone)=E2=80=9D all over the place =
and make it
> work. But that is really ugly. Keeping the length field makes the code
> generic and following the standard, which has no restriction on the
> zone sizes. We could do some memory optimisation using different types
> of blk_zone sturcts, the types mapping to the SAME value: drives with
> constant zone size can use a blk_zone type without the length field,
> others use a different type that include the field. Accessor functions
> can hide the different types in the zone manipulation code.

Ah. I just said that dropping the zone length is not a good idea.
Why the antagonistic exposition?

All I am saying is that I can give you the zone cache with 1/7th of
the memory and the same performance with _no_ loss of information,
or features, as compared to the existing zone cache.

All the code is done now. I will post patches once my testing is
done.

I have also reworked all the zone integration so the BIO flags will
pull from and update the zone cache as opposed to the first hack
that only really integrated with some ioctls.

Regards,
Shaun
