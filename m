Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61F0225A30;
	Thu,  6 Feb 2025 14:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738852090; cv=none; b=RIkp3Lu/EHxYb+OwaBbGfXWk0IVf56ogvTRxgSm9bmAI6k9kgTuP+HE2VHaXePpLeeR7kdbLmYvrryodo7FPZiw73gVukcj8L7hb8QQVT6LmIQ55CONAKPdyRxANAhkAzsQ+bV0qhFuXiT1JJMmg6ViOp5eokoGuC2MIo+lsZgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738852090; c=relaxed/simple;
	bh=xEGVwu4ZhC6jHJ7DDWTDV+bZUvs+4SMtuUoW0awunFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+Qfj/Q1QzcjF5pXbuILDLHLkICqGH9X9+Z3QLjHVnfdTqCoLfGtV1kd5JRTXTpnHFPwwYrX1uDG0uHwsGdCmM/4IFsmCxgld7ffLYaU2AlXgJRmaCpeF75KL7FUpYWK1iSqvE4SAdx8eAjd3FpgTo1cTaoAsU27O4o0tP5xH2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUGgnhl2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUGgnhl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0794DC4CEDD;
	Thu,  6 Feb 2025 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738852090;
	bh=xEGVwu4ZhC6jHJ7DDWTDV+bZUvs+4SMtuUoW0awunFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HUGgnhl2GzLq9a8ffCa+61N8TpO3Roa56omdYkUseeGeFN72Xr3FuRw32lTHD5qaO
	 tdCNKofACxAhGpBrPxXcKC+zxcs2cR0sKg5xH5WlP6rS1vJB3wNLkToumdCs1GXwM3
	 zRGvExUoUzqAYKfIFv8WyZ7ZBHf9IMCyzRVBR2hE=
Date: Thu, 6 Feb 2025 06:36:58 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Cc: markus.elfring@web.de, GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com, arun.easi@cavium.com,
	bvanassche@acm.org, jhasan@marvell.com,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com, martin.petersen@oracle.com,
	nilesh.javali@cavium.com, skashyap@marvell.com,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: qedf: Replace kmalloc_array() with kcalloc()
Message-ID: <2025020626-purist-chrome-0dd6@gregkh>
References: <d4db5506-6ace-4585-972e-6b7a6fc882a4@web.de>
 <20250206052523.16683-1-jiashengjiangcool@gmail.com>
 <20250206052523.16683-2-jiashengjiangcool@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206052523.16683-2-jiashengjiangcool@gmail.com>

On Thu, Feb 06, 2025 at 05:25:22AM +0000, Jiasheng Jiang wrote:
> Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
> used/freed.

Used/freed where?

> 
> Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
> Cc: <stable@vger.kernel.org> # v5.10+
> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
> ---
>  drivers/scsi/qedf/qedf_io.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
> index fcfc3bed02c6..d52057b97a4f 100644
> --- a/drivers/scsi/qedf/qedf_io.c
> +++ b/drivers/scsi/qedf/qedf_io.c
> @@ -254,9 +254,7 @@ struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_ctx *qedf)
>  	}
>  
>  	/* Allocate pool of io_bdts - one for each qedf_ioreq */
> -	cmgr->io_bdt_pool = kmalloc_array(num_ios, sizeof(struct io_bdt *),
> -	    GFP_KERNEL);
> -
> +	cmgr->io_bdt_pool = kcalloc(num_ios, sizeof(*cmgr->io_bdt_pool), GFP_KERNEL);

This is just an array that is then properly all initialized a few lines
below this.

So why does this need to be zeroed out at all?

thanks,

greg k-h
