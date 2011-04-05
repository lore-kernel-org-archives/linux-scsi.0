From: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
Date: Tue, 5 Apr 2011 12:21:30 +0530
Message-ID: <20110405065129.GC2872@amit-x200.redhat.com>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
 <20110401154327.GA6593@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1DEGvq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Apr 2011 02:51:46 -0400
Content-Disposition: inline
In-Reply-To: <20110401154327.GA6593@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>

On (Fri) 01 Apr 2011 [17:43:27], Tejun Heo wrote:
> Hello,
> 
> On Thu, Mar 31, 2011 at 11:50:04PM +0530, Amit Shah wrote:
> > After the first GET_EVENT_STATUS_NOTIFICATION command, any new media
> > notification is reset by the device.  The following is then noticed:
> > 
> > 1. insert a CD of a particular size
> > 2. mount it
> > 3. note /sys/block/sr0/size
> > 4. unmount cd
> > 5. replace cd with a size greater than previous one
> > 6. mount it
> > 7. /sys/block/sr0/size isn't updated
> > 8. copy all files from cd to somewhere; IO errors will pop up where the
> >    files lie beyond previous CD's geometry
> > 
> > The cause is:
> > 
> >  cdrom_open()
> >      open_for_data()
> >          cdo->drive_status() = sr_drive_status()
> >              cdrom_get_media_event()
> >              --> GPCMD_GET_EVENT_STATUS_NOTIFICATION
> >          --> med.media_present is true, return CDS_DISK_OK
> >      (success)
> >  check_disk_change()
> >     ... -> 2nd call to GPCMD_GET_EVENT_STATUS_NOTIFICATION
> > 
> > at this point the device has already reset the new media event and the
> > call to revalidate_disk() in check_disk_change() is never made.
> 
> Hmm... I see.  That's something I didn't expect.
> 
> > All of this is noticed in a qemu-kvm virtual machine where two CD images
> > are created from two files different in size.
> ...
> > diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
> > index 8be3055..0651448 100644
> > --- a/drivers/scsi/sr_ioctl.c
> > +++ b/drivers/scsi/sr_ioctl.c
> > @@ -316,12 +316,19 @@ int sr_drive_status(struct cdrom_device_info *cdi, int slot)
> >  		return CDS_DRIVE_NOT_READY;
> >  
> >  	if (!cdrom_get_media_event(cdi, &med)) {
> > -		if (med.media_present)
> > +		if (med.media_present) {
> > +			/*
> > +			 * New media was inserted; ensure disk data is
> > +			 * revalidated.
> > +			 */
> > +			if (cdi->disk->fops->revalidate_disk)
> > +				cdi->disk->fops->revalidate_disk(cdi->disk);
> >  			return CDS_DISC_OK;
> > -		else if (med.door_open)
> > +		} else if (med.door_open) {
> >  			return CDS_TRAY_OPEN;
> > -		else
> > +		} else {
> >  			return CDS_NO_DISC;
> > +		}
> >  	}
> 
> But I don't think this is the correct place to do it.  The problem
> happens because block layer consumes the event but doesn't remember it
> when the time for revalidation comes.  It should be done by block
> layer, not sr.  Hmmm... looking at the code, the new disk event code
> should handle this correctly.  Was 2.6.38 showing the problem too?

Yes, 2.6.38 shows the same problem.  I went back to ancient kernels
(2.6.31 on Fedora 11-alpha) which had the previous media_changed
infrastructure and those places too show the same behaviour (with the
TEST_UNIT_READY way of detecting media changes).

		Amit
