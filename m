From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH v3 1/7] libata-acpi: set acpi state for SATA port
Date: Thu, 29 Mar 2012 03:55:16 +0800
Message-ID: <20120328195509.GA1965@localhost.amd.com>
References: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com>
 <1332915722-15963-2-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1332915722-15963-2-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

The patch does not apply, are you using libata-devel/ALL branch?

-Aaron

On Wed, Mar 28, 2012 at 02:21:56PM +0800, Lin Ming wrote:
> Currently, ata_acpi_set_state() only sets acpi sate for IDE port.
> Remove this limitation.
> 
> Acked-by: Aaron Lu <aaron.lu@amd.com>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/ata/libata-acpi.c |   21 ++++++++++++---------
>  1 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index b03e468..104c1d0 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -841,23 +841,26 @@ void ata_acpi_on_resume(struct ata_port *ap)
>  void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
>  {
>  	struct ata_device *dev;
> -
> -	if (!ata_ap_acpi_handle(ap) || (ap->flags & ATA_FLAG_ACPI_SATA))
> -		return;
> +	acpi_handle handle;
> +	int acpi_state;
>  
>  	/* channel first and then drives for power on and vica versa
>  	   for power off */
> -	if (state.event == PM_EVENT_ON)
> -		acpi_bus_set_power(ata_ap_acpi_handle(ap), ACPI_STATE_D0);
> +	handle = ata_ap_acpi_handle(ap);
> +	if (handle && state.event == PM_EVENT_ON)
> +		acpi_bus_set_power(handle, ACPI_STATE_D0);
>  
>  	ata_for_each_dev(dev, &ap->link, ENABLED) {
> -		if (ata_dev_acpi_handle(dev))
> -			acpi_bus_set_power(ata_dev_acpi_handle(dev),
> +		handle = ata_dev_acpi_handle(dev);
> +		if (handle)
> +			acpi_bus_set_power(handle,
>  				state.event == PM_EVENT_ON ?
>  					ACPI_STATE_D0 : ACPI_STATE_D3);
>  	}
> -	if (state.event != PM_EVENT_ON)
> -		acpi_bus_set_power(ata_ap_acpi_handle(ap), ACPI_STATE_D3);
> +
> +	handle = ata_ap_acpi_handle(ap);
> +	if (handle && state.event != PM_EVENT_ON)
> +		acpi_bus_set_power(handle, ACPI_STATE_D3);
>  }
>  
>  /**
> -- 
> 1.7.2.5
> 
> 
