Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B8DC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Nov 2023 05:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjKHF0J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Nov 2023 00:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjKHF0I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2023 00:26:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E37D79;
        Tue,  7 Nov 2023 21:26:06 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C12EC433C8;
        Wed,  8 Nov 2023 05:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699421165;
        bh=6XsO4oPWRbENbVTxo0tFgjVMF1113wwAH94yp91iZYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r/qmN1cUwEur5A73ezFFDUidlST90QTC5khaFYwwgArL7cQBHOr4nQ2U/UKEr9I0M
         EWXJexK7a6apFSN0yRch7zrqzB/JrPH5GTkKeO/zpNCuWRjw/j/B5XjIELP0bdWL0h
         ptP/sUxQyt195JQl1duaFrCHfYpM2rlbfDJJgL/AglEHhPXk0Zc2HZ2Efg1FdDQhIu
         JB7MvjANCkLySdsaVaCbrvAoT0cHVHKB3EphCKjL8P0S00dfwBH1x4wP/yv1u5UabJ
         8Lzcl1OIaXestaLkerRsQRSaz8KQthc9D97aSBMeAbyt8IRkh1BeB83zDT4drMYHvs
         3nReP4w5PrXKA==
Date:   Wed, 8 Nov 2023 10:55:55 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Can Guo <cang@qti.qualcomm.com>
Cc:     quic_cang@quicinc.com, bvanassche@acm.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/7] scsi: ufs: ufs-qcom: Limit HS-G5 Rate-A to hosts
 with HW version 5
Message-ID: <20231108052555.GD3296@thinkpad>
References: <1699332374-9324-1-git-send-email-cang@qti.qualcomm.com>
 <1699332374-9324-5-git-send-email-cang@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1699332374-9324-5-git-send-email-cang@qti.qualcomm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 06, 2023 at 08:46:10PM -0800, Can Guo wrote:
> From: Can Guo <quic_cang@quicinc.com>
> 
> Qcom UFS hosts, with HW ver 5, can only support up to HS-G5 Rate-A due to
> HW limitations. If the HS-G5 PHY gear is used, update host_params->hs_rate
> to Rate-A, so that the subsequent power mode changes shall stick to Rate-A.
> 
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 60b35ca..55ee31d 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -442,9 +442,25 @@ static u32 ufs_qcom_get_hs_gear(struct ufs_hba *hba)
>  static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> +	struct ufs_host_params *host_params = &host->host_params;
>  	struct phy *phy = host->generic_phy;
> +	enum phy_mode mode;
>  	int ret;
>  
> +	/*
> +	 * HW ver 5 can only support up to HS-G5 Rate-A due to HW limitations.

Does this limitation apply to future targets as well or just to SM8550? If
it's the latter, then we need to use a flag.

- Mani

> +	 * If the HS-G5 PHY gear is used, update host_params->hs_rate to Rate-A,
> +	 * so that the subsequent power mode change shall stick to Rate-A.
> +	 */
> +	if (host->hw_ver.major == 0x5) {
> +		if (host->phy_gear == UFS_HS_G5)
> +			host_params->hs_rate = PA_HS_MODE_A;
> +		else
> +			host_params->hs_rate = PA_HS_MODE_B;
> +	}
> +
> +	mode = host_params->hs_rate == PA_HS_MODE_B ? PHY_MODE_UFS_HS_B : PHY_MODE_UFS_HS_A;
> +
>  	/* Reset UFS Host Controller and PHY */
>  	ret = ufs_qcom_host_reset(hba);
>  	if (ret)
> @@ -459,7 +475,7 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>  		return ret;
>  	}
>  
> -	phy_set_mode_ext(phy, PHY_MODE_UFS_HS_B, host->phy_gear);
> +	phy_set_mode_ext(phy, mode, host->phy_gear);
>  
>  	/* power on phy - start serdes and phy's power and clocks */
>  	ret = phy_power_on(phy);
> -- 
> 2.7.4
> 

-- 
மணிவண்ணன் சதாசிவம்
