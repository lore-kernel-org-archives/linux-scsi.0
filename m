From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 9/9] scsi_error: do not display kernel pointer in message
 logs
Date: Sun, 11 Jan 2015 13:39:22 -0500
Message-ID: <54B2C35A.4050005@interlog.com>
References: <1420699430-9492-1-git-send-email-hare@suse.de> <1420699430-9492-10-git-send-email-hare@suse.de> <94D0CD8314A33A4D9D801C0FE68B40295A730091@G9W0745.americas.hpqcorp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:42645 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbbAKSjm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Jan 2015 13:39:42 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A730091@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 15-01-10 02:17 PM, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
>> Sent: Thursday, January 08, 2015 12:44 AM
>> To: James Bottomley
>> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Hannes Reinecke
>> Subject: [PATCH 9/9] scsi_error: do not display kernel pointer in
>> message logs
>>
>> It is not good practice to display the kernel pointer
>> in any message logs, and it doesn't display any additional
>> information. And as we know have block-layer assigned tags
>> we can use them to differentiate the messages.
>> So remove any pointer references from the displayed messages.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi_error.c | 49 +++++++++++++++++++---------------------
>> -------
>>   1 file changed, 20 insertions(+), 29 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index e42fff6..10ffa21 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -124,41 +124,37 @@ scmd_eh_abort_handler(struct work_struct *work)
> ...
>>   				SCSI_LOG_ERROR_RECOVERY(3,
>>   					scmd_printk(KERN_INFO, scmd,
>> -						    "scmd %p eh timeout, "
>> -						    "not retrying aborted "
>> -						    "command\n", scmd));
>> +						    "eh timeout, not retrying "
>> +						    "aborted command\n"));
>
> checkpatch allows/encourages keeping strings on one line even when
> they go past the 80th column.  So, I recommend joining those two
> lines.

Which in turn conflicts with cleanfile which is another kernel
supplied utility. So I would suggest checkpatch should back off
with that particular warning (and several other of its nags).
Also new code (say a complete new function) should be treated
differently compared to a patch (e.g. the 2 lines shown above)
on existing code.

I use cleanfile in the user space since it warns of lines
greater than 79 characters and trims trailing spaces
(whitespaces ?) from the end of a line. And I would never use
checkpatch in the user space since the coherence of the
resulting source is much more important than the route to
get there :-)

Doug Gilbert


