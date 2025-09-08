Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8106F23CB;
	Mon,  8 Sep 2025 08:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757321432; cv=none; b=BNS1FTvMALaUlFnoWL/qiBnzeAIoR7HY7BKrcQMYyzy5U/9lXN37KDtNmQUjC2LVXQm5RHct00pPboL/GYWbDl8ax1zrUAC+uaqo7NSdk6LERF7uMFaaDQo4qw8t+fvmNT4u/ZS/0LRo9aQa9stypl42XbP4sIco0KWTaKZZl60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757321432; c=relaxed/simple;
	bh=hXy8jp4sCJyc6cb27KtrieaZLOF3mq0on6D17/uWSP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRL+qB4X3wIYVNzjeKAgXe8OFJ0szxERwt54PwQMEtkpr7wr/aKs6fmtYPwYJu8U0igzyQumTa4mSrrkJ3Aax1C8vmwLF9OoUbto6nkKgJKSsuN1c6spWqOudsh2k5ooChbfY9boO7HuJw2gwJiQTT6Ei/0L2VZYhvFjiuDkNAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F38mM7rr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F38mM7rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AFCC4CEF8;
	Mon,  8 Sep 2025 08:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757321432;
	bh=hXy8jp4sCJyc6cb27KtrieaZLOF3mq0on6D17/uWSP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F38mM7rrSo1mV051FnK0O2gQGczbdPo/XOvo2ua63MdkpCRJcqYIPHziOiN+gQ/1J
	 Y/zfhPrhUKmlCZptI3VXvTMY5Fjq7cfB65QoDM/rO5t8OgrzbxtaamdUZZU19AFgjR
	 bTpWg1d92wGPnTr0lWTVOJXeGm1pbHXo0DMsgpWpPSb86P8Qmsu6BZqwJEyYI/ucbl
	 ZVn9KVD30Gp/BF4llHSaGSif1G6WARmjqfbhhN2xNPKX5B0VEB6M3VYAC8Gv36e3pS
	 TKIVU3oOIVBklu6iwkn8aLOb/tH/8yUaUwL9OQMbcyDpSk81qiSNht5B2OoznW0a3g
	 0+nFXCOs7AIOQ==
Date: Mon, 8 Sep 2025 14:20:25 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: quic_cang@quicinc.com, quic_asutoshd@quicinc.com, 
	peter.wang@mediatek.com, martin.petersen@oracle.com, alim.akhtar@samsung.com, 
	avri.altman@wdc.com, bvanassche@acm.org, James.Bottomley@hansenpartnership.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: mcq: Fix memory allocation checks for SQE
 and CQE
Message-ID: <fjcv7v3fli7gcdm4yyppfnazzt4eojzlo7yprefnvzcrxqu6xo@7zmecfu6m25f>
References: <20250907194025.3611607-1-alok.a.tiwari@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250907194025.3611607-1-alok.a.tiwari@oracle.com>

On Sun, Sep 07, 2025 at 12:40:16PM GMT, Alok Tiwari wrote:
> Previous checks incorrectly tested the DMA addresses (dma_handle)
> for NULL. Since dma_alloc_coherent() returns the CPU (virtual)
> address, the NULL check should be performed on the *_base_addr
> pointer to correctly detect allocation failures.
> 
> Update the checks to validate sqe_base_addr and cqe_base_addr
> instead of sqe_dma_addr and cqe_dma_addr.
> 
> Fixes: 4682abfae2eb ("scsi: ufs: core: mcq: Allocate memory for MCQ mode")
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
> v1 -> v2
> rephrase commit message and added Reviewed-by Alim
> ---
>  drivers/ufs/core/ufs-mcq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 1e50675772fe..cc88aaa106da 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -243,7 +243,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
>  		hwq->sqe_base_addr = dmam_alloc_coherent(hba->dev, utrdl_size,
>  							 &hwq->sqe_dma_addr,
>  							 GFP_KERNEL);
> -		if (!hwq->sqe_dma_addr) {
> +		if (!hwq->sqe_base_addr) {
>  			dev_err(hba->dev, "SQE allocation failed\n");
>  			return -ENOMEM;
>  		}
> @@ -252,7 +252,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
>  		hwq->cqe_base_addr = dmam_alloc_coherent(hba->dev, cqe_size,
>  							 &hwq->cqe_dma_addr,
>  							 GFP_KERNEL);
> -		if (!hwq->cqe_dma_addr) {
> +		if (!hwq->cqe_base_addr) {
>  			dev_err(hba->dev, "CQE allocation failed\n");
>  			return -ENOMEM;
>  		}
> -- 
> 2.50.1
> 

-- 
மணிவண்ணன் சதாசிவம்
