From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/9] block: Add 'zoned' sysfs queue attribute
Date: Fri, 15 Apr 2016 20:03:10 +0200
Message-ID: <57112CDE.2080303@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-7-git-send-email-hare@suse.de>
 <571128C7.1060107@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbcDOSDR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 14:03:17 -0400
In-Reply-To: <571128C7.1060107@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/15/2016 07:45 PM, Bart Van Assche wrote:
> On 04/04/2016 03:00 AM, Hannes Reinecke wrote:
>> Add a sysfs queue attribute 'zoned' to display the zone layout
>> for zoned devices.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   block/blk-sysfs.c | 47 +++++++++++++++++++++++++++++++++++++++++++=
++++
>>   1 file changed, 47 insertions(+)
>>
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>> index ff97091..748bb27 100644
>> --- a/block/blk-sysfs.c
>> +++ b/block/blk-sysfs.c
>> @@ -244,6 +244,43 @@ static ssize_t queue_max_hw_sectors_show(struct
>> request_queue *q, char *page)
>>       return queue_var_show(max_hw_sectors_kb, (page));
>>   }
>>
>> +#ifdef CONFIG_BLK_DEV_ZONED
>> +static ssize_t queue_zoned_show(struct request_queue *q, char *page=
)
>> +{
>> +    struct rb_node *node;
>> +    struct blk_zone *zone;
>> +    ssize_t offset =3D 0, end =3D 0;
>> +    size_t size =3D 0, num =3D 0;
>> +    enum blk_zone_type type =3D BLK_ZONE_TYPE_UNKNOWN;
>> +
>> +    for (node =3D rb_first(&q->zones); node; node =3D rb_next(node)=
) {
>> +        zone =3D rb_entry(node, struct blk_zone, node);
>> +        if (zone->type !=3D type ||
>> +            zone->len !=3D size ||
>> +            end !=3D zone->start) {
>> +            if (size !=3D 0)
>> +                offset +=3D sprintf(page + offset, "%zu\n", num);
>> +            /* We can only store one page ... */
>> +            if (offset + 42 > PAGE_SIZE) {
>> +                offset +=3D sprintf(page + offset, "...\n");
>> +                return offset;
>> +            }
>> +            size =3D zone->len;
>> +            type =3D zone->type;
>> +            offset +=3D sprintf(page + offset, "%zu %zu %d ",
>> +                      zone->start, size, type);
>> +            num =3D 0;
>> +            end =3D zone->start + size;
>> +        } else
>> +            end +=3D zone->len;
>> +        num++;
>> +    }
>> +    if (num > 0)
>> +        offset +=3D sprintf(page + offset, "%zu\n", num);
>> +    return offset > 0 ? offset : -EINVAL;
>> +}
>> +#endif
>> +
>>   #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)                \
>>   static ssize_t                                \
>>   queue_show_##name(struct request_queue *q, char *page)            =
\
>> @@ -468,6 +505,13 @@ static struct queue_sysfs_entry
>> queue_write_same_max_entry =3D {
>>       .show =3D queue_write_same_max_show,
>>   };
>>
>> +#ifdef CONFIG_BLK_DEV_ZONED
>> +static struct queue_sysfs_entry queue_zoned_entry =3D {
>> +    .attr =3D {.name =3D "zoned", .mode =3D S_IRUGO },
>> +    .show =3D queue_zoned_show,
>> +};
>> +#endif
>> +
>
> Hello Hannes,
>
> Have you considered to move the above definitions into a new file? Th=
at
> would allow to avoid two #ifdefs and to move the code that decides
> whether or not the above code gets built into block/Makefile.
>
Well, it's just these few lines, so I thought it easier to put it into=20
the existing file.
But sure I can add a separate files for that.

> Additionally, have you considered to create one sysfs directory per z=
one
> instead of one sysfs attribute with all zone information? From
> Documentation/filesystems/sysfs.txt: "Attributes should be ASCII text
> files, preferably with only one value per file."
>
Yes, I have considered it.
But doing so would require me to add about 20k sysfs attributes.
=46or no apparent gain.
So I've settled on this condensed approach here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
