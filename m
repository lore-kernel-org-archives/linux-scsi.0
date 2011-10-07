From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH] log unhandled scsi error and sense messages via SCSI_LOG
Date: Fri, 07 Oct 2011 15:42:32 -0400
Message-ID: <4E8F5628.1070605@redhat.com>
References: <1318010370-26976-1-git-send-email-revers@redhat.com> <1318011808.5071.90.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1JGTmg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2011 15:42:36 -0400
In-Reply-To: <1318011808.5071.90.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de

  On 10/07/2011 02:23 PM, James Bottomley wrote:
> On Fri, 2011-10-07 at 13:59 -0400, Rob Evers wrote:
>> ---
>>   drivers/scsi/scsi_lib.c |    6 ++++--
>>   1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index fc3f168..9905e2f 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -920,12 +920,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>>   			action = ACTION_FAIL;
>>   			break;
>>   		default:
>> -			description = "Unhandled sense code";
>> +			SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, cmd,
>> +							   "Unhandled sense code\n"));
>>   			action = ACTION_FAIL;
>>   			break;
>>   		}
>>   	} else {
>> -		description = "Unhandled error code";
>> +		SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, cmd,
>> +						   "Unhandled error code\n"));
> I just don't understand the necessity of this.  We're going to fail the
> command and we'd like someone to understand why.

As someone who looks at this code and try's to understand what
happens, I agree but this is not always the case with our general
consumers of this code.

> Before this patch we print
>
> sdX: Unhandled sense code
> sdX:<sense information>
> sdX:<command information>
>
> Which hopefully causes someone to investigate what the actual problem
> is.
>
> If I apply this patch we're going to print
>
> sdX:<sense information>
> sdX:<command information>
>
> Which is even less helpful.
>
> If you're seeing some error or sense code that's causing a common retry,
> then perhaps we should add it to the codes we check for instead of
> trying to hide it?

I only currently have one example of multiple unhandled error and sense 
conditions.

Perhaps I could collect the others.

> James
>
>

According to the report I got, there is no functional problem, just
noise in /var/log/messages when fabric faults are occurring.

This is occurring for both un-handled error and un-handled sense codes.

I've been asked to reduce the noise as "Unhandled error code" and
"Unhandled sense code" seem to be causing some concern.

Can you suggest something to reduce the user concerns but doesn't
loose the information as to what code path is executing before other
informational prints occur?

This is what I was trying to get at in the previous post where Mike
Christie suggested the message be 'softened' but then Hannes suggested
the change I have here.  Perhaps softening is the best course until all the
cases are collected and appropriate decisions are made regarding
the types of messages for each of them?

Rob
