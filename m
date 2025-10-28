Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C2E283FF8;
	Tue, 28 Oct 2025 03:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761623838; cv=none; b=MXFWVWq3cqIznIz83f8K2akz92NGCvwYdBBPNZT8C3cKdPrDW53J1UftEDTjFZ7dDP0+jRvTDigqPZip53dJfbPqkwPJH9pBtp8bIoEZEVjkjNYCitU/2xj0XTZiNovsEF0Kd80L2Ul1cqPH2IaMOxdgA/EsBsU2l3I1eocfpWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761623838; c=relaxed/simple;
	bh=ynt5plEYl5dm1sGTyU8tzNNoQJ+b9D93uZu0cDeCric=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UlSamAQvgL2AiWCvipwHA5NUui6nDaniAe095IVIccxkEG7hDpzVUEBQ0UHNkmYH4G2mUGBWuW2ItpZf3XdSj6nKSiVfm/7qhvs7latLAqWjIU6LKiDuvmHYkjZt3/4fUdqmiumr7TiKRgjMLV/GSXNsrdb5BYQL+IvtKj6RjPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jQdXEghL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jQdXEghL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC353C4CEE7;
	Tue, 28 Oct 2025 03:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761623838;
	bh=ynt5plEYl5dm1sGTyU8tzNNoQJ+b9D93uZu0cDeCric=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jQdXEghLsGJSPadDdI2MiZE1iFk/JuCDclHnvGbNM4SY/krRLV16ZNuUDW++SiAFp
	 RMqjSR2kRmWInaBjHtlqdP3N1d7IIiJ4uXoFLzWqnDkJa7Xm6+GK8CfUa4f2+7ifYP
	 7nwqJX12auVIg8+mRXPDDm/hAsAzLJYDmKYonGnGc/yyxRyiAzo5VldKb9RzyGQQqA
	 wfS4ho/QUffh3RU54cIpQPyVrrnGu56ez1v+zjFKl7YwCFoAVWpBZ+B+pvaP7kgQZE
	 a/ucntYeX6lvOvBTjlfXicDWzPmrV9RtmkwBKEVQB5uyhttViMhIdqN1/kWhf7dLbb
	 MWEzObOrTW2Og==
Message-ID: <896e0d4a-b9c2-43d6-a8bd-e717bfbab817@kernel.org>
Date: Tue, 28 Oct 2025 12:53:32 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] ata: stop disk on restart if ACPI power resources
 are found
To: Markus Probst <markus.probst@posteo.de>, Niklas Cassel
 <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251027202339.1043723-1-markus.probst@posteo.de>
 <20251027202339.1043723-3-markus.probst@posteo.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251027202339.1043723-3-markus.probst@posteo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/28/25 5:23 AM, Markus Probst wrote:
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

I think you meant to say "to avoid unclean shutdown due to power loss." ?
Because this is not handling a power failure, but rather a power loss on
shutdown with the device still running, right ?

With that clarified, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
