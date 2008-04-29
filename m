From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] scsi: Add helper code so transport classes/driver
 can control queueing
Date: Tue, 29 Apr 2008 11:41:27 -0500
Message-ID: <48174FB7.2080805@cs.wisc.edu>
References: <1209442937-15130-1-git-send-email-michaelc@cs.wisc.edu> <1209442937-15130-2-git-send-email-michaelc@cs.wisc.edu> <4817271A.8020708@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43192 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbYD2Qlk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2008 12:41:40 -0400
In-Reply-To: <4817271A.8020708@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> 
> 
> michaelc@cs.wisc.edu wrote:
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index f6a9fe0..06b7b59 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -206,6 +206,16 @@ struct scsi_target {
>>                           * for the device at a time. */
>>      unsigned int        pdt_1f_for_no_lun;    /* PDT = 0x1f */
>>                          /* means no lun present */
>> +    /* commands actually active on LLD. protected by host lock. */
>> +    unsigned int        target_busy;
>> +    /*
>> +     * LLDs should set this in the slave_alloc host template callout.
>> +     * If set to zero then there is not limit.
>> +     */
>> +    unsigned int        can_queue;
>> +    unsigned int        target_blocked;
>> +    unsigned int        max_target_blocked;
>> +#define SCSI_DEFAULT_TARGET_BLOCKED    3
>>  
>>      char            scsi_level;
>>      struct execute_work    ew;
> 
> Mike,
> 
> The starget->can_queue value should come from the targets device_list 
> entry, not the LLD.
> 

I am not sure what you mean. How would the device_list->tgt_can_queue 
get set in the first place? Is there some scsi inquiry setting that can 
be parsed or are you saying it should be based on the 
scsi_device->queue_depth or cmd_per_lun?

> To complete this fully, if the LLD had a per-target resource restriction 
> (which I doubt
> would be target-specific), it should set a value within the shost 
> template much along the

I thought we were trying to not add new scsi_host_template fields for 
settings, so I was setting this like how we would set new blk_queue 
settings in the slave_alloc/config callouts.

Here is the patch for iscsi
http://git.kernel.org/?p=linux/kernel/git/mnc/linux-2.6-iscsi.git;a=commitdiff;h=3f78fae83155c4e1af72d0d8da18ac7fbc52aa38
I can move it but we wanted to be able to set this for each session. 
Instead of resetting the host_template value it seemed nicer to do this 
in the slave functions for each target.

The problem I have is that for bnx2i we have to preallocate X 
commands/itts for each session in the firmware/hardware. Each session 
than can only accept the amount of commands I tell the fw/hw about at 
session setup time. So a user can setup the driver so that session1 has 
a limit of X commands, but later create a second session to some other 
target that has a limit of Y commands.

What do you think?
