Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EEF6AB9;
	Thu, 27 Jun 2024 01:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719451911; cv=none; b=L6oOyU4ZF1FoCY9dFf7fJsOweR2cgDO7pxGFXcEHsyEk57659su06v2EauM9qu7Oh12srrbLfUWnaB2/R9oeYpHV2JznI03u/m4QGcRfqmbdPVv21JKBc3I9hyL4ZMCmG2dqfbvWJ3359VcT1L5/sQMw/Qi7iw8wPc/JIopOxf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719451911; c=relaxed/simple;
	bh=jy1htihZZx2t+mHXKrZHZ5fn0bhyk73W8j+79tfMoX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B2sILGo+ScAW7x0fz0PnS1qRFK/vrg4pnifpVwsq1XG2octG8newOfAIDhsg3yMmc4Qc9v/Z1pBzwFg1w6qZ+xaXBepN4+pHYSrdP4pMt1MzFCOeaGb718Hfxv5F4JUt7zv7m0J8uNpjzEbzBluDAD5I/Sv1vZd2Qbfqtgd9luM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=etDhIMqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="etDhIMqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1F3C116B1;
	Thu, 27 Jun 2024 01:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719451910;
	bh=jy1htihZZx2t+mHXKrZHZ5fn0bhyk73W8j+79tfMoX8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=etDhIMqgwbz1XUIu5dPVagm5GshOZAXg6sWMjjoNUPOSQhvDoZHg46jmfE29tQCmy
	 bKsYO2BzKgKkqPLSuVB++HuxfQCd9H/HPPeLB78YaNMae1UwMOdNuBuIFJ9TUM2Ut7
	 WGnXESAuxxp6qcQErkUorgCNFfaFx6TKqyy/m4N9Ruv6hfk4v4K8O9aEvtGV1H3RdC
	 dbivVdrv2cNlfVI58eZZtWLCNZg+huuq2gDx41wBDBWKZEUjRM27p2n85aDzUHLd+6
	 pLlwwjho9XlTee1ZQzA3ypes/1vs85RmaoxqFmvzV0bTRpM1kw9+QSOp78JTvl5LEx
	 vtbJpmtCcMxKQ==
Message-ID: <1e88506f-eb3d-45e8-8c11-97325497d23d@kernel.org>
Date: Thu, 27 Jun 2024 10:31:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/13] ata: libata-sata: Remove superfluous assignment
 in ata_sas_port_alloc()
To: Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-23-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240626180031.4050226-23-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 03:00, Niklas Cassel wrote:
> ata_sas_port_alloc() calls ata_port_alloc() which already assigns ap->lock
> so there is no need to ata_sas_port_alloc() to assign it again.

Nit: s/need to/need for

> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
>  drivers/ata/libata-sata.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index e7991595bfe5..1a36a5d1d7bc 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1228,7 +1228,6 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
>  		return NULL;
>  
>  	ap->port_no = 0;
> -	ap->lock = &host->lock;
>  	ap->pio_mask = port_info->pio_mask;
>  	ap->mwdma_mask = port_info->mwdma_mask;
>  	ap->udma_mask = port_info->udma_mask;

-- 
Damien Le Moal
Western Digital Research

