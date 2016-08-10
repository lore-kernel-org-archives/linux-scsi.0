From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH v2 2/2] libata-core: do not set dev->max_sectors for LBA48 devices
Date: Wed, 10 Aug 2016 16:32:39 +0800
Message-ID: <CAGnHSE=z78AjDC13XKk_WnkQcjFHWGcatciwoJJYW-97a0qWjQ@mail.gmail.com>
References: <5eceeb9ad825beb87db03b0989f746dfbe0cf3fe.1470753817.git.tom.ty89@gmail.com>
 <10c4d38005e24bb477b5182d4fc17879139f14d9.1470753817.git.tom.ty89@gmail.com> <20160810041042.GH25053@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33081 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023AbcHJVEE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2016 17:04:04 -0400
In-Reply-To: <20160810041042.GH25053@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, jmoyer@redhat.com, axboe@fb.com, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

I have to admit that libata may not be the right place to deal with my
concern over the current BLK_DEF_MAX_SECTORS, which seems non-sensical
to me. In the original commit message:

(d2be537c3ba3, "block: bump BLK_DEF_MAX_SECTORS to 2560")
"A value of 2560 (1280k) will accommodate a 10-data-disk stripe write
with chunk size 128k...a value of 1280 does not show a big performance
difference from 512, but will hopefully help software RAID setups
using SATA disks, as reported by Christoph."

So I have no idea at all why the bump was allowed. What so special
about "10-data-disk stripe write with chunk size 128k", that we would
want to make a block layer general default base on that?

The macro appeared to be used by the aoeblk driver only. Yet since a
later commit (ca369d51b3e1, "block/sd: Fix device-imposed transfer
length limits"), the scsi disk driver will use it to set the effective
max_sectors(_kb) for devices that does not report Optimal Transfer
Length in the Block Limit VPD (which is the case of libata's SATL).

So the consequence is, ATA drives with max_hw_sectors(_kb) (i.e.
dev->max_sectors set in libata-core.c) set to higher than
BLK_DEF_MAX_SECTORS will end up having it as the effective
max_sectors. Not only the value is non-sensical, but also the logic.
(Btw, ATA_HORKAGE_MAX_SEC_LBA48 will sort of become ineffective
because of this.)

Now let's just come back to libata. I've thought of reporting
dev->max_sectors as Optimal Transfer Length in the SATL. However, I am
not sure if it is a safe thing to do, because we set it as high as
65535 for devices with LBA48 devices. Does such a high max_sectors
ever make sense in libata's case?

That's why I took the approach of the USB Attached SCSI driver. That
is, we only explicitly set max_hw_sectors in cases that is strictly
necessary (e.g. no LBA48 support, horkages). Otherwise we'll leave
request queue as-is.

I've also thought of reporting dev->max_sectors as Optimal Transfer
Length but cap it at 1024, so that users will still be allowed to bump
max_sectors_kb up to 32767 kb, but we'll always start at 512 kb or
less. But this approach have a side-effect that I find ugly, that is
the block layer limit "io_opt" could be set to a value that is not
max_hw_sectors(_kb). I have also no idea about the consequence of
having io_opt set.

On 10 August 2016 at 12:10, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Aug 09, 2016 at 10:45:47PM +0800, tom.ty89@gmail.com wrote:
>> From: Tom Yan <tom.ty89@gmail.com>
>>
>> Currently block layer limit max_hw_sectors is set to
>> ATA_MAX_SECTORS_LBA48 (65535), for devices with LBA48 support.
>>
>> However, block layer limit max_sectors (which is the effective
>> one; also adjustable, upper-bounded by max_hw_sectors) is set to
>> BLK_DEF_MAX_SECTORS (currently 2560) by the scsi disk driver,
>> since libata's SATL does not report an Optimal Transfer Length.
>>
>> This does not make much sense, especially when the current
>> BLK_DEF_MAX_SECTORS appears to be unsafe for some ATA devices
>> (see ATA_HORKAGE_MAX_SEC_1024). Truth is, the current value
>> appears to be arbitrary anyway. See commit d2be537c3ba3
>> ("block: bump BLK_DEF_MAX_SECTORS to 2560").
>>
>> Therefore, avoid setting dev->max_sectors when it is strictly
>> necessary. Leave it as 0 otherwise, so that both block layer
>> limits will remain as SCSI_DEFAULT_MAX_SECTORS (currently 1024).
>
> These changes feel rather gratuitous.  What's the upside here?
>
> Thanks.
>
> --
> tejun
