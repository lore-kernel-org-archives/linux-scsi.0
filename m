From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas: boot hangs while LD is offline
Date: Mon, 18 Jan 2016 07:54:18 +0100
Message-ID: <569C8C1A.1070105@suse.de>
References: <1452865396-9887-1-git-send-email-hare@suse.de>
 <4e96fb90476261bae709ac7abfe21e93@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbcARGyV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 01:54:21 -0500
In-Reply-To: <4e96fb90476261bae709ac7abfe21e93@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 01/18/2016 06:48 AM, Kashyap Desai wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Friday, January 15, 2016 7:13 PM
>> To: Sumit Saxena
>> Cc: Kashyap Desai; megaraidlinux.pdl@avagotech.com; Martin K. Peters=
en;
>> James Bottomley; linux-scsi@vger.kernel.org; Hannes Reinecke; Hannes
>> Reinecke
>> Subject: [PATCH] megaraid_sas: boot hangs while LD is offline
>>
>> Offline Logical drives (LDs) should not allowed to be visible to the=
 OS,
> as the
>> OS will hang trying to send commands to it.
>> This patch skips offline LDs like it already does for non-system
> physical
>> drives (PDs).
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>   drivers/scsi/megaraid/megaraid_sas_base.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>> index 97a1c1c..f32831b 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>> @@ -1760,7 +1760,7 @@ static void megasas_set_dma_alignment(struct
>> scsi_device *sdev)
>>
>>   static int megasas_slave_configure(struct scsi_device *sdev)  {
>> -	u16 pd_index =3D 0;
>> +	u16 pd_index =3D 0, ld_index;
>>   	struct megasas_instance *instance;
>>
>>   	instance =3D megasas_lookup_instance(sdev->host->host_no);
>> @@ -1772,6 +1772,11 @@ static int megasas_slave_configure(struct
>> scsi_device *sdev)
>>   			if (instance->pd_list[pd_index].driveState !=3D
>>   				MR_PD_STATE_SYSTEM)
>>   				return -ENXIO;
>> +		} else {
>> +			ld_index =3D ((sdev->channel -
>> MEGASAS_MAX_PD_CHANNELS) *
>> +				    MEGASAS_MAX_DEV_PER_CHANNEL) +
>> sdev->id;
>> +			if (instance->ld_ids[ld_index] =3D=3D 0xff)
>> +				return -ENXIO;
>
> Hannes - We attempted this code change for one of the issue in past. =
This
> code drop was just a quick workaround to unblock that customer issue.
> Avago provided FW fix for this issue as new FW (again fix was done 2 =
years
> before, so many latest FW will have this fix) return below sense key =
for
> TUR.
> SenseKey=3D0x2, asc=3D0x4, ascq=3D0x3(LOGICAL UNIT NOT READY, MANUAL
> INTERVENTION REQUIRED)
>
> Have you seen any issue w.r.t VD Offline or trying to optimize code i=
n
> megaraid driver ?
>
Currently I'm in the process to review all non-mainstream SLES=20
patches. And this is one of them which do not have a clear=20
equivalent in mainline.
But as all are customers are running _with_ this patch, we wouldn't=20
know if the upstream fix resolves this issue, too.

But thanks for the review, I'll drop this patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
