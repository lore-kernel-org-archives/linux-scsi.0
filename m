From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Thu, 6 Sep 2012 13:17:33 +0800
Message-ID: <20120906051732.GA1706@mint-spring.sh.intel.com>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com>
 <1346768680-7287-2-git-send-email-aaron.lwe@gmail.com>
 <1519541.IZ88lAq0Bj@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1519541.IZ88lAq0Bj@linux-lqwf.site>
Sender: linux-acpi-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 04, 2012 at 05:57:35PM +0200, Oliver Neukum wrote:
> > diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> > index 902b5a4..64ba43d 100644
> > --- a/drivers/ata/libata-acpi.c
> > +++ b/drivers/ata/libata-acpi.c
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

The reason I added the flag is to let sr knows that when the device
gets resumed, please eject its tray since user just pressed the eject
button when it is in powered off state.

If wakeup_by_user is badly named, what about need_eject? I don't think
insert_event_during_suspend reflects what happened here.

-Aaron
