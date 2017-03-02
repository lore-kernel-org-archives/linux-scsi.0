From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 1/6] scsi_error: count medium access timeout only once
 per EH run
Date: Thu, 2 Mar 2017 09:02:42 +0100
Message-ID: <21ec4ad7-9a56-dc2b-3baa-9c85eb0c1527@suse.de>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
 <1488359720-130871-2-git-send-email-hare@suse.de>
 <1488410641.2699.14.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50957 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751229AbdCBOfY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Mar 2017 09:35:24 -0500
In-Reply-To: <1488410641.2699.14.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "emilne@redhat.com" <emilne@redhat.com>, "loberman@redhat.com" <loberman@redhat.com>, "maier@de.ibm.com" <maier@de.ibm.com>

On 03/02/2017 12:24 AM, Bart Van Assche wrote:
> On Wed, 2017-03-01 at 10:15 +0100, Hannes Reinecke wrote:
>> The current medium access timeout counter will be increased for
>> each command, so if there are enough failed commands we'll hit
>> the medium access timeout for even a single failure.
>
> This sentence describes multiple failed commands as a single failure.
> That's confusing to me. Did you perhaps intend "for a single device
> failure"?
>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index f2cafae..cec439c 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -58,6 +58,7 @@
>>  static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
>>  static int scsi_try_to_abort_cmd(struct scsi_host_template *,
>>  				 struct scsi_cmnd *);
>> +static int scsi_eh_reset(struct scsi_cmnd *scmd);
>>
>>  /* called with shost->host_lock held */
>>  void scsi_eh_wakeup(struct Scsi_Host *shost)
>> @@ -249,6 +250,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
>>  	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
>>  		eh_flag &= ~SCSI_EH_CANCEL_CMD;
>>  	scmd->eh_eflags |= eh_flag;
>> +	scsi_eh_reset(scmd);
>>  	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
>>  	shost->host_failed++;
>>  	scsi_eh_wakeup(shost);
>> @@ -1107,7 +1109,19 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
>>  	if (!blk_rq_is_passthrough(scmd->request)) {
>>  		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>>  		if (sdrv->eh_action)
>> -			rtn = sdrv->eh_action(scmd, rtn);
>> +			rtn = sdrv->eh_action(scmd, rtn, false);
>> +	}
>> +	return rtn;
>> +}
>> +
>> +static int scsi_eh_reset(struct scsi_cmnd *scmd)
>> +{
>> +	int rtn = SUCCESS;
>> +
>> +	if (!blk_rq_is_passthrough(scmd->request)) {
>> +		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>> +		if (sdrv->eh_action)
>> +			rtn = sdrv->eh_action(scmd, rtn, true);
>>  	}
>>  	return rtn;
>>  }
>
> Can this function be moved up such that we don't need a new forward declaration?
>
Why, but of course.
I just put is here to be next to the original scsi_eh_action() function.

>> @@ -1689,18 +1689,28 @@ static int sd_pr_clear(struct block_device *bdev, u64 key)
>>   *	sd_eh_action - error handling callback
>>   *	@scmd:		sd-issued command that has failed
>>   *	@eh_disp:	The recovery disposition suggested by the midlayer
>> + *	@reset:		Reset medium access counter
>
> It seems to me that @reset does not trigger a reset of the medium access counter
> but rather of the variable that prevents the medium access error counter to be
> incremented?
>
Correct. Will be fixing up the description.

>> + *	recovery).
>> + *	We have to be careful to count a medium access failure only once
>> + *	per SCSI EH run; there might be several timed out commands which
>
> Did you perhaps intend "once per device per SCSI EH run"?
>
Yes.

>> --- a/drivers/scsi/sd.h
>> +++ b/drivers/scsi/sd.h
>> @@ -106,6 +106,7 @@ struct scsi_disk {
>>  	unsigned	rc_basis: 2;
>>  	unsigned	zoned: 2;
>>  	unsigned	urswrz : 1;
>> +	unsigned	medium_access_reset : 1;
>
> The name of this new member is confusing to me. How about using the name
> "ignore_medium_access_errors" instead? And since this is a boolean, how
> about using true and false in assignments to this variable?
>
Ok, will be doing so.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
