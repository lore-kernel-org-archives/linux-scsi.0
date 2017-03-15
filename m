From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 4/6] scsi_error: do not escalate failed EH command
Date: Wed, 15 Mar 2017 14:54:16 +0100
Message-ID: <aa4c4285-782f-bd41-2fe8-98f54c2c2d9d@suse.de>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
 <1488359720-130871-5-git-send-email-hare@suse.de>
 <20170314175611.GC19037@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50987 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753711AbdCONyU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 09:54:20 -0400
In-Reply-To: <20170314175611.GC19037@bblock-ThinkPad-W530>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 03/14/2017 06:56 PM, Benjamin Block wrote:
> Hello Hannes,
> 
> On Wed, Mar 01, 2017 at 10:15:18AM +0100, Hannes Reinecke wrote:
>> When a command is sent as part of the error handling there
>> is not point whatsoever to start EH escalation when that
>> command fails; we are _already_ in the error handler,
>> and the escalation is about to commence anyway.
>> So just call 'scsi_try_to_abort_cmd()' to abort outstanding
>> commands and let the main EH routine handle the rest.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
>> ---
>>  drivers/scsi/scsi_error.c | 11 +----------
>>  1 file changed, 1 insertion(+), 10 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index e1ca3b8..4613aa1 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -889,15 +889,6 @@ static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
>>  	return hostt->eh_abort_handler(scmd);
>>  }
>>
>> -static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
>> -{
>> -	if (scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd) != SUCCESS)
>> -		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
>> -			if (scsi_try_target_reset(scmd) != SUCCESS)
>> -				if (scsi_try_bus_reset(scmd) != SUCCESS)
>> -					scsi_try_host_reset(scmd);
>> -}
>> -
>>  /**
>>   * scsi_eh_prep_cmnd  - Save a scsi command info as part of error recovery
>>   * @scmd:       SCSI command structure to hijack
>> @@ -1082,7 +1073,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>>  			break;
>>  		}
>>  	} else if (rtn != FAILED) {
>> -		scsi_abort_eh_cmnd(scmd);
>> +		scsi_try_to_abort_cmd(shost->hostt, scmd);
>>  		rtn = FAILED;
>>  	}
> 
> The idea is sound, but this implementation would cause "use-after-free"s.
> 
> I only know our own LLD well enough to judge, but with zFCP there will
> always be a chance that an abort fails - be it memory pressure,
> hardware/firmware behavior or internal EH in zFCP.
> 
> Calling queuecommand() will mean for us in the LLD, that we allocate a
> unique internal request struct for the scsi_cmnd (struct
> zfcp_fsf_request) and add that to our internal hash-table with
> outstanding commands. We assume this scsi_cmnd-pointer is ours till we
> complete it via scsi_done are yield it via successful EH-actions.
> 
> In case the abort fails, you fail to take back the ownership over the
> scsi command. Which in turn means possible "use-after-free"s when we
> still thinks the scsi command is ours, but EH has already overwritten
> the scsi-command with the original one. When we still get an answer or
> otherwise use the scsi_cmnd-pointer we would access an invalid one.
> 
That is actually not try.
As soon as we're calling 'scsi_try_to_abort_command()' ownership is
assumed to reside in the SCSI midlayer; also, the command used for
recovery here is actually using the same structure than the failed
command, so if the command abort failed the command is already in the
list of failed commands, and will be recovered after SCSI EH returned.

So no use-after-free here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
