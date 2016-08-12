From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 1/2] libata-scsi: use dev->max_sectors from libata-core appropriately
Date: Fri, 12 Aug 2016 22:36:23 +0800
Message-ID: <CAGnHSEn36OgegFJHzojOPYiMzfiLe6eDgSofYHGgmtmdoUQbww@mail.gmail.com>
References: <911c68378b91bf275a4bbed5717b4639641d7029.1471002480.git.tom.ty89@gmail.com>
 <f7fcf6b0-8d12-c2ae-2c51-a9071fd89f7c@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <f7fcf6b0-8d12-c2ae-2c51-a9071fd89f7c@cogentembedded.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Tejun Heo <tj@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12 August 2016 at 21:42, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> On 08/12/2016 02:56 PM, tom.ty89@gmail.com wrote:
>
>> From: Tom Yan <tom.ty89@gmail.com>
>>
>> Currently we use dev->max_sectors to set max_hw_sectors, which
>> is actually supposed to be a host controller limit (that get set
>
>
>    Gets.
>
>

Thanks, but I read too late. I'll try to bare in mind to correct that
if I'll need to send a v3 or so.

>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index be9c76c..4e2d8e7 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -1204,14 +1204,26 @@ static int ata_scsi_dev_config(struct scsi_device
>> *sdev,
>>         if (!ata_id_has_unload(dev->id))
>>                 dev->flags |= ATA_DFLAG_NO_UNLOAD;
>>
>> -       /* configure max sectors */
>> -       blk_queue_max_hw_sectors(q, dev->max_sectors);
>> -
>>         if (dev->class == ATA_DEV_ATAPI) {
>>                 void *buf;
>>
>>                 sdev->sector_size = ATA_SECT_SIZE;
>>
>> +               /*
>> +                * We are setting the limit here merely because CD/DVD
>> device does not
>> +                * have Block Limits VPD.
>> +                *
>> +                * Supposedly dev->max_sectors should be left shifted by
>> +                * (ilog2(sdev->sector_size) - 9). But since ATAPI class
>> device has a
>> +                * static logical sector size of 512 (ATA_SECT_SIZE), the
>> shift became
>> +                * unnecessary.
>> +                */
>> +               q->limits.max_dev_sectors = dev->max_sectors;
>> +               /* Make max_dev_sectors effective by adjusting max_sectors
>> accordingly,
>> +                  while leave max_hw_sectors, which is supposed to be
>> host controller
>> +                  limit, untouched. */
>
>
>    Why 2 different comment styles? The previous comment's style is actually
> preferred in the kernel.
>

I just tried to follow the styles of the existing comments. Apparently
the first style is used for multi-paragraph comments, while the other
one is used for single-paragraph one.
