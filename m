Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31B2CD80BD
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 12:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbjJJMVc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Oct 2023 08:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbjJJMVb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2023 08:21:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5CA99;
        Tue, 10 Oct 2023 05:21:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBE5C433C7;
        Tue, 10 Oct 2023 12:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696940489;
        bh=Yej9bVPXe3Yn3VuZSMy7tR2lCorR7YuG7/gHIvWhSps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LnkFxwRGButXSwjFV9YJqgfe/gHEZ5zf1Pf8vukA8jB+DXk1OiCCacoqLk844x5Te
         ktVllChcD+0a31UVSv4aH2SSYW1Gw7ACD+6AZJEVX8llNNEViwVbASpUv/IDvqB/fD
         RU6g2iAxhNNCF2YBOXCmASbuLePa1mW3a8/vCw97fnhqQG4VvIWsHgnUJUv3xnR5Mn
         YZUNJiTCoart30dZshRKI6TU9V+63kY6M7rOVaRwf+eKJcePo6zSE/8ZiqYhBVFNOW
         dDbcy+qMbGJw8pOJpkBd0NgddKk2YsSqVi1nv2v2CVayomsNkwTIjbGK20LRTMO3AY
         vUkWFxpfdgDJQ==
Date:   Tue, 10 Oct 2023 17:51:16 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: qcom: remove unnecessary check
Message-ID: <20231010122116.GI4884@thinkpad>
References: <fe3b8fcd-64a7-4887-bddd-32239a88a6a3@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe3b8fcd-64a7-4887-bddd-32239a88a6a3@moroto.mountain>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 02, 2023 at 10:03:35AM +0300, Dan Carpenter wrote:
> The "attr" pointer points to an offset into the "host" struct so it
> can't be NULL.  Delete the if statement and pull the code in a tab.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/host/ufs-qcom.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 2128db0293b5..96cb8b5b4e66 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1447,15 +1447,11 @@ static int ufs_qcom_clk_scale_up_pre_change(struct ufs_hba *hba)
>  	if (!ufs_qcom_cap_qunipro(host))
>  		return 0;
>  
> -	if (attr) {
> -		ret = ufs_qcom_cfg_timers(hba, attr->gear_rx,
> -					attr->pwr_rx, attr->hs_rate,
> -					false, true);
> -		if (ret) {
> -			dev_err(hba->dev, "%s ufs cfg timer failed\n",
> -						__func__);
> -			return ret;
> -		}
> +	ret = ufs_qcom_cfg_timers(hba, attr->gear_rx, attr->pwr_rx,
> +				  attr->hs_rate, false, true);
> +	if (ret) {
> +		dev_err(hba->dev, "%s ufs cfg timer failed\n", __func__);
> +		return ret;
>  	}
>  	/* set unipro core clock attributes and clear clock divider */
>  	return ufs_qcom_set_core_clk_ctrl(hba, true);
> -- 
> 2.39.2
> 

-- 
மணிவண்ணன் சதாசிவம்
