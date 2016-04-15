From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/9] blk-sysfs: Add 'chunk_sectors' to sysfs attributes
Date: Fri, 15 Apr 2016 08:01:11 +0200
Message-ID: <571083A7.80009@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-2-git-send-email-hare@suse.de>
 <570FEAF8.7060606@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbcDOGBP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 02:01:15 -0400
In-Reply-To: <570FEAF8.7060606@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/14/2016 09:09 PM, Bart Van Assche wrote:
> On 04/04/2016 03:00 AM, Hannes Reinecke wrote:
>> The queue limits already have a 'chunk_sectors' setting, so
>> we should be presenting it via sysfs.
>=20
> This patch does more than exporting chunk_sectors via sysfs. It also
> makes that parameter configurable. Please mention this in the patch
> description.
>=20
> My understanding of the block drivers that call
> blk_queue_chunk_sectors() is that increasing the chunk_sectors
> parameter will break these drivers. I think the single
> queue_limits.chunk_sectors parameter needs to be converted into two
> parameters:
> - The value set by the block driver by calling
>   blk_queue_chunk_sectors().
> - The value configured from user space through sysfs.
>=20
> This will allow to ensure that the chunk_sectors parameter can be
> increased from user space and also that it cannot be decreased.
>=20
>> +static ssize_t
>> +queue_chunk_sectors_store(struct request_queue *q, const char
>> *page, size_t count)
>> +{
>> +    unsigned long chunk_sectors;
>> +
>> +    ssize_t ret =3D queue_var_store(&chunk_sectors, page, count);
>> +    if (ret < 0)
>> +        return ret;
>> +    spin_lock_irq(q->queue_lock);
>> +    blk_queue_chunk_sectors(q, chunk_sectors);
>> +    spin_unlock_irq(q->queue_lock);
>> +
>> +    return ret;
>> +}
>=20
> In blk_queue_chunk_sectors() I found the following:
>=20
>     BUG_ON(!is_power_of_2(chunk_sectors));
>=20
> Please make sure that this BUG_ON() cannot be triggered from user
> space.
>=20
> Additionally, an update for Documentation/block/queue-sysfs.txt is
> missing from this patch.
>=20

Ah, right.
Actually, making the sysfs attribute writeable is a leftover from
the original (debugging) patchset, so I'll be removing it from the
next iteration of this patchset.

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
