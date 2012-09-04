From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Tue, 4 Sep 2012 13:59:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209041350490.1605-100000@iolanthe.rowland.org>
References: <1519541.IZ88lAq0Bj@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1519541.IZ88lAq0Bj@linux-lqwf.site>
Sender: linux-ide-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Aaron Lu <aaron.lwe@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 4 Sep 2012, Oliver Neukum wrote:

> On Tuesday 04 September 2012 22:24:34 Aaron Lu wrote:
> > From: Aaron Lu <aaron.lu@intel.com>
> > 
> > The ODD will be placed into suspend state when:
> > 1 For tray type ODD, no media inside and door closed;
> > 2 For slot type ODD, no media inside;
> > And together with ACPI, when we suspend the ODD's parent(the port it
> > attached to), we will omit the power altogether to reduce power
> > consumption(done in libata-acpi.c).
> 
> Well, this is quite a layering violation. You encode that specific requirement
> in the generic sr_suspend()

What requirement are you talking about?  The "no media and door closed" 
thing?  How is that a layering violation?  Are you suggesting this 
should go into the CD layer instead?

> > @@ -985,8 +985,10 @@ static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
> >  	struct ata_device *ata_dev = context;
> >  
> >  	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
> > -			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
> > -		scsi_autopm_get_device(ata_dev->sdev);
> > +			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev)) {
> > +		ata_dev->sdev->wakeup_by_user = 1;
> 
> That flag is badly named. Something like "insert_event_during_suspend"
> would be better.

What happens on non-ACPI systems when a new disc is inserted into a
suspended ODD?  How does the drive let the computer know that an insert
event has occurred?

> > +	if (cd->cdi.mask & CDC_CLOSE_TRAY)
> > +		/* no media for caddy/slot type ODD */
> > +		suspend = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a;
> > +	else
> > +		/* no media and door closed for tray type ODD */
> > +		suspend = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a &&
> > +			sshdr.ascq == 0x01;
> 
> That requirement is valid for a specific type of disk. You cannot put it
> into generic sd_suspend().

You mean sr_suspend().  What's not generic about it?

>  And even so I don't see why you wouldn't
> want to suspend for example a drive with an inserted but unopened disk.

I assume that Aaron wanted to handle the easiest case first.  Adding 
suspend/resume handling to the open/close routines can be done later.

Alan Stern

