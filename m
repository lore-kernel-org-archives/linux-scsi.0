From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Tue, 04 Sep 2012 20:47:15 +0200
Message-ID: <11638307.8MbrDPKO6y@linux-lqwf.site>
References: <Pine.LNX.4.44L0.1209041350490.1605-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444Ab2IDSsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Sep 2012 14:48:39 -0400
In-Reply-To: <Pine.LNX.4.44L0.1209041350490.1605-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lwe@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>

On Tuesday 04 September 2012 13:59:38 Alan Stern wrote:
> On Tue, 4 Sep 2012, Oliver Neukum wrote:
> 
> > On Tuesday 04 September 2012 22:24:34 Aaron Lu wrote:
> > > From: Aaron Lu <aaron.lu@intel.com>
> > > 
> > > The ODD will be placed into suspend state when:
> > > 1 For tray type ODD, no media inside and door closed;
> > > 2 For slot type ODD, no media inside;
> > > And together with ACPI, when we suspend the ODD's parent(the port it
> > > attached to), we will omit the power altogether to reduce power
> > > consumption(done in libata-acpi.c).
> > 
> > Well, this is quite a layering violation. You encode that specific requirement
> > in the generic sr_suspend()
> 
> What requirement are you talking about?  The "no media and door closed" 
> thing?  How is that a layering violation?  Are you suggesting this

There is no reason this requirement should apply to any other drive than the
device this is aimed at. It comes from the ability of this specific combination
to detect medium changes.

> should go into the CD layer instead?

No. It needs to be specific to a certain hardware. It needs to be a callback.
 
> > > @@ -985,8 +985,10 @@ static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
> > >  	struct ata_device *ata_dev = context;
> > >  
> > >  	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
> > > -			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
> > > -		scsi_autopm_get_device(ata_dev->sdev);
> > > +			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev)) {
> > > +		ata_dev->sdev->wakeup_by_user = 1;
> > 
> > That flag is badly named. Something like "insert_event_during_suspend"
> > would be better.
> 
> What happens on non-ACPI systems when a new disc is inserted into a
> suspended ODD?  How does the drive let the computer know that an insert
> event has occurred?

Good question. Again either the kernel polls the drive or there a mechanism
specific to the hardware.
 
> > > +	if (cd->cdi.mask & CDC_CLOSE_TRAY)
> > > +		/* no media for caddy/slot type ODD */
> > > +		suspend = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a;
> > > +	else
> > > +		/* no media and door closed for tray type ODD */
> > > +		suspend = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a &&
> > > +			sshdr.ascq == 0x01;
> > 
> > That requirement is valid for a specific type of disk. You cannot put it
> > into generic sd_suspend().
> 
> You mean sr_suspend().  What's not generic about it?

Yes. We may encounter drives which cannot register a medium change while
suspended, but can be safely suspended while their door is locked.

> >  And even so I don't see why you wouldn't
> > want to suspend for example a drive with an inserted but unopened disk.
> 
> I assume that Aaron wanted to handle the easiest case first.  Adding 
> suspend/resume handling to the open/close routines can be done later.

Sure, but this patch blocks that in contrast to just not implementing it.

	Regards
		Oliver

