From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sd: retry read_capacity on UNIT_ATTENTION
Date: Thu, 08 Apr 2010 09:36:47 +0200
Message-ID: <4BBD878F.3090205@suse.de>
References: <20100401134428.7E4D1337C5@ochil.suse.de> <1270132201.4439.14.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42848 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab0DHHgt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2010 03:36:49 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 45CBE93717
	for <linux-scsi@vger.kernel.org>; Thu,  8 Apr 2010 09:36:48 +0200 (CEST)
In-Reply-To: <1270132201.4439.14.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2010-04-01 at 15:44 +0200, Hannes Reinecke wrote:
>> Hazard testing uncovered yet another bug in sd. Under heavy
>> reset activity the retry counter might be exhausted and
>> the command will be returned with sense UNIT_ATTENTION/0x29/00
>> (POWER ON, RESET, OR BUS DEVICE RESET OCCURRED). In those
>> cases we should just increase the retry counter again,
>> retrying one more to clear up this Unit Attention state.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 1962bea..7d75a21 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -1454,8 +1454,15 @@ static int read_capacity_10(struct scsi_disk =
*sdkp, struct scsi_device *sdp,
>>  		if (media_not_present(sdkp, &sshdr))
>>  			return -ENODEV;
>> =20
>> -		if (the_result)
>> +		if (the_result) {
>>  			sense_valid =3D scsi_sense_valid(&sshdr);
>> +			if (sense_valid &&
>> +			    sshdr.sense_key =3D=3D UNIT_ATTENTION &&
>> +			    sshdr.asc =3D 0x29 && sshdr.asq =3D=3D 0x00)
>                                       ^^^^
> should be =3D=3D
>=20
>> +			    /* Device reset might occur several times,
>> +			     * give it one more chance */
>> +			    retries++;
>> +		}
>=20
> Firstly, not even compile checked:
>=20
> drivers/scsi/sd.c: In function =E2=80=98read_capacity_10=E2=80=99:
> drivers/scsi/sd.c:1558: error: =E2=80=98struct scsi_sense_hdr=E2=80=99=
 has no member named =E2=80=98asq=E2=80=99
>=20
D'oh.

> Secondly, we can't quite do this.  Some devices (only broken ones in =
my
> experience) will reply UNIT_ATTENTION I was RESET forever, leading to=
 a
> loop here.  Additionally, a massive reset storm on a shared bus would
> DoS the code here, so there must be a give up point after a reasonabl=
e
> number of retries.
>=20
Hmm. yes.

> The third problem is that if this is happening to a large device, we
> only catch it in RC10 ... so we'll report undersize if the device is =
>
> SPC2
>=20
Okay. In the best of all worlds we would have a module parameter which
would us to adjust this parameter, as I fear the actual number of retri=
es
will depend on the number of devices connected.

But if you fell that's overkill it's fine by me, too.

> How about this instead?
>=20
Yes, that's better. Thanks.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
