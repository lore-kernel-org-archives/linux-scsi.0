From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Thu, 01 Feb 2007 15:02:22 -0500
Message-ID: <45C2474E.9030306@rtr.ca>
References: <200701301947.08478.liml@rtr.ca> <1170206199.10890.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1170206199.10890.13.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2007-01-30 at 19:47 -0500, Mark Lord wrote:
>> Kernels since about 2.6.16 or so have been broken in this regard.
>> They "complete" the good sectors before the error,
>> and then fail the entire remaining portions of the request.
> 
> What was the commit that introduced the change? ... I have a vague
> memory of it being deliberate.

I believe you made the first change in response to my prodding at the time,
when libata was not returning valid sense data (no LBA) for media errors.
The SCSI EH handling of that was rather poor at the time,
and so having it not retry the remaining sectors was actually
a very good fix at the time.

But now, libata *does* return valid sense data for LBA/DMA drives,
and the workaround from circa 2.6.16 is no longer the best we can do.
Now that we know which sector failed, we ought to be able to skip
over it, and continue with the rest of the merged request.

One thing that could be even better than the patch below,
would be to have it perhaps skip the entire bio that includes
the failed sector, rather than only the bad sector itself.

I think doing that might address most concerns expressed here.
Have you got an alternate suggestion, James?

..
>> Signed-off-by:  Mark Lord <mlord@pobox.com>
>> ---
>> diff -u --recursive --new-file --exclude-from=linux_17//Documentation/dontdiff old/drivers/scsi/scsi_lib.c linux/drivers/scsi/scsi_lib.c
>> --- old/drivers/scsi/scsi_lib.c	2007-01-30 13:58:05.000000000 -0500
>> +++ linux/drivers/scsi/scsi_lib.c	2007-01-30 18:30:01.000000000 -0500
>> @@ -865,6 +865,12 @@
>>  	 */
>>  	if (sense_valid && !sense_deferred) {
>>  		switch (sshdr.sense_key) {
>> +		case MEDIUM_ERROR:
>> +			// Bad sector.  Fail it, and then continue the rest of the request:
>> +			if (scsi_end_request(cmd, 0, cmd->device->sector_size, 1) == NULL) {
> 
> The sense key may have come with additional information  I think we want
> to parse that (if it exists) rather than just blindly failing the first
> sector of the request.
> 
>> +				cmd->retries = 0;	// go around again..
>> +				return;
>> +			}
> 
> This would drop through to the UNIT_ATTENTION case if scsi_end_request()
> fails ... I don't think that's correct.
> 
>>  		case UNIT_ATTENTION:
>>  			if (cmd->device->removable) {
>>  				/* Detected disc change.  Set a bit
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

