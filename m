Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B172E3B6C11
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 07:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774940990; cv=none; b=eIRT5DtEsn2/8p9U2nibD76z6iFPsWKal5hejAdzWyy7a+gZePxtKKs805sK/Dupkh4EVRuWwMHT5eE8YmdSD6+4pCMQHdtT+CHyxOHnAmbBouwifwEXfs32c5d2cEt9PkOkxHZHkUsTHNjINbjl3XXGqaajSP6BV0CSastCG3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774940990; c=relaxed/simple;
	bh=53PEQ92KLw7/l2XTCd2m+bD/ZzkRsfvGdtFU4h1KYsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOCPeoUMMhkFATpc0XUn9vY3RO7xJuIv0FLFbY1R1FlqK5kFyu/oyWZO/bJshPQAWKRQI+ifKnH4zg8P7STE6Gu2MgmaePnVELQgFZUQplmX2j6FoA+NtLlR0nd+BN/wKo/tbOraL6ca4kr3rQdV6w60PH9m2TB1LYDzqdX0R3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrYBl0wi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrYBl0wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96625C2BCB0;
	Tue, 31 Mar 2026 07:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774940990;
	bh=53PEQ92KLw7/l2XTCd2m+bD/ZzkRsfvGdtFU4h1KYsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lrYBl0wilbHERhAuMOx5OXMcyBJ3jkKd0S8KpMjWY7K4osPqmoEZft/niZVagjb4Y
	 nKWWl6CdpGJE8zebiEb36NLFbD77h8mv430pEUTBBJtwwRQFuer7u9AUvttRgdzgsD
	 D9zUWfC2VkFI57GBWcAtaAVe4tl30X89lJ3tBfSri2kAUnpi0yv2PLa7R2C7lMEXOo
	 23cRAHZfISMSJVoDS0OWq0Y7IH8n6ZCMQLaRqfx9gdkpbz7bhhjeMYrzu1O5lhqqMl
	 owrfCuURQT1/cfK2d6oRLchz21VO149aGzvUQUrV3WF5Uty4DhHBO2Y4ULlgJCUY1Q
	 sMlmNzU0UxuZQ==
Date: Tue, 31 Mar 2026 12:39:39 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Nitin Rawat <quic_nitirawa@quicinc.com>, linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 3/3] ufs: qcom: Reduce interrupt latency
Message-ID: <fg4i4d3fjpjvwp5xe5zvzwjlhq5dlmiauchh62fka5lujmolcm@pzzbd7h3se3e>
References: <20260330183311.1941942-1-bvanassche@acm.org>
 <20260330183311.1941942-4-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260330183311.1941942-4-bvanassche@acm.org>

+ Nitin

On Mon, Mar 30, 2026 at 11:33:05AM -0700, Bart Van Assche wrote:
> Defer completion processing to thread context on slower CPU cores to
> prevent interrupt latency spikes. On the fastest CPU cores, keep
> processing all completions in interrupt context.
> 

By default, all interrupts are pinned to CPU0. So unless some userspace entity
like irqbalance changes the CPU affinity, all the interrupts will be serviced
in the threaded context on CPU0, which will negatively impact performance with
this patch.

I think from the kernel driver, we should just set the IRQ affinity hint as
Nitin tried [1] and let the userspace to balance IRQ load based on the activity.

- Mani

[1] https://lore.kernel.org/all/20260122141331.239354-2-nitin.rawat@oss.qualcomm.com

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/host/ufs-qcom.c | 33 +++++++++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 5a58ffef3d27..7cacc0ec0624 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -2370,6 +2370,16 @@ struct ufs_qcom_irq {
>  	struct ufs_hba		*hba;
>  };
>  
> +static irqreturn_t ufs_qcom_mcq_threaded_esi_handler(int irq, void *data)
> +{
> +	struct ufs_qcom_irq *qi = data;
> +	struct ufs_hba *hba = qi->hba;
> +
> +	ufshcd_mcq_poll_cqe_lock(hba, &hba->uhq[qi->idx]);
> +
> +	return IRQ_HANDLED;
> +}
> +
>  static irqreturn_t ufs_qcom_mcq_esi_handler(int irq, void *data)
>  {
>  	struct ufs_qcom_irq *qi = data;
> @@ -2377,9 +2387,22 @@ static irqreturn_t ufs_qcom_mcq_esi_handler(int irq, void *data)
>  	struct ufs_hw_queue *hwq = &hba->uhq[qi->idx];
>  
>  	ufshcd_mcq_write_cqis(hba, 0x1, qi->idx);
> -	ufshcd_mcq_poll_cqe_lock(hba, hwq);
>  
> -	return IRQ_HANDLED;
> +	if (arch_scale_cpu_capacity(raw_smp_processor_id()) ==
> +	    SCHED_CAPACITY_SCALE) {
> +		ufshcd_mcq_poll_cqe_lock(hba, hwq);
> +		return IRQ_HANDLED;
> +	}
> +
> +	if (ufshcd_mcq_poll_cqe_lock_n(hba, hwq, 4) < 4)
> +		return IRQ_HANDLED;
> +
> +	/*
> +	 * Defer further completion processing to thread context because
> +	 * processing a large number of completions in interrupt context on
> +	 * slower CPU cores can result in unacceptably high interrupt latencies.
> +	 */
> +	return IRQ_WAKE_THREAD;
>  }
>  
>  static int ufs_qcom_config_esi(struct ufs_hba *hba)
> @@ -2415,8 +2438,10 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
>  		qi[idx].idx = idx;
>  		qi[idx].hba = hba;
>  
> -		ret = devm_request_irq(hba->dev, qi[idx].irq, ufs_qcom_mcq_esi_handler,
> -				       IRQF_SHARED, "qcom-mcq-esi", qi + idx);
> +		ret = devm_request_threaded_irq(hba->dev, qi[idx].irq,
> +			ufs_qcom_mcq_esi_handler,
> +			ufs_qcom_mcq_threaded_esi_handler,
> +			IRQF_SHARED | IRQF_ONESHOT, "qcom-mcq-esi", qi + idx);
>  		if (ret) {
>  			dev_err(hba->dev, "%s: Failed to request IRQ for %d, err = %d\n",
>  				__func__, qi[idx].irq, ret);

-- 
மணிவண்ணன் சதாசிவம்
