Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C94423D7DD
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 11:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765280033; cv=none; b=mltIPiyEqIb7otoDmbwospUj7DsCzgq433AWwwiOQKGbU65Yd6lVqvlhZOPU9A5Z0XbBPUNm/f2buGJYFb+HY+02eDzPp6rEIhVqW9BTJ7tDPaOsdTUoW3dLQaaEqBN/yahz/OOXEhUVdNZqjVYH645Uav5ytSa1XSUfsdVUzuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765280033; c=relaxed/simple;
	bh=jZ9f4mXXn0iG2MmPzdRxjes0Y+5e6eFl7/YH5mv3GV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ftcngH7ON5KQw+8NPH+hlP39kBQBmHH3zU2WIl/D1OmmZgcLJmVjUntB5cBvFXe//OtlVn3ro5E45OCttdJ9R9isuGm2qVIdL4qdtlF0rFdt5ABoajkDOOO5BQKlMK998/E4s1nD9PVfgu5F2PodjncukpftOZXfKKMDJRb7y6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCvE745u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCvE745u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CD5C4CEF5;
	Tue,  9 Dec 2025 11:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765280033;
	bh=jZ9f4mXXn0iG2MmPzdRxjes0Y+5e6eFl7/YH5mv3GV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VCvE745uwAez9sb3mzSoTR8lqMoKMTNvIGWLKasQiUP9rGr6MmeqIOp5PmH37mZJS
	 ITNuPWK3SwuqVCPxeUZZnYLAI/fIc1SEK3u9DQoAzo78EXOA9G8dUFbMu48cmu6SPy
	 dWAuTvGWnRovypCKfDWdGQ7PrDlI3He1YWhxtP0G52APAauk2lWjuV1DPVrn9hc91r
	 n6X2/ac93cuqGW5dCq7s26oRA/2yK8g88S6vu29+AHiNqHhfeJPWWgn8A1u7OxvxJo
	 NbNvXCYCWGhaY2Q/GN0ufLFk6B1k7dq2SOZ0HJhwf0hN4oYjr9aHhlTuoIMdzQiMmg
	 wYctyBiPiN5Ww==
Date: Tue, 9 Dec 2025 20:33:44 +0900
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, Roger Shimizu <rosh@debian.org>, 
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bean Huo <beanhuo@micron.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH] ufs: core: Fix a deadlock in the frequency scaling code
Message-ID: <cem2gv6cz6bxz3i7eogqnbruzbts5jn4ijlu43bt5g2rl5or5p@evrj4kyqovrk>
References: <20251204181548.1006696-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251204181548.1006696-1-bvanassche@acm.org>

On Thu, Dec 04, 2025 at 08:15:43AM -1000, Bart Van Assche wrote:
> Commit 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
> accidentally introduced a deadlock in the frequency scaling code.
> ufshcd_clock_scaling_unprepare() may submit a device management command
> while SCSI command processing is blocked. The deadlock was introduced by
> using the SCSI core for submitting device management commands
> (scsi_get_internal_cmd() + blk_execute_rq()). Fix this deadlock by calling
> blk_mq_unquiesce_tagset() before any device management commands are
> submitted by ufshcd_clock_scaling_unprepare().
> 
> Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
> Reported-by: Manivannan Sadhasivam <mani@kernel.org>
> Reported-by: Roger Shimizu <rosh@debian.org>
> Closes: https://lore.kernel.org/linux-scsi/ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow/
> Tested-by: Roger Shimizu <rosh@debian.org>
> Cc: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Thanks for the quirk fix. While it seems to have fixed the boot hang, I'm
quite skeptical about the fix. What is the guarantee that another device
management command won't be submitted before blk_mq_unquiesce_tagset() in the
future? IOW, the developer would have no idea that doing such will result in a
deadlock as nothing in the UFS code makes it clear, like using the same lock and
such.

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 1837ae204d5e..80c0b49f30b0 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1455,15 +1455,14 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
>  static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
>  {
>  	up_write(&hba->clk_scaling_lock);
> +	mutex_unlock(&hba->wb_mutex);
> +	blk_mq_unquiesce_tagset(&hba->host->tag_set);
> +	mutex_unlock(&hba->host->scan_mutex);
>  
>  	/* Enable Write Booster if current gear requires it else disable it */
>  	if (ufshcd_enable_wb_if_scaling_up(hba) && !err)
>  		ufshcd_wb_toggle(hba, hba->pwr_info.gear_rx >= hba->clk_scaling.wb_gear);
>  
> -	mutex_unlock(&hba->wb_mutex);
> -
> -	blk_mq_unquiesce_tagset(&hba->host->tag_set);
> -	mutex_unlock(&hba->host->scan_mutex);
>  	ufshcd_release(hba);
>  }
>  

-- 
மணிவண்ணன் சதாசிவம்
