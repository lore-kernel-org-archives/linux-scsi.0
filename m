From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] scsi: Return VPD page length in scsi_vpd_inquiry()
Date: Thu, 13 Mar 2014 07:45:20 +0100
Message-ID: <53215400.50907@suse.de>
References: <1394461725-76203-1-git-send-email-hare@suse.de>	<1394461725-76203-3-git-send-email-hare@suse.de> <CAFR8ueeATrBwSMg_dmA2gY-Bt2D2+F8rR5zmDbN1ZC3Aw5bJMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaCMGpV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2014 02:45:21 -0400
In-Reply-To: <CAFR8ueeATrBwSMg_dmA2gY-Bt2D2+F8rR5zmDbN1ZC3Aw5bJMw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muthukumar R <muthu.lkml@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>, Bart van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 03/12/2014 10:14 PM, Muthukumar R wrote:
> On Mon, Mar 10, 2014 at 7:28 AM, Hannes Reinecke <hare@suse.de> wrote=
:
>> We should be returning the number of bytes of the
>> requested VPD page in scsi_vpd_inquiry.
>> This makes it easier for the caller to verify the
>> required space.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/scsi.c | 17 ++++++++++-------
>>  1 file changed, 10 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index d8afec8..ecaeff1 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -954,7 +954,7 @@ EXPORT_SYMBOL(scsi_track_queue_full);
>>   * This is an internal helper function.  You probably want to use
>>   * scsi_get_vpd_page instead.
>>   *
>> - * Returns 0 on success or a negative error number.
>> + * Returns size of the vpg page on success or a negative error numb=
er.
>>   */
> Typo:                              ^^^
>=20
>  Should be: vpd page
>=20
>=20
Ah. Correct.

>>  static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char=
 *buffer,
>>                                                         u8 page, uns=
igned len)
>> @@ -962,6 +962,9 @@ static int scsi_vpd_inquiry(struct scsi_device *=
sdev, unsigned char *buffer,
>>         int result;
>>         unsigned char cmd[16];
>>
>> +       if (len < 4)
>> +               return -EINVAL;
>> +
>>         cmd[0] =3D INQUIRY;
>>         cmd[1] =3D 1;             /* EVPD */
>>         cmd[2] =3D page;
>> @@ -982,7 +985,7 @@ static int scsi_vpd_inquiry(struct scsi_device *=
sdev, unsigned char *buffer,
>>         if (buffer[1] !=3D page)
>>                 return -EIO;
>>
>> -       return 0;
>> +       return get_unaligned_be16(&buffer[2]) + 4;
>>  }
>>
>>  /**
>> @@ -1009,18 +1012,18 @@ int scsi_get_vpd_page(struct scsi_device *sd=
ev, u8 page, unsigned char *buf,
>>
>>         /* Ask for all the pages supported by this device */
>>         result =3D scsi_vpd_inquiry(sdev, buf, 0, buf_len);
>> -       if (result)
>> +       if (result < 4)
>>                 goto fail;
>=20
>=20
> You mean:
>=20
>             if (result < 0)
>                    goto fail;
>=20
>=20
No. See above. The actual data starts at offset 4.

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
