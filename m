From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Make scsi_vpd_lun_id() able to use T10 vendor ID
 based designators
Date: Thu, 5 May 2016 10:01:13 +0200
Message-ID: <572AFDC9.1000607@suse.de>
References: <20160504065830.GB19436@oak.ozlabs.ibm.com>
 <5729C920.1040206@suse.de> <20160505035010.GA4635@oak.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbcEEIBQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 May 2016 04:01:16 -0400
In-Reply-To: <20160505035010.GA4635@oak.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@ozlabs.org>
Cc: linux-scsi@vger.kernel.org

On 05/05/2016 05:50 AM, Paul Mackerras wrote:
> On Wed, May 04, 2016 at 12:04:16PM +0200, Hannes Reinecke wrote:
>> On 05/04/2016 08:58 AM, Paul Mackerras wrote:
>>> This adds code to scsi_vpd_lun_id() to enable it to use T10 vendor =
ID
>>> based designators.  This is needed to allow alua to work on disks t=
hat
>>> don't have any designators of type 2, 3 or 8.  Commit 0047220c6c36
>>> ("scsi_dh_alua: use unique device id", 2016-02-19) added a requirem=
ent
>>> that alua can only be used on disks for which scsi_vpd_lun_id() can
>>> produce an identifying string.
>>>
>>> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
>>> ---
>>>  drivers/scsi/scsi_lib.c |   14 ++++++++++++++
>>>  1 file changed, 14 insertions(+)
>>>
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index 8106515..f4f69cc 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -3214,6 +3214,20 @@ int scsi_vpd_lun_id(struct scsi_device *sdev=
, char *id, size_t id_len)
>>>  			goto next_desig;
>>> =20
>>>  		switch (d[1] & 0xf) {
>>> +		case 0x1:
>>> +			/* T10 vendor ID */
>>> +			if (cur_id_size > d[3])
>>> +				break;
>>> +			/* Prefer EUI-64 or NAA IEEE Registered Extended */
>>> +			if ((cur_id_type =3D=3D 0x2 || cur_id_type =3D=3D 0x3) &&
>>> +			    cur_id_size =3D=3D d[3])
>>> +				break;
>>> +			cur_id_size =3D d[3];
>>> +			cur_id_str =3D d + 4;
>>> +			cur_id_type =3D d[1] & 0xf;
>>> +			id_size =3D snprintf(id, id_len, "%*phN", cur_id_size,
>>> +					   cur_id_str);
>>> +			break;
>>>  		case 0x2:
>>>  			/* EUI-64 */
>>>  			if (cur_id_size > d[3])
>>>
>> Nearly.
>> The thing is, a T-10 vendor specific ID is _supposed_ to be an ASCII
>> string. So I'd rather have it decoded as such.
>=20
> Do we need to defend against non-printing characters in the string?
>=20
I really would like to stick to ASCII output here, as most vendors put =
a
meaningful string in here.
Those who don't we should be going with the '.' normal method and print
a dot '.' instead.
(Can't we fix up snprintf do do it for us? Would be soo cool ...)

>> And we're missing decoding for 'vendor-specific' ID, too.
>=20
> There's no guarantee that this would be ASCII, right?  So would you
> print it in hex?
>=20
Yes, that's the plan here.

> Also, is there a preference between these types?  For example, is an
> 8-byte EUI-64 preferable to a vendor-specific ID of any length?
>=20
Yes. I'd treat T10 vendor ID descriptors with the lowest preference
(irrespective of the length), eclipsed (sic) only by the truly vendor
specific ones.
And actually I would make the vendor-specific decoding the default
entry, too, as we might come across some other descriptors which we
cannot decode (yet). And by having a default method for decoding we
ensure to always be able to come up with an ALUA identification.
Otherwise we might end up in the same situation as we're in now.

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
