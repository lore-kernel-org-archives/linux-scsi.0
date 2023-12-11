Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E40739ADC
	for <linux-scsi@vger.kernel.org>; Mon, 11 Dec 2023 12:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I7z0jLw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4579C43395;
	Mon, 11 Dec 2023 12:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702296449;
	bh=X0lineiGbEOw+if71lLAZ8HUqLj0hNmSIZ78hSwpTDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I7z0jLw0YmiptUk44fTXoCKiT3QeNZ/aTegnhhyJayO6W6a+z+pGxbs8BNYCuNfFv
	 GTSvfE5k97FrQjffo17yf07uV6oECh8mMxPRQzNfDblqx9CtsTMQ82zrx6OCkLMKXX
	 hB8kyfG+baevsO7LVK11BB++H3hLXcQAksXkOJcsPYp+08qaOA0KZgbcbU/Qs3I4+P
	 YPLMRiXbxT0hjcjRZd8EODUpyH5uS3HNL7uFVayjlLiAE6+ZhNpMGOmLl/ZYusUf44
	 cn9Q7s/8z4K/L9Ooyj0tGMDC1J4Z/n98PNT9bnXtSZp/PoNu1UzHwpP1YIObje5FI2
	 yrWHHK9i9xXcQ==
Date: Mon, 11 Dec 2023 17:37:14 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com,
	jejb@linux.ibm.com, martin.petersen@oracle.com,
	quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
	beanhuo@micron.com, thomas@t-8ch.de, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, mikebi@micron.com, lporzio@micron.com
Subject: Re: [PATCH v4 2/3] scsi: ufs: core: Add UFS RTC support
Message-ID: <20231211120714.GB2894@thinkpad>
References: <20231208103940.153734-1-beanhuo@iokpp.de>
 <20231208103940.153734-3-beanhuo@iokpp.de>
 <20231208145021.GC15552@thinkpad>
 <89c02f8b999a90329f2125380ad2d984767d25ae.camel@iokpp.de>
 <20231208170609.GD15552@thinkpad>
 <fe5eacf2016622f4f3335a1d39063ec523999184.camel@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe5eacf2016622f4f3335a1d39063ec523999184.camel@iokpp.de>

On Sun, Dec 10, 2023 at 08:28:21PM +0100, Bean Huo wrote:
> On Fri, 2023-12-08 at 22:36 +0530, Manivannan Sadhasivam wrote:
> > Except that the warning will be issued to users after each 10s for 40
> > years.
> > Atleast get rid of that.
> 
> how about using dev_warn_once(), instead of dev_warn, using
> dev_warn_once() ensures the warning is issued only once.
> 

Sounds good to me.

- Mani

> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 953d50cc4256..b2287d2f9bf3 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8205,7 +8205,7 @@ static void ufshcd_update_rtc(struct ufs_hba
> *hba)
>         ktime_get_real_ts64(&ts64);
>  
>         if  (ts64.tv_sec < hba->dev_info.rtc_time_baseline) {
> -               dev_warn(hba->dev, "%s: Current time precedes previous
> setting!\n", __func__);
> +               dev_warn_once(hba->dev, "%s: Current time precedes
> previous setting!\n", __func__);
> 
> 
> 
> Kind regards,
> Bean

-- 
மணிவண்ணன் சதாசிவம்
