Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA91242D84;
	Tue, 28 Oct 2025 04:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761624163; cv=none; b=u6oyke00t/2peMxXI3tNNWBmXw+B1Pmk5zHjq6uzgSPHj29MlmEAeuEWU1f9c3ZbfdeYks++pWqRBsqmpSl+PDnSxOh7DXqtucYNok7urufrdxhKy+jJEmFv+Ll/eFoA9olboQG1vQwW+p0tTYWSFclpUtLoGLoo8P+LCGF6djE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761624163; c=relaxed/simple;
	bh=6WI4ZVh8wMgU7O5q+rTJ4KkNYHxwoyFzm2cij4TqfDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oHistXpaonL//wehESwf/1tkwa6M34+84r5A0bNC4XTt6nUFlah+OeVPZVn8kCu37pm0dGwjwxylF08pIfBFy0pgWPToiOU8+gCUdt10809MsPcVtSavIQdiakkSCr4QyTFm5UUfvpzqDrwNx2twMpkaTPqTCg5vwMUK+GbpkGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrXVFwZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrXVFwZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B94CC4CEE7;
	Tue, 28 Oct 2025 04:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761624162;
	bh=6WI4ZVh8wMgU7O5q+rTJ4KkNYHxwoyFzm2cij4TqfDE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qrXVFwZLEr+0Cm8WrMAjIKcVg5mzGP3i9PJRKc0th9/wyqAksUcyOxRdWRdiJnsud
	 EscvGJSu/RCIEotdl8RoXTHo5M1NnaUgkLFMkd5LVbIk/5mlCsbWxWMJozGpYp8cnz
	 BleSup5j4flE8V3Z8Ye4ia1V1iB+jx3xGHQBwto/HkQIKy24gaHd7Z/hGDcJIi21wi
	 fBH2GJ4T3LapFJMD+MXm/m0RFwUOHVwn9g3vCgshMBpuFZvbXF053eeiBDEZZeQAQH
	 SJm8ZWngYCOI60CAYSLAdN5plYVMhqlbYN2w7x9nvZ5e+UwIhL4ECWhMrQ993BnKwK
	 uplCog+OEvAWA==
Message-ID: <a4ac4503-da4f-43f0-808b-fbf0d9bc309f@kernel.org>
Date: Tue, 28 Oct 2025 12:58:56 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] ata: Use ACPI methods to power on disks
To: Markus Probst <markus.probst@posteo.de>, Niklas Cassel
 <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251027202339.1043723-1-markus.probst@posteo.de>
 <20251027202339.1043723-4-markus.probst@posteo.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251027202339.1043723-4-markus.probst@posteo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/28/25 5:23 AM, Markus Probst wrote:
> Some embedded devices have the ability to control whether power is
> provided to the disks via the SATA power connector or not. If power
> resources are defined on ATA ports / devices in ACPI, we should try to set
> the power state to D0 before probing the disk to ensure that any power
> supply or power gate that may exist is providing power to the disk.
> 
> An example for such devices would be newer synology NAS devices. Every
> disk slot has its own SATA power connector. Whether the connector is
> providing power is controlled via an gpio, which is *off by default*.
> Also the disk loses power on reboots.
> 
> Add a new function, ata_acpi_port_power_on(), that will be used to power
> on the SATA power connector if usable ACPI power resources on the
> associated ATA port / device are found. It will be called right before
> probing the port, therefore the disk will be powered on just in time.
> 
> Signed-off-by: Markus Probst <markus.probst@posteo.de>

I think that this patch should be 2/3 and 2/3 should be 3/3. That makes more
sense to have the basic power control first and then solve the restart power
loss after that.

