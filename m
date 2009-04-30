From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 1/4] sd: fix cache flushing message
Date: Thu, 30 Apr 2009 14:32:31 +0200
Message-ID: <200904301432.31548.bzolnier@gmail.com>
References: <200904292206.29844.bzolnier@gmail.com> <200904292354.03136.bzolnier@gmail.com> <49F98D04.9010005@interlog.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:52804 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZD3M2a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2009 08:28:30 -0400
Received: by wa-out-1112.google.com with SMTP id j5so977419wah.21
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2009 05:28:30 -0700 (PDT)
In-Reply-To: <49F98D04.9010005@interlog.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

On Thursday 30 April 2009 13:35:32 Douglas Gilbert wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 29 April 2009 23:14:02 James Bottomley wrote:
> >> On Wed, 2009-04-29 at 22:53 +0200, Bartlomiej Zolnierkiewicz wrote:
> >>> On Wednesday 29 April 2009 22:22:51 Jeff Garzik wrote:
> >>>> James Bottomley wrote:
> >>>>> On Wed, 2009-04-29 at 22:06 +0200, Bartlomiej Zolnierkiewicz wrote:
> >>>>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >>>>>> ---
> >>>>>> some minor sd.c fixups against linux-next
> >>>>>>
> >>>>>>  drivers/scsi/sd.c |    4 ++--
> >>>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>>>>
> >>>>>> Index: b/drivers/scsi/sd.c
> >>>>>> ===================================================================
> >>>>>> --- a/drivers/scsi/sd.c
> >>>>>> +++ b/drivers/scsi/sd.c
> >>>>>> @@ -2140,7 +2140,7 @@ static void sd_shutdown(struct device *d
> >>>>>>  		return;         /* this can happen */
> >>>>>>  
> >>>>>>  	if (sdkp->WCE) {
> >>>>>> -		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> >>>>>> +		sd_printk(KERN_NOTICE, sdkp, "Synchronizing disk cache\n");
> >>>>>>  		sd_sync_cache(sdkp);
> >>>>>>  	}
> >>>>>>  
> >>>>>> @@ -2161,7 +2161,7 @@ static int sd_suspend(struct device *dev
> >>>>>>  		return 0;	/* this can happen */
> >>>>>>  
> >>>>>>  	if (sdkp->WCE) {
> >>>>>> -		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> >>>>>> +		sd_printk(KERN_NOTICE, sdkp, "Synchronizing disk cache\n");
> >>>>>>  		ret = sd_sync_cache(sdkp);
> >>>>>>  		if (ret)
> >>>>>>  			goto done;
> >>>>> So you want it to say 
> >>>>>
> >>>>> sda: synchronizing disk cache
> >>>>>
> >>>>> instead of
> >>>>>
> >>>>> sda: synchronizing SCSI cache
> >>>>>
> >>>>> I don't really see that buying us anything in terms of clarity.  What's
> >>>>> the actual problem it solves?
> >>> Inconsistent kernel messages:
> >>>
> >>> 	if (sdkp->WCE) {
> >>> 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> >>> 		sd_sync_cache(sdkp);
> >>> 	}
> >>>
> >>> 	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
> >>> 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
> >>> 		sd_start_stop_device(sdkp, 0);
> >>> 	}
> >>>
> >>>> Indeed.
> >>>>
> >>>> And we can argue for weeks about English text, too.  Non-disk devices 
> >>> Or we can just apply the patch and go back with the program.
> >>>
> >>>> like SSDs have caches too, so I'd say "SCSI cache" is more accurate than 
> >>>> "disk cache".  But maybe "SCSI writeback cache" would be even better.
> >>> Could you please explain me what *SCSI* cache is?
> >> It's the cache described by SBC (SCSI Block Commandset).
> > 
> > Sorry, I don't buy it.
> > 
> > There is no "SCSI cache" in the SBC spec (at least not in sbc2r16).
> 
> The search function must be faulty on your pdf viewer.
>      sbc2r16 section 4.10
>      sbc3r18 section 4.12
> The timing of writing back volatile and non-volatile
> caches is also discussed in several places in spc4r18.

Still no "SCSI cache"... but maybe it is really Adobe Reader's fault... ;)

> Note that t10 and t13 standards do not necessarily prefix
> terms with "SCSI" or "ATA" unless there is room for
> confusion. For example "device" is such an overused term
> that d2015r1-ATAATAPI_Command_Set_-_2_ACS-2.pdf defines both
> "ATA device" and "device" to be the same thing.
> 
> In the context of an OS storage system unadorned terms like
> "device" and "cache" are imprecise because the kernel
> uses these terms for its own purposes (e.g. an ATA host
> is a (PCI bus) device to the kernel).
> 
> So the discussion is about a cache, or caches, that
> reside on a SCSI logical unit or SCSI target. In ATA
> land that would be an ATA or ATAPI device.

cache in this context is a sd device's property -- be it SCSI logical unit,
SCSI target or ATA device so "SCSI cache" is much worse than "device cache"
(or "disk cache") because you really don't know what the SCSI is about
there, i.e. it can be about Linux storage subsystem.

Please also try to look beyond SCSI/ATA/storage person's POV and think what
would the the _average_ user answer inquired about "SCSI cache" (then please
repeat the exercise using "disk cache" or "device cache" instead).

Hmm.. on the second thought I may have a better solution which avoids using
"disk" naming completely and shrinks kernel size by 10 bytes as a bonus!! ;)

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH v2] sd: fix cache flushing message

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/sd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/sd.c
===================================================================
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2140,7 +2140,7 @@ static void sd_shutdown(struct device *d
 		return;         /* this can happen */
 
 	if (sdkp->WCE) {
-		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
+		sd_printk(KERN_NOTICE, sdkp, "Synchronizing cache\n");
 		sd_sync_cache(sdkp);
 	}
 
@@ -2161,7 +2161,7 @@ static int sd_suspend(struct device *dev
 		return 0;	/* this can happen */
 
 	if (sdkp->WCE) {
-		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
+		sd_printk(KERN_NOTICE, sdkp, "Synchronizing cache\n");
 		ret = sd_sync_cache(sdkp);
 		if (ret)
 			goto done;
