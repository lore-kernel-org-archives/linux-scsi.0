From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] sg: Add target reset support
Date: Thu, 03 Jul 2008 11:15:30 -0500
Message-ID: <486CFB22.2080004@cs.wisc.edu>
References: <200807011803.m61I3OoD030274@d01av02.pok.ibm.com> <486ADCBC.3020608@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37440 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYGCQSz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2008 12:18:55 -0400
In-Reply-To: <486ADCBC.3020608@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Brian King wrote:
>> Adds support for target reset to SG_SCSI_RESET.
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/scsi/sg.c |    3 +++
>>  include/scsi/sg.h |    1 +
>>  2 files changed, 4 insertions(+)
>>
>> diff -puN drivers/scsi/sg.c~sg_target_reset drivers/scsi/sg.c
>> --- linux-2.6/drivers/scsi/sg.c~sg_target_reset    2008-06-16 
>> 15:34:16.000000000 -0500
>> +++ linux-2.6-bjking1/drivers/scsi/sg.c    2008-06-16 
>> 15:36:48.000000000 -0500
>> @@ -1026,6 +1026,9 @@ sg_ioctl(struct inode *inode, struct fil
>>          case SG_SCSI_RESET_DEVICE:
>>              val = SCSI_TRY_RESET_DEVICE;
>>              break;
>> +        case SG_SCSI_RESET_TARGET:
>> +            val = SCSI_TRY_RESET_TARGET;
>> +            break;
>>          case SG_SCSI_RESET_BUS:
>>              val = SCSI_TRY_RESET_BUS;
>>              break;
>> diff -puN include/scsi/sg.h~sg_target_reset include/scsi/sg.h
>> --- linux-2.6/include/scsi/sg.h~sg_target_reset    2008-06-16 
>> 15:36:05.000000000 -0500
>> +++ linux-2.6-bjking1/include/scsi/sg.h    2008-06-16 
>> 15:36:17.000000000 -0500
>> @@ -206,6 +206,7 @@ typedef struct sg_req_info { /* used by 
>>  #define        SG_SCSI_RESET_DEVICE    1
>>  #define        SG_SCSI_RESET_BUS    2
>>  #define        SG_SCSI_RESET_HOST    3
>> +#define        SG_SCSI_RESET_TARGET    4
>>  
>>  /* synchronous SCSI command ioctl, (only in version 3 interface) */
>>  #define SG_IO 0x2285   /* similar effect as write() followed by 
>> read() */
>> _
>>
> 
> Brian,
> Is SG_SCSI_RESET_DEVICE actually a Logical Unit Reset
> (as defined by SAM-4) on a modern LLD? If so perhaps a

I am working on it so all drivers follow that convention. I converted 
most drivers so they sent a target reset in the target reset handler and 
a lun reset in the device reset handler. Some of the patches for older 
or rare drivers/hardware I could not test did not get merged yet so they 
still do a target reset in the device reset handler. And for some 
drivers like ipr, which would send a lun reset, but could escalate to a 
target reset internally I was not sure what to do.
