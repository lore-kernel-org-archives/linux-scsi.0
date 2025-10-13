Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555E42C0F71;
	Mon, 13 Oct 2025 08:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760343644; cv=none; b=M/LMGUQSO155ao4jIiOoKSL4yDPkvijBT5jgfgXY1iaJ1yhMM+qp/hi0kH7rs7943l/VnjaKfv7N80UjgwvFA21Frla00QW11KucE3uRktTKIdZavYFLv7CG8tTgTDqLVbhWkb4szWDWvu5Z5ZEa5hDdxwN+qeauvJ3rMXhb8ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760343644; c=relaxed/simple;
	bh=WqSVscyKogP7qt1W7UqnltGcwKEGshwHgBtupZDlMcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ev8PCp9xn/NYpHv0Z1+GKqQ3ShVaBJKEGjfzz9PV2OQtcOmWAzyDsK2n50NdnkE+syEZXGGzFdArpj8/xYoZHGd/MS2yalMNTpxpA1Jp54v7ki+T9R/Yug5/VGocMfCkP76y4Ii5CHTr5T+Ct38lZHdDBWAlvTNFeSCm6tHaaoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p2qPs0yE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p2qPs0yE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4950AC4CEE7;
	Mon, 13 Oct 2025 08:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760343643;
	bh=WqSVscyKogP7qt1W7UqnltGcwKEGshwHgBtupZDlMcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p2qPs0yEoNgB8k47PI4VWAe3Te4jP3dnbQ1VgtJf39l8MawlYt1ieIB5qAfK77AXj
	 KOptxF0lfxLHOHjxbvauF1f2Nf5YHwQCt5Nn8zJs7zDRYcWkkLJz5SiyNPt0YqLEKR
	 XvQlEyRuBIvYgvQLH1j2vbkQ/hqX8fGRyMDuqNLYBhfLYr7feLCDKMZe193wFPRWsJ
	 OwPxJlWOrsl7SSGNQU6gW02JCxxiJXAFP3yDSTKSNrH0Bg/F8sCxfwQvz++bhVegdi
	 2qcps3St5ni6QeOkhQ4Zg0IO5QQhc+3NJSSD7yV0Y2N+bQN/LqydJEMnsOIr6g1uvD
	 ltE5FO8PU5Gag==
Date: Mon, 13 Oct 2025 10:20:39 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Markus Probst <markus.probst@posteo.de>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ata: Use ACPI methods to power on disks
Message-ID: <aOy2Vy6AQNynzewo@ryzen>
References: <20251010223817.729490-1-markus.probst@posteo.de>
 <20251010223817.729490-3-markus.probst@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010223817.729490-3-markus.probst@posteo.de>

On Fri, Oct 10, 2025 at 10:38:35PM +0000, Markus Probst wrote:
> Some embedded devices have the ability to control whether power is
> provided to the disks via the sata power connector or not. If power
> resources are defined on ata ports / devices in ACPI, we should try to set
> the power state to D0 before probing the disk to ensure that any power
> supply or power gate that may exist is providing power to the disk.
> 
> An example for such devices would be newer synology nas devices. Every
> disk slot has its own sata power connector. Whether the connector is
> providing power is controlled via an gpio, which is *off by default*.
> Also the disk loses power on reboots.
> 
> Add a new function, ata_acpi_dev_manage_restart(), that will be used to
> determine if a disk should be stopped before restarting the system. If a
> usable ACPI power resource has been found, it is assumed that the disk
> will lose power after a restart and should be stopped to avoid a power
> failure. Also add a new function, ata_acpi_port_set_power_state(), that
> will be used to power on the sata power connector if usable ACPI power
> resources on the associated ata port are found. It will be called right
> before probing the port, therefore the disk will be powered on just in
> time.

s/sata/SATA/
s/nas/NAS/
s/ata/ATA/ (except for function names of course)

Since this patch is basically doing two logical changes
1) Calling ata_acpi_dev_manage_restart() on restart, which calls
acpi_bus_power_manageable() to disable power on shutdown.

2) Calling ata_acpi_port_set_power_state() during ata_port_probe(),
to enable power.

Please also split this patch into two, so that we have one commit per
logical change. That would make things easier to understand, as your
commit message your just describe one behavior instead of two completely
different behaviors.


Your commit message mentions that you want to spin down the disk on
restart to avoid "avoid a power failure".

Is there a reason why you call acpi_bus_power_manageable() to spin down
the disk instead of the regular function: ata_dev_power_set_standby()
which spins down the disk?


> 
> Signed-off-by: Markus Probst <markus.probst@posteo.de>
> ---
>  drivers/ata/libata-acpi.c | 71 +++++++++++++++++++++++++++++++++++++++
>  drivers/ata/libata-core.c |  2 ++
>  drivers/ata/libata-scsi.c |  1 +
>  drivers/ata/libata.h      |  4 +++
>  4 files changed, 78 insertions(+)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index f2140fc06ba0..4a72a98b922c 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -245,6 +245,77 @@ void ata_acpi_bind_dev(struct ata_device *dev)
>  				   ata_acpi_dev_uevent);
>  }
>  
> +/**
> + * ata_acpi_dev_manage_restart - if the disk should be stopped (spun down) on
> + * system restart.
> + * @dev: target ATA device
> + *
> + * RETURNS:
> + * 1 if the disk should be stopped, otherwise 0
> + */
> +bool ata_acpi_dev_manage_restart(struct ata_device *dev)
> +{
> +	// If the device is power manageable and we assume the disk loses power
> +	// on reboot.

Please no C++ style comments.

Also "If the device is power manageable and we assume"
should this not be
"If the device is power manageable, we assume"

Because your commit message says:
"If a usable ACPI power resource has been found, it is assumed that the disk
will lose power after a restart"

so I think the word "and" here is wrong.


> +	if (dev->link->ap->flags & ATA_FLAG_ACPI_SATA) {
> +		if (!is_acpi_device_node(dev->tdev.fwnode))
> +			return 0;
> +		return acpi_bus_power_manageable(ACPI_HANDLE(&dev->tdev));
> +	}
> +

Please add a commend here explaining the difference between the
two cases, because you call either:
return acpi_bus_power_manageable(ACPI_HANDLE(&dev->tdev));
or
return acpi_bus_power_manageable(ACPI_HANDLE(&dev->link->ap->tdev));

At least the difference is not obvious to me, from just looking at this
function.


> +	if (!is_acpi_device_node(dev->link->ap->tdev.fwnode))
> +		return 0;
> +	return acpi_bus_power_manageable(ACPI_HANDLE(&dev->link->ap->tdev));
> +}
> +
> +/**
> + * ata_acpi_port_set_power_state - set the power state of the ata port
> + * @ap: target ATA port
> + * @enable: power state to be set
> + *
> + * This function is called at the beginning of ata_port_probe.
> + */
> +void ata_acpi_port_set_power_state(struct ata_port *ap, bool enable)

This function is never called with enable==false, so let's please remove
this parameter and rename the function to something like
ata_acpi_port_enable_power() or similar.
If someone a future patch ever wants to refactor this to also handle
disable, then that patch can also create a parameter for this function.
Otherwise we are just adding dead code.


Kind regards,
Niklas
