From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sd: fix race between rescan and remove
Date: Fri, 04 Nov 2005 11:45:08 -0600
Message-ID: <1131126308.3532.34.camel@mulgrave>
References: <Pine.LNX.4.44L0.0511041039180.4812-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:9904 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750763AbVKDRpM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 12:45:12 -0500
In-Reply-To: <Pine.LNX.4.44L0.0511041039180.4812-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2005-11-04 at 11:40 -0500, Alan Stern wrote:
> On Thu, 3 Nov 2005, James Bottomley wrote:
> 
> > Thanks for investigating this ... I really hate debugging these obscure
> > object reference races.
> 
> Yeah, it was a real pain to find the cause.  Took most of two days.  And 
> yet it should have been obvious where to look...

That's what I usually end up saying after days of staring at the
code ...

> > I'm afraid that your fix isn't quite right:  The problem occurs because
> > in most cases scsi_remove_device will call sd_remove (via the driver
> > model call backs from device_del).  The kref_put in sd_remove will
> > (almost always) trigger scsi_disk_release which frees sdkp.  So, I'm
> > afraid you can't rely on sdkp->device being correct.
> 
> Hmm.  Surely that's a problem for the old scsi_disk_get routine rather 
> than the new scsi_disk_get_from_dev routine?

No .. we rely on support from the way block operation works for the
scsi_disk_get() routine to work.  The problem I was trying to prevent is
the race where scsi_remove_disk is freeing sdkp as sd_rescan is being
called.

> The problem I fixed was different: sdkp was getting freed while it was 
> still in use by the rescan procedure.  But I agree that after sd_remove 
> returns, we can't depend on sdkp->device being correct.

Yes, but I also wanted to fix the race between acquiring a reference to
sdkp and having it freed.

> > The fix for this one is a bit nasty because it's a reversal in the
> > logic.  The usual logic is that the user does something, so we have a
> > refcounted gendisk object that we tie to scsi_disk and then scsi_device.
> > In this case, we actually get a scsi_device and we have to try to work
> > out how to get a valid refcounted scsi_disk object out of it.
> > Unfortunately, this problem doesn't just affect sd_rescan, it affects
> > the flush functions too where they try to do the same thing.
> 
> I wasn't sure about them.  It wasn't clear if they could get called after 
> sd_remove.  However it certainly doesn't hurt to make them call the new 
> routine.
> 
> > Could you take a look at the attached?  I just threw it together on a
> > 'plane, so it's completely untested.  It tries to implement the secure
> > get of struct scsi_disk by tying the nulling out of drvdata to the
> > sd_ref_sem, so we can now either get a reference to the scsi_disk or
> > return NULL.  I also fixed all the other relevant driver data users to
> > follow this model.
> 
> I see three differences between your patch and mine:
> 
> 	You refactored the common code in scsi_disk_get and
> 	scsi_disk_get_from_dev.  Okay, that's fine, although
> 	it looks a little strange to be going all the way
> 	down to the disk just to go back up to the sdkp.
> 	Note that when scsi_disk_get_from_dev calls __scsi_disk_get,
> 	it's not possible for disk->private_data to be NULL.

Yes, I just wanted the tying in a single routine rather than being open
coded in two different routines.

> 	You added calls to scsi_disk_get_from_dev in the flush
> 	and shutdown routines.  That's good; I would have done
> 	it originally had I known it was needed.
> 
> 	You added dev_set_drvdata(dev, NULL) to sd_remove.
> 	Actually I'm astonished it wasn't there before and that
> 	I didn't realize it was missing.  I guess nobody
> 	considered that the scsi_device might outlive the disk.

Yes, that's the key to mediating the final race.

> This is all good.  I've made a few stylistic changes (mostly to avoid goto
> statements).  By the way, is there any reason that disk->private_data is
> set to &sdkp->driver instead of to sdkp?  I don't see any, so I'll change
> it.

Actually, it is necessary, it's a way of overloading private_data so we
can get the driver even if we don't know the ULD type (we use this in
scsi_lib.c), but also so that the ULD can get its specific structure as
well.

> However this still doesn't solve the problem you mentioned.  Somehow
> sd_remove has to tell __scsi_disk_get that sdkp->device might be gone.  
> The only way I can think of is to add an extra bitfield to the scsi_disk
> structure.

Hmm, OK, but you don't need a gone field to mediate that.  just do a
get_device(&sdp->sdev_gendev) before setting the sdkp->device pointer
and do a put_device() in the release method.  That won't interfere with
the scsi_remove_device logic, but it will ensure that the pointer is
always valid until we release it.

> This patch solves the original problem and works okay on my system.  If it 
> looks okay to you, I'll resend it as a proper patch submission.

Great, thanks.

James


