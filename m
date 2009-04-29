From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 1/4] sd: fix cache flushing message
Date: Wed, 29 Apr 2009 23:54:02 +0200
Message-ID: <200904292354.03136.bzolnier@gmail.com>
References: <200904292206.29844.bzolnier@gmail.com> <200904292253.07817.bzolnier@gmail.com> <1241039642.3369.67.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:29043 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbZD2Vtq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 17:49:46 -0400
Received: by mu-out-0910.google.com with SMTP id i2so529385mue.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2009 14:49:45 -0700 (PDT)
In-Reply-To: <1241039642.3369.67.camel@mulgrave.int.hansenpartnership.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

On Wednesday 29 April 2009 23:14:02 James Bottomley wrote:
> On Wed, 2009-04-29 at 22:53 +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 29 April 2009 22:22:51 Jeff Garzik wrote:
> > > James Bottomley wrote:
> > > > On Wed, 2009-04-29 at 22:06 +0200, Bartlomiej Zolnierkiewicz wrote:
> > > >> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > >> ---
> > > >> some minor sd.c fixups against linux-next
> > > >>
> > > >>  drivers/scsi/sd.c |    4 ++--
> > > >>  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >>
> > > >> Index: b/drivers/scsi/sd.c
> > > >> ===================================================================
> > > >> --- a/drivers/scsi/sd.c
> > > >> +++ b/drivers/scsi/sd.c
> > > >> @@ -2140,7 +2140,7 @@ static void sd_shutdown(struct device *d
> > > >>  		return;         /* this can happen */
> > > >>  
> > > >>  	if (sdkp->WCE) {
> > > >> -		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> > > >> +		sd_printk(KERN_NOTICE, sdkp, "Synchronizing disk cache\n");
> > > >>  		sd_sync_cache(sdkp);
> > > >>  	}
> > > >>  
> > > >> @@ -2161,7 +2161,7 @@ static int sd_suspend(struct device *dev
> > > >>  		return 0;	/* this can happen */
> > > >>  
> > > >>  	if (sdkp->WCE) {
> > > >> -		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> > > >> +		sd_printk(KERN_NOTICE, sdkp, "Synchronizing disk cache\n");
> > > >>  		ret = sd_sync_cache(sdkp);
> > > >>  		if (ret)
> > > >>  			goto done;
> > > > 
> > > > So you want it to say 
> > > > 
> > > > sda: synchronizing disk cache
> > > > 
> > > > instead of
> > > > 
> > > > sda: synchronizing SCSI cache
> > > > 
> > > > I don't really see that buying us anything in terms of clarity.  What's
> > > > the actual problem it solves?
> > 
> > Inconsistent kernel messages:
> > 
> > 	if (sdkp->WCE) {
> > 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> > 		sd_sync_cache(sdkp);
> > 	}
> > 
> > 	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
> > 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
> > 		sd_start_stop_device(sdkp, 0);
> > 	}
> > 
> > > Indeed.
> > > 
> > > And we can argue for weeks about English text, too.  Non-disk devices 
> > 
> > Or we can just apply the patch and go back with the program.
> > 
> > > like SSDs have caches too, so I'd say "SCSI cache" is more accurate than 
> > > "disk cache".  But maybe "SCSI writeback cache" would be even better.
> > 
> > Could you please explain me what *SCSI* cache is?
> 
> It's the cache described by SBC (SCSI Block Commandset).

Sorry, I don't buy it.

There is no "SCSI cache" in the SBC spec (at least not in sbc2r16).

> > Does ATA disks have *SCSI* cache (whatever it is)?
> 
> Only if you use it via SAT (SCSI to ATA translation).

Hmm, and without SAT there is ATA cache, right? :)

> > Please also note that sd.c uses "disk" all over the place.
> 
> Yes, but I think the four other suggestions for text demonstrate the
> need to get something worm proof back on this can ASAP.

Well, "SCSI device writeback cache" should be fine with everybody, no? ;)

Anyway, please just scrap that patch.

Thanks,
Bart
