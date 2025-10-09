Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0331E1E12;
	Thu,  9 Oct 2025 11:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760011175; cv=none; b=HKrW6jkhkzjrR2knfSJXCtUDbdWzfKSKrCT6xNLN0GvrCe2WdBr1//l8xV5HDj7VFtd4C2q69jzhvkCanUt0fhLandqYUPPdn75px9OfgkjRX9+Jx+SBhaWCMeGbAAG14uXelkhyyOjOnUf5roRbtSovsoiayZBgIZ7edioVHZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760011175; c=relaxed/simple;
	bh=5Mvef/DdaBxamtyhas+4duS0BHXlqranUz6aaOC1nzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bXDVVP2ASFOtFRALz2p6gQ9bjxrk++4B6gNRZn0OoqeF34faOgUECc5LiU/0Ary6vK7phowBLD+GyU8a49ERilvk7AxKBAGP35jQmdGxK0nvl2y/No4Av5aiGMEX4R9gIbPz31fxXgpLBbbylqvWF8QHB5XQ5MKrgONVNyrn2AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KssFZgDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KssFZgDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46499C4CEF5;
	Thu,  9 Oct 2025 11:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760011175;
	bh=5Mvef/DdaBxamtyhas+4duS0BHXlqranUz6aaOC1nzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KssFZgDsZCV2Ys1nIDByjcOd1F8DyiOkN6PMwceer++FQGrBYnwZaixHTYwiDhXFT
	 Gng5Udq34G1unrCfrPHzEeIFhSr92ZzzJMrUirXmRLltZcJ4CBbzOf67UIPoxgRDR3
	 vOJevgyjdwJr1DLXwpLnnLinhIbVqCraNR2pim7a379PdXDSOUB0M1nDnvphwe3hJx
	 XczveJE93gGcc+f8931mrKkuO4cKeQHf3/wxvTck6bQlgafVXATnSTgpA2dvL74qPX
	 omw4SesB7DX+BygNpOvZOKvNrUJwX6cX1L8U8h4Qsa/VDwxph8QsPCEuM43Kltmbs8
	 EPoshdGzEZ9Ig==
Date: Thu, 9 Oct 2025 13:59:30 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Markus Probst <markus.probst@posteo.de>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ata: Use ACPI methods to power on ata ports
Message-ID: <aOejov5d_TlVkueH@ryzen>
References: <8c3cb28c57462f9665b08fdaa022e6abc57fcd9e.camel@posteo.de>
 <20251009112433.108643-1-markus.probst@posteo.de>
 <20251009112433.108643-3-markus.probst@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009112433.108643-3-markus.probst@posteo.de>

On Thu, Oct 09, 2025 at 11:24:49AM +0000, Markus Probst wrote:
> Some embedded devices, including many Synology NAS devices, have the
> ability to control whether a ATA port has power or not.

In V1, you mentioned that it was to control the SATA power supply,
now you mention the ATA port. I am confused.

If it is for the ATA port, then SATA already has support for this,
using PxSCTL.

How does this ACPI way to control power interact with the regular
way to control power for a port using PxSCTL?


> 
> Add a new function, ata_acpi_dev_manage_restart(), that will be used to
> determine if a disk should be stopped before restarting the system. If a
> usable ACPI power resource has been found, it is assumed that the disk
> will lose power after a restart and should be stopped to avoid a power
> failure. Also add a new function, ata_acpi_port_set_power_state(), that
> will be used to power on an ata port if usable ACPI power resources are
> found. It will be called right before probing the port, therefore the port
> will be powered on just in time.
> 
> Signed-off-by: Markus Probst <markus.probst@posteo.de>
> ---
>  drivers/ata/libata-acpi.c | 70 +++++++++++++++++++++++++++++++++++++++
>  drivers/ata/libata-core.c |  2 ++
>  drivers/ata/libata-scsi.c |  1 +
>  drivers/ata/libata.h      |  4 +++
>  4 files changed, 77 insertions(+)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index f2140fc06ba0..bba5ef49f055 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -245,6 +245,76 @@ void ata_acpi_bind_dev(struct ata_device *dev)
>  				   ata_acpi_dev_uevent);
>  }
>  
> +/**
> + * ata_acpi_dev_manage_restart - if the disk should be stopped (spin down) on
> + * system restart.
> + * @dev: target ATA device
> + *
> + * RETURNS:
> + * true if the disk should be stopped, otherwise false
> + */
> +bool ata_acpi_dev_manage_restart(struct ata_device *dev)
> +{
> +	// If the device is power manageable and we assume the disk loses power
> +	// on reboot.

Like Damien mentioned earlier, please no C++ style comments.


Kind regards,
Niklas
