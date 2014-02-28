From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: Requeue another not ready check condition
 at ML
Date: Fri, 28 Feb 2014 16:14:55 +0100
Message-ID: <5310A7EF.7060902@suse.de>
References: <8255ED565A0EAA4A960625E27D49DBF24AC8B21D@SACEXCMBX04-PRD.hq.netapp.com> <530FED5B.60803@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbaB1PO5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Feb 2014 10:14:57 -0500
In-Reply-To: <530FED5B.60803@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "Stewart, Sean" <Sean.Stewart@netapp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

On 02/28/2014 02:58 AM, Mike Christie wrote:
> On 02/27/2014 06:14 PM, Stewart, Sean wrote:
>> This allows the sd driver to retry commands like read capacity until=
 a
>> LUN is ready, rather than giving up after three retries.
>>
>> In NetApp E-Series, a controller can return not ready like this when=
 it
>> quiesces I/O on the controller that just came on the network, during=
 a
>> firmware upgrade procedure, and retrying the command at the midlayer
>> will allow the discovery to complete, successfully.
>>
>> Signed-off-by: Sean Stewart <sean.stewart@netapp.com>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index 5248c88..95d87fe 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -454,6 +454,11 @@ static int alua_check_sense(struct scsi_device =
*sdev,
>>  {
>>  	switch (sense_hdr->sense_key) {
>>  	case NOT_READY:
>> +		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D 0x01)
>> +			/*
>> +			 * LUN Not Ready -- In process of becoming ready
>> +			 */
>> +			return ADD_TO_MLQUEUE;
>=20
> It seems like the check_sense callout is being used to work around
> scsi-ml in a lot of the additions that are not alua specific. If this=
 is
> meant for a specific target then it should not be here. If this is
> non-alua specific behavior then it should also not be here either.
>=20
> If the IO was not a REQ_TYPE_BLOCK_PC request, then it would retried =
by
> scsi_io_completion. Same with the other ones like inquiry data change=
d,
> report luns data changed, etc.
>=20
> Are we sure we don't want to fix the REQ_TYPE_BLOCK_PC/scsi_execute*
> users to retry, or to add some new flag that those users can use that
> tells scsi-ml to retry like it normally would so callers do not have =
to
> check for all these errors, or just add these to scsi_decide_disposit=
ion?
>=20
Yes, that's definitely a better idea. I've stumbled across this
issue several times now.

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
