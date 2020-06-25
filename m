Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF3FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 14:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6699120781
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 14:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405590AbgFYOw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 10:52:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46121 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S2405536AbgFYOw6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2020 10:52:58 -0400
Received: (qmail 258042 invoked by uid 1000); 25 Jun 2020 10:52:56 -0400
Date:   Thu, 25 Jun 2020 10:52:56 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Bart Van Assche <bvanassche@acm.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200625145256.GA257526@rowland.harvard.edu>
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 25, 2020 at 10:16:06AM +0200, Martin Kepplinger wrote:
> On 24.06.20 15:33, Bart Van Assche wrote:
> > On 2020-06-23 04:10, Martin Kepplinger wrote:
> >> This add a very conservative but simple implementation for runtime PM
> >> to the sd scsi driver:
> >> Resume when opened (mounted) and suspend when released (unmounted).
> >>
> >> Improvements that allow suspending while a device is "open" can
> >> be added later, but now we save power when no filesystem is mounted
> >> and runtime PM is enabled.
> >>
> >> Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
> >> ---
> >>  drivers/scsi/sd.c | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> >> index d90fefffe31b..fe4cb7c50ec1 100644
> >> --- a/drivers/scsi/sd.c
> >> +++ b/drivers/scsi/sd.c
> >> @@ -1372,6 +1372,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
> >>  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"));
> >>  
> >>  	sdev = sdkp->device;
> >> +	scsi_autopm_get_device(sdev);
> >>  
> >>  	/*
> >>  	 * If the device is in error recovery, wait until it is done.
> >> @@ -1418,6 +1419,9 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
> >>  
> >>  error_out:
> >>  	scsi_disk_put(sdkp);
> >> +
> >> +	scsi_autopm_put_device(sdev);
> >> +
> >>  	return retval;	
> >>  }
> >>  
> >> @@ -1441,6 +1445,8 @@ static void sd_release(struct gendisk *disk, fmode_t mode)
> >>  
> >>  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
> >>  
> >> +	scsi_autopm_put_device(sdev);
> >> +
> >>  	if (atomic_dec_return(&sdkp->openers) == 0 && sdev->removable) {
> >>  		if (scsi_block_when_processing_errors(sdev))
> >>  			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
> > 
> > My understanding of the above patch is that it introduces a regression,
> > namely by disabling runtime suspend as long as an sd device is held open.
> > 
> > Bart.
> > 
> > 
> 
> hi Bart,
> 
> Alan says the same (on block request, the block layer should initiate a
> runtime resume), so merging with the thread from
> https://lore.kernel.org/linux-usb/8738e4d3-62b1-0144-107d-ff42000ed6c6@puri.sm/T/
> now and answer to both Bart and Alan here:]
> 
> I see scsi-pm.c using the blk-pm.c API but I'm not sure how the block
> layer would itself resume the scsi device (I use it via usb_storage, so
> that usb_stor_resume() follows in my case but I guess that doesn't
> matter here):

The block layer does this in block/blk-core.c:blk_queue_enter(), as part 
of the condition check in the call to wait_event() near the end of the 
function.  The blk_pm_request_resume() inline routine calls 
pm_request_resume().

At least, that's what is _supposed_ to happen.  See commit 0d25bd072b49 
("block: Schedule runtime resume earlier").

> my understanding of "sd" is: enable runtime pm in probe(), so *allow*
> the device to be suspended (if enabled by the user), but never
> resume(?). Also, why isn't "autopm" used in its ioctl() implementation
> (as opposed to in "sr")?

I don't remember the reason.  It may be that the code in sr.c isn't 
needed.

> here's roughly what happens when enabling runtime PM in sysfs (again,
> because sd_probe() calls autopm_put() and thus allows it:
> 
> [   27.384446] sd 0:0:0:0: scsi_runtime_suspend
> [   27.432282] blk_pre_runtime_suspend
> [   27.435783] sd_suspend_common
> [   27.438782] blk_post_runtime_suspend
> [   27.442427] scsi target0:0:0: scsi_runtime_suspend
> [   27.447303] scsi host0: scsi_runtime_suspend
> 
> then I "mount /dev/sda1 /mnt" and none of the resume() functions get
> called. To me it looks like the sd driver should initiate resuming, and
> that's not implemented.
> 
> what am I doing wrong or overlooking? how exactly does (or should) the
> block layer initiate resume here?

I don't know what's going wrong.  Bart, can you look into it?  As far as I 
can tell, you're the last person to touch the block-layer's runtime PM 
code.

Alan Stern
