From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Fri, 1 Apr 2016 09:29:15 +0200
Message-ID: <56FE234B.8090904@suse.de>
References: <1458200385-32088-1-git-send-email-hare@suse.de>
 <20160330194153.GB13317@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbcDAH3T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 03:29:19 -0400
In-Reply-To: <20160330194153.GB13317@bblock-ThinkPad-W530>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/30/2016 09:41 PM, Benjamin Block wrote:
> Hello Hannes,
>=20
> I am a bit late here, but as this got pulled and Steffen didn't have
> time to give it a review, I did today.
>=20
> On 08:39 Thu 17 Mar     , Hannes Reinecke wrote:
>> On larger installations it is useful to disable automatic LUN
>> scanning, and only add the required LUNs via udev rules.
>> This can speed up bootup dramatically.
>>
>> This patch introduces a new scan module parameter value 'manual',
>> which works like 'none', but can be overriden by setting the 'rescan=
'
>> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
>> And it updates all relevant callers to set the 'rescan' value
>> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>=20
> [:snip:]
>=20
>>
>> diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_=
unit.c
>> index 157d3d2..08bba7c 100644
>> --- a/drivers/s390/scsi/zfcp_unit.c
>> +++ b/drivers/s390/scsi/zfcp_unit.c
>> @@ -26,7 +26,8 @@ void zfcp_unit_scsi_scan(struct zfcp_unit *unit)
>>  	lun =3D scsilun_to_int((struct scsi_lun *) &unit->fcp_lun);
>>
>>  	if (rport && rport->port_state =3D=3D FC_PORTSTATE_ONLINE)
>> -		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id, lun, 1);
>> +		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id, lun,
>> +				 SCSI_SCAN_RESCAN);
>=20
> I'd rather use the new SCSI_SCAN_MANUAL here. We don't want this to b=
e
> "blocked" by an attribute set in a different (new) code-path and
> config-location.
>=20
> This path is used by both, zfcp-recovery and -userinterfaces (sysfs) =
and
> in both cases we call it with the intend that the scan is really done=
 -
> hence the SCSI_SCAN_MANUAL to force a scan. I'd find it very weird if
> suddenly our users would have to additionally use yet an other config=
 to
> get the old interfaces working properly.
>=20
Okay, no problem with that.
zfcp has its own scanning rules (cf allow_lun_scan module parameter), s=
o
setting it to 'MANUAL' will just restore the original behaviour.

Will you be sending a patch for it?

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
