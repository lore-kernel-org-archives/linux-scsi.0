From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Tue, 11 Sep 2012 17:24:13 +0800
Message-ID: <20120911092410.GA1704@mint-spring.sh.intel.com>
References: <Pine.LNX.4.44L0.1209061437050.1182-100000@iolanthe.rowland.org>
 <4663685.bsC7gzLV6E@linux-lqwf.site>
 <20120911064429.GA2196@mint-spring.sh.intel.com>
 <3578472.dQIepChrCX@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3578472.dQIepChrCX@linux-lqwf.site>
Sender: linux-acpi-owner@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 11, 2012 at 10:55:44AM +0200, Oliver Neukum wrote:
> On Tuesday 11 September 2012 14:44:30 Aaron Lu wrote:
> > On Mon, Sep 10, 2012 at 12:45:51PM +0200, Oliver Neukum wrote:
> > > On Monday 10 September 2012 17:16:22 Aaron Lu wrote:
> > > 
> > > > +static int sr_resume(struct device *dev)
> > > > +{
> > > > +	struct scsi_cd *cd;
> > > > +	struct scsi_sense_hdr sshdr;
> > > > +
> > > > +	cd = dev_get_drvdata(dev);
> > > > +
> > > > +	if (!cd->device->powered_off)
> > > > +		return 0;
> > > > +
> > > > +	/* get the disk ready */
> > > > +	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
> > > > +
> > > > +	/* if user wakes up the ODD, eject the tray */
> > > > +	if (cd->device->need_eject) {
> > > > +		cd->device->need_eject = 0;
> > > > +		if (!(cd->cdi.mask & CDC_CLOSE_TRAY))
> > > > +			sr_tray_move(&cd->cdi, 1);
> > > 
> > > 1. Even if the door is locked?
> > 
> > This piece of code of sr_resume is intended for ZPODD devices, for
> > normal devices it will simply return as the powered_off flag will never
> > be set for them.
> > 
> > And for ZPODD devices, the door shouldn't be in locked state here since
> > for it to enter power off state, "no medium inside" has to be satisfied
> 
> This is true only if the device is autosuspended. But sr_resume()
> will also be called if the whole system was suspended.

You mean when system resumes, right?

> What happens if the user presses the door button on the drive
> while the system was suspended?

The drive does not have the capability to wake up the system from S3, so
nothing happens.

> 
> > and when there is no medium inside, we do not lock its door.
> > 
> > > 2. sr_tray_move allocates memory with GFP_KERNEL. This smells of a deadlock.
> > 
> > Sorry, don't get this. Can you please elaborate?
> 
> Suppose you need to wake up two devices for the same reason, a ZPODD and a hard
> drive. The ZPODD is woken first and sr_resume() requests memory with GFP_KERNEL.
> The VM layer decides to page out to the hard drive to be woken up -> deadlock.

While, I don't understand what stops the hard disk from being resumed,
the hard drive's runtime resume does not depend on the ODD's, and I
don't think there should be an order enforced on them.

Thanks,
Aaron
