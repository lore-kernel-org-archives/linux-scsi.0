Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AECCC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 02:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C537207EA
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 02:54:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g/h4wKVt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgIOCyJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 22:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgIOCyH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2020 22:54:07 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556B0C06174A
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2020 19:54:05 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id p15so1078317qvk.5
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2020 19:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AENtihZFanz7AK6JAQj2iuXl1rr5XpuLAyHhP2fdTxc=;
        b=g/h4wKVtRzze15q7+YBYa8/BU5+91OBLBnKQ/0b/r2PCfF49nXRZnsElWP3ecnuHzq
         EM+R+PjHIbUv4pd2JUJas4i+d5pUKdy9OTUdEQV0Jp/NSiPGV+e1D3wEDcIX9ApI4VZX
         +2hwSCeDbmLrnG73Up5dRLqZUF5RHBnT6IW8iKDIXbMiCbHpDWiltkYTycPejWzqC51j
         BBZ1YVVBSbAJWyAdGZFgkBnMExUoSyMG1P+uKDzN7nytHu5Ma5cnNSBYbf7sqU0C3gWL
         X+VYR+LyvNH3CiR5df85wESmzQ3Vr1NkafTjaDAcbBb/ODyyAqY8VmL9u6+dfOwcvlXl
         hUlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AENtihZFanz7AK6JAQj2iuXl1rr5XpuLAyHhP2fdTxc=;
        b=s+XuGiE/TPiW7sd1v62ryPX+gEKLYtKgYZmKq6lr6UdZCjoE5aA/olXJCCrREDiMEQ
         i1GCY7aBT2ytk4Q+WHWSDpH4TgA5B4EBq2Q9hdnSkmBYWsWvlQliuU7PZ2GXKZQ7Ae2N
         /DyIfjt0rkTYHAupweODliU/9gwiUMkI9jMeJ84nqzwmrjtYo+ZA30cE1AxMZd4ZGoMK
         vv+198NErvNL4+/PtM9DBR+qGFhZS8xC91D0fR0GbO+ts6a6nSMVLWRPp8i56riTvcMo
         Z8vohmNv/pAFRHudTw5bLJrzZzgtqobSPg8alkXdoK54NnixPTjRS3cTnajPD0o3qrQW
         c23A==
X-Gm-Message-State: AOAM53024sqsHMpO1skFF4ImBGxV3Hi+OF9SL7W3l6kW+nNrFVh1qu0s
        YdSWqTURgh8Hp+AZ2INjfT4KeQ==
X-Google-Smtp-Source: ABdhPJxHxWeHi97ePv3FCP2DV1zftb/XyH1vIFWezkQmVxts9NiBBIfqccJnCV2mwFphJKlRWsDQuA==
X-Received: by 2002:a05:6214:12c:: with SMTP id w12mr16299144qvs.18.1600138444488;
        Mon, 14 Sep 2020 19:54:04 -0700 (PDT)
Received: from uller (ec2-34-197-84-77.compute-1.amazonaws.com. [34.197.84.77])
        by smtp.gmail.com with ESMTPSA id s47sm16504448qtb.13.2020.09.14.19.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 19:54:03 -0700 (PDT)
Date:   Tue, 15 Sep 2020 02:54:01 +0000
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "Bao D. Nguyen" <nguyenb@codeaurora.org>
Cc:     cang@codeaurora.org, asutoshd@codeaurora.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] scsi: ufshcd: Properly set the device Icc Level
Message-ID: <20200915025401.GD471@uller>
References: <5c9d6f76303bbe5188bf839b2ea5e5bf530e7281.1598923023.git.nguyenb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c9d6f76303bbe5188bf839b2ea5e5bf530e7281.1598923023.git.nguyenb@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue 01 Sep 01:19 UTC 2020, Bao D. Nguyen wrote:

> UFS version 3.0 and later devices require Vcc and Vccq power supplies
> with Vccq2 being optional. While earlier UFS version 2.0 and 2.1
> devices, the Vcc and Vccq2 are required with Vccq being optional.
> Check the required power supplies used by the device
> and set the device's supported Icc level properly.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Bao D. Nguyen <nguyenb@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 06e2439..fdd1d3e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6845,8 +6845,9 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
>  {
>  	u32 icc_level = 0;
>  
> -	if (!hba->vreg_info.vcc || !hba->vreg_info.vccq ||
> -						!hba->vreg_info.vccq2) {
> +	if (!hba->vreg_info.vcc ||

How did you test this?

devm_regulator_get() never returns NULL, so afaict this conditional will
never be taken with either the old or new version of the code.

Regards,
Bjorn

> +		(!hba->vreg_info.vccq && hba->dev_info.wspecversion >= 0x300) ||
> +		(!hba->vreg_info.vccq2 && hba->dev_info.wspecversion < 0x300)) {
>  		dev_err(hba->dev,
>  			"%s: Regulator capability was not set, actvIccLevel=%d",
>  							__func__, icc_level);
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
