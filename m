From: Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH] SCSI: sd: don't fail if the device doesn't recognize
 SYNCHRONIZE CACHE
Date: Mon, 17 Feb 2014 12:33:45 +0100
Message-ID: <5301F399.9070301@zonque.org>
References: <Pine.LNX.4.44L0.1401151533360.1587-100000@iolanthe.rowland.org> <52F21AB1.8030003@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:33011 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaBQLdu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Feb 2014 06:33:50 -0500
In-Reply-To: <52F21AB1.8030003@zonque.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sven Neumann <s.neumann@raumfeld.com>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On 02/05/2014 12:04 PM, Daniel Mack wrote:
> On 01/15/2014 09:37 PM, Alan Stern wrote:
>> Evidently some wacky USB-ATA bridges don't recognize the SYNCHRONIZE
>> CACHE command, as shown in this email thread:
>>
>> 	http://marc.info/?t=138978356200002&r=1&w=2
>>
>> The fact that we can't tell them to drain their caches shouldn't
>> prevent the system from going into suspend.  Therefore sd_sync_cache()
>> shouldn't return an error if the device replies with an Invalid
>> Command ASC.
>>
>> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>> Reported-by: Sven Neumann <s.neumann@raumfeld.com>
>> Tested-by: Daniel Mack <zonque@gmail.com>
>> CC: Oliver Neukum <oliver@neukum.org>
>> CC: <stable@vger.kernel.org>
> 
> Any objections about this patch? It would be good to get it merged for
> 3.14, if possible.

Ping? Did anyone queue this one up?


Thanks,
Daniel


>>  drivers/scsi/sd.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: usb-3.13/drivers/scsi/sd.c
>> ===================================================================
>> --- usb-3.13.orig/drivers/scsi/sd.c
>> +++ usb-3.13/drivers/scsi/sd.c
>> @@ -1463,8 +1463,8 @@ static int sd_sync_cache(struct scsi_dis
>>  			sd_print_sense_hdr(sdkp, &sshdr);
>>  		/* we need to evaluate the error return  */
>>  		if (scsi_sense_valid(&sshdr) &&
>> -			/* 0x3a is medium not present */
>> -			sshdr.asc == 0x3a)
>> +			(sshdr.asc == 0x3a ||	/* medium not present */
>> +			 sshdr.asc == 0x20))	/* invalid command */
>>  				/* this is no error here */
>>  				return 0;
>>  
>>
> 

