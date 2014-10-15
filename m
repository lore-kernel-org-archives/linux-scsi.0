From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 21/26] scsi: simplify scsi_log_(send|completion)
Date: Wed, 15 Oct 2014 15:10:10 +0200
Message-ID: <543E7232.9070609@suse.de>
References: <1412672605-42868-1-git-send-email-hare@suse.de> <1412672605-42868-22-git-send-email-hare@suse.de> <94D0CD8314A33A4D9D801C0FE68B402958CDC959@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbaJONKM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Oct 2014 09:10:12 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CDC959@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/08/2014 10:41 PM, Elliott, Robert (Server Storage) wrote:
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Tuesday, 07 October, 2014 4:03 AM
>> To: James Bottomley
>> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Elliott, Robert (=
Server
>> Storage); Hannes Reinecke
>> Subject: [PATCH 21/26] scsi: simplify scsi_log_(send|completion)
>>
>> Simplify scsi_log_(send|completion) by externalizing
>> scsi_mlreturn_string() and always print the command address.
>>
> ...
>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index b853659..2df485f 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -831,7 +831,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, u=
nsigned
>> int good_bytes)
>>   	int error =3D 0;
>>   	struct scsi_sense_hdr sshdr;
>>   	bool sense_valid =3D false;
>> -	int sense_deferred =3D 0;
>> +	int sense_deferred =3D 0, level =3D 0;
>>   	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
>>   	      ACTION_DELAYED_RETRY} action;
>>   	unsigned long wait_for =3D (cmd->allowed + 1) * req->timeout;
>> @@ -1037,8 +1037,15 @@ void scsi_io_completion(struct scsi_cmnd *cmd=
,
>> unsigned int good_bytes)
>>   	switch (action) {
>>   	case ACTION_FAIL:
>>   		/* Give up and fail the remainder of the request */
>> -		if (!(req->cmd_flags & REQ_QUIET)) {
>> -			scsi_print_result(cmd);
>> +		if (unlikely(scsi_logging_level))
>> +			level =3D SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
>> +					       SCSI_LOG_MLQUEUE_BITS);
>
> scsi_log_completion prints based on SCSI_LOG_MLCOMPLETE,
> not SCSI_LOG_MLQUEUE, so this is not accomplishing what
> the next comment says.
>
>> +		/*
>> +		 * if logging is enabled the failure will be printed
>> +		 * in scsi_log_completion(), so avoid duplicate messages
>> +		 */
>> +		if (!level && !(req->cmd_flags & REQ_QUIET)) {
>> +			scsi_print_result(cmd, NULL, FAILED);
>>   			if (driver_byte(result) & DRIVER_SENSE)
>>   				scsi_print_sense(cmd);
>>   			scsi_print_command(cmd);
>
> This still results in prints on every completion with ACTION_FAIL.
> Since they're not ratelimited, the massive number of prints after
> a device failure under heavy load causes other timeouts.  Since
> the block layer also prints errors, with ratelimiting, these are
> not really necessary (although they're more informative than the
> block layer prints).  There needs to be a way to turn these off,
> both in scsi_log_completion and here - maybe different MLCOMPLETE
> levels?
>
> The issue will be mitigated if the next patch series makes these
> ratelimited.
>
Okay, I'll be adding a printk_ratelimited here.

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
