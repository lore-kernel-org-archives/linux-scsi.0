From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 1/2] libata-scsi: use dev->max_sectors from libata-core
 appropriately
Date: Sat, 13 Aug 2016 13:10:15 +0300
Message-ID: <e5daafbb-e0f4-94fa-6edf-8ba0c9cced88@cogentembedded.com>
References: <911c68378b91bf275a4bbed5717b4639641d7029.1471002480.git.tom.ty89@gmail.com>
 <f7fcf6b0-8d12-c2ae-2c51-a9071fd89f7c@cogentembedded.com>
 <CAGnHSEn36OgegFJHzojOPYiMzfiLe6eDgSofYHGgmtmdoUQbww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAGnHSEn36OgegFJHzojOPYiMzfiLe6eDgSofYHGgmtmdoUQbww@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 8/12/2016 5:36 PM, Tom Yan wrote:

>>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>>> index be9c76c..4e2d8e7 100644
>>> --- a/drivers/ata/libata-scsi.c
>>> +++ b/drivers/ata/libata-scsi.c
>>> @@ -1204,14 +1204,26 @@ static int ata_scsi_dev_config(struct scsi_device
>>> *sdev,
>>>         if (!ata_id_has_unload(dev->id))
>>>                 dev->flags |= ATA_DFLAG_NO_UNLOAD;
>>>
>>> -       /* configure max sectors */
>>> -       blk_queue_max_hw_sectors(q, dev->max_sectors);
>>> -
>>>         if (dev->class == ATA_DEV_ATAPI) {
>>>                 void *buf;
>>>
>>>                 sdev->sector_size = ATA_SECT_SIZE;
>>>
>>> +               /*
>>> +                * We are setting the limit here merely because CD/DVD
>>> device does not
>>> +                * have Block Limits VPD.
>>> +                *
>>> +                * Supposedly dev->max_sectors should be left shifted by
>>> +                * (ilog2(sdev->sector_size) - 9). But since ATAPI class
>>> device has a
>>> +                * static logical sector size of 512 (ATA_SECT_SIZE), the
>>> shift became
>>> +                * unnecessary.
>>> +                */
>>> +               q->limits.max_dev_sectors = dev->max_sectors;
>>> +               /* Make max_dev_sectors effective by adjusting max_sectors
>>> accordingly,
>>> +                  while leave max_hw_sectors, which is supposed to be
>>> host controller
>>> +                  limit, untouched. */
>>
>>
>>    Why 2 different comment styles? The previous comment's style is actually
>> preferred in the kernel.
>>
>
> I just tried to follow the styles of the existing comments. Apparently
> the first style is used for multi-paragraph comments, while the other
> one is used for single-paragraph one.

    Nevertheless, only the 1st comment is formatted in the preferred manner; 
see Documentation/CodingStyle, chapter 8.

MBR, Sergei

