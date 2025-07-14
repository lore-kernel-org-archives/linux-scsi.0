Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDD52E3707;
	Mon, 14 Jul 2025 07:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752479798; cv=none; b=ETvM7BY61MLZLXjFhYDUrZj/GO42PPz5eXiz4TQoeY0zzpWAhVSdj15/NLBKyxkQjcg1eO4Pns62xdiFJHmDsyTirZlxq26vYoV/JnNa7cx10Qk663BdZ5Hmh9WcMWeLUuMU3srRys9diDAIbH2S9K4rFNRotQVl0Mqn6TMSZ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752479798; c=relaxed/simple;
	bh=pS+IyBVHXRGrL+UhKGBYuMctr3AMVlPFFDs/06qNKkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9uOGYGwbJ1cKVBlr3Yli1DB2+Rss1dmJUImO2z+lzko+pq2MToyBDL2th2BeJ2RGdcIEEQs9QbA1c7e/zwX53BlVdGnfmAg8YAPqd0W/vELWgLBa4s6kcWBmqS/ARCNrpwCFbkm4HaqsyQG/rAV2AufnZTxShaWSCpN2sh7YEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YG+uelsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YG+uelsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5B0C4CEED;
	Mon, 14 Jul 2025 07:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752479798;
	bh=pS+IyBVHXRGrL+UhKGBYuMctr3AMVlPFFDs/06qNKkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YG+uelsqG9Zxy875TjXK/h+Jslf1MbolWIBw9c530DLNo7Z+wTas7L9muV0/RQnyh
	 t3LcbZlLc9D360doL9XEFsVBVO6GAUw/fZ+GIy1xThGePFyyaVgF9XC9wRz8fF4PCy
	 thEIzYnA8pOlo2uSmNr36xmTW6PWSAQL8jdN6AC8qTQayESOrcQaUGkQ7DTMySljxx
	 HKrCLEIP6DMZtW1k2FHbgN6AakL6lEJj+cZfPpLDkPorp6zRbJBYbXc75MqrhmdHSS
	 7Yz8pEVn54OHXU8MkAWloI97dRVO0BAF7rkWHAFjOMecvMm+V420QVrsZw61/OW5D3
	 iHfLWDka08qmA==
Date: Mon, 14 Jul 2025 09:56:34 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v4 2/3] ata: libata-eh: Simplify reset operation
 management
Message-ID: <aHS4MmhX0W33SxL7@ryzen>
References: <20250714005454.35802-1-dlemoal@kernel.org>
 <20250714005454.35802-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714005454.35802-3-dlemoal@kernel.org>

On Mon, Jul 14, 2025 at 09:54:53AM +0900, Damien Le Moal wrote:
> Introduce struct ata_reset_operations to aggregate in a single structure
> the definitions of the 4 reset methods (prereset, softreset, hardreset
> and postreset) for a port. This new structure is used in struct ata_port
> to define the reset methods for a regular port (reset field) and for a
> port-multiplier port (pmp_reset field). A pointer to either of these
> fields replaces the 4 reset method arguments passed to ata_eh_recover()
> and ata_eh_reset().
> 
> The definition of the reset methods for all drivers is changed to use
> the reset and pmp_reset fields in struct ata_port_operations.
> 
> A large number of files is modifed, but no functional changes are
> introduced.
> 
> Suggested-by: Niklas Cassel <cassel@kernel.org>
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---

(snip)

> diff --git a/drivers/ata/pata_parport/pata_parport.c b/drivers/ata/pata_parport/pata_parport.c
> index 93ebf566b54e..8de63d889a68 100644
> --- a/drivers/ata/pata_parport/pata_parport.c
> +++ b/drivers/ata/pata_parport/pata_parport.c
> @@ -321,8 +321,7 @@ static void pata_parport_drain_fifo(struct ata_queued_cmd *qc)
>  static struct ata_port_operations pata_parport_port_ops = {
>  	.inherits		= &ata_sff_port_ops,
>  
> -	.softreset		= pata_parport_softreset,
> -	.hardreset		= NULL,

I think you need to add .reset.hardreset = NULL, because pata_parport_port_ops
inherits ata_sff_port_ops, which does set hardreset, so I think this line will
clear the pointer.


> +	.reset.softreset	= pata_parport_softreset,
>  
>  	.sff_dev_select		= pata_parport_dev_select,
>  	.sff_set_devctl		= pata_parport_set_devctl,


Rest looks good to me:
Reviewed-by: Niklas Cassel <cassel@kernel.org>


Tell me if you want to fix it up when applying or if you want to send a new
version.


Kind regards,
Niklas
