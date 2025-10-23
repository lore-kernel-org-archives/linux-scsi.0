Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A32227E83;
	Thu, 23 Oct 2025 20:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761252965; cv=none; b=BProLaTgLBXmBpy3nIVxkdIa0X4BWkVH/ZmRxP24oA5BJ5Ff9i3mEgIZGfebcNH/njItALVko77BOjERLCSUJKz55XQq2TvJXcBMl0gmsfD4huhi2VuedQScfKZL7cPoRONGWNILVnqIh5g9Xs9P6RWkPNBxJzhmrlkVQxaxV7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761252965; c=relaxed/simple;
	bh=NIDohqEvg6ulwO9TZBZ8QHqBnnBapxawQLIajgUxLhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=evW/fqcqItQku+qXG1rmOO1uEiznnAsdeAaA4HTCNCHKTqvsyupOVuIGYnmbjRtB3kXtVs7ainEWDjstbyvv+v1eq6Chx1m2yLDaDN1UxFIceQV0iILJls/DF9dLP4p1V8wrz6t/wPPPqkro6ZUQTLKlOgMR4HL9ZZ0fjldygxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iq0pRHT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iq0pRHT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D171C4CEE7;
	Thu, 23 Oct 2025 20:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761252962;
	bh=NIDohqEvg6ulwO9TZBZ8QHqBnnBapxawQLIajgUxLhw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Iq0pRHT8EDoDjSv/dfkaJwrTU+2X7tK4k3sCPPvgIUB4UMt1+iNm6SKXZrT8KN5dt
	 BljJ2o3Y3hMDx2yv9c8xaEP1vCkehhY2Z7pu+CNDYPy+z96q4jpZFc4bgLwnppDChJ
	 hU3POC8TMkHpVQ4ACICZF2Ffb/jNjX/J9NzdaBsbnPLUv1Q1u9M4v9YOwMTKgeYlpI
	 U4WE+E7PDaP0VAm8QvbVG4GVWJb/8SzMdKjxHgcqSG6xRQ2D23y+Obj0vTp2bclZGc
	 UcmhxKYPAA9I7J60E0MnRksWTaiWYmndWBHH40moY7m+QXU85Sq8F3+AIoRU7F2Ow1
	 NbgWQa279jlMQ==
Message-ID: <df9980f4-67c4-48d9-a5fd-56d5f15b7482@kernel.org>
Date: Thu, 23 Oct 2025 13:56:02 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] ata: Use ACPI methods to power on disks
To: Markus Probst <markus.probst@posteo.de>, Niklas Cassel
 <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251023165151.722252-1-markus.probst@posteo.de>
 <20251023165151.722252-4-markus.probst@posteo.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251023165151.722252-4-markus.probst@posteo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/10/23 9:52, Markus Probst wrote:
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
> ---
>  drivers/ata/libata-acpi.c | 40 +++++++++++++++++++++++++++++++++++++++
>  drivers/ata/libata-core.c |  2 ++
>  drivers/ata/libata.h      |  2 ++
>  3 files changed, 44 insertions(+)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index f05c247d25bc..9d6177420e82 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -273,6 +273,46 @@ bool ata_acpi_dev_manage_restart(struct ata_device *dev)
>  	return acpi_bus_power_manageable(ACPI_HANDLE(&dev->link->ap->tdev));
>  }
>  
> +/**
> + * ata_acpi_port_power_on - set the power state of the ata port to D0
> + * @ap: target ATA port
> + *
> + * This function is called at the beginning of ata_port_probe.
> + */
> +void ata_acpi_port_power_on(struct ata_port *ap)
> +{
> +	acpi_handle handle;
> +	int i;
> +
> +	/* If `ATA_FLAG_ACPI_SATA` is set, the acpi fwnode is attached to the
> +	 * `ata_device` instead of the `ata_port`.
> +	 */
> +	if (ap->flags & ATA_FLAG_ACPI_SATA) {
> +		for (i = 0; i < ATA_MAX_DEVICES; i++) {

Adding:

			struct device *tdev = &ap->link.device[i].tdev;

will simplify the code a little below, and make the lines shorter (they are too
long).
> +			if (!is_acpi_device_node(ap->link.device[i].tdev.fwnode))
> +				continue;
> +			handle = ACPI_HANDLE(&ap->link.device[i].tdev);
> +			if (!acpi_bus_power_manageable(handle))
> +				continue;
> +			if (!acpi_bus_set_power(handle, ACPI_STATE_D0))
> +				ata_dev_dbg(&ap->link.device[i], "acpi: power on\n");

Long line. Please split.
But is this debug message really needed ?

> +			else
> +				ata_dev_err(&ap->link.device[i], "acpi: failed to power state\n");

Very long line. Please split.

> +		}
> +		return;
> +	}

A blank line here would be nice.

> +	if (!is_acpi_device_node(ap->tdev.fwnode))
> +		return;
> +	handle = ACPI_HANDLE(&ap->tdev);
> +	if (!acpi_bus_power_manageable(handle))
> +		return;
> +
> +	if (!acpi_bus_set_power(handle, ACPI_STATE_D0))
> +		ata_port_dbg(ap, "acpi: power on\n");
> +	else
> +		ata_port_err(ap, "acpi: failed to set power state\n");

"to set power state" is not very clear. Which state ? Please rephrase this
message. Same remark for the same message above in the for loop

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
