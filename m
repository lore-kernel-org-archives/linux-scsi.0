From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/4] sd: fix cache flushing message
Date: Thu, 30 Apr 2009 13:35:32 +0200
Message-ID: <49F98D04.9010005@interlog.com>
References: <200904292206.29844.bzolnier@gmail.com> <200904292253.07817.bzolnier@gmail.com> <1241039642.3369.67.camel@mulgrave.int.hansenpartnership.com> <200904292354.03136.bzolnier@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54557 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763390AbZD3Lfh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2009 07:35:37 -0400
In-Reply-To: <200904292354.03136.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 29 April 2009 23:14:02 James Bottomley wrote:
>> On Wed, 2009-04-29 at 22:53 +0200, Bartlomiej Zolnierkiewicz wrote:
>>> On Wednesday 29 April 2009 22:22:51 Jeff Garzik wrote:
>>>> James Bottomley wrote:
>>>>> On Wed, 2009-04-29 at 22:06 +0200, Bartlomiej Zolnierkiewicz wrote:
>>>>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>>>> ---
>>>>>> some minor sd.c fixups against linux-next
>>>>>>
>>>>>>  drivers/scsi/sd.c |    4 ++--
>>>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> Index: b/drivers/scsi/sd.c
>>>>>> ===================================================================
>>>>>> --- a/drivers/scsi/sd.c
>>>>>> +++ b/drivers/scsi/sd.c
>>>>>> @@ -2140,7 +2140,7 @@ static void sd_shutdown(struct device *d
>>>>>>  		return;         /* this can happen */
>>>>>>  
>>>>>>  	if (sdkp->WCE) {
>>>>>> -		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
>>>>>> +		sd_printk(KERN_NOTICE, sdkp, "Synchronizing disk cache\n");
>>>>>>  		sd_sync_cache(sdkp);
>>>>>>  	}
>>>>>>  
>>>>>> @@ -2161,7 +2161,7 @@ static int sd_suspend(struct device *dev
>>>>>>  		return 0;	/* this can happen */
>>>>>>  
>>>>>>  	if (sdkp->WCE) {
>>>>>> -		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
>>>>>> +		sd_printk(KERN_NOTICE, sdkp, "Synchronizing disk cache\n");
>>>>>>  		ret = sd_sync_cache(sdkp);
>>>>>>  		if (ret)
>>>>>>  			goto done;
>>>>> So you want it to say 
>>>>>
>>>>> sda: synchronizing disk cache
>>>>>
>>>>> instead of
>>>>>
>>>>> sda: synchronizing SCSI cache
>>>>>
>>>>> I don't really see that buying us anything in terms of clarity.  What's
>>>>> the actual problem it solves?
>>> Inconsistent kernel messages:
>>>
>>> 	if (sdkp->WCE) {
>>> 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
>>> 		sd_sync_cache(sdkp);
>>> 	}
>>>
>>> 	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
>>> 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>>> 		sd_start_stop_device(sdkp, 0);
>>> 	}
>>>
>>>> Indeed.
>>>>
>>>> And we can argue for weeks about English text, too.  Non-disk devices 
>>> Or we can just apply the patch and go back with the program.
>>>
>>>> like SSDs have caches too, so I'd say "SCSI cache" is more accurate than 
>>>> "disk cache".  But maybe "SCSI writeback cache" would be even better.
>>> Could you please explain me what *SCSI* cache is?
>> It's the cache described by SBC (SCSI Block Commandset).
> 
> Sorry, I don't buy it.
> 
> There is no "SCSI cache" in the SBC spec (at least not in sbc2r16).

The search function must be faulty on your pdf viewer.
     sbc2r16 section 4.10
     sbc3r18 section 4.12
The timing of writing back volatile and non-volatile
caches is also discussed in several places in spc4r18.

Note that t10 and t13 standards do not necessarily prefix
terms with "SCSI" or "ATA" unless there is room for
confusion. For example "device" is such an overused term
that d2015r1-ATAATAPI_Command_Set_-_2_ACS-2.pdf defines both
"ATA device" and "device" to be the same thing.

In the context of an OS storage system unadorned terms like
"device" and "cache" are imprecise because the kernel
uses these terms for its own purposes (e.g. an ATA host
is a (PCI bus) device to the kernel).

So the discussion is about a cache, or caches, that
reside on a SCSI logical unit or SCSI target. In ATA
land that would be an ATA or ATAPI device.

Doug Gilbert


>>> Does ATA disks have *SCSI* cache (whatever it is)?
>> Only if you use it via SAT (SCSI to ATA translation).
> 
> Hmm, and without SAT there is ATA cache, right? :)
> 
>>> Please also note that sd.c uses "disk" all over the place.
>> Yes, but I think the four other suggestions for text demonstrate the
>> need to get something worm proof back on this can ASAP.
> 
> Well, "SCSI device writeback cache" should be fine with everybody, no? ;)
> 
> Anyway, please just scrap that patch.