> ---
>  drivers/ata/libata-acpi.c | 40 +++++++++++++++++++++++++++++++++++++++
>  drivers/ata/libata-core.c |  2 ++
>  drivers/ata/libata.h      |  2 ++
>  3 files changed, 44 insertions(+)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 196ca1227d09..b0d70e075cd2 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -271,6 +271,46 @@ bool ata_acpi_dev_manage_restart(struct ata_device *dev)
>  	return acpi_bus_power_manageable(ACPI_HANDLE(tdev));
>  }
>  
> +/**
> + * ata_acpi_port_power_on - set the power state of the ata port to D0
> + * @ap: target ATA port
> + *
> + * This function is called at the beginning of ata_port_probe.

Please add "()" after ata_port_probe ("ata_port_probe()") to show it is a function.

> + */
> +void ata_acpi_port_power_on(struct ata_port *ap)
> +{
> +	acpi_handle handle;
> +	int i;
> +
> +	/* If `ATA_FLAG_ACPI_SATA` is set, the acpi fwnode is attached to the
> +	 * `ata_device` instead of the `ata_port`.
> +	 */

As already commented, please drop the quote marks inside the comment (not
needed at all) and format the multi line comment correctly:

	/*
	 * If ATA_FLAG_ACPI_SATA is set, the acpi fwnode is attached to the
	 * ATA device instead of the ATA port.
	 */

> +	if (ap->flags & ATA_FLAG_ACPI_SATA) {
> +		for (i = 0; i < ATA_MAX_DEVICES; i++) {
> +			struct ata_device *dev = &ap->link.device[i];
> +
> +			if (!is_acpi_device_node(dev->tdev.fwnode))
> +				continue;
> +			handle = ACPI_HANDLE(&dev->tdev);
> +			if (!acpi_bus_power_manageable(handle))
> +				continue;
> +			if (acpi_bus_set_power(handle, ACPI_STATE_D0))
> +				ata_dev_err(dev,
> +					    "acpi: failed to power state to D0\n");

"acpi: failed to set power state to D0\n" ? (set missing ?)

> +		}
> +		return;
> +	}
> +
> +	if (!is_acpi_device_node(ap->tdev.fwnode))
> +		return;
> +	handle = ACPI_HANDLE(&ap->tdev);
> +	if (!acpi_bus_power_manageable(handle))
> +		return;
> +
> +	if (acpi_bus_set_power(handle, ACPI_STATE_D0))
> +		ata_port_err(ap, "acpi: failed to set power state to D0\n");

Not missing here :)

> +}
> +
>  /**
>   * ata_acpi_dissociate - dissociate ATA host from ACPI objects
>   * @host: target ATA host
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 2a210719c4ce..a6813ced3ec2 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5901,6 +5901,8 @@ void ata_port_probe(struct ata_port *ap)
>  	struct ata_eh_info *ehi = &ap->link.eh_info;
>  	unsigned long flags;
>  
> +	ata_acpi_port_power_on(ap);
> +
>  	/* kick EH for boot probing */
>  	spin_lock_irqsave(ap->lock, flags);
>  
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index af08bb9b40d0..0e7ecac73680 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -130,6 +130,7 @@ extern void ata_acpi_on_disable(struct ata_device *dev);
>  extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
>  extern void ata_acpi_bind_port(struct ata_port *ap);
>  extern void ata_acpi_bind_dev(struct ata_device *dev);
> +extern void ata_acpi_port_power_on(struct ata_port *ap);
>  extern bool ata_acpi_dev_manage_restart(struct ata_device *dev);
>  extern acpi_handle ata_dev_acpi_handle(struct ata_device *dev);
>  #else
> @@ -141,6 +142,7 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
>  				      pm_message_t state) { }
>  static inline void ata_acpi_bind_port(struct ata_port *ap) {}
>  static inline void ata_acpi_bind_dev(struct ata_device *dev) {}
> +static inline void ata_acpi_port_power_on(struct ata_port *ap) {}
>  static inline bool ata_acpi_dev_manage_restart(struct ata_device *dev) { return 0; }
>  #endif
>  


-- 
Damien Le Moal
Western Digital Research
