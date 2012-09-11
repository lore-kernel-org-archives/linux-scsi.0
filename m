From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Tue, 11 Sep 2012 19:11:08 +0800
Message-ID: <20120911111107.GA20361@mint-spring.sh.intel.com>
References: <Pine.LNX.4.44L0.1209061437050.1182-100000@iolanthe.rowland.org>
 <3578472.dQIepChrCX@linux-lqwf.site>
 <20120911092410.GA1704@mint-spring.sh.intel.com>
 <1545884.X9DCxzsAFq@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1545884.X9DCxzsAFq@linux-lqwf.site>
Sender: linux-acpi-owner@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 11, 2012 at 11:30:35AM +0200, Oliver Neukum wrote:
> On Tuesday 11 September 2012 17:24:13 Aaron Lu wrote:
> > On Tue, Sep 11, 2012 at 10:55:44AM +0200, Oliver Neukum wrote:
> > > On Tuesday 11 September 2012 14:44:30 Aaron Lu wrote:
> > > > On Mon, Sep 10, 2012 at 12:45:51PM +0200, Oliver Neukum wrote:
> > > > > On Monday 10 September 2012 17:16:22 Aaron Lu wrote:
> > > > > 
> > > > > > +static int sr_resume(struct device *dev)
> > > > > > +{
> > > > > > +       struct scsi_cd *cd;
> > > > > > +       struct scsi_sense_hdr sshdr;
> > > > > > +
> > > > > > +       cd = dev_get_drvdata(dev);
> > > > > > +
> > > > > > +       if (!cd->device->powered_off)
> > > > > > +               return 0;
> > > > > > +
> > > > > > +       /* get the disk ready */
> > > > > > +       scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
> > > > > > +
> > > > > > +       /* if user wakes up the ODD, eject the tray */
> > > > > > +       if (cd->device->need_eject) {
> > > > > > +               cd->device->need_eject = 0;
> > > > > > +               if (!(cd->cdi.mask & CDC_CLOSE_TRAY))
> > > > > > +                       sr_tray_move(&cd->cdi, 1);
> > > > > 
> > > > > 1. Even if the door is locked?
> > > > 
> > > > This piece of code of sr_resume is intended for ZPODD devices, for
> > > > normal devices it will simply return as the powered_off flag will never
> > > > be set for them.
> > > > 
> > > > And for ZPODD devices, the door shouldn't be in locked state here since
> > > > for it to enter power off state, "no medium inside" has to be satisfied
> > > 
> > > This is true only if the device is autosuspended. But sr_resume()
> > > will also be called if the whole system was suspended.
> > 
> > You mean when system resumes, right?
> 
> Yes, but because the whole system had been suspended.
> In that case you can have a locked door.

By locked, do you mean the door is closed or the door is locked by the
sr_lock_door function with param lock set to 1?

> 
> > > What happens if the user presses the door button on the drive
> > > while the system was suspended?
> > 
> > The drive does not have the capability to wake up the system from S3, so
> > nothing happens.
> 
> You are assuming that the system is resumed because the door button is pressed.

No, as I said, pressing the eject button can't wake up a suspended
system. The whole idea of ZPODD is to put the ODD into powered off state
while the system is at S0.

> That need not be the case. What happens if the door button is pressed while
> the system is resuming?

In that case, if the hardware logic is ready, an ACPI event will fire
and the device will be runtime resumed; if the hardware logic is not
ready yet due to the system is resuming, nothing happens.

Thanks,
Aaron
