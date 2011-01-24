From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [LSF/MM TOPIC] SCSI referrals support
Date: Mon, 24 Jan 2011 11:17:47 +0200
Message-ID: <4D3D43BB.1060805@panasas.com>
References: <4D385C0A.3000901@suse.de>  <4D385F69.5060209@interlog.com> <1295541361.3014.8.camel@mulgrave.site> <4D3C100C.1010609@panasas.com> <4D3D327F.1040807@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:11481 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1AXJRw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2011 04:17:52 -0500
In-Reply-To: <4D3D327F.1040807@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, dgilbert@interlog.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 01/24/2011 10:04 AM, Hannes Reinecke wrote:
> On 01/23/2011 12:25 PM, Boaz Harrosh wrote:
>> On 01/20/2011 06:36 PM, James Bottomley wrote:
>>> On Thu, 2011-01-20 at 17:14 +0100, Douglas Gilbert wrote:
>>>> On 11-01-20 05:00 PM, Hannes Reinecke wrote:
>>>>> Agenda topic proposal:
>>>>>
>>>>> SCSI referrals support has already been discussed at last year's LSF
>>>>> conference. However, the solution proposed there would not support
>>>>> failover and would require quite a lot of changes to multipathing.
>>>>>
>>>>> To enable failover it might be an idea to handle the LUN directly in
>>>>> multipathing. This would require eg:
>>>>> - request splitting
>>>>> - I/O alignment handling
>>>>> - SCSI unit attention handling
>>>>>
>>>>> I would be giving a short overview/presentation of the current
>>>>> state of the art, the shortcomings on the original proposal,
>>>>> and would like to invite a discussion on how to best support
>>>>> SCSI referrals.
>>>>
>>>> IMO a worrying aspect of the changes associated with SCSI
>>>> referrals is that sense data can now be returned with any
>>>> SCSI status (i.e. not just CHECK CONDITION). How well would
>>>> the SCSI subsystem cope with that? I know that the sg driver
>>>> (and probably bsg) would need changes, as would my libsgutils
>>>> library used by sg3_utils.
>>>
>>> Well, not necessarily.  It scuppers plans to try to use the sense buffer
>>> more efficiently, but right at the moment, we can receive sense for any
>>> command.  We only actually look at it on a check condition return, but
>>> that's easily updated.
>>>
>>> As I read the standard, referrals sense data on successfully completed
>>> commands is only really relevant to mp implementations, so it looks like
>>> the mid-layer should ignore it anyway (as it would now) but provide a
>>> hook for the device handlers to see it if they wanted.
>>>
>>> James
>>>
>> Something like:
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index eafeeda..454e562 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -722,20 +722,23 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>>  			sense_deferred = scsi_sense_is_deferred(&sshdr);
>>  	}
>>  
>> +	if (req->sense) {
>> +		/*
>> +		 * SG_IO wants current and deferred errors
>> +		 */
>> +		int len = 8 + cmd->sense_buffer[7];
>> +
>> +		if (unlikely(len)) {
>> +			if (len > SCSI_SENSE_BUFFERSIZE)
>> +				len = SCSI_SENSE_BUFFERSIZE;

See here it will not crash

>> +			memcpy(req->sense, cmd->sense_buffer,  len);
>> +			req->sense_len = len;
>> +		}
>> +	}
>> +
>>  	if (req->cmd_type == REQ_TYPE_BLOCK_PC) { /* SG_IO ioctl from block level */
>>  		req->errors = result;
>>  		if (result) {
>> -			if (sense_valid && req->sense) {
>> -				/*
>> -				 * SG_IO wants current and deferred errors
>> -				 */
>> -				int len = 8 + cmd->sense_buffer[7];
>> -
>> -				if (len > SCSI_SENSE_BUFFERSIZE)
>> -					len = SCSI_SENSE_BUFFERSIZE;
>> -				memcpy(req->sense, cmd->sense_buffer,  len);
>> -				req->sense_len = len;
>> -			}
>>  			if (!sense_deferred)
>>  				error = -EIO;
>>  		}
>>
>> Then an interested user can just look at req->sense_len. The reset of the stack will
>> ignore all that because it looks for status/error-code.
>>
> Ah, if it were so easy. Currently sense codes have two problems:
> 
> - They are limited to 96 bytes. Anything larger than that will just
>   be discarded (or crash with your patch above :-)

It will not crash.

I have a patchset here that expands the request/scsi_cmnd sense_buffer
support to the maximum 260 bytes supported by the std.

If you want I can revive it. It is a sweep of all drivers, but a small
one, nothing like the accessors changes.

> - They inherit the same lifetime than the scsi command. But for any
>   decent handling you really need to push them into some
>   asynchronous context as you might well be within an interrupt
>   handler here.

No that's fine. request->sense is a user supplied buffer that extends
the life of scsi_cmnd. above code just copies from a scsi-layer dma-able
buffer to the request->sense buffer. interrupt-time is fine.

> I'm currently working on a handling framework using relayfs
> (basically blktrace for SCSI Unit Attention); I can be doing a short
> presentation at LSF if requested.
> 

That would be interesting. Thanks

> Cheers,
> 
> Hannes

Boaz
