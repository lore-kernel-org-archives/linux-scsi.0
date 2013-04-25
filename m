From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][v3] scsi: Handle MLQUEUE busy response in scsi_send_eh_cmnd
Date: Thu, 25 Apr 2013 07:53:41 +0200
Message-ID: <5178C4E5.9070809@suse.de>
References: <1366803168-79391-1-git-send-email-hare@suse.de> <1366814922.1971.5.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab3DYFxm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Apr 2013 01:53:42 -0400
In-Reply-To: <1366814922.1971.5.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>

On 04/24/2013 04:48 PM, James Bottomley wrote:
> On Wed, 2013-04-24 at 13:32 +0200, Hannes Reinecke wrote:
>> scsi_send_eh_cmnd() is calling queuecommand() directly, so
>> it needs to check the return value here.
>> The only valid return codes for queuecommand() are 'busy'
>> states, so we need to wait for a bit to allow the LLDD
>> to recover.
>>
>> Based on an earlier patch from Wen Xiong.
>=20
> This looks good, only one minor nitpick:
>=20
>> Cc: Wen Xiong <wenxiong@linux.vnet.ibm.com>
>> Cc: Brian King <brking@linux.vnet.ibm.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index c1b05a8..1fc6da94 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -791,22 +791,32 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd =
*scmd, unsigned char *cmnd,
>>  	struct scsi_device *sdev =3D scmd->device;
>>  	struct Scsi_Host *shost =3D sdev->host;
>>  	DECLARE_COMPLETION_ONSTACK(done);
>> -	unsigned long timeleft;
>> +	unsigned long timeleft =3D timeout;
>>  	struct scsi_eh_save ses;
>> +	const int stall_for =3D min(HZ/10, 1);
>>  	int rtn;
>> =20
>> +retry:
>>  	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
>>  	shost->eh_action =3D &done;
>> =20
>>  	scsi_log_send(scmd);
>>  	scmd->scsi_done =3D scsi_eh_done;
>> -	shost->hostt->queuecommand(shost, scmd);
>> -
>> -	timeleft =3D wait_for_completion_timeout(&done, timeout);
>> +	rtn =3D shost->hostt->queuecommand(shost, scmd);
>> +	if (rtn) {
>> +		if (timeleft) {
>> +			scsi_eh_restore_cmnd(scmd, &ses);
>> +			timeleft -=3D stall_for;
>> +			msleep(stall_for);
>=20
> Stall for is in HZ: need to convert to ms, so
>=20
> 			msleep(stall_for * 1000/HZ);
>=20
Right. Will be converting it.

> I also don't see a need to restore and reprep the command each time, =
but
> I don't see a problem with it either.
>=20
This was mainly thought as a safeguard here; just in case someone
else might be fiddling with the command. But yeah, it's not required.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
