Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C6AC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 15:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449177AbiDVPnV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Apr 2022 11:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449488AbiDVPnL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2022 11:43:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6AAF3D48C
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 08:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650642015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4QhChbQB9YDaMeenbkdMZZmXadlUdt0Dsk5a56hLZNI=;
        b=XYdfAFuG1NzSXBAKLh2yLTzmz1IhGzPbo1YqjgfyjoNyaGt17srRv/gXNfqHHrfSWVGqhl
        ae5s6IO5FBQGG/a9HMJ0DYI7EKP/mupLietzqB5ATguwZsHlpPXsrpHVyYNVAncTdm0UBH
        pRx+WpkeLrYD41z29FpOf7X0HMazL00=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-YpkgloONPqGvMPyh6Yvlfg-1; Fri, 22 Apr 2022 11:40:14 -0400
X-MC-Unique: YpkgloONPqGvMPyh6Yvlfg-1
Received: by mail-qt1-f197.google.com with SMTP id ay26-20020a05622a229a00b002f20573a0faso5234722qtb.13
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 08:40:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4QhChbQB9YDaMeenbkdMZZmXadlUdt0Dsk5a56hLZNI=;
        b=Y3fdDtDCExSkp8Eg4ZCM/sQq9c8q5oUC3NhKysFoZI6fZVIR8SMnvFcRbNDJaLPHGU
         22/n3gX8D1q03+Z+X9r2d2y518gaAJob+mpBOMRmYwkGPIkcaA5ySwrONOUZra21MUtk
         gC3KjOGFtDrsYGI+on1xKrhxG8DIiIJO/aE/MVoCd10iGfVkvbRaUWHjdF3FdplDZ2lf
         P0CP/tUws39zaa5P7ss9s4Plrlk86qd5tOk+jjxv2XOTyWCXGvyezSqbvEutHWKZYxyT
         MYw6Qn7usn5vDQAtQMuGsLKWbOVqs3k4hllAyRbvMODNm5EjMHaafY1Hu4D9CaZCM12y
         a+7A==
X-Gm-Message-State: AOAM531CN6TPy0oTDB7QzBW4emlZ/ggQLKcSYDDFOBVq1kmyHqr95Gsw
        BAwDiCecgtKwryXT1a57bvf5w5lyn1NhM9d/3HBL0w4AT7tv0F7MI4R2ZMmuWDlIJa7czE152S4
        R3oTEmt6W4YtEgm0ki7fpUg==
X-Received: by 2002:a05:6214:262c:b0:446:3464:57cd with SMTP id gv12-20020a056214262c00b00446346457cdmr4194743qvb.89.1650642014108;
        Fri, 22 Apr 2022 08:40:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzU/zrP23x+VGLwwKjYVd8GBF1zIofL+6BYuCYCGu72U6zgNGIJUYYLxnyojnu2QA1/y2aBZw==
X-Received: by 2002:a05:6214:262c:b0:446:3464:57cd with SMTP id gv12-20020a056214262c00b00446346457cdmr4194730qvb.89.1650642013880;
        Fri, 22 Apr 2022 08:40:13 -0700 (PDT)
Received: from halaneylaptop (068-184-200-203.res.spectrum.com. [68.184.200.203])
        by smtp.gmail.com with ESMTPSA id e126-20020a376984000000b0069c86b28524sm1113111qkc.19.2022.04.22.08.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 08:40:13 -0700 (PDT)
Date:   Fri, 22 Apr 2022 10:40:10 -0500
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] scsi: ufs: qcom: Fix acquiring the optional reset
 control line
Message-ID: <20220422154010.2cxk4qy5eikxujb2@halaneylaptop>
References: <20220422132140.313390-1-manivannan.sadhasivam@linaro.org>
 <20220422132140.313390-2-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422132140.313390-2-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 22, 2022 at 06:51:36PM +0530, Manivannan Sadhasivam wrote:
> On Qcom UFS platforms, the reset control line seems to be optional
> (for SoCs like MSM8996 and probably for others too). The current logic
> tries to mimic the `devm_reset_control_get_optional()` API but it also
> continues the probe if there is an error with the declared reset line in
> DT/ACPI.
> 
> In an ideal case, if the reset line is not declared in DT/ACPI, the probe
> should continue. But if there is problem in acquiring the declared reset
> line (like EPROBE_DEFER) it should fail and return the appropriate error
> code.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 0d2e950d0865..5db0fd922062 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1002,13 +1002,13 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	host->hba = hba;
>  	ufshcd_set_variant(hba, host);
>  
> -	/* Setup the reset control of HCI */
> -	host->core_reset = devm_reset_control_get(hba->dev, "rst");
> +	/* Setup the optional reset control of HCI */
> +	host->core_reset = devm_reset_control_get_optional(hba->dev, "rst");
>  	if (IS_ERR(host->core_reset)) {
>  		err = PTR_ERR(host->core_reset);
> -		dev_warn(dev, "Failed to get reset control %d\n", err);
> -		host->core_reset = NULL;
> -		err = 0;
> +		if (err != -EPROBE_DEFER)
> +			dev_err(dev, "Failed to get reset control %d\n", err);

Could we use dev_err_probe() here?

Otherwise, looks good to me.

> +		goto out_variant_clear;
>  	}
>  
>  	/* Fire up the reset controller. Failure here is non-fatal. */
> -- 
> 2.25.1
> 

