From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] libata-core: do not set dev->max_sectors for
 LBA48 devices
Date: Wed, 10 Aug 2016 11:22:41 -0400
Message-ID: <20160810152241.GJ25053@mtj.duckdns.org>
References: <5eceeb9ad825beb87db03b0989f746dfbe0cf3fe.1470753817.git.tom.ty89@gmail.com>
 <10c4d38005e24bb477b5182d4fc17879139f14d9.1470753817.git.tom.ty89@gmail.com>
 <20160810041042.GH25053@mtj.duckdns.org>
 <CAGnHSE=z78AjDC13XKk_WnkQcjFHWGcatciwoJJYW-97a0qWjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGnHSE=z78AjDC13XKk_WnkQcjFHWGcatciwoJJYW-97a0qWjQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: jmoyer@redhat.com, axboe@fb.com, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Tom.

On Wed, Aug 10, 2016 at 04:32:39PM +0800, Tom Yan wrote:
> I have to admit that libata may not be the right place to deal with my
> concern over the current BLK_DEF_MAX_SECTORS, which seems non-sensical
> to me. In the original commit message:
> 
> (d2be537c3ba3, "block: bump BLK_DEF_MAX_SECTORS to 2560")
> "A value of 2560 (1280k) will accommodate a 10-data-disk stripe write
> with chunk size 128k...a value of 1280 does not show a big performance
> difference from 512, but will hopefully help software RAID setups
> using SATA disks, as reported by Christoph."
> 
> So I have no idea at all why the bump was allowed. What so special

In general, people are okay with upping the limits as long as there
are actual use cases which can benefit.  The devices are getting
constantly faster and the hardware limits are going up along with it
after all.

> about "10-data-disk stripe write with chunk size 128k", that we would
> want to make a block layer general default base on that?

It's not special.  It's just an actual use case which can benefit from
the raised limit.

> The macro appeared to be used by the aoeblk driver only. Yet since a
> later commit (ca369d51b3e1, "block/sd: Fix device-imposed transfer
> length limits"), the scsi disk driver will use it to set the effective
> max_sectors(_kb) for devices that does not report Optimal Transfer
> Length in the Block Limit VPD (which is the case of libata's SATL).
>
> So the consequence is, ATA drives with max_hw_sectors(_kb) (i.e.
> dev->max_sectors set in libata-core.c) set to higher than
> BLK_DEF_MAX_SECTORS will end up having it as the effective
> max_sectors. Not only the value is non-sensical, but also the logic.
> (Btw, ATA_HORKAGE_MAX_SEC_LBA48 will sort of become ineffective
> because of this.)
>
> Now let's just come back to libata. I've thought of reporting
> dev->max_sectors as Optimal Transfer Length in the SATL. However, I am
> not sure if it is a safe thing to do, because we set it as high as
> 65535 for devices with LBA48 devices. Does such a high max_sectors
> ever make sense in libata's case?

libata is just exposing whatever the underlying hardware supports.
Whether that should be exposed as optimal transfer length is a
different matter.

> That's why I took the approach of the USB Attached SCSI driver. That
> is, we only explicitly set max_hw_sectors in cases that is strictly
> necessary (e.g. no LBA48 support, horkages). Otherwise we'll leave
> request queue as-is.

I see.  Alright, let's do that.  Can you please respin the patch with
more detailed description?

Thanks.

-- 
tejun
