From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v8 1/2 RESEND] Add bio/request flags to issue ZBC/ZAC commands
Date: Fri, 26 Aug 2016 00:17:48 -0500
Message-ID: <CAJVOszANdQBrXvpuv1=HCcd2gvZ0jsxyFwAG8HJ=JUFhWodb8Q@mail.gmail.com>
References: <20160822042010.32416-2-shaun@tancheff.com> <20160824202409.30345-1-shaun@tancheff.com>
 <5b710eda-6445-f42a-72f0-4a1bf843d501@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:37701 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750795AbcHZFYQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 01:24:16 -0400
Received: from pps.filterd (m0075550.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u7Q5K4fI026725
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2016 01:24:16 -0400
Received: from mail-yw0-f200.google.com (mail-yw0-f200.google.com [209.85.161.200])
        by mx0a-00003501.pphosted.com with ESMTP id 2529sw1b70-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2016 01:24:15 -0400
Received: by mail-yw0-f200.google.com with SMTP id f123so122890604ywd.2
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2016 22:24:15 -0700 (PDT)
In-Reply-To: <5b710eda-6445-f42a-72f0-4a1bf843d501@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, "David S . Miller" <davem@davemloft.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Guenter Roeck <linux@roeck-us.net>, Ming Lei <ming.lei@canonical.com>, Mike Christie <michaelc@cs.wisc.edu>, Keith Busch <keith.busch@intel.com>, Mike Snitzer <snitzer@redhat>

On Thu, Aug 25, 2016 at 9:31 PM, Damien Le Moal <damien.lemoal@hgst.com> wrote:
>
> Shaun,
>
> On 8/25/16 05:24, Shaun Tancheff wrote:
>>
>> (RESENDING to include f2fs, fs-devel and dm-devel)
>>
>> Add op flags to access to zone information as well as open, close
>> and reset zones:
>>   - REQ_OP_ZONE_REPORT - Query zone information (Report zones)
>>   - REQ_OP_ZONE_OPEN - Explicitly open a zone for writing
>>   - REQ_OP_ZONE_CLOSE - Explicitly close a zone
>>   - REQ_OP_ZONE_FINISH - Explicitly finish a zone
>>   - REQ_OP_ZONE_RESET - Reset Write Pointer to start of zone
>>
>> These op flags can be used to create bio's to control zoned devices
>> through the block layer.
>
>
> I still have a hard time seeing the need for the REQ_OP_ZONE_REPORT
> operation assuming that the device queue will hold a zone information cache,
> Hannes RB-tree or your array type, whichever.
>
> Let's try to think simply here: if the disk user (and FS, a device mapper or
> an application doing raw disk accesses) wants to access the disk zone
> information, why would it need to issue a BIO when calling
> blkdev_lookup_zone would exactly give that information straight out of
> memory (so much faster) ? I thought hard about this, but cannot think of any
> value for the BIO-to-disk option. It seems to me to be equivalent to
> systematically doing a page cache read even if the page cache tells us that
> the page is up-to-date...

Firstly the BIO abstraction here gives a common interface to
getting the zone information and works even for embedded
systems that are not willing / convinced to enable
SCSI_ZBC + BLK_ZONED.

Secondly when SCSI_ZBC + BLK_ZONED are enabled it just
returns from the zone cache [as you can hopefully find
in the second half of this series]. I did add a 'force' option
but it's not intended to be used lightly.

Thirdly it is my belief that BIO abstraction is more easily
adapted to working with [and through] the device mapper
layer (s).

Today we both have the issue where if a file system
supports working with a ZBC device there can be no
device mapper stacked between the file system and
the actual zoned device. This is also true of our respective
device mapper targets.

It is my current belief that teaching the device mapper
layer to include REQ_OP_ZONE* operations is relatively
straight forward and can be done w/o affecting existing
targets that don't specifically need to operate on zones.
Something similar to the way flush is handled currently.
If the target doesn't ask to see zone operations the default
mapping rules apply.

Examples of why I would like to add REQ_OP_ZONE*
support to the device mapper:

I think it would be really neat if I could just to a quick
dm-linear and put big chunk of SSD in front of dm-zoned
or dm-zdm as it would be a nice way to boost performance.

Similarly it enable using dm-linear to stitch together enough
conventional space with a ZBC drive to see if Dave Chinner's
XFS proposal from a couple of years ago could work.

> Moreover, issuing a report zone to the disk may return information that is
> in fact incorrect, as that would not take into account the eventual set of
> write requests that was dispatched but not yet processed by the disk (some
> zone write pointer may be reported with a value lower than what the zone
> cache maintains).

Yes but issuing a zone report to media is not the expected path
when the zone cache is available. It is there to 'force' a re-sync
and it is intended that the user of the call knows that the force
is being applied and wants it to happen. Perhaps I should make
it two flags? One to force a reply form the device and second
flag to re-sync the zone cache with the result? There is one
piece of information that can only be retrieved by going to the
device and that is the 'non-seq resources' flag and it is only
used by Host Aware devices ... as far as I understand.

> Dealing (and fixing) these inconsistencies would force an update of the
> report zone result using the information of the zone cache, which in itself
> sounds like a good justification of not doing a report zones in the first
> place.

When report zones is just pulling from the zone cache it should
not be a problem. So the normal activity [when SCSI_ZBC +
BLK_ZONED are enabled] should not be introducing any
inconsistencies.

> I am fine with the other operations, and in fact having a BIO interface for
> them to send down to the SCSI layer is better than any other method. It will
> causes them to be seen in sd_init_command, which is the path taken for read
> and write commands too. So all zone cache information checking and updating
> can be done in that single place and serialized with a spinlock. Maintenance
> of the zone cache information becomes very easy.
>
> Any divergence of the zone cache information with the actual state of the
> disk will likely cause an error (unaligned write or other). Having a
> specific report zone BIO option will not help the disk user recover from
> those. Hannes current implementation make sure that the information of the
> zone for the failed request is automatically updated. That is enough to
> maintain the zone cache information uptodate, and a zone information can be
> marked as "in update" for the user to notice and wait for the refreshed
> information.

Which is why the zone cache is consider the default authority .. when it
is available.

Hopefully you will find this use case more compelling:

User issues:
   # sg_reset_wp --all /dev/sdz
User then proceeds to run:
   # mkfs.f2fs -m /dev/sdz

Now quite possibly the zone information is 'out of sync' because the user
used a ZBC command that we to catch in the zone cache.

Now if mkfs.f2fs does a reports zones with a force it will fix the
zone cache and everything goes nice and quick.

Since the output of report zones is the same format as the
ZBC spec [and therefore SG_IO] it should be a stright forward
change in mkfs.f2fs to call BLKREPORT instead of via SG_IO.

> The ioctl code for reporting zones does not need the specific request op
> code either. Again, blkdev_lookup_zone can provide zone information, and an
> emulation of the reporting options filtering is also trivial to implement on
> top of that, if really required (I do not think that is strongly needed
> though).
>
> Without the report zone operation, your patch set size would significantly
> shrink and merging with Hannes work becomes very easy too.
>
> Please let me know what you think. If we drop this, we can get a clean and
> full ZBC support patch set ready in no time at all.

-- 
Regards,
Shaun Tancheff
