Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F23C352A3
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 20:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 375E522B48
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 20:33:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="khF2rN3D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgBFUdl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 15:33:41 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45468 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbgBFUdk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 15:33:40 -0500
Received: by mail-pg1-f193.google.com with SMTP id b9so3313948pgk.12
        for <linux-scsi@vger.kernel.org>; Thu, 06 Feb 2020 12:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VpINtvpl8gFHQ0mORs3d/SBnRHkntsKpRwCxcH8Pi/M=;
        b=khF2rN3DjY9FOox2SkpmQf8w8i4PYKUqPU2z3H45oXaqk0kZyA3kh44tjTaW0V8P7O
         vXtWoDgt0QXsfo6nbfZRtp15g3IWlkvhXJ7wfVxyepST3B/jB2fOuV3sNTPFOvym3DbQ
         f9txmV6TZQrXDJiPodVdHqD81N0LjCax4wCs7JnrRYvJr3UhErMMWB/shIyrIt7kVdd1
         7l4MEAZKLntXoa4HqkYeUsa2JEJAPwNwmqAhkeA2h0i+i4/iJ8tEgnYli31BsaihW3b1
         I6Sm+/ig9cGKIU1rp8PYykizu41SdiCoJ9Ggr2VQ3W9hFu4lsvFHW97PhoLd8mCLQEAi
         +cuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VpINtvpl8gFHQ0mORs3d/SBnRHkntsKpRwCxcH8Pi/M=;
        b=BcQccF6bhTpuOX98yFMNN0b3Pr/eSmLpIMTXXT83X5aYrTHC1Z5LwDWU0csFWmfi5c
         oTDnOQk3iD6p+j1RB1c2lAX+IIRbFW3XDQjrgPW5CXqGzaX2qw4YGCFLuO4bbANGK/yF
         bSTRR2bLoxLoPMtKnvb/2X3IM0CvXRYx4mzCfxa2mGZPWs9xEcEnK3oALcVROOL7WDCi
         FYeXdb7s0Bknsv9ZmCxYKBjMcQ1tORM8I68ceqfBxES/UCZDp8EK/Sc2nVpVc3/wnlfm
         0eK9zcvKU3TDk5slGBeGtLJ3rRSgyxRzvOcFCykTrXvsVTMNpQ+Ba7ooyISmjjsvN2V2
         JSyg==
X-Gm-Message-State: APjAAAWsoaAuV86s/FGhhHzfQBYwB8Ozg0FsNA07mEXO+Fi0fwOwbOc1
        aYKlsG+LaYnQeEU/3hxOwvRT1w==
X-Google-Smtp-Source: APXvYqyOwhQxvxYJuq1dFXkORTFoc1v18fGUp5SD8YPW+YEwmuiOytZ0dvOUz8r6PQeRGUo1txE1nw==
X-Received: by 2002:a63:aa09:: with SMTP id e9mr5701988pgf.354.1581021219662;
        Thu, 06 Feb 2020 12:33:39 -0800 (PST)
Received: from yoga (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id r3sm253200pfg.145.2020.02.06.12.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 12:33:39 -0800 (PST)
Date:   Thu, 6 Feb 2020 12:33:36 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Andy Gross <agross@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 7/8] scsi: ufs-qcom: Delay specific time before gate
 ref clk
Message-ID: <20200206203336.GQ2514@yoga>
References: <1580978008-9327-1-git-send-email-cang@codeaurora.org>
 <1580978008-9327-8-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580978008-9327-8-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu 06 Feb 00:33 PST 2020, Can Guo wrote:

> After enter hibern8, as UFS JEDEC ver 3.0 requires, a specific gating wait
> time is required before disable the device reference clock. If it is not
> specified, use the old delay.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 85d7c17..39eefa4 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -833,6 +833,8 @@ static int ufs_qcom_bus_register(struct ufs_qcom_host *host)
>  
>  static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
>  {
> +	unsigned long gating_wait;
> +
>  	if (host->dev_ref_clk_ctrl_mmio &&
>  	    (enable ^ host->is_dev_ref_clk_enabled)) {
>  		u32 temp = readl_relaxed(host->dev_ref_clk_ctrl_mmio);
> @@ -845,11 +847,25 @@ static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
>  		/*
>  		 * If we are here to disable this clock it might be immediately
>  		 * after entering into hibern8 in which case we need to make
> -		 * sure that device ref_clk is active at least 1us after the
> +		 * sure that device ref_clk is active for specific time after
>  		 * hibern8 enter.
>  		 */
> -		if (!enable)
> -			udelay(1);
> +		if (!enable) {
> +			gating_wait = host->hba->dev_info.clk_gating_wait_us;
> +			if (!gating_wait) {

Afaict this can't happen, because in patch 6 you check for gating_wait
being 0 and if so set it to 0xff.

> +				udelay(1);
> +			} else {
> +				/*
> +				 * bRefClkGatingWaitTime defines the minimum
> +				 * time for which the reference clock is
> +				 * required by device during transition from
> +				 * HS-MODE to LS-MODE or HIBERN8 state. Give it
> +				 * more time to be on the safe side.
> +				 */
> +				gating_wait += 10;
> +				usleep_range(gating_wait, gating_wait + 10);

I presume there's no strong requirement on the max, so how about using a
substantially larger max - say 1k, or 10k - to allow the usleep_range()
to do it's job?


PS. Please include linux-arm-msm@ on all the patches in the series, not
just two of them.

Regards,
Bjorn

> +			}
> +		}
>  
>  		writel_relaxed(temp, host->dev_ref_clk_ctrl_mmio);
>  
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
