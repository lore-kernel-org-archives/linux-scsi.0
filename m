Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CE7C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 03:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38B7B64DD0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 03:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhA1D3L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 22:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhA1D2w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 22:28:52 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A20C0613D6
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2021 19:28:12 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id a77so4619173oii.4
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2021 19:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bycrFGxpFESrx+c4otqRsuFh+D02wUypmFMxBRknlK4=;
        b=UBJ0MbjDr6+BGF80tKXERVTyHoyOj7tIHcgu4yaM8Q7fFOx54mS/MbFiUQA/jo7AdF
         Q8vjF6xCkJaYmCs3yTB9+Ib9Kx6nR/Axulu0pruKSZgf1CpiIxw4pwaDtmUjxMpUEEsr
         logHokRTDh1pJXp7t6OzUyBc0350Mhoh+qEzVCLue+HBclPOxwZkDIPfnqVQfTIvwzfr
         IyFl+fV7kUoPDE2mNAO076fxA+82ZvAFaGWtdGe4M0sV0Fs3kE1pA80VkgHbOB7y5KTc
         OdYEzcan5BGxaeF6K/rB70vtClKseV0zYuPqp7zpHdyjt6u+8j0O8WSgLhYa+R/Hd1bd
         pvSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bycrFGxpFESrx+c4otqRsuFh+D02wUypmFMxBRknlK4=;
        b=J8VnQEcQVrdJMGwNoo7kzyFH/kI13UgXozYzvoMoCKY6gEPnt4TSTz1QnElCulPZcg
         6ULDQxgX6E2z+BcwGCP26mKDeJisQmRvcrrvFw0kZD+LQmk6rkgMBeZ02bBA16s9afqR
         rwGz4v222cx5irwNOnJKTv13rOLxsriJvOp1OgicOX+VC+/zBIEfja86QKQKet9iGDx1
         cHxZVaqi42mCvntY4fxqbNZVAuTK1U9JivGPUIlIuBJ64hJlbuZQwiAr8UkQPKlULqhO
         QNFlQv+OaG2Dom6Fwy47XXgJKlfk0rUmlfQOMqH7S9Jwd+lZHsMdJo8Z3UFeRiRnrg4p
         0A5g==
X-Gm-Message-State: AOAM531y2UYhHS25L+NnS6c8RHOi+Tnbf/1Sd2vEmm09iQh0TrQSfi4A
        gKXObGsKyEKhqkLOxosCNDbLUw==
X-Google-Smtp-Source: ABdhPJx8a83lqg1wni2Qp7f0Poa5JrVnwmN+XtnSvavaPlSohixjoabxHk48mGhrMtqQJEbW2UQVrw==
X-Received: by 2002:a05:6808:158:: with SMTP id h24mr5410906oie.135.1611804491367;
        Wed, 27 Jan 2021 19:28:11 -0800 (PST)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id 67sm752150ott.64.2021.01.27.19.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 19:28:10 -0800 (PST)
Date:   Wed, 27 Jan 2021 21:28:07 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     jaegeuk@kernel.org, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: Give clk scaling min gear a value
Message-ID: <20210128032807.GA5254@yoga>
References: <1611802172-37802-1-git-send-email-cang@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611802172-37802-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed 27 Jan 20:49 CST 2021, Can Guo wrote:

> The initialization of clk_scaling.min_gear was removed by mistake. This
> change adds it back, otherwise clock scaling down would fail.
> 

Thanks for the patch Can, it solves the problem I'm seeing!

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>


And perhaps a:

Reported-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Fixes: 4543d9d78227 ("scsi: ufs: Refactor ufshcd_init/exit_clk_scaling/gating()")
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 36bcbb3..8ef6796 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1602,6 +1602,9 @@ static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
>  	if (!ufshcd_is_clkscaling_supported(hba))
>  		return;
>  
> +	if (!hba->clk_scaling.min_gear)
> +		hba->clk_scaling.min_gear = UFS_HS_G1;
> +
>  	INIT_WORK(&hba->clk_scaling.suspend_work,
>  		  ufshcd_clk_scaling_suspend_work);
>  	INIT_WORK(&hba->clk_scaling.resume_work,
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
> 
