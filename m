From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 2/2] libata-scsi: do not return t10 designator if drive
 has WWN
Date: Thu, 7 Jul 2016 20:40:29 +0800
Message-ID: <CAGnHSEnxFdSKzzhqMKUkFeaOH02M2E8sTo9H28eFRbv48QyUng@mail.gmail.com>
References: <577d824d.a10c420a.da50c.ffff9544@mx.google.com> <577E356E.9050209@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33765 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbcGGMkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2016 08:40:31 -0400
In-Reply-To: <577E356E.9050209@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Well, udev uses its own `ata_id` (which issues IDENTIFY DEVICE through
ATA PASS-THROUGH) though.

Anyway I expected the reasoning you gave and I can't really argue with
you. It's just personally I still prefer a cleaner SATL implementation
(considering Linux is open source and can be deemed as some sort of
reference), so I gave it a go.

Not that SAT requires the DI VPD return only one desingator / LU name t=
hough.

On 7 July 2016 at 18:56, Hannes Reinecke <hare@suse.de> wrote:
> On 07/07/2016 12:12 AM, tom.ty89@gmail.com wrote:
>> From: Tom Yan <tom.ty89@gmail.com>
>>
>> SAT (as of sat4r05f.pdf) only requires the t10 designator if the
>> drive does not support/have WWN. Besides, we already have the ATA
>> information VPD.
>>
>> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 9f478ad..84b3d42 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -2210,21 +2210,6 @@ static unsigned int ata_scsiop_inq_83(struct =
ata_scsi_args *args, u8 *rbuf)
>>       rbuf[1] =3D 0x83;                 /* this page code */
>>       num =3D 4;
>>
>> -     /* SAT defined lu model and serial numbers descriptor */
>> -     /* piv=3D0, assoc=3Dlu, code_set=3DACSII, designator=3Dt10 ven=
dor id */
>> -     rbuf[num + 0] =3D 2;
>> -     rbuf[num + 1] =3D 1;
>> -     rbuf[num + 3] =3D sat_model_serial_desc_len;
>> -     num +=3D 4;
>> -     memcpy(rbuf + num, "ATA     ", 8);
>> -     num +=3D 8;
>> -     ata_id_string(args->id, (unsigned char *) rbuf + num, ATA_ID_P=
ROD,
>> -                   ATA_ID_PROD_LEN);
>> -     num +=3D ATA_ID_PROD_LEN;
>> -     ata_id_string(args->id, (unsigned char *) rbuf + num, ATA_ID_S=
ERNO,
>> -                   ATA_ID_SERNO_LEN);
>> -     num +=3D ATA_ID_SERNO_LEN;
>> -
>>       if (ata_id_has_wwn(args->id)) {
>>               /* SAT defined lu world wide name */
>>               /* piv=3D0, assoc=3Dlu, code_set=3Dbinary, designator=3D=
NAA */
>> @@ -2236,6 +2221,23 @@ static unsigned int ata_scsiop_inq_83(struct =
ata_scsi_args *args, u8 *rbuf)
>>                             ATA_ID_WWN, ATA_ID_WWN_LEN);
>>               num +=3D ATA_ID_WWN_LEN;
>>       }
>> +     else {
>> +             /* SAT defined lu model and serial numbers descriptor =
*/
>> +             /* piv=3D0, assoc=3Dlu, code_set=3DACSII, designator=3D=
t10 vendor id */
>> +             rbuf[num + 0] =3D 2;
>> +             rbuf[num + 1] =3D 1;
>> +             rbuf[num + 3] =3D sat_model_serial_desc_len;
>> +             num +=3D 4;
>> +             memcpy(rbuf + num, "ATA     ", 8);
>> +             num +=3D 8;
>> +             ata_id_string(args->id, (unsigned char *) rbuf + num, =
ATA_ID_PROD,
>> +                           ATA_ID_PROD_LEN);
>> +             num +=3D ATA_ID_PROD_LEN;
>> +             ata_id_string(args->id, (unsigned char *) rbuf + num, =
ATA_ID_SERNO,
>> +                           ATA_ID_SERNO_LEN);
>> +             num +=3D ATA_ID_SERNO_LEN;
>> +     }
>> +
>>       rbuf[3] =3D num - 4;    /* page len (assume less than 256 byte=
s) */
>>       return 0;
>>  }
>>
> Nope.
> We cannot go about and remove VPD descriptors.
> Existing systems might rely on the VPD attribute to be present (think=
 of
> udev persistent symlinks), and the system will refuse to boot.
> NACK.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
