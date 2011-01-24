From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi: Erroneous handling of sense status in SCSI EH commands
Date: Mon, 24 Jan 2011 14:17:03 -0600
Message-ID: <4D3DDE3F.2030902@cs.wisc.edu>
References: <1295597274-5844-1-git-send-email-hare@suse.de> <4D39F16A.5020002@cs.wisc.edu> <4D3D317D.6060403@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51095 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1AXUQz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2011 15:16:55 -0500
In-Reply-To: <4D3D317D.6060403@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@suse.de>, linux-scsi@vger.kernel.org

On 01/24/2011 01:59 AM, Hannes Reinecke wrote:
> On 01/21/2011 09:49 PM, Mike Christie wrote:
>> On 01/21/2011 02:07 AM, Hannes Reinecke wrote:
>>> Consider a scenario where a SCSI EH command like TUR fails with a NOT
>>> READY
>>> status - MANUAL INTERVENTION REQUIRED (02/04/03). As evident in the
>>> ASC/ASCQ
>>> description, manual intervention is required in this case i.e. the
>>> target wants
>>> TUR to fail here so that the host administrator can take corrective
>>> action.
>>>
>>> But this particular ASC/ASCQ is not handled in the scsi_check_sense,
>>> which
>>> ultimately causes scsi_eh_tur to erroneously report a SUCCESS (device
>>> ready)
>>> instead of the actual FAILURE state (device not ready).
>>>
>>> This patch converts scsi_check_sense() to return SOFT_ERROR in
>>> cases where an error has been signalled via the sense code, but
>>> we should not wake the error handler. This error code will be
>>> reverted back to SUCCESS for normal command handling, but
>>> scsi_eh_completed_normally() will convert it to FAILED.
>>>
>>> Reported-by: Martin George<marting@netapp.com>
>>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>>>
>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>>> index 45c7564..e86e62e 100644
>>> --- a/drivers/scsi/scsi_error.c
>>> +++ b/drivers/scsi/scsi_error.c
>>> @@ -223,7 +223,7 @@ static inline void scsi_eh_prt_fail_stats(struct
>>> Scsi_Host *shost,
>>>     * @scmd:    Cmd to have sense checked.
>>>     *
>>>     * Return value:
>>> - *     SUCCESS or FAILED or NEEDS_RETRY
>>> + *     SUCCESS or FAILED or NEEDS_RETRY or SOFT_ERROR
>>>     *
>>>     * Notes:
>>>     *    When a deferred error is detected the current command has
>>> @@ -278,7 +278,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>>>
>>>        case ABORTED_COMMAND:
>>>            if (sshdr.asc == 0x10) /* DIF */
>>> -            return SUCCESS;
>>> +            return SOFT_ERROR;
>>>
>>>            return NEEDS_RETRY;
>>>        case NOT_READY:
>>> @@ -324,19 +324,19 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>>>             * Pass the UA upwards for a determination in the completion
>>>             * functions.
>>>             */
>>> -        return SUCCESS;
>>> +        return SOFT_ERROR;
>>>
>>
>>
>> For normal IO execution the UA, not ready, and illegal request handling
>> in scsi_io_completion would determine that some of these are retryable
>> conditions, but with the patch in the scsi_error.cs path we will return
>> soft error and fail. Also a lot of these that were retryable were
>> returned as success in the past, but with the patch are being failed.
>>
> No. scsi_check_sense() is not called from scsi_io_completion; that

I did not say that it was. It is not directly called by 
scsi_io_completion, but for the normal IO completion path 
scsi_check_sense is called by scsi_decide_disposition and eventually 
scsi_io_completion is then called once we go through the ULD handling.

> just calls scsi_normalize_sense().
> scsi_check_sense() is only called from
>
> - scsi_eh_completed_normally()
> - scsi_eh_stu()
> - scsi_decide_disposition()
>
> All of which have been checked against this patch.
> scsi_io_completion() has it's own set of checks for sense codes
> which I don't modify here.

I am saying I think we need the extra checks from scsi_io_completion or 
we need something like it in the scsi eh path, or the scsi eh is going 
to fail when it could have succeeded. For normal IO, 
scsi_decide_disposition would call scsi_check_sense, and 
scsi_check_sense would return SUCCESS on some UA or not ready and 
illegal requests. Then later scsi_io_completion would look at the 
asc/ascq in more depth and retry in a lot of situations.

With your patch all those IOs that would be determined by 
scsi_io_completion to be retryable are now returned as SOFT_ERROR in 
scsi_check_sense and so scsi_eh_completed_normally will see SOFT_ERROR 
and fail them.

For example, with your patch if for the 
scsi_send_eh_cmnd/scsi_eh_completed_normally/scsi_check_sense path we 
got 02/04/01 (not ready - becomming ready), scsi_send_eh_cmnd would see 
SOFT_ERROR and fail the scsi eh. And, I am saying don't we want retry 
this like we would if we were going through the normal IO path, so we do 
not offline devices on this type of failure?


>
>> Martin made me the same bugzilla :) I was thinking we needed to make
>> check_sense smarter or move some of the scsi_io_completion code to some
>> lib helpers so scsi_error.c could call them.
>>
>> And does scsi_eh_stu need to be covnerted to check for soft error and
>> failed.
>>
> No. scsi_eh_stu() needs to check if a START STOP UNIT command needs
> to be send. The trigger for this is that scsi_check_sense() returns
> FAILED:
>

Ah yeah, my mistake.

>
>> Also if we did this patch, then I think we also have to convert the
>> device handlers.
> Not necessarily. This patch just allows check_sense() to return
> an additional error code; the device handlers are not forced to
> use them. If they don't things will work like before.
>

Maybe I should have written, don't we want to fix them too. For example 
if alua_check_sense got 02/04/12 it returns SUCCESS, and expects the IO 
to be failed, right? With your patch the 
scsi_send_eh_cmnd/scsi_eh_completed_normally/scsi_check_sense path will 
still see the SUCCESS and propagate that upwards and you hit the problem 
where the scsi eh should have failed the eh but let it succeed.
