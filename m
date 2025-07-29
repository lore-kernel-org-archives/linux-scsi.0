Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136B01DFDAB
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2025 16:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753805698; cv=none; b=X6A0hReYv60HSmBRVQrBp+7Hd8Tv0bT4K96vK8xrSVWiW0+oahNHYO+QmSgg7xqYDuVURXucDySKmIZIlSJPqksB4Xg7mjPA4nL0MklXFJIiztz+ugIU5NHgN+V94Z8RuBPqtsOySj3Cte5cbwzUJKlbFgEXlitqsyCWdtKoZZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753805698; c=relaxed/simple;
	bh=46VXgXxeTWi9/JKWGdepsVUHylK7WF0fP2AUAxbBDHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mIZxvAWKG8qTPEPfmQHZ0h4qHdA8LgKSKenGSkdim45jSJPmuQdO3YDyZyD6vMMMTuC2eTpSECqJlHvx2oLwmTFwQdtr30W8iJm8i5fBiAtc4bzowqaFG0rS1iCDtwUIAdJaVt5rGigcHRiGKF6aTtGE223qCAVqNYuBYy3xba4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6pz4+Zb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6pz4+Zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC355C4CEEF;
	Tue, 29 Jul 2025 16:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753805697;
	bh=46VXgXxeTWi9/JKWGdepsVUHylK7WF0fP2AUAxbBDHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X6pz4+Zb8ajhlQ9q1szCV985o1Xw9B9qlr99fOskXfAwAv0Ub1zrUrV9evO0G3ia6
	 wJ00c2WaH9mpDX2uDs1rCehlK5oCHsleByQavrxQIMqR6kqU5IYQOenQxeTBGWu8yS
	 1qb9zmO4k+OohAokBxnnB+1h7IwVnj+Zcj1/rICvimy8Ail5s8Dr0APKdCdzJoDGtM
	 IfAu9A46ypcLjp9OtI1g53yJa26v2StFumrLihllQI3jAcpsSch+NEKlmPjOCg+ZDx
	 TsCBeh9fFG+HusAsmS3PlCxO1OrGI/HxKRCjlqNFT0lp5dsF6L2jvAX2UW5v42XnWR
	 hZntK9GddbarA==
Date: Tue, 29 Jul 2025 21:44:49 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>, 
	=?utf-8?B?QW5kcsOp?= Draszik <andre.draszik@linaro.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] ufs: core: Fix interrupt handling
Message-ID: <vr3eeh6g4wvzhburj6r4jo7nhxq35kna63majiufb6vq75rvkh@gsdn62wzbwxp>
References: <20250728212731.899429-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250728212731.899429-1-bvanassche@acm.org>

On Mon, Jul 28, 2025 at 02:27:23PM GMT, Bart Van Assche wrote:
> Fix the following issues:
> * An "irq ...: nobody cared" complaint during boot.
> * Not handling a SCSI command in time, resulting in the following
>   complaint:
> 
> [   41.700204][   T13] google-ufshcd 3c2d0000.ufs: ufshcd_abort: Device abort task at tag 23
> [   41.700945][   T13] sd 0:0:0:0: [sda] tag#23 CDB: opcode=0x2a 2a 00 00 02 61 e5 00 00 01 00
> 

This patch only mentions the issue it is solving, not describing the change.

- Mani

> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Cc: André Draszik <andre.draszik@linaro.org>
> Fixes: 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service routine to a threaded IRQ handler")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 77768bf722fa..7f4651b570be 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7137,8 +7137,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
>  		return IRQ_WAKE_THREAD;
>  
>  	/* Directly handle interrupts since MCQ ESI handlers does the hard job */
> -	return ufshcd_sl_intr(hba, ufshcd_readl(hba, REG_INTERRUPT_STATUS) &
> -				   ufshcd_readl(hba, REG_INTERRUPT_ENABLE));
> +	return ufshcd_threaded_intr(irq, hba);
>  }
>  
>  static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)

-- 
மணிவண்ணன் சதாசிவம்
