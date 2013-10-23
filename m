From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] scsi: Fix erratic device offline during EH
Date: Wed, 23 Oct 2013 11:27:28 +0200
Message-ID: <52679680.7070209@suse.de>
References: <1378123118-111972-1-git-send-email-hare@suse.de>	 <1378123118-111972-2-git-send-email-hare@suse.de> <1381840900.3752.19.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab3JWHZi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Oct 2013 03:25:38 -0400
In-Reply-To: <1381840900.3752.19.camel@dabdike.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 10/16/2013 09:22 PM, James Bottomley wrote:
> On Mon, 2013-09-02 at 13:58 +0200, Hannes Reinecke wrote:
>> Commit 18a4d0a22ed6c54b67af7718c305cd010f09ddf8
>> (Handle disk devices which can not process medium access commands)
>> was introduced to offline any device which cannot process medium
>> access commands.
>> However, commit 3eef6257de48ff84a5d98ca533685df8a3beaeb8
>> (Reduce error recovery time by reducing use of TURs) reduced
>> the number of TURs by sending it only on the first failing
>> command, which might or might not be a medium access command.
>> So in combination this results in an erratic device offlining
>> during EH; if the command where the TUR was sent upon happens
>> to be a medium access command the device will be set offline,
>> if not everything proceeds as normal.
>>
>> So instead of checking the EH command in the ->eh_action
>> callback we should rather call ->eh_action when we're
>> about to finish the command _and_ have sent a TUR previously.
>> This should then set the device offline as advertised.
>>
>> Cc: Martin K. Petersen <martin.petersen@oracle.com>
>> Cc: Ewan Milne <emilne@redhat.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi_error.c | 28 +++++++++++++++++++---------
>>   1 file changed, 19 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index abf0916..c88cb7e 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -941,12 +941,6 @@ retry:
>>
>>   	scsi_eh_restore_cmnd(scmd, &ses);
>>
>> -	if (scmd->request->cmd_type !=3D REQ_TYPE_BLOCK_PC) {
>> -		struct scsi_driver *sdrv =3D scsi_cmd_to_driver(scmd);
>> -		if (sdrv->eh_action)
>> -			rtn =3D sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
>> -	}
>> -
>>   	return rtn;
>>   }
>>
>> @@ -964,6 +958,18 @@ static int scsi_request_sense(struct scsi_cmnd =
*scmd)
>>   	return scsi_send_eh_cmnd(scmd, NULL, 0, scmd->device->eh_timeout,=
 ~0);
>>   }
>>
>> +static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
>> +{
>> +	static unsigned char tur_command[6] =3D {TEST_UNIT_READY, 0, 0, 0,=
 0, 0};
>> +
>> +	if (scmd->request->cmd_type !=3D REQ_TYPE_BLOCK_PC) {
>> +		struct scsi_driver *sdrv =3D scsi_cmd_to_driver(scmd);
>> +		if (sdrv->eh_action)
>> +			rtn =3D sdrv->eh_action(scmd, tur_command, 6, rtn);
>
> This is all a bit pointless.  You've altered eh_action so it's always
> input an eh TUR command, so just eliminate the check of the eh comman=
d
> and assume it's a TUR in the implementation (i.e. fix up sd.c)
>
> Once that's done, I think the patch looks like the one below, is that
> OK?
>
Yes, the patch looks okay. No objections from my side.

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
