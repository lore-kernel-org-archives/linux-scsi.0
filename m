Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAD7171C3
	for <linux-scsi@vger.kernel.org>; Fri,  8 Dec 2023 12:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUr7UsSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38120C433C8;
	Fri,  8 Dec 2023 12:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702039731;
	bh=vLThQTwl+IH3G3R9f1dHTk2ydKuwPB5ETojX8rQGxDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cUr7UsShhnUneWThZk3aObq/YSqB0oQQVo1qKpT4PFaXdBLQSGttqnQUkEutMBmE3
	 4p0OqjCxmDbKZ6Z13oeqDssnJK4EUx7ksPahHJmd4fkbX1kn6mgZpcRNwmyoJod69U
	 p/oTNCzTU1bqp2C+mnseohOA36Hws7niwY/oikrHnsxTNJQ11i/5pvNvMH1LnuLOnU
	 8RoRIXUZuFjCUb0FAwOISYH2Ozu1K/zBkSCIFUvNm5uQNGN9LdSEVw/jGKxTOBduB+
	 Cm7f0Jb4JnMBykYNWeM7Hkg67bOsVtFjA51SGQNci2y7zeAuAg+qdgsLMJRMAiR8ML
	 hrmVof53G0CtA==
Date: Fri, 8 Dec 2023 18:18:35 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
	beanhuo@micron.com, thomas@t-8ch.de, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, mikebi@micron.com, lporzio@micron.com
Subject: Re: [PATCH v4 1/3] scsi: ufs: core: Add ufshcd_is_ufs_dev_busy()
Message-ID: <20231208124835.GB15552@thinkpad>
References: <20231208103940.153734-1-beanhuo@iokpp.de>
 <20231208103940.153734-2-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231208103940.153734-2-beanhuo@iokpp.de>

On Fri, Dec 08, 2023 at 11:39:38AM +0100, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Add helper inline for retrieving whether UFS device is busy or not.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/ufs/core/ufshcd.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index f0b837cb0c2b..32cfcba66d60 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -235,6 +235,13 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
>  	return UFS_PM_LVL_0;
>  }
>  
> +static inline bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)

No need to use 'inline' keyword in '.c' files. Compiler has its own decisions.

> +{
> +	return (hba->clk_gating.active_reqs || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||

I feel like checking the ufshcd state inside ufshcd_is_ufs_dev_busy() is
somewhat confusing. Because, if "ufshcd_state != UFSHCD_STATE_OPERATIONAL"
returns true, then it means that the ufshc is in non-operational state. But,
non-operational state doesn't mean that the ufs is busy doing some work.

So I propose to move this check outside of ufshcd_is_ufs_dev_busy().

Like,

	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
	    ufshcd_is_ufs_dev_busy(hba))

- Mani

> +		hba->outstanding_reqs || hba->outstanding_tasks || hba->active_uic_cmd ||
> +		hba->uic_async_done);
> +}
> +
>  static const struct ufs_dev_quirk ufs_fixups[] = {
>  	/* UFS cards deviations table */
>  	{ .wmanufacturerid = UFS_VENDOR_MICRON,
> @@ -1917,10 +1924,7 @@ static void ufshcd_gate_work(struct work_struct *work)
>  		goto rel_lock;
>  	}
>  
> -	if (hba->clk_gating.active_reqs
> -		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
> -		|| hba->outstanding_reqs || hba->outstanding_tasks
> -		|| hba->active_uic_cmd || hba->uic_async_done)
> +	if (ufshcd_is_ufs_dev_busy(hba))
>  		goto rel_lock;
>  
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
