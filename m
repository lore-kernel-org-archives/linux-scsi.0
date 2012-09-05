From: Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Wed, 5 Sep 2012 23:22:55 +0800
Message-ID: <20120905152251.GA2794@localhost.localdomain>
References: <Pine.LNX.4.44L0.1209041350490.1605-100000@iolanthe.rowland.org>
 <11638307.8MbrDPKO6y@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51298 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758802Ab2IEPXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Sep 2012 11:23:07 -0400
Content-Disposition: inline
In-Reply-To: <11638307.8MbrDPKO6y@linux-lqwf.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>

On Tue, Sep 04, 2012 at 08:47:15PM +0200, Oliver Neukum wrote:
> On Tuesday 04 September 2012 13:59:38 Alan Stern wrote:
> > On Tue, 4 Sep 2012, Oliver Neukum wrote:
> > 
> > > On Tuesday 04 September 2012 22:24:34 Aaron Lu wrote:
> > > > From: Aaron Lu <aaron.lu@intel.com>
> > > > 
> > > > The ODD will be placed into suspend state when:
> > > > 1 For tray type ODD, no media inside and door closed;
> > > > 2 For slot type ODD, no media inside;
> > > > And together with ACPI, when we suspend the ODD's parent(the port it
> > > > attached to), we will omit the power altogether to reduce power
> > > > consumption(done in libata-acpi.c).
> > > 
> > > Well, this is quite a layering violation. You encode that specific requirement
> > > in the generic sr_suspend()
> > 
> > What requirement are you talking about?  The "no media and door closed" 
> > thing?  How is that a layering violation?  Are you suggesting this
> 
> There is no reason this requirement should apply to any other drive than the
> device this is aimed at. It comes from the ability of this specific combination
> to detect medium changes.

When suspending, I'll check the "no media inside and door closed"
condition. Do you mean this is a special ability for devices driven by
sr driver?

And after the device is runtime suspended, if the platform has the
ability to power off the device and the device supports notifying the
host of user action(i.e inserting a disc to a slot type ODD or pressing
the eject button of a tray type ODD), it will be powered off to save
more power. This is ZPODD device.

By detecting medium change, I suppose you mean when the device is
runtime suspended, how can it detect medium change?
There are 2 situations here:
1 For normal devices, the in kernel poll is still going on;
2 For ZPODD device, it will be powered off when runtime suspended.
And the in kernel poll is stopped to let the device stay in powered off
state longer(done in patch 3). when user wants to use the ODD by either
inserting a disc or pressing the eject button, an ACPI event is
generated and the notification code will runtime resume the device and
the in kernel poll is restarted. And then the medium change can be
detected.

> 
> > should go into the CD layer instead?
> 
> No. It needs to be specific to a certain hardware. It needs to be a callback.
>  
> > > > @@ -985,8 +985,10 @@ static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
> > > >  	struct ata_device *ata_dev = context;
> > > >  
> > > >  	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
> > > > -			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
> > > > -		scsi_autopm_get_device(ata_dev->sdev);
> > > > +			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev)) {
> > > > +		ata_dev->sdev->wakeup_by_user = 1;
> > > 
> > > That flag is badly named. Something like "insert_event_during_suspend"
> > > would be better.

This flag means, the reason the device gets runtime resumed is due to
user as described by the above situation 2, not by software(e.g. by
sr_check_events).

I don't quite understand insert_event_during_suspend mean here...

> > 
> > What happens on non-ACPI systems when a new disc is inserted into a
> > suspended ODD?  How does the drive let the computer know that an insert
> > event has occurred?
> 
> Good question. Again either the kernel polls the drive or there a mechanism
> specific to the hardware.

Yes. And the mechanism is called ZPODD :-)
And if ZPODD is supported, I'll block kernel polling; If not, kernel
polling is not blocked.

>  
> > > > +	if (cd->cdi.mask & CDC_CLOSE_TRAY)
> > > > +		/* no media for caddy/slot type ODD */
> > > > +		suspend = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a;
> > > > +	else
> > > > +		/* no media and door closed for tray type ODD */
> > > > +		suspend = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a &&
> > > > +			sshdr.ascq == 0x01;
> > > 
> > > That requirement is valid for a specific type of disk. You cannot put it
> > > into generic sd_suspend().
> > 
> > You mean sr_suspend().  What's not generic about it?
> 
> Yes. We may encounter drives which cannot register a medium change while
> suspended, but can be safely suspended while their door is locked.

There is no need to register a medium change while suspended.
The current model of periodically poll is not changed.
Only when platform and device both support ZPODD will the in kernel poll
be stopped.

> 
> > >  And even so I don't see why you wouldn't
> > > want to suspend for example a drive with an inserted but unopened disk.
> > 
> > I assume that Aaron wanted to handle the easiest case first.  Adding 
> > suspend/resume handling to the open/close routines can be done later.
> 
> Sure, but this patch blocks that in contrast to just not implementing it.

It's already implemented. I did it in scsi_cd_get/put.

And the reason I didn't allow runtime suspend for medium inside and door
closed case are:
1 ZPODD has a spec and it didn't allow that;
2 It's not easy to implement. Imagine user just inserts a disc, and the
sr_suspend routine checks that door is closed so that it wants to
suspend the device. But actually, after user just inserts a disc, he
definitely wants to use the device, so it's not a good thing to do. And
if ZPODD is used, the device will be powered off instantly when the door
is closed, this is not good.

So I think for now, the "no medium inside and door closed" makes thing
easier :-)

Thanks,
Aaron
