Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831483E120C;
	Wed,  9 Sep 2026 07:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788938120; cv=none; b=PP8/PMdlXJUTlTLizd4yc74yk7It6VjmQisQ+k8XflDOFGe0ZFGTXdSvlc0/PB//0/FfbN18REspldYX4hYM+06aNki3AeeNGPixMELiysLr0mPA+PBpUrpBjvZPf3Ns5uOGtpq2fnegBB5VtadchGj/azcKZ1qy45Bvf8Mq0cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788938120; c=relaxed/simple;
	bh=M2I1fYqj/rnqb84waFjRELf6jrAl9LXjFS5fom9MFUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+iMVrucIlB8nFh2dlBWT1JK+g5SnmrBl9YHMLHevRouefRleIo4vl8nvQfOPaVR+emNxSmh7wyKCsgWyWEh2mN5ar563Vk/WMGiOUT7g0bWtXDsWl/Ljm5+rx0JQ61ak03Vaa7yat6BcdVs0dJ+6Exajbxyyq7lsIoZWFC70RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=akiqnWfB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="akiqnWfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953AE1F00A3A;
	Wed,  9 Sep 2026 07:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788938119;
	bh=6Ey6L9ip63czste/fovmDjod9w1fp+JYeSbkrh3ESeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=akiqnWfBSYz9MEGU+R7KW0hbKxNg2P1YO77+c9dOZ850t9WcKN9p1iKnjmQkGPZzJ
	 hua712Rh+jDz1buJHfXvoZeYBDe+GShGoW/RXyh1gcRcuiAlmE0FbL0SKFm4JXMzbi
	 TzLQCSSvGBxGshW2c+vbzOnDmsQ0SxRPuuACK2viqQUesQrxa6scZxXdTj3xBYlDNn
	 I0IPO+ornFEHaCH1DlbNWiK90kzbutOTXkg+P2CvZz+74q64FwJpMKuACQTgaa4EJb
	 LBCD9kUkn6jHsNsOKkAFUKzJgN8c39f6zTxDxAo/ZaSmwb+jBK2uF9Z79LPUmNd0ME
	 q506WV9FJNfHg==
Date: Wed, 9 Sep 2026 09:15:12 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: James.Bottomley@hansenpartnership.com, konrad.dybcio@linaro.org, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH V2] scsi: ufs: ufs-qcom: Enable only lane clocks in lane
 clock APIs
Message-ID: <ogl5cq5updw4u3iy4tpnijozpengmkvskfuozxvfamgehtoobi@yb4a65wbuvbw>
References: <20260909053944.2827968-1-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260909053944.2827968-1-nitin.rawat@oss.qualcomm.com>

On Wed, Sep 09, 2026 at 11:09:44AM +0530, Nitin Rawat wrote:
> ufs_qcom_enable_lane_clks() and ufs_qcom_disable_lane_clks() currently
> use clk_bulk_prepare_enable()/clk_bulk_disable_unprepare() on the
> entire host->clks array obtained from devm_clk_bulk_get_all(). This
> array contains all device clocks, not just lane symbol clocks.
> 
> Since the UFS core framework already manages the non-lane clocks via
> the setup_clocks callback, the bulk enable/disable in the lane clock
> APIs resulted in duplicate reference count increments on those shared
> clocks. The extra enable counts were never balanced by a corresponding
> disable from the framework's clock gating path, preventing the clock
> reference counts from reaching zero and ultimately blocking CXO
> shutdown during low-power states.
> 
> Fix this by restricting the lane clock APIs to only prepare/enable
> and disable/unprepare the three lane symbol clocks (tx_lane0_sync_clk,
> rx_lane0_sync_clk, rx_lane1_sync_clk), leaving the handling of all
> other clocks to the UFS core framework. The lane clocks are now
> acquired individually via devm_clk_get() instead of being looked up
> in the bulk clock array.
> 
> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

One comment below for future optimization.

> ---
> Changes from v1:
> 1. As per konrad's comment, used devm_clk_get instead of to get
>    lane clock handle instead of using bulk call API.
> ---
>  drivers/ufs/host/ufs-qcom.c | 47 ++++++++++++++++++++++++++++++-------
>  drivers/ufs/host/ufs-qcom.h |  5 ++--
>  2 files changed, 42 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index aa2ac2cd2b69..50f34d1c5fdb 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -348,7 +348,9 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
>  	if (!host->is_lane_clks_enabled)
>  		return;
> 
> -	clk_bulk_disable_unprepare(host->num_clks, host->clks);
> +	clk_disable_unprepare(host->rx_lane1_sync_clk);
> +	clk_disable_unprepare(host->rx_lane0_sync_clk);
> +	clk_disable_unprepare(host->tx_lane0_sync_clk);
> 
>  	host->is_lane_clks_enabled = false;
>  }
> @@ -357,28 +359,57 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
>  {
>  	int err;
> 
> -	err = clk_bulk_prepare_enable(host->num_clks, host->clks);
> +	if (host->is_lane_clks_enabled)
> +		return 0;

Presence of this check/flag gives an indication that lane_clocks are not
handled in a refcounted manner i.e., ufs_qcom_{enable/disabled}_lane_clks() are
called multiple times from different places and the code only ensures that these
are called only once. As a future optimization, I would recommend removing this
check and ensure that enable/disable are called in a refcounted manner. Since
the clk framework handles refcount, the UFS driver's job is simply to ensure
the enable/disable count matches to avoid under/over flows.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
