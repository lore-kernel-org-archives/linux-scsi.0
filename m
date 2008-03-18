From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device
 causes infinite loop in 2.6.24
Date: Tue, 18 Mar 2008 11:12:20 -0500
Message-ID: <47DFE9E4.6070301@sgi.com>
References: <47D7035F.5000700@sgi.com> <47D7B4A1.6020909@panasas.com> <47D7FECE.1020901@sgi.com> <47D8002C.9010306@panasas.com> <47DA798E.5080305@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42381 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752976AbYCST0B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 15:26:01 -0400
In-Reply-To: <47DA798E.5080305@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>



Michael Reed wrote:
> 
> Boaz Harrosh wrote:
> <snip>
>>>> Just to demonstrate what I mean a patch is attached. Just as an RFC, totally
>>>> untested.
>>> I can try this out and see what happens.
>>>
>>>
>> Will not compile here is a cleaner one
> 
> Still in my queue.  Hopefully I'll get to poke at this today.

Patch compiles cleanly and appears to have no effect on the misc.
sg_* commands I've executed including sg_dd, sg_inq, sg_luns, sg_readcap.

Mike

> 
> Mike
> 
>> ---
>> From: Boaz Harrosh <bharrosh@panasas.com>
>> Date: Wed, 12 Mar 2008 13:18:49 +0200
>> Subject: [PATCH] scsi: Always complete BLOCK_PC commands
>>
>> Current code, in some IO combinations could wrongly retry
>> a BLOCK_PC command in chunks. This was never intended.
>> Fix it that BLOCK_PC will always complete atomically
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  drivers/scsi/scsi_lib.c |   24 +++++++++++++-----------
>>  1 files changed, 13 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index ba21d97..4b8b57c 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -784,14 +784,20 @@ EXPORT_SYMBOL(scsi_release_buffers);
>>   * in req->data_len and req->next_rq->data_len. The upper-layer driver can
>>   * decide what to do with this information.
>>   */
>> -void scsi_end_bidi_request(struct scsi_cmnd *cmd)
>> +static void scsi_end_blk_request(struct scsi_cmnd *cmd)
>>  {
>>  	struct request *req = cmd->request;
>>  	unsigned int dlen = req->data_len;
>> -	unsigned int next_dlen = req->next_rq->data_len;
>> +	unsigned int next_dlen;
>>  
>> -	req->data_len = scsi_out(cmd)->resid;
>> -	req->next_rq->data_len = scsi_in(cmd)->resid;
>> +	if (blk_bidi_rq(req)) {
>> +		next_dlen = req->next_rq->data_len;
>> +		req->data_len = scsi_out(cmd)->resid;
>> +		req->next_rq->data_len = scsi_in(cmd)->resid;
>> +	} else {
>> +		next_dlen = 0;
>> +		req->data_len = scsi_get_resid(cmd);
>> +	}
>>  
>>  	/* The req and req->next_rq have not been completed */
>>  	BUG_ON(blk_end_bidi_request(req, 0, dlen, next_dlen));
>> @@ -866,15 +872,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>>  				req->sense_len = len;
>>  			}
>>  		}
>> -		if (scsi_bidi_cmnd(cmd)) {
>> -			/* will also release_buffers */
>> -			scsi_end_bidi_request(cmd);
>> -			return;
>> -		}
>> -		req->data_len = scsi_get_resid(cmd);
>> +		/* will also release_buffers */
>> +		scsi_end_blk_request(cmd);
>> +		return;
>>  	}
>>  
>> -	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
>>  	scsi_release_buffers(cmd);
>>  
>>  	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
