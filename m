Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44D334BA37;
	Mon,  6 Oct 2025 01:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759712943; cv=none; b=OVUmARa4BAXk2dik1JskkuGH0bfUAw3bvf57V0WXzy70ETgfWTsN90DXG4utD/fS1+SbSyltwt4nsldRISr3TmawdEc/5qsav4fciNcN4eRHrT+PvEiBGS4CCeBWUAmfrevZYatXzPSiNFjUuWnIiGqIZRO+uaBFlrtqR+iT7jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759712943; c=relaxed/simple;
	bh=0CVmKxnZq/4Ze7JXr0cU500rdoLgJfHc7/J5/Uy/nHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tiuPl0K1yanEih4XvnDLlpK3WShlS4d8pLbY0fLRnE7IwL3p9UG1T/dC99I65l8y4SnncRiKOqOhle8+mFldhG9+eiGJkP9LMLH3MjIsLPQ6eaa2pJ8yvvO4LqsESIuGbu2deTUivm6piHxfjWa+pV0DBmmyGt9v8pf0pDB9oSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EyoJyDB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EyoJyDB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C51BC4CEF4;
	Mon,  6 Oct 2025 01:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759712942;
	bh=0CVmKxnZq/4Ze7JXr0cU500rdoLgJfHc7/J5/Uy/nHg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EyoJyDB3hPGGIf44occZ0Z+qpGRs3kLTkTL7UOJP2ArEB0bATKfTPF9xZwMScEVii
	 l3POzAgqd1I7GSYVHCvvpiaha8ZBT/d/xdD3qXo6gmgdpMbSVkl8HJ4kpCZz7lmHi7
	 xdsx7Fx+ofDxTGR1lOaP0TxIhjOKwH84VmflftNjs7SD4UG5ohZFptKsaZMFnPg+mo
	 or1VMfcxgRGpsaDJyEUzW5cq5eCbdVK/dz3rKMJtNNRpv6DXv6453394SFRuAgY1bj
	 ATAqXmuI7OF3Cj1EQLig8+Jd9ehcbor6hooWL8xD8lTH+vpDk+5TkByN6ILPyUd2EZ
	 6t9Iut5JPrhnQ==
Message-ID: <7ab0ef5c-cce7-44d7-a416-4963e24e0b17@kernel.org>
Date: Mon, 6 Oct 2025 10:09:00 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] Power on ata ports defined in ACPI before probing
 ports
To: Markus Probst <markus.probst@posteo.de>, Niklas Cassel
 <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <8c3cb28c57462f9665b08fdaa022e6abc57fcd9e.camel@posteo.de>
 <20251005190559.1472308-1-markus.probst@posteo.de>
 <20251005190559.1472308-2-markus.probst@posteo.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251005190559.1472308-2-markus.probst@posteo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/6/25 04:06, Markus Probst wrote:
> some devices (for example every synology nas with "deep sleep" support)
> have the ability to power on and off each ata port individually. This
> turns the specific port on, if power manageable in acpi, before probing
> it.

Please add "ata: " prefix to the commit titel and capitalize the first letter of
sentences.

The commit message above should also be improved. E.g. The "This" in "This turns
on..." is unclear (I am assuming you mean "this patch" ?).

