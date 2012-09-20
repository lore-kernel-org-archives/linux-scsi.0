From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: Enable STPG for unavailable ports
Date: Thu, 20 Sep 2012 07:28:29 +0200
Message-ID: <505AA97D.7040005@suse.de>
References: <50374499.5010808@acm.org> <5059E97E.1000500@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab2ITF2d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 01:28:33 -0400
In-Reply-To: <5059E97E.1000500@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Babu Moger <babu.moger@netapp.com>

On 09/19/2012 05:49 PM, Mike Christie wrote:
> On 08/24/2012 04:08 AM, Bart Van Assche wrote:
>> A quote from SPC-4: "While in the unavailable primary target port
>> asymmetric access state, the device server shall support those of
>> the following commands that it supports while in the active/optimize=
d
>> state: [ ... ] d) SET TARGET PORT GROUPS; [ ... ]". Hence enable
>> sending STPG to a target port group that is in the unavailable state=
=2E
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Mike Christie <michaelc@cs.wisc.edu>
>> Cc: Mike Snitzer <snitzer@redhat.com>
>> Cc: Babu Moger <babu.moger@netapp.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index 08d80a6..a05d469 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -641,8 +641,7 @@ static int alua_rtpg(struct scsi_device *sdev, s=
truct alua_dh_data *h)
>>  		h->state =3D TPGS_STATE_STANDBY;
>>  		break;
>>  	case TPGS_STATE_OFFLINE:
>> -	case TPGS_STATE_UNAVAILABLE:
>> -		/* Path unusable for unavailable/offline */
>> +		/* Path unusable */
>>  		err =3D SCSI_DH_DEV_OFFLINED;
>>  		break;
>>  	default:
>>
>=20
> Hey, was this patch ok Hannes and James and others?
>=20
> I see bb2c94a3a6ad37fe7d34f369295bcdf5387e264f was merged, but this o=
ne
> was not.
>=20
> I was thinking this might have got missed because it has the same pat=
ch
> description as  bb2c94a3a6ad37fe7d34f369295bcdf5387e264f, so it is
> confusion, but they are different patches. One fixes alua_rtpg and on=
e
> fixes alua_activate, but both are needed.
>=20
Yeah, patch's okay.

Acked-by: Hannes Reinecke <hare@suse.de>

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
