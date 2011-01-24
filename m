From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Erroneous handling of sense status in SCSI EH commands
Date: Mon, 24 Jan 2011 08:59:57 +0100
Message-ID: <4D3D317D.6060403@suse.de>
References: <1295597274-5844-1-git-send-email-hare@suse.de> <4D39F16A.5020002@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1AXHws (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2011 02:52:48 -0500
In-Reply-To: <4D39F16A.5020002@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <jbottomley@suse.de>, linux-scsi@vger.kernel.org

On 01/21/2011 09:49 PM, Mike Christie wrote:
> On 01/21/2011 02:07 AM, Hannes Reinecke wrote:
>> Consider a scenario where a SCSI EH command like TUR fails with a NO=
T
>> READY
>> status - MANUAL INTERVENTION REQUIRED (02/04/03). As evident in the
>> ASC/ASCQ
>> description, manual intervention is required in this case i.e. the
>> target wants
>> TUR to fail here so that the host administrator can take corrective
>> action.
>>
>> But this particular ASC/ASCQ is not handled in the scsi_check_sense,
>> which
>> ultimately causes scsi_eh_tur to erroneously report a SUCCESS (devic=
e
>> ready)
>> instead of the actual FAILURE state (device not ready).
>>
>> This patch converts scsi_check_sense() to return SOFT_ERROR in
>> cases where an error has been signalled via the sense code, but
>> we should not wake the error handler. This error code will be
>> reverted back to SUCCESS for normal command handling, but
>> scsi_eh_completed_normally() will convert it to FAILED.
>>
>> Reported-by: Martin George<marting@netapp.com>
>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 45c7564..e86e62e 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -223,7 +223,7 @@ static inline void scsi_eh_prt_fail_stats(struct
>> Scsi_Host *shost,
>>    * @scmd:    Cmd to have sense checked.
>>    *
>>    * Return value:
>> - *     SUCCESS or FAILED or NEEDS_RETRY
>> + *     SUCCESS or FAILED or NEEDS_RETRY or SOFT_ERROR
>>    *
>>    * Notes:
>>    *    When a deferred error is detected the current command has
>> @@ -278,7 +278,7 @@ static int scsi_check_sense(struct scsi_cmnd *sc=
md)
>>
>>       case ABORTED_COMMAND:
>>           if (sshdr.asc =3D=3D 0x10) /* DIF */
>> -            return SUCCESS;
>> +            return SOFT_ERROR;
>>
>>           return NEEDS_RETRY;
>>       case NOT_READY:
>> @@ -324,19 +324,19 @@ static int scsi_check_sense(struct scsi_cmnd *=
scmd)
>>            * Pass the UA upwards for a determination in the completi=
on
>>            * functions.
>>            */
>> -        return SUCCESS;
>> +        return SOFT_ERROR;
>>
>=20
>=20
> For normal IO execution the UA, not ready, and illegal request handli=
ng
> in scsi_io_completion would determine that some of these are retryabl=
e
> conditions, but with the patch in the scsi_error.cs path we will retu=
rn
> soft error and fail. Also a lot of these that were retryable were
> returned as success in the past, but with the patch are being failed.
>=20
No. scsi_check_sense() is not called from scsi_io_completion; that
just calls scsi_normalize_sense().
scsi_check_sense() is only called from

- scsi_eh_completed_normally()
- scsi_eh_stu()
- scsi_decide_disposition()

All of which have been checked against this patch.
scsi_io_completion() has it's own set of checks for sense codes
which I don't modify here.

> Martin made me the same bugzilla :) I was thinking we needed to make
> check_sense smarter or move some of the scsi_io_completion code to so=
me
> lib helpers so scsi_error.c could call them.
>=20
> And does scsi_eh_stu need to be covnerted to check for soft error and
> failed.
>=20
No. scsi_eh_stu() needs to check if a START STOP UNIT command needs
to be send. The trigger for this is that scsi_check_sense() returns
=46AILED:

		list_for_each_entry(scmd, work_q, eh_entry)
			if (scmd->device =3D=3D sdev && SCSI_SENSE_VALID(scmd) &&
			    scsi_check_sense(scmd) =3D=3D FAILED ) {
				stu_scmd =3D scmd;
				break;
			}

		if (!stu_scmd)
			continue;

so this logic hasn't changed.

> Also if we did this patch, then I think we also have to convert the
> device handlers.
Not necessarily. This patch just allows check_sense() to return
an additional error code; the device handlers are not forced to
use them. If they don't things will work like before.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