> 
> This can later be extended to power down the ata ports (removing power
> from a disk) while the disk is spin down.
> 
> Signed-off-by: Markus Probst <markus.probst@posteo.de>
> ---
>  drivers/ata/libata-acpi.c | 68 +++++++++++++++++++++++++++++++++++++++
>  drivers/ata/libata-core.c | 21 ++++++++++++
>  drivers/ata/libata-scsi.c |  1 +
>  drivers/ata/libata.h      |  4 +++
>  include/linux/libata.h    |  1 +
>  5 files changed, 95 insertions(+)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index f2140fc06ba0..891b59bfe29f 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -245,6 +245,74 @@ void ata_acpi_bind_dev(struct ata_device *dev)
>  				   ata_acpi_dev_uevent);
>  }
>  
> +/**
> + * ata_acpi_dev_manage_restart - if the disk should be stopped (spin down) on system restart.

Long line. Please split at 80 chars.

> + * @dev: target ATA device
> + *
> + * RETURNS:
> + * true if the disk should be stopped, otherwise false
> + */
> +bool ata_acpi_dev_manage_restart(struct ata_device *dev)
> +{
> +	// If the device is power manageable and we assume the disk loses power on reboot.

This is not C++. Please use C style comments and split the long line.

> +	if (dev->link->ap->flags & ATA_FLAG_ACPI_SATA) {
> +		if (!is_acpi_device_node(dev->tdev.fwnode))
> +			return false;
> +		return acpi_bus_power_manageable(ACPI_HANDLE(&dev->tdev));
> +	}
> +
> +	if (!is_acpi_device_node(dev->link->ap->tdev.fwnode))
> +		return false;
> +	return acpi_bus_power_manageable(ACPI_HANDLE(&dev->link->ap->tdev));
> +}
> +
> +/**
> + * ata_acpi_port_set_power_state - set the power state of the ata port
> + * @ap: target ATA port
> + *
> + * This function is called at the begin of ata_port_probe.

...at the beginning of ata_port_probe().

> + */
> +void ata_acpi_port_set_power_state(struct ata_port *ap, bool enable)
> +{
> +	acpi_handle handle;
> +	unsigned char state;
> +	int i;
> +
> +	if (libata_noacpi)
> +		return;
> +
> +	if (enable)
> +		state = ACPI_STATE_D0;
> +	else
> +		state = ACPI_STATE_D3_COLD;
> +
> +	if (ap->flags & ATA_FLAG_ACPI_SATA) {
> +		for (i = 0; i < ATA_MAX_DEVICES; i++) {
> +			if (!is_acpi_device_node(ap->link.device[i].tdev.fwnode))
> +				continue;
> +			handle = ACPI_HANDLE(&ap->link.device[i].tdev);
> +			if (!acpi_bus_power_manageable(handle))
> +				continue;
> +			if (!acpi_bus_set_power(handle, state))
> +				ata_dev_info(&ap->link.device[i], "acpi: power was set to %d\n",
> +					     enable);
> +			else
> +				ata_dev_info(&ap->link.device[i], "acpi: power failed to be set\n");
> +		}

Add a return here to avoid the else.

> +	} else {
> +		if (!is_acpi_device_node(ap->tdev.fwnode))
> +			return;
> +		handle = ACPI_HANDLE(&ap->tdev);
> +		if (!acpi_bus_power_manageable(handle))
> +			return;
> +
> +		if (!acpi_bus_set_power(handle, state))
> +			ata_port_info(ap, "acpi: power was set to %d\n", enable);

ata_port_debug(ap, "acpi: power %sabled\n",
	       enable ? "en" : "dis");

> +		else
> +			ata_port_info(ap, "acpi: power failed to be set\n");

ata_port_err(ap, "acpi: failed to set power state\n");

Overall, this hunk is the same as what is done in the loop above. So maybe
create a helper function instead of repeating the same procedure.

> +	}
> +}
> +
>  /**
>   * ata_acpi_dissociate - dissociate ATA host from ACPI objects
>   * @host: target ATA host
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index ff53f5f029b4..a52b916af14c 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5899,11 +5899,32 @@ void ata_host_init(struct ata_host *host, struct device *dev,
>  }
>  EXPORT_SYMBOL_GPL(ata_host_init);
>  
> +static inline void ata_port_set_power_state(struct ata_port *ap, bool enable)
> +{
> +	ata_acpi_port_set_power_state(ap, enable);
> +	// Maybe add a way with device tree and regulators too?

Drop this comment please.

> +}
> +
> +/**
> + * ata_dev_manage_restart - if the disk should be stopped (spin down) on system restart.
> + * @dev: target ATA device
> + *
> + * RETURNS:
> + * true if the disk should be stopped, otherwise false
> + */
> +bool ata_dev_manage_restart(struct ata_device *dev)
> +{
> +	return ata_acpi_dev_manage_restart(dev);
> +}
> +EXPORT_SYMBOL_GPL(ata_dev_manage_restart);

Why the export ? libata-core and libata-scsi are compiled together as libata.ko.
The export should not be needed.

> +
>  void ata_port_probe(struct ata_port *ap)
>  {
>  	struct ata_eh_info *ehi = &ap->link.eh_info;
>  	unsigned long flags;
>  
> +	ata_port_set_power_state(ap, true);
> +
>  	/* kick EH for boot probing */
>  	spin_lock_irqsave(ap->lock, flags);
>  
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2ded5e476d6e..52297d9e3dc2 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1095,6 +1095,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
>  		 */
>  		sdev->manage_runtime_start_stop = 1;
>  		sdev->manage_shutdown = 1;
> +		sdev->manage_restart = ata_dev_manage_restart(dev);
>  		sdev->force_runtime_start_on_system_start = 1;
>  	}
>  
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index e5b977a8d3e1..28cb652d99bc 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -130,6 +130,8 @@ extern void ata_acpi_on_disable(struct ata_device *dev);
>  extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
>  extern void ata_acpi_bind_port(struct ata_port *ap);
>  extern void ata_acpi_bind_dev(struct ata_device *dev);
> +extern void ata_acpi_port_set_power_state(struct ata_port *ap, bool enable);
> +extern bool ata_acpi_dev_manage_restart(struct ata_device *dev);
>  extern acpi_handle ata_dev_acpi_handle(struct ata_device *dev);
>  #else
>  static inline void ata_acpi_dissociate(struct ata_host *host) { }
> @@ -140,6 +142,8 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
>  				      pm_message_t state) { }
>  static inline void ata_acpi_bind_port(struct ata_port *ap) {}
>  static inline void ata_acpi_bind_dev(struct ata_device *dev) {}
> +static inline void ata_acpi_port_set_power_state(struct ata_port *ap, bool enable) {}
> +static inline bool ata_acpi_dev_manage_restart(struct ata_device *dev) { return false; }
>  #endif
>  
>  /* libata-scsi.c */
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 0620dd67369f..af5974e91e1d 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1302,6 +1302,7 @@ extern int sata_link_debounce(struct ata_link *link,
>  extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
>  			     bool spm_wakeup);
>  extern int ata_slave_link_init(struct ata_port *ap);
> +extern bool ata_dev_manage_restart(struct ata_device *dev);
>  extern void ata_port_probe(struct ata_port *ap);
>  extern struct ata_port *ata_port_alloc(struct ata_host *host);
>  extern void ata_port_free(struct ata_port *ap);


-- 
Damien Le Moal
Western Digital Research
