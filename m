Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECD8C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Apr 2022 14:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiDWPAS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Apr 2022 11:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiDWPAQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Apr 2022 11:00:16 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEF07DE13
        for <linux-scsi@vger.kernel.org>; Sat, 23 Apr 2022 07:57:18 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id c11-20020a9d684b000000b00603307cef05so7576733oto.3
        for <linux-scsi@vger.kernel.org>; Sat, 23 Apr 2022 07:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XjKZSro3DpVzoh8wbUic306++EFAdF/1LLF/UK3rLrU=;
        b=advgWBozNFrwpMfVZAmEPyp93pCNxaIz6pe9scBCWEWrGuzCKhU+KPXWoUbuYXyZFp
         UEyWbJKARQAYgO87vKKrI+61t6FQksdhtFNAaApxx5Ia+3dFukKZxCSTurFnWb1eZaK5
         1tsjN7sAmoSaDLRTK1JwQLio2Ey/9UocuDqfleswIGHQpdrA36eCFtKQV0Tk158lPQ+7
         1BT2Vc6SjiE+cETdnMHDQxp+1Bjo451C1YZ3J3WINEchyhpyUu0gyZ5FrJKutBqxmOOJ
         Bq0BSHnf7Pv9cjPxy3miXXJs1/yZUEhGzdq+A42ewc+fFUM9b6VJ7mPgj1ZT+zb/x0Vn
         KlZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XjKZSro3DpVzoh8wbUic306++EFAdF/1LLF/UK3rLrU=;
        b=1tym3qe1Crucc2yD+onROT3+pfuEi2LRXI88W9h8NdQgp4vkAHq9EsfjQU36LgKGDG
         zmqngIIa8xXgWx+c2Xp8vEwTT1INjhQzJyGjwf1UMZd/Cc+dEUn4WW/0cmrRWDwsSodg
         5edspBiknU8ZkDfPfn4welCDHYKECcGJ/wElaxKSFZfcF0mXw7tZpt3RFUIopNoaJ6oj
         s7ghOvXSxrz8ZAlPQ/tRBKpUTddlao9tq+lsyw9LSTz6erCtqibwIAUJ+SqqqLDbhRQB
         dbGYUDRGHWI+/TcbVDHcXRTCn2CX/xysvURYqIOdiyWtuaiIRNBhlcDySL2FDUCKlGDI
         IIvQ==
X-Gm-Message-State: AOAM532xwotRYvs5L8GlJLSXcftcuLZ+2S5O/I+Lsz9trOcOW6IvMha0
        vea4HPAZz/31JvI8K7USUxlymSX5FOUDWT0d
X-Google-Smtp-Source: ABdhPJzfaf0fnc1yHREYwM0HAeiZQYOU4Bw+tQ9TIWYCkZYyebUV4SVBJ/C1GeZkG1pskEFy7KO7ww==
X-Received: by 2002:a9d:5a19:0:b0:5cd:9ca0:898b with SMTP id v25-20020a9d5a19000000b005cd9ca0898bmr3666119oth.318.1650725837834;
        Sat, 23 Apr 2022 07:57:17 -0700 (PDT)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id b4-20020aca1b04000000b00322959f5251sm1816136oib.26.2022.04.23.07.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 07:57:17 -0700 (PDT)
Date:   Sat, 23 Apr 2022 07:59:17 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        linux-arm-msm@vger.kernel.org, quic_asutoshd@quicinc.com,
        quic_cang@quicinc.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        ahalaney@redhat.com
Subject: Re: [PATCH v2 1/5] scsi: ufs: qcom: Fix acquiring the optional reset
 control line
Message-ID: <YmQURV7yQMof4RB8@ripper>
References: <20220423140245.394092-1-manivannan.sadhasivam@linaro.org>
 <20220423140245.394092-2-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220423140245.394092-2-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat 23 Apr 07:02 PDT 2022, Manivannan Sadhasivam wrote:

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
> index 0d2e950d0865..bee81b45299e 100644
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

dev_err_probe() does this comparison internally, so you can omit it
here.

With that removed, feel free to add my:
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> +			dev_err_probe(dev, err, "Failed to get reset control\n");
> +		goto out_variant_clear;
>  	}
>  
>  	/* Fire up the reset controller. Failure here is non-fatal. */
> -- 
> 2.25.1
> 
