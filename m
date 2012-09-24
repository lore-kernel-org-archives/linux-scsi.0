From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v7 3/6] scsi: sr: support zero power ODD(ZPODD)
Date: Mon, 24 Sep 2012 17:55:04 -0400
Message-ID: <5060D6B8.9030006@pobox.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <1347438597-5903-4-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1347438597-5903-4-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 09/12/2012 04:29 AM, Aaron Lu wrote:
> When ODD is runtime suspended, we will check if it is OK to remove
> its power:
> 1 For tray type, no medium inside and tray closed;
> 2 For slot type, no medium inside.
> And if yes, we will set the ready_to_power_off flag as an indication to
> ATA layer that it is safe to place this device into ACPI D3 cold power
> state.
>
> And when it is powered off, we will set the powered_off flag so that the
> periodically running check_events will not bother this device by simply
> return.
>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>   drivers/ata/libata-acpi.c  | 27 +++++++++++++++--------
>   drivers/scsi/sr.c          | 53 ++++++++++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/sr.h          |  1 +
>   drivers/scsi/sr_ioctl.c    |  7 +++++-
>   include/scsi/scsi_device.h |  3 +++
>   5 files changed, 81 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 902b5a4..9aca057 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -854,7 +854,7 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
>   {
>   	struct ata_device *dev;
>   	acpi_handle handle;
> -	int acpi_state;
> +	int acpi_state, ret;
>
>   	/* channel first and then drives for power on and vica versa
>   	   for power off */
> @@ -869,17 +869,24 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
>
>   		if (state.event != PM_EVENT_ON) {
>   			acpi_state = acpi_pm_device_sleep_state(
> -				&dev->sdev->sdev_gendev, NULL, ACPI_STATE_D3);
> -			if (acpi_state > 0)
> -				acpi_bus_set_power(handle, acpi_state);
> -			/* TBD: need to check if it's runtime pm request */
> -			acpi_pm_device_run_wake(
> -				&dev->sdev->sdev_gendev, true);
> +					&dev->sdev->sdev_gendev, NULL,
> +					dev->sdev->ready_to_power_off ?
> +					ACPI_STATE_D3 : ACPI_STATE_D3_HOT);
> +			if (acpi_state > 0) {
> +				ret = acpi_bus_set_power(handle, acpi_state);
> +				if (!ret && acpi_state == ACPI_STATE_D3)
> +					dev->sdev->powered_off = 1;
> +
> +				/* TODO: check if it's runtime pm request */
> +				acpi_pm_device_run_wake(
> +						&dev->sdev->sdev_gendev, true);
> +			}
>   		} else {
>   			/* Ditto */
>   			acpi_pm_device_run_wake(
>   				&dev->sdev->sdev_gendev, false);
>   			acpi_bus_set_power(handle, ACPI_STATE_D0);
> +			dev->sdev->powered_off = 0;
>   		}
>   	}
>
> @@ -985,8 +992,10 @@ static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
>   	struct ata_device *ata_dev = context;
>
>   	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
> -			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
> -		scsi_autopm_get_device(ata_dev->sdev);
> +			ata_dev->sdev->powered_off) {
> +		ata_dev->sdev->need_eject = 1;
> +		pm_runtime_resume(&ata_dev->sdev->sdev_gendev);
> +	}
>   }
>

these bits are Acked-by: Jeff Garzik <jgarzik@redhat.com>

but obviously that is contingent upon acceptance of the upper level SCSI 
and ACPI changes.



