From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/4] sd: fix cache flushing message
Date: Wed, 29 Apr 2009 16:22:51 -0400
Message-ID: <49F8B71B.90707@garzik.org>
References: <200904292206.29844.bzolnier@gmail.com> <1241036401.3369.57.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:48033 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbZD2UWy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2009 16:22:54 -0400
In-Reply-To: <1241036401.3369.57.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-04-29 at 22:06 +0200, Bartlomiej Zolnierkiewicz wrote:
>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> ---
>> some minor sd.c fixups against linux-next
>>
>>  drivers/scsi/sd.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: b/drivers/scsi/sd.c
>> ===================================================================
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -2140,7 +2140,7 @@ static void sd_shutdown(struct device *d
>>  		return;         /* this can happen */
>>  
>>  	if (sdkp->WCE) {
>> -		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
>> +		sd_printk(KERN_NOTICE, sdkp, "Synchronizing disk cache\n");
>>  		sd_sync_cache(sdkp);
>>  	}
>>  
>> @@ -2161,7 +2161,7 @@ static int sd_suspend(struct device *dev
>>  		return 0;	/* this can happen */
>>  
>>  	if (sdkp->WCE) {
>> -		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
>> +		sd_printk(KERN_NOTICE, sdkp, "Synchronizing disk cache\n");
>>  		ret = sd_sync_cache(sdkp);
>>  		if (ret)
>>  			goto done;
> 
> So you want it to say 
> 
> sda: synchronizing disk cache
> 
> instead of
> 
> sda: synchronizing SCSI cache
> 
> I don't really see that buying us anything in terms of clarity.  What's
> the actual problem it solves?

Indeed.

And we can argue for weeks about English text, too.  Non-disk devices 
like SSDs have caches too, so I'd say "SCSI cache" is more accurate than 
"disk cache".  But maybe "SCSI writeback cache" would be even better.

	Jeff




