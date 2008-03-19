From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] gdth: Use scsi_get_command for gdth internal commands
Date: Wed, 19 Mar 2008 11:57:23 +0200
Message-ID: <47E0E383.8000705@panasas.com>
References: <47E00779.3000701@panasas.com> <1205866479.2900.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8491 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752968AbYCSTxl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 15:53:41 -0400
In-Reply-To: <1205866479.2900.12.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sven Schnelle <svens@bitebene.org>

On Tue, Mar 18 2008 at 20:54 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Tue, 2008-03-18 at 20:18 +0200, Boaz Harrosh wrote:
>> This is for for the next kernel window (v2.6.26). It is based on top of
>> both scsi-misc and scsi-rc-fixes. Once scsi-misc rebases to scsi-rc-fixes
>> this patch can be committed.
>>
>> Boaz
>> ---
>> From: Boaz Harrosh <bharrosh@panasas.com>
>> Date: Tue, 11 Mar 2008 17:42:06 +0200
>> Subject: [PATCH] gdth: Use scsi_get_command for gdth internal commands
>>
>> use scsi_get_command() in __gdth_execute() of internal commands for two reasons.
>> - To be insulated from future scsi-ml changes and the way scsi_cmnd is
>>   structured / allocated.
>> - Hold onto the scsi_device while executing since execution can come from
>>   user-mode management SW through the gdth char device.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> Tested-by: Sven Schnelle <svens@bitebene.org>
>> ---
>>  drivers/scsi/gdth.c |   12 ++----------
>>  1 files changed, 2 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
>> index c6d6e7c..c6e2b8d 100644
>> --- a/drivers/scsi/gdth.c
>> +++ b/drivers/scsi/gdth.c
>> @@ -448,17 +448,10 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
>>      DECLARE_COMPLETION_ONSTACK(wait);
>>      int rval;
>>  
>> -    scp = kzalloc(sizeof(*scp), GFP_KERNEL);
>> +    scp = scsi_get_command(sdev, GFP_KERNEL);
>>      if (!scp)
>>          return -ENOMEM;
>>  
>> -    scp->sense_buffer = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
>> -    if (!scp->sense_buffer) {
>> -	kfree(scp);
>> -	return -ENOMEM;
>> -    }
>> -
>> -    scp->device = sdev;
>>      memset(&cmndinfo, 0, sizeof(cmndinfo));
>>  
>>      /* use request field to save the ptr. to completion struct. */
>> @@ -478,8 +471,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
>>      rval = cmndinfo.status;
>>      if (info)
>>          *info = cmndinfo.info;
>> -    kfree(scp->sense_buffer);
>> -    kfree(scp);
>> +    scsi_put_command(scp);
>>      return rval;
> 
> This needs to be the scsi_allocate_command/scsi_free_command interface.  Other than that, it looks fine.
> 
> James
> 
> 

No, I disagree, and I said that in the commit log above. I like how we take the
reference to the device by doing it through the scsi_device. __gdth_execute in
principle should have been using simple scsi_execute(). It does not because it
sends none_standard commands that would choke the midlayer. Actually once my
varlen patches go through we could easily convert it.

(In the USB case you are right)

Boaz
