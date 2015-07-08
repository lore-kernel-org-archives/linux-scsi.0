From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] sd: do not try to spin-up disks for ALUA 'transitioning'
 state
Date: Wed, 08 Jul 2015 10:46:35 +0200
Message-ID: <559CE36B.8090005@suse.de>
References: <1436341268-91432-1-git-send-email-hare@suse.de> <1436341268-91432-4-git-send-email-hare@suse.de> <559CE233.3080809@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005AbbGHIqh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 04:46:37 -0400
In-Reply-To: <559CE233.3080809@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 07/08/2015 10:41 AM, Sagi Grimberg wrote:
> On 7/8/2015 10:41 AM, Hannes Reinecke wrote:
>> If a disk reports an ALUA 'transitioning' state we should not
>> try to spin up the device.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/sd.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 7c0bdaa..180a6e8 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -1801,6 +1801,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>>           if (sense_valid && sshdr.sense_key =3D=3D NOT_READY) {
>>               if (sshdr.asc =3D=3D 4 && sshdr.ascq =3D=3D 3)
>>                   break;    /* manual intervention required */
>> +            if (sshdr.asc =3D=3D 4 && sshdr.ascq =3D=3D 0xa)
>> +                break;  /* transitioning */
>>               if (sshdr.asc =3D=3D 4 && sshdr.ascq =3D=3D 0xb)
>>                   break;    /* standby */
>>               if (sshdr.asc =3D=3D 4 && sshdr.ascq =3D=3D 0xc)
>>
>=20
>=20
> Hi Hannes,
>=20
> Just nit-picking, but do you think that these four if statements can =
be
> re-organized to condition (asc =3D=3D 4) once and OR on the rest?
Sure they can, I don't mind.
Once we have a general agreement about these patches (hint, hint :-)
I can update it.

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
