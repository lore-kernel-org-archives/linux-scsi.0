From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH v2 2/2] libata-core: do not set dev->max_sectors for LBA48 devices
Date: Thu, 11 Aug 2016 17:30:59 +0800
Message-ID: <CAGnHSEn3pXR33Ju+mr0DYdE0G7kNhxNCbvocX1pZXvYfxx5+3A@mail.gmail.com>
References: <5eceeb9ad825beb87db03b0989f746dfbe0cf3fe.1470753817.git.tom.ty89@gmail.com>
 <10c4d38005e24bb477b5182d4fc17879139f14d9.1470753817.git.tom.ty89@gmail.com>
 <20160810041042.GH25053@mtj.duckdns.org> <CAGnHSE=z78AjDC13XKk_WnkQcjFHWGcatciwoJJYW-97a0qWjQ@mail.gmail.com>
 <yq1twesq8lm.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <yq1twesq8lm.fsf@sermon.lab.mkp.net>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, jmoyer@redhat.com, axboe@fb.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
List-Id: linux-scsi@vger.kernel.org

On 11 August 2016 at 11:37, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:
>
> I don't agree with conflating the optimal transfer size and the maximum
> supported ditto. Submitting the largest possible I/O to a device does
> not guarantee that you get the best overall performance.
>
>  - max_hw_sectors is gated by controller DMA constraints.
>
>  - max_dev_sectors is set for devices that explicitly report a transfer
>    length limit.
>
>  - max_sectors, the soft limit for filesystem read/write requests,
>    should be left at BLK_DEF_MAX_SECTORS unless the device explicitly
>    requests transfers to be aligned multiples of a different value
>    (typically the internal stripe size in large arrays).

Shouldn't we use Maximum Transfer Length to derive max_sectors (and
get rid of the almost useless max_dev_sectors)? Honestly it looks
pretty non-sensical to me that the SCSI disk driver uses Optimal
Transfer Length for max_sectors. Also in libata's case, this make
setting the effective max_sectors (e.g. see ATA_HORKAGE_MAX_SEC_LBA48)
impossible if we do not want to touch io_opt.

It would look to me that our block layer simply have a flawed design
if we really need to derive both io_opt and max_sectors from the same
field.

>
> The point of BLK_DEF_MAX_SECTORS is to offer a reasonable default for
> common workloads unless otherwise instructed by the storage device.
>
> We can have a discussion about what the right value for
> BLK_DEF_MAX_SECTORS should be. It has gone up over time but it used to
> be the case that permitting large transfers significantly impacted
> interactive I/O performance. And finding a sweet spot that works for a
> wide variety of hardware, interconnects and workloads is obviously
> non-trivial.
>

If BLK_DEF_MAX_SECTORS is supposed to be used as a fallback, then it
should be a safe value, especially when max_sectors_kb can be adjusted
through sysfs.

But the biggest problem isn't on bumping it, but the value picked is
totally irrational for a general default. I mean, given that it was
1024 (512k), try to double it? Fine. Try to quadruple it? Alright.
We'll need to deal with some alignment / boundary issue (like the
typical 65535 vs 65536 case)? Okay let's do it. But what's the sense
in picking a random RAID configuartion as the base to decide the
default? Also, if max_sectors need to concern about the number of
disks used and chunk sizes in a RAID configuartion, it should be
calculated in the device-mapper layer or a specific driver or so.
Changing a block layer default won't help anyway. Say 2560 will
accomodate a 10-disk 128k-chunk RAID. What about a 12-disk 128k-chunk
RAID then? Why not just decide the value base on an 8-disk 128k-chunk
RAID, which HAPPENED to be a double of 1024 as well?

It does not make sense that the SCSI disk driver uses it as the
fallback either. SCSI host templates that does not have max_sectors
set (as well as some specific driver) will use
SCSI_DEFAULT_MAX_SECTORS as the fallback, for such hosts
max_hw_sectors will be 1024, where the current BLK_DEF_MAX_SECTORS
cannot apply as max_sectors anyway. So we should use also
SCSI_DEFAULT_MAX_SECTORS in the SCSI disk driver as fallback for
max_sectors. If the value is considered to low even as a safe
fallback, then it should be bumped appropriately. (Or we might want to
replace it with BLK_DEF_MAX_SECTORS everywhere in the SCSI layer, that
said, after the value is fixed.)

> --
> Martin K. Petersen      Oracle Linux Engineering
