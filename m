From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] sd: configure ZBC devices
Date: Sat, 16 Apr 2016 13:24:14 +0200
Message-ID: <571220DE.2050900@suse.de>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-4-git-send-email-hare@suse.de>
 <57110D11.2010201@sandisk.com> <57112C6F.4090602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbcDPLYT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Apr 2016 07:24:19 -0400
In-Reply-To: <57112C6F.4090602@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 04/15/2016 08:01 PM, Hannes Reinecke wrote:
> On 04/15/2016 05:47 PM, Bart Van Assche wrote:
>> On 04/04/2016 03:00 AM, Hannes Reinecke wrote:
>>> +static int
>>> +sd_zbc_report_zones(struct scsi_disk *sdkp, sector_t start_lba,
>>> +            unsigned char *buffer, int bufflen )
>>> +{
>>> [ ... ]
>>> +    put_unaligned_be64(start_lba, &cmd[2]);
>>> +    put_unaligned_be32(bufflen, &cmd[10]);
>>
>> The argument "sector_t start_lba" is confusing me. Isn't a number ei=
ther
>> a sector number or an LBA? Shouldn't that number be shifted right by
>> ilog2(sdp->sector_size) - 9 before storing it in the CDB?
>>
> Well. I've considered the 'lba' the native disk lba, and sector the
> (logical) sector number from the block layer.
> I was under the impression that this was the correct nomenclature her=
e;
> if not I'm happy to change it.
>
> But yes, I should be adding a documentation to that function.
>
I've changed sd_zbc_report_zones() to use the sector number,
not the LBA. And added some documentation clarifying that.

Thanks for the review.

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
