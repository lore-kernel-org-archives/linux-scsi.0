From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v6 7/7] libata: acpi: respect may_power_off flag
Date: Thu, 06 Sep 2012 22:38:18 -0400
Message-ID: <50495E1A.8010208@pobox.com>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com> <1346768680-7287-8-git-send-email-aaron.lwe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1346768680-7287-8-git-send-email-aaron.lwe@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 09/04/2012 10:24 AM, Aaron Lu wrote:
> From: Aaron Lu <aaron.lu@intel.com>
>
> If user does not want the device being powered off when runtime
> suspended by setting may_power_off flag to 0, we will not choose D3 cold
> ACPI D-State for it.
>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>   drivers/ata/libata-acpi.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 6c8f89c..774180d 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -869,7 +869,9 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
>
>   		if (state.event != PM_EVENT_ON) {
>   			acpi_state = acpi_pm_device_sleep_state(
> -				&dev->sdev->sdev_gendev, NULL, ACPI_STATE_D3);
> +				&dev->sdev->sdev_gendev, NULL,
> +				dev->sdev->may_power_off ?
> +				ACPI_STATE_D3_COLD : ACPI_STATE_D3_HOT);
>   			if (acpi_state > 0)
>   				acpi_bus_set_power(handle, acpi_state);

Acked-by: Jeff Garzik <jgarzik@redhat.com>



