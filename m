Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AC5221DB1;
	Thu, 23 Oct 2025 20:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761252558; cv=none; b=eF4JFHPozXFO22LqM9cxMd0PzGwokZ2YuLJKgmrWvnziV9WoNkLikMQfLfnyFyLVQgGSU3gQxgf2YiKyQR1wppY52LgLOYyEfRPQ7VWtUAOQ+6VxVWcVrjdaj3XY6nt629/qMfpx0Lcti3Vp0fzF9CsYHNYhAh2FyeusRmjgvZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761252558; c=relaxed/simple;
	bh=rTnxbfw78lgnyUm0E2PF8Vgl+6eU7Ji3n5U9PshCkZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VewiRMl6OVUzfs3ekXkqcxeWrlLleTTIVDZlSsF+ppDn3VtTMpv3IPvOXWsQfPs3voUyyyqhXdeVyiudD8i91yptk4lztzWtP4OAyLV/iLXCLtcMIzEFdnrj1eXKn3IdewbL75s0O1bzQadVUZQbLg2BfW0Ih898j7YKoe+DO5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/6vLuiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/6vLuiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02CFC4CEE7;
	Thu, 23 Oct 2025 20:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761252557;
	bh=rTnxbfw78lgnyUm0E2PF8Vgl+6eU7Ji3n5U9PshCkZM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T/6vLuiDda8wdXfAaqDeo6kJVlaQNYkpvw9SgAUUi1vpPcgU+olmHDdmvQqsScnpc
	 5QSOl4nLYE23eixIZJV/rNfTLabBES6pT69Q4XhhP+F6xy0vjt+TCILbTHp6dBVInP
	 bMe+tiYwatAO7yzvhvPIpqIhXC+tzzzf2acvv2lOsjyPG9QixndcnrAVHBR6H3wSc5
	 AT+B6J1baHrlilynl999eFA830Si28I3NBCMbgzLS1LNb26p+jpTplSk9vRvVK2gbG
	 IsHJ8HcAiWcA1DuchcPPjQZ+KmiaF6J1HiOG+aofJZHYObJzpc2itCs44ZFgcZEway
	 yL6rtfxoNtvrg==
Message-ID: <8efdeaad-4f69-44d5-90d7-f5af005d8abf@kernel.org>
Date: Thu, 23 Oct 2025 13:49:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] ata: stop disk on restart if ACPI power resources
 are found
To: Markus Probst <markus.probst@posteo.de>, Niklas Cassel
 <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251023165151.722252-1-markus.probst@posteo.de>
 <20251023165151.722252-3-markus.probst@posteo.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251023165151.722252-3-markus.probst@posteo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/10/23 9:52, Markus Probst wrote:
> Some embedded devices have the ability to control whether power is
> provided to the disks via the SATA power connector or not. ACPI power
> resources are usually off by default, thus making it unclear if the
> specific power resource will retain its state after a restart. If power
> resources are defined on ATA ports / devices in ACPI, we should stop the
> disk on SYSTEM_RESTART, to ensure the disk will not lose power while
> active.
> 
> Add a new function, ata_acpi_dev_manage_restart(), that will be used to
> determine if a disk should be stopped before restarting the system. If a
> usable ACPI power resource has been found, it is assumed that the disk
> will lose power after a restart and should be stopped to avoid a power
> failure.
> 
> Signed-off-by: Markus Probst <markus.probst@posteo.de>
> ---
>  drivers/ata/libata-acpi.c | 28 ++++++++++++++++++++++++++++
>  drivers/ata/libata-scsi.c |  1 +
>  drivers/ata/libata.h      |  2 ++
>  3 files changed, 31 insertions(+)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index f2140fc06ba0..f05c247d25bc 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -245,6 +245,34 @@ void ata_acpi_bind_dev(struct ata_device *dev)
>  				   ata_acpi_dev_uevent);
>  }
>  
> +/**
> + * ata_acpi_dev_manage_restart - if the disk should be stopped (spun down) on
> + * system restart.

Please align "system restart" to the "if" above.

> + * @dev: target ATA device
> + *
> + * RETURNS:
> + * 1 if the disk should be stopped, otherwise 0

s/1/true
s/0/false

And please terminate sentences with a period.

> + */
> +bool ata_acpi_dev_manage_restart(struct ata_device *dev)
> +{
> +	/* If the device is power manageable, we assume the disk loses power on
> +	 * reboot.
> +	 */

And then ? This seems incomplete...
Also please adhere to the normal multi-line comment style by starting the
multi-line comment block with "/*".

	/*
	 * If the device is power manageable, we assume the disk loses power on
	 * reboot.
	 */

> +
> +	/* If `ATA_FLAG_ACPI_SATA` is set, the acpi fwnode is attached to the
> +	 * `ata_device` instead of the `ata_port`.
> +	 */

No need for all the quote marks here.

> +	if (dev->link->ap->flags & ATA_FLAG_ACPI_SATA) {
> +		if (!is_acpi_device_node(dev->tdev.fwnode))
> +			return 0;

			return false;

> +		return acpi_bus_power_manageable(ACPI_HANDLE(&dev->tdev));
> +	}
> +
> +	if (!is_acpi_device_node(dev->link->ap->tdev.fwnode))
> +		return 0;

		return false;

> +	return acpi_bus_power_manageable(ACPI_HANDLE(&dev->link->ap->tdev));
> +}

Overall, I think the following is cleaner and simpler as it doe not repeat code:

bool ata_acpi_dev_manage_restart(struct ata_device *dev)
{
	struct device *tdev;

	/*
	 * If ATA_FLAG_ACPI_SATA is set, the acpi fwnode is attached to the
	 * ATA device instead of the port.
	 */
	if (dev->link->ap->flags & ATA_FLAG_ACPI_SATA)
		tdev = &dev->tdev;
	else
		tdev = &dev->link->ap->tdev;

	if (!is_acpi_device_node(tdev->fwnode))
		return false;

	return acpi_bus_power_manageable(ACPI_HANDLE(tdev));
}

> +
>  /**
>   * ata_acpi_dissociate - dissociate ATA host from ACPI objects
>   * @host: target ATA host
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index b43a3196e2be..026122bb6f2f 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1095,6 +1095,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct queue_limits *lim,
>  		 */
>  		sdev->manage_runtime_start_stop = 1;
>  		sdev->manage_shutdown = 1;
> +		sdev->manage_restart = ata_acpi_dev_manage_restart(dev);
>  		sdev->force_runtime_start_on_system_start = 1;
>  	}
>  
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index e5b977a8d3e1..af08bb9b40d0 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -130,6 +130,7 @@ extern void ata_acpi_on_disable(struct ata_device *dev);
>  extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
>  extern void ata_acpi_bind_port(struct ata_port *ap);
>  extern void ata_acpi_bind_dev(struct ata_device *dev);
> +extern bool ata_acpi_dev_manage_restart(struct ata_device *dev);
>  extern acpi_handle ata_dev_acpi_handle(struct ata_device *dev);
>  #else
>  static inline void ata_acpi_dissociate(struct ata_host *host) { }
> @@ -140,6 +141,7 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
>  				      pm_message_t state) { }
>  static inline void ata_acpi_bind_port(struct ata_port *ap) {}
>  static inline void ata_acpi_bind_dev(struct ata_device *dev) {}
> +static inline bool ata_acpi_dev_manage_restart(struct ata_device *dev) { return 0; }
>  #endif
>  
>  /* libata-scsi.c */


-- 
Damien Le Moal
Western Digital Research
