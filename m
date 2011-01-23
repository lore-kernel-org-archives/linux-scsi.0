From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [LSF/MM TOPIC] SCSI referrals support
Date: Sun, 23 Jan 2011 13:25:00 +0200
Message-ID: <4D3C100C.1010609@panasas.com>
References: <4D385C0A.3000901@suse.de>  <4D385F69.5060209@interlog.com> <1295541361.3014.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:55987 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1AWLZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jan 2011 06:25:03 -0500
In-Reply-To: <1295541361.3014.8.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: dgilbert@interlog.com, Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 01/20/2011 06:36 PM, James Bottomley wrote:
> On Thu, 2011-01-20 at 17:14 +0100, Douglas Gilbert wrote:
>> On 11-01-20 05:00 PM, Hannes Reinecke wrote:
>>> Agenda topic proposal:
>>>
>>> SCSI referrals support has already been discussed at last year's LSF
>>> conference. However, the solution proposed there would not support
>>> failover and would require quite a lot of changes to multipathing.
>>>
>>> To enable failover it might be an idea to handle the LUN directly in
>>> multipathing. This would require eg:
>>> - request splitting
>>> - I/O alignment handling
>>> - SCSI unit attention handling
>>>
>>> I would be giving a short overview/presentation of the current
>>> state of the art, the shortcomings on the original proposal,
>>> and would like to invite a discussion on how to best support
>>> SCSI referrals.
>>
>> IMO a worrying aspect of the changes associated with SCSI
>> referrals is that sense data can now be returned with any
>> SCSI status (i.e. not just CHECK CONDITION). How well would
>> the SCSI subsystem cope with that? I know that the sg driver
>> (and probably bsg) would need changes, as would my libsgutils
>> library used by sg3_utils.
> 
> Well, not necessarily.  It scuppers plans to try to use the sense buffer
> more efficiently, but right at the moment, we can receive sense for any
> command.  We only actually look at it on a check condition return, but
> that's easily updated.
> 
> As I read the standard, referrals sense data on successfully completed
> commands is only really relevant to mp implementations, so it looks like
> the mid-layer should ignore it anyway (as it would now) but provide a
> hook for the device handlers to see it if they wanted.
> 
> James
> 
Something like:
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index eafeeda..454e562 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -722,20 +722,23 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			sense_deferred = scsi_sense_is_deferred(&sshdr);
 	}
 
+	if (req->sense) {
+		/*
+		 * SG_IO wants current and deferred errors
+		 */
+		int len = 8 + cmd->sense_buffer[7];
+
+		if (unlikely(len)) {
+			if (len > SCSI_SENSE_BUFFERSIZE)
+				len = SCSI_SENSE_BUFFERSIZE;
+			memcpy(req->sense, cmd->sense_buffer,  len);
+			req->sense_len = len;
+		}
+	}
+
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC) { /* SG_IO ioctl from block level */
 		req->errors = result;
 		if (result) {
-			if (sense_valid && req->sense) {
-				/*
-				 * SG_IO wants current and deferred errors
-				 */
-				int len = 8 + cmd->sense_buffer[7];
-
-				if (len > SCSI_SENSE_BUFFERSIZE)
-					len = SCSI_SENSE_BUFFERSIZE;
-				memcpy(req->sense, cmd->sense_buffer,  len);
-				req->sense_len = len;
-			}
 			if (!sense_deferred)
 				error = -EIO;
 		}

Then an interested user can just look at req->sense_len. The reset of the stack will
ignore all that because it looks for status/error-code.

I was needing something like that as well but it's to do with advance
storage maintenance, that's far down the road.

Thanks
Boaz
 
