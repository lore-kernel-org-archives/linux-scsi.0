From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH] return all status bytes for sg io.
Date: Wed, 02 Jun 2004 16:42:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40BE65C9.7020301@us.ibm.com>
References: <40BDC726.7070004@cs.wisc.edu> <20040602193158.GB2401@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:47289 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S261862AbUFBXmo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jun 2004 19:42:44 -0400
In-Reply-To: <20040602193158.GB2401@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Jens Axboe wrote:
> On Wed, Jun 02 2004, Mike Christie wrote:
> 
>>Hi Jens,
>>
>>For block/scsi_ioctl.c only the status_byte is returned. However, when sg 
>>io is performed through a sg device the host, msg and driver bytes are 
>>passed back. I was not sure if this is a bug on the block layers part 
>>(becuase as you see in the patch, after the msg, host and driver bytes are 
>>zerod out they are tested), or is the bug in the app and it should be 
>>modifed to access sg devices instead of block devs. The attached patch was 
>>built against 2.6.7-rc2.
>>
>>Thanks,
>>
>>Mike
> 
> 
>>diff -arup linux-2.6.7-rc2/drivers/block/scsi_ioctl.c linux-2.6.7-rc2-work/drivers/block/scsi_ioctl.c
>>--- linux-2.6.7-rc2/drivers/block/scsi_ioctl.c	2004-05-29 23:26:48.000000000 -0700
>>+++ linux-2.6.7-rc2-work/drivers/block/scsi_ioctl.c	2004-06-02 04:32:27.000000000 -0700
>>@@ -185,11 +185,11 @@ static int sg_io(request_queue_t *q, str
>> 	blk_execute_rq(q, bd_disk, rq);
>> 
>> 	/* write to all output members */
>>-	hdr->status = rq->errors;	
>>-	hdr->masked_status = (hdr->status >> 1) & 0x1f;
>>-	hdr->msg_status = 0;
>>-	hdr->host_status = 0;
>>-	hdr->driver_status = 0;
>>+	hdr->status = 0xff & rq->errors;
>>+	hdr->masked_status = status_byte(rq->errors);
>>+	hdr->msg_status = msg_byte(rq->errors);
>>+	hdr->host_status = host_byte(rq->errors);
>>+	hdr->driver_status = driver_byte(rq->errors);
> 
> 
> For SCSI, this looks good. I need to look at ide-cd to be sure it's ok,
> did you verify this?
> 

For ide-cd I mostly executed sg commands while doing things like pulling
cables and or running on bad CD's to get SCSI stats like Busy and Check
Condidtion to verify that it worked like before my patch. As far as verifing the 
code it looked like ide-cd was just using the scsi status bits like ERROR_MAX 
mapped to SAMS_STAT_BUSY and for sense SAM_STAT_CHECK_CONDITION was set. I would 
occasionaly get Unknown status (0xb) with and without my patch when unplugging 
and replugging in the drive mulitple times. I was thinking this was due to the 
sense value ABORTED_COMMAND getting set to rq->errors similar to how ide-cd.c's 
ide_cdrom_prep_pc() sets rq->errors to ILLEGAL_REQUEST. Are those type of things 
bugs, or a result of not having a request_sense structure available and now 
other apps rely on this behavior?


-- 
Mike Christie
mikenc@us.ibm.com



