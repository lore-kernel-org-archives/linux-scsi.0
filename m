Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0436197A7D;
	Sun, 26 Apr 2026 23:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777246648; cv=none; b=ZlSqBU0x7NTgp9QvjeNIHBXAdGUSBajvNY657JDx5X2KAcouKm+z0/+bMGTMlRxZNhTe3RdiDUJEvt1IN4Z/L4eXtG0ikTZbf5aKDiO9DQ8QYKuCYGQpRbOF9DkPIxZ+7Pu61ZbtobGXQMEKm436V4kvlKtOgkTCh1+nnoBK038=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777246648; c=relaxed/simple;
	bh=sMDyinNuAsv12Ena7vNmBzeiWqr1LDKhrZyHoDLKWko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NZLc6p74ZIXWU9mFIlx66r4Jnx6ATH1ROC6yBOa9uJol39bjCH28WdRZPU5d4NVKpsOsQziDneyazhD+FTcrGvrqYtuKmLinLSGY/jh/UUnzgSyScc47KzLC+5HXvEiTKUIDNl0C/yb1GPqn970IoJ7pXUaD1Dlj0UbpCPglFQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCi2qJu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCi2qJu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76688C2BCAF;
	Sun, 26 Apr 2026 23:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777246648;
	bh=sMDyinNuAsv12Ena7vNmBzeiWqr1LDKhrZyHoDLKWko=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fCi2qJu8R30u7fRMNg4NM6h2T3nsxrc98gRXW1hPLdDTKUXMcve7Yof7NtrgV2m6j
	 DGhdxPRVDlirpU/FSbSeW5+w/DCUFeJLkWDJcvwMaVagLE2JSnmgE9GsVbRqie0x8K
	 f1Nr5Mx1JygqCmPcVXC2P0uHg6dFyf0B15my5LP33wS6FU7/4NiYOW0zbqXfyHc5Bi
	 uJPeYdcLAAYE19ifV3xsRjgdNvYI9fobYmWVU7N/cpe8oBbOl7W852yxYYNDJObs0c
	 XxihEXToJyNS6Oitv/e7mNrSNQYRP61ujBXCInuLITvHeE9Ise9B6Sc9Am0n3hyVms
	 1cd7QjCpNTyiA==
Message-ID: <b1875ef5-a898-47ed-8cd4-1915d6097bcf@kernel.org>
Date: Mon, 27 Apr 2026 08:37:20 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] scsi: scsi_devinfo: add COMPAQ PD-1 multi-LUN
 ATAPI device quirk
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
 <20260426190920.2051289-7-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260426190920.2051289-7-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/27/26 4:09 AM, Phil Pemberton wrote:
> The COMPAQ PD-1 (OEM Panasonic/Matsushita LF-1195C) is a PD/CD combo
> drive that exposes two ATAPI LUNs: LUN 0 is a CD-ROM (TYPE_ROM),
> LUN 1 is a 650 MB PD (TYPE_DISK).
> 
> Add it to the SCSI device list with:
>   - BLIST_FORCELUN: tells the SCSI layer to scan past LUN 0
>   - BLIST_SINGLELUN: serialises commands across the two LUNs, since
>     the drive has a single transport and cannot handle concurrent
>     operations on both
>   - BLIST_NO_LUN_1F: the drive returns PQ=0/PDT=0x1f for unpopulated
>     LUNs instead of PQ=3; this flag tells scsi_probe_and_add_lun()
>     to silently skip them
> 
> The INQUIRY strings as reported by the device are:
>   Vendor:  "COMPAQ  " (T10 format, space-padded)
>   Product: "PD-1"
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
