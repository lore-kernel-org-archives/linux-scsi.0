From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Tue, 04 Sep 2012 17:57:35 +0200
Message-ID: <1519541.IZ88lAq0Bj@linux-lqwf.site>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com> <1346768680-7287-2-git-send-email-aaron.lwe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1346768680-7287-2-git-send-email-aaron.lwe@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 04 September 2012 22:24:34 Aaron Lu wrote:
> From: Aaron Lu <aaron.lu@intel.com>
> 
> The ODD will be placed into suspend state when:
> 1 For tray type ODD, no media inside and door closed;
> 2 For slot type ODD, no media inside;
> And together with ACPI, when we suspend the ODD's parent(the port it
> attached to), we will omit the power altogether to reduce power
> consumption(done in libata-acpi.c).

Well, this is quite a layering violation. You encode that specific requirement
in the generic sr_suspend()

> The ODD can be resumed either by user or by software.
> 
> For user to resume the suspended ODD:
> 1 For tray type ODD, press the eject button;
> 2 For slot type ODD, insert a disc;
> Once such events happened, an ACPI notification will be sent and in our
> handler, we will resume the ODD(again in libata-acpi.c).
> This kind of resume requires platform and device support and is
> reflected by the can_power_off flag.
> 
> For software to resume the suspended ODD, we did this in ODD's
> open/release and check_event function.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>  drivers/ata/libata-acpi.c  |  6 ++--
>  drivers/scsi/sr.c          | 76 ++++++++++++++++++++++++++++++++++++++++++++--
>  include/scsi/scsi_device.h |  1 +
>  3 files changed, 79 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 902b5a4..64ba43d 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -985,8 +985,10 @@ static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
>  	struct ata_device *ata_dev = context;
>  
>  	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
> -			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
> -		scsi_autopm_get_device(ata_dev->sdev);
> +			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev)) {
> +		ata_dev->sdev->wakeup_by_user = 1;

That flag is badly named. Something like "insert_event_during_suspend"
would be better.

[..]
> +static int sr_suspend(struct device *dev, pm_message_t msg)
> +{
> +	int suspend;
> +	struct scsi_sense_hdr sshdr;
> +	struct scsi_cd *cd = dev_get_drvdata(dev);
> +
> +	/* no action for system pm */
> +	if (!PMSG_IS_AUTO(msg))
> +		return 0;
> +
> +	/*
> +	 * ODD can be runtime suspended when:
> +	 * tray type: no media inside and tray closed
> +	 * slot type: no media inside
> +	 */
> +	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
> +
> +	if (cd->cdi.mask & CDC_CLOSE_TRAY)
> +		/* no media for caddy/slot type ODD */
> +		suspend = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a;
> +	else
> +		/* no media and door closed for tray type ODD */
> +		suspend = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a &&
> +			sshdr.ascq == 0x01;

That requirement is valid for a specific type of disk. You cannot put it
into generic sd_suspend(). And even so I don't see why you wouldn't
want to suspend for example a drive with an inserted but unopened disk.

> +
> +	if (!suspend)
> +		return -EBUSY;
> +
> +	return 0;
> +}

	Regards
		Oliver

