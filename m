From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/9] block: update chunk_sectors in blk_stack_limits()
Date: Fri, 15 Apr 2016 08:05:47 +0200
Message-ID: <571084BB.4020006@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-3-git-send-email-hare@suse.de>
 <571062E0.2010208@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbcDOGFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 02:05:49 -0400
In-Reply-To: <571062E0.2010208@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 04/15/2016 05:41 AM, Bart Van Assche wrote:
> On 04/04/16 03:00, Hannes Reinecke wrote:
>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>> index c7bb666..29fa900 100644
>> --- a/block/blk-settings.c
>> +++ b/block/blk-settings.c
>> @@ -630,6 +630,9 @@ int blk_stack_limits(struct queue_limits *t,
>> struct queue_limits *b,
>>               t->discard_granularity;
>>       }
>>
>> +    if (b->chunk_sectors)
>> +        t->chunk_sectors =3D max(t->chunk_sectors, b->chunk_sectors=
);
>> +
>>       return ret;
>>   }
>>   EXPORT_SYMBOL(blk_stack_limits);
>=20
> Hello Hannes,
>=20
> My understanding is that a non-zero chunk_sectors value defines a
> maximum I/O size. Shouldn't max() be changed into min_not_zero()?
> From include/linux/blkdev.h:
>=20
> static inline unsigned int blk_max_size_offset(struct request_queue *=
q,
>                            sector_t offset)
> {
>     if (!q->limits.chunk_sectors)
>         return q->limits.max_sectors;
>=20
>     return q->limits.chunk_sectors -
>             (offset & (q->limits.chunk_sectors - 1));
> }
>=20
Hmm.

_Actually_ it should be the least common denominator, me thinks...
Have to think it through a bit more.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
