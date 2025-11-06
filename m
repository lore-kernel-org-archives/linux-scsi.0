Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D06A7FBA2;
	Thu,  6 Nov 2025 07:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762413367; cv=none; b=H2OjtLIdgK9swziWHMJIm37mY4QkWnfW8PlozPF6bF9ryqcEpwRF9+uxq42vxB88UI9+4ccmHCSB9+oC5ukYjMG74HGDG09oXOcHh7bHETS2e+7MoFDU7PgvERDRiLOz6OglnOvYKuRzWojnX/ocnTppqqTmHuJmJBd99p2VEn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762413367; c=relaxed/simple;
	bh=Twy8mmHy7U2wj3bLY/1A4yl68N/dIj9GkGpmlchk0Ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vr4wCJab7Hu4PP4+z0yEe6T+D7b0M+8HfWdSNz/4czXahrZYp/Sie/TSPmOKEMSicKLs9DNmpZVWqE9sqNI7KZIbqbrAEdUgEC9xsWlzRtRrYVGrtuyEXdz9vpe6tx2vrpTpQoG4xLRw+iFuMZoFAAV4oe6QAZsv1e2B6j7pxJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EwIBjoPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EwIBjoPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2897C4CEF7;
	Thu,  6 Nov 2025 07:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762413367;
	bh=Twy8mmHy7U2wj3bLY/1A4yl68N/dIj9GkGpmlchk0Ds=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EwIBjoPqIA7xofTl5ZFh9mi0WVBnMao457CaooQfiyxu9AOprWRrY8UmbDTGiTCco
	 R1bLM7BdZ7Mt4mTFUBoeQ4OI0MWBybpty+bwAaSrtby1b+CRBZXNXlxpTMBHUJAd38
	 3CJfPDQxm71qtCXb8A14VTP/bnNbfEmUt1WLMcXAGIDsO7tXmI+2X2ZdUnhge1qVhf
	 zlKDzM92D+o+8wAKbTLKHm9JYJLsg+9FfYlHytffoqVXNVZOvLcCAk+BqDgJpoAaJP
	 8V5PYs1AzkGGQYnhhNAsgUzFMXM5fF7LbhT3nG4uV0CpXBqI35WmFcyiBdd2CVzQuu
	 CaXCYSCcLPV9w==
Message-ID: <9724fc14-c362-4f70-b14b-718049737895@kernel.org>
Date: Thu, 6 Nov 2025 16:12:12 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] ata: Use ACPI methods to power on disks
To: Markus Probst <markus.probst@posteo.de>, Niklas Cassel
 <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251104142413.322347-1-markus.probst@posteo.de>
 <20251104142413.322347-3-markus.probst@posteo.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251104142413.322347-3-markus.probst@posteo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/25 11:24 PM, Markus Probst wrote:
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

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
