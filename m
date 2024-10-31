Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9806155333
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 07:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730360777; cv=none; b=klzdhqCxfwRDaqsDsnt/S7ofYxF2QQ0FXR5YufFMuXL2ISiQ5wrRKDVpTxQB9RsGWokUlXNBUh5/2lIyG7dcHCqsk6DabRvG7eBh1xilYA9YlBSeG5la04EFUVtF+PMVYtZ3t7ivcOi0rp8Shc8ufzjGVLBDs38o4sJ6L8cC/g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730360777; c=relaxed/simple;
	bh=sUtQVMqwuhsbex4oTGmNLr+pD8hCpgSQW+7M3d3Hk5k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nKf/L7ohRhpdk9xrsPX5RveqN06/HqEibMOiW5+R8aDWqEItEtOBzSFuyajBkRu8ynD5pefRgp72TgUzdeZb0qmWeEylFNJPwlHCiiaEYj9P+M/U0j/DDBLeoMyydwuVjBkeYropC1rFjyZvSPpl84Ms1cUEbFZUeqxkKrdcB3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 325AF92009C; Thu, 31 Oct 2024 08:46:13 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 2BC5792009B;
	Thu, 31 Oct 2024 07:46:13 +0000 (GMT)
Date: Thu, 31 Oct 2024 07:46:13 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Magnus Lindholm <linmag7@gmail.com>
cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] qla1280.c set DMA_BIT_MASK from bus width
In-Reply-To: <20241029161049.2133-2-linmag7@gmail.com>
Message-ID: <alpine.DEB.2.21.2410310656020.40463@angie.orcam.me.uk>
References: <20241029161049.2133-1-linmag7@gmail.com> <20241029161049.2133-2-linmag7@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 29 Oct 2024, Magnus Lindholm wrote:

> Signed-off-by: Magnus Lindholm <linmag7@gmail.com>

 You'll need some text in your change description for your patch to be 
accepted.

> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 8958547ac111..70409a140461 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -368,6 +374,7 @@
>  
>  #define	MEMORY_MAPPED_IO	1
>  
> +

 Please don't add an extra line.

> @@ -655,18 +662,51 @@ qla1280_info(struct Scsi_Host *host)
>  {
>  	static char qla1280_scsi_name_buffer[125];
>  	char *bp;
> +	char hwrev = ' ';
> +	int bits;
>  	struct scsi_qla_host *ha;
>  	struct qla_boards *bdp;
> +	struct device_reg __iomem *reg;
>  
>  	bp = &qla1280_scsi_name_buffer[0];
>  	ha = (struct scsi_qla_host *)host->hostdata;
> +	reg = ha->iobase;
>  	bdp = &ql1280_board_tbl[ha->devnum];
>  	memset(bp, 0, sizeof(qla1280_scsi_name_buffer));
>  
> +

 Likewise.

> +	if (IS_ISP1040(ha))
> +		switch (ha->revision) {
> +		case 1:
> +			hwrev = ' ';
> +			break;
> +		case 2:
> +			hwrev = 'A';
> +			break;
> +		case 3:
> +			hwrev = ' ';
> +			break;
> +		case 4:
> +			hwrev = 'A';
> +			break;
> +		case 5:
> +			hwrev = 'B';
> +			break;
> +		case 6:
> +			hwrev = 'C';
> +			break;
> +		default:
> +			hwrev = '?';
> +			break;
> +	}

 Currently QLA1040 is always printed even for ISP1020 devices, so I think 
adding a revision to that will only be confusing.  Can this reporting be 
improved by any chance?

> @@ -2177,9 +2224,9 @@ qla1280_nvram_config(struct scsi_qla_host *ha)
>  
>  	if (IS_ISP1040(ha)) {
>  		uint16_t hwrev, cfg1, cdma_conf;
> -

 Please don't remove the line.

>  		hwrev = RD_REG_WORD(&reg->cfg_0) & ISP_CFG0_HWMSK;
>  
> +		ha->revision = hwrev;

 Notice that masking with ISP_CFG0_HWMSK clobbers the revision.  It does 
not matter for existing code, but it breaks your reporting improvement.

 I'm leaving the rest for the time being as you'll need to change the DMA 
mask selection logic as per the other thread.  Overall you'll have to 
split your change into a patch series, with the DMA mask fix and reporting 
improvements each as an individual self-contained update.  This is how we 
do development in principle, but in this particular case the fix also asks 
for being backported, as it addresses data corruption, so it has to be on 
its own.

 NB please run updated patches through scripts/get_maintainer.pl for the 
complete list of recipients to send to.

  Maciej
