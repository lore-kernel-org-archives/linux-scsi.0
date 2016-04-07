From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/9] block: Add 'zoned' sysfs queue attribute
Date: Thu, 7 Apr 2016 07:57:36 +0200
Message-ID: <5705F6D0.70604@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-7-git-send-email-hare@suse.de>
 <CC35A7E7-DF48-49F9-ABCF-B93A5B95DC99@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbcDGF5k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2016 01:57:40 -0400
In-Reply-To: <CC35A7E7-DF48-49F9-ABCF-B93A5B95DC99@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@hgst.com>, Jens Axboe <axboe@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/07/2016 03:56 AM, Damien Le Moal wrote:
>=20
> Hannes,
>=20
>> Add a sysfs queue attribute 'zoned' to display the zone layout
>> for zoned devices.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>> block/blk-sysfs.c | 47 +++++++++++++++++++++++++++++++++++++++++++++=
++
>> 1 file changed, 47 insertions(+)
>>
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>> index ff97091..748bb27 100644
>> --- a/block/blk-sysfs.c
>> +++ b/block/blk-sysfs.c
>> @@ -244,6 +244,43 @@ static ssize_t queue_max_hw_sectors_show(struct=
 request_queue *q, char *page)
>> 	return queue_var_show(max_hw_sectors_kb, (page));
>> }
>>
>> +#ifdef CONFIG_BLK_DEV_ZONED
>> +static ssize_t queue_zoned_show(struct request_queue *q, char *page=
)
>> +{
>> +	struct rb_node *node;
>> +	struct blk_zone *zone;
>> +	ssize_t offset =3D 0, end =3D 0;
>> +	size_t size =3D 0, num =3D 0;
>> +	enum blk_zone_type type =3D BLK_ZONE_TYPE_UNKNOWN;
>> +
>> +	for (node =3D rb_first(&q->zones); node; node =3D rb_next(node)) {
>> +		zone =3D rb_entry(node, struct blk_zone, node);
>> +		if (zone->type !=3D type ||
>> +		    zone->len !=3D size ||
>> +		    end !=3D zone->start) {
>> +			if (size !=3D 0)
>> +				offset +=3D sprintf(page + offset, "%zu\n", num);
>> +			/* We can only store one page ... */
>> +			if (offset + 42 > PAGE_SIZE) {
>> +				offset +=3D sprintf(page + offset, "...\n");
>> +				return offset;
>> +			}
>> +			size =3D zone->len;
>> +			type =3D zone->type;
>> +			offset +=3D sprintf(page + offset, "%zu %zu %d ",
>> +					  zone->start, size, type);
>> +			num =3D 0;
>> +			end =3D zone->start + size;
>> +		} else
>> +			end +=3D zone->len;
>> +		num++;
>> +	}
>> +	if (num > 0)
>> +		offset +=3D sprintf(page + offset, "%zu\n", num);
>> +	return offset > 0 ? offset : -EINVAL;
>> +}
>> +#endif
>=20
> With this, an application reading the =E2=80=9Czoned=E2=80=9D file fo=
r a non-SMR disk
> will get a -EINVAL error. Not really super nice. Could we just have t=
he
> zoned files contain a single =E2=80=9C0=E2=80=9D for non-SMR disks ? =
Or at least have the
> file empty and read return 0 Bytes. That would allow applications to =
easily
> and cleanly detect if they are dealing with a SMR disk (or not) inste=
ad of
> assuming that =E2=80=9C-EINVAL=E2=80=9D means =E2=80=9Cnot SMR=E2=80=9D=
, which seems very ugly to me.
>=20
Sure.

Actually I was looking in blanking out this attribute entirely like
I did with the SCSI sysfs attributes, but as the 'queue' sysfs
directory is a blank kobj it's not easily done.
But yes, '0' seems like a reasonable value here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
