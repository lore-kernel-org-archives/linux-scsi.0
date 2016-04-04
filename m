From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] libata: support device-managed ZAC devices
Date: Mon, 4 Apr 2016 16:15:28 +0200
Message-ID: <57027700.6070107@suse.de>
References: <1459763271-125856-1-git-send-email-hare@suse.de>
 <1459763271-125856-4-git-send-email-hare@suse.de>
 <57024C5D.8070402@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbcDDOPb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 10:15:31 -0400
In-Reply-To: <57024C5D.8070402@cogentembedded.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/04/2016 01:13 PM, Sergei Shtylyov wrote:
> Hello.
>=20
> On 4/4/2016 12:47 PM, Hannes Reinecke wrote:
>=20
>> Device-managed ZAC devices just set the zoned capabilities field
>> in INQUIRY byte 69 (cf ACS-4). This corresponds to the 'zoned'
>> field in the block device characteristics VPD page.
>> As this is only defined in SPC-5/SBC-4 we also need to update
>> the supported SCSI version descriptor.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/ata/libata-scsi.c | 19 ++++++++++---------
>>   include/linux/ata.h       |  5 +++++
>>   2 files changed, 15 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 6db2aaf..ff95ef6 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
> [...]
>> @@ -2316,12 +2314,15 @@ static unsigned int
>> ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
>>   {
>>       int form_factor =3D ata_id_form_factor(args->id);
>>       int media_rotation_rate =3D ata_id_rotation_rate(args->id);
>> +    u8 zoned =3D ata_id_zoned_cap(args->id);
>>
>>       rbuf[1] =3D 0xb1;
>>       rbuf[3] =3D 0x3c;
>>       rbuf[4] =3D media_rotation_rate >> 8;
>>       rbuf[5] =3D media_rotation_rate;
>>       rbuf[7] =3D form_factor;
>> +    if (zoned)
>> +        rbuf[8] =3D (zoned << 4);
>=20
>    Parens not needed here.
>=20
> [...]
>=20
> MBR, Sergei
>=20
Thanks, will be fixing it up with the next round of submissions.

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
