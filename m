From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] sd: remove redundant check for BLK_DEF_MAX_SECTORS
Date: Sun, 5 Jun 2016 13:16:09 +0800
Message-ID: <CAGnHSEn0eLwjTc0NTAhsWJr47FdA_93bpR=tBZnw48=NDsCyRw@mail.gmail.com>
References: <1465012678-32547-1-git-send-email-longli@microsoft.com>
 <CAGnHSE=ZriFjvdXT5npv92VhqxtN1SqQL+jwMehCq42K3O+=VQ@mail.gmail.com> <BLUPR0301MB19724E7E002D1E47719D262CCE5A0@BLUPR0301MB1972.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BLUPR0301MB19724E7E002D1E47719D262CCE5A0@BLUPR0301MB1972.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Never mind. I misread. I thought q->limits.max_sectors = min(rw_max,
queue_max_hw_sectors(q)); can be run when rw_max is not set.

On 4 June 2016 at 23:18, Long Li <longli@microsoft.com> wrote:
> Sorry, "redundant check" is not the best word to describe this patch.
>
> The result of this patch is that:
> 1. if opt_xfer_blocks has a valid value (returned form VPD BLOCK LIMITS), use it to set max_sectors
> 2. if opt_xfer_blocks doesn't have a valid value, leave max_sectors unchanged
>
> The reason is that, max_sectors already has value at this point, the default value is SCSI_DEFAULT_MAX_SECTORS (include/scsi/scsi_host.h). The lower layer host driver can change this value in its template. I think the drivers care about this value have already set it. So it's better not to change it again. If they want max_sectors to be set by sd, they can use BLOCK LIMITS VPD to tell it to do so.
>
>
>> -----Original Message-----
>> From: Tom Yan [mailto:tom.ty89@gmail.com]
>> Sent: Saturday, June 4, 2016 1:41 AM
>> To: Long Li <longli@microsoft.com>
>> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen
>> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH] sd: remove redundant check for
>> BLK_DEF_MAX_SECTORS
>>
>> The main point there is not to check q->limits.max_sectors against
>> BLK_DEF_MAX_SECTORS, but sdkp->opt_xfer_blocks against
>> SD_DEF_XFER_BLOCKS et al.? `rw_max = BLK_DEF_MAX_SECTORS;` there is
>> merely the fallback when sdkp->opt_xfer_blocks does not pass the
>> conditions. With your patch `rw_max` can be indeterminate in those
>> circumstances.
>>
>> On 4 June 2016 at 11:57, Long Li <longli@microsoft.com> wrote:
>> > q->limits.max_sectors is already checked against BLK_DEF_MAX_SECTORS
>> in __scsi_alloc_queue(), when it calls blk_queue_max_hw_sectors(). There
>> is no need to check it again in sd.
>> >
>> > This change also allows a SCSI driver set an maximum sector size bigger
>> than BLK_DEF_MAX_SECTORS, without returning values on optional VPD
>> page 0xb0 "Block Limits".
>> >
>> > Signed-off-by: Long Li <longli@microsoft.com>
>> >
>> > ---
>> >  drivers/scsi/sd.c | 7 ++-----
>> >  1 file changed, 2 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c index
>> > 60bff78..d8c4047 100644
>> > --- a/drivers/scsi/sd.c
>> > +++ b/drivers/scsi/sd.c
>> > @@ -2870,11 +2870,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
>> >             logical_to_bytes(sdp, sdkp->opt_xfer_blocks) >= PAGE_SIZE) {
>> >                 q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
>> >                 rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
>> > -       } else
>> > -               rw_max = BLK_DEF_MAX_SECTORS;
>> > -
>> > -       /* Combine with controller limits */
>> > -       q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
>> > +               q->limits.max_sectors = min(rw_max,
>> queue_max_hw_sectors(q));
>> > +       }
>> >
>> >         set_capacity(disk, logical_to_sectors(sdp, sdkp->capacity));
>> >         sd_config_write_same(sdkp);
>> > --
>> > 2.7.4
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> > in the body of a message to majordomo@vger.kernel.org More
>> majordomo
>> > info at
>> > https://na01.safelinks.protection.outlook.com/?url=http%3a%2f%2fvger.k
>> > ernel.org%2fmajordomo-
>> info.html&data=01%7c01%7clongli%40microsoft.com%
>> >
>> 7ce142128958ec47629dbe08d38c540306%7c72f988bf86f141af91ab2d7cd011d
>> b47%
>> > 7c1&sdata=EjjF86cvJqaxOAOWnN0%2f3Qln05qcquwe%2fKA7DgEjtcI%3d
