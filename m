Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D7BFA3746
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 20:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJaUGq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 16:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiJaUGq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 16:06:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A055D10544
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 13:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667246748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H3ZU5SpqvPjaqpTfjZ04SSbHmjl8vKSTt7kMWQY1QWg=;
        b=RZO1NqMpmu8OdFuwH8t0CPjnUe8RID6+Bc6tbjigup4O90aUN5zOPk0p+q6s7Y4Gwcf7hn
        T5KPpVu/mEm0rC+e+7u/Xv+mwPTgorgWG5tZM4sEwnpV+cYDpsjopi73goOL/V0xOhugtH
        GM8nMqge9Fv8fCj4l2volJqHplQJYYA=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-517-irFehVJdNSuV0tjd1h2Xfg-1; Mon, 31 Oct 2022 16:05:47 -0400
X-MC-Unique: irFehVJdNSuV0tjd1h2Xfg-1
Received: by mail-ot1-f70.google.com with SMTP id t14-20020a9d7f8e000000b0066c61f96c54so732626otp.21
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 13:05:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H3ZU5SpqvPjaqpTfjZ04SSbHmjl8vKSTt7kMWQY1QWg=;
        b=oqNmJ9T/JEnwW26/Q/1f8+24NGvfl9F1vKLRnNnIIjTDgPjqfwLC18ivzIZJ1D5qt8
         MqBkcFovpthcNokKEjt6qcxcL4mrLROwnBHc00cTnRJIjgOE2ChmEGy99BVQbW8XrjH0
         oUGI00RtO9ZO4DDy7+ZsWqiJEvxtsBXG3r29ANozYjUy915BjsnsEfYTJ+l7jSjkgosM
         vUvAJ+RNtEXY5EIaJJzEuxXgmgtyfp6X9OuUx/ZTqEKJAmwLEoBxO8HJA0yL915lMp8P
         xCOmKTPCJN8lknNXR58TQ25wL2mF9b9JW/s3DRufqGmBv/MUvp7zUdiF1Y14RqXDnOvO
         R+6w==
X-Gm-Message-State: ACrzQf3sudMMLbfnbJJZLIuqo5vNqWQAH2cmXwSV8M9wsHqqrS/VU6kg
        suApQgGbYp49alYXxIsN/w2R9TeGQSJ7PNVY8sd9IdrKVU/AAlAXBdcLQkV9NuKY7bNoB554gdY
        INJmLE7ENSqXYzNvyJnb4Vw==
X-Received: by 2002:a05:6830:6401:b0:661:c74e:6b03 with SMTP id cj1-20020a056830640100b00661c74e6b03mr7158961otb.291.1667246746796;
        Mon, 31 Oct 2022 13:05:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4UUO37SZvA4qjX9uf7dmQCxxsJtcyXRaXYuTlx2k2AoBUUULV+m0zUJOEaCdymKZ+gqdzveQ==
X-Received: by 2002:a05:6830:6401:b0:661:c74e:6b03 with SMTP id cj1-20020a056830640100b00661c74e6b03mr7158939otb.291.1667246746589;
        Mon, 31 Oct 2022 13:05:46 -0700 (PDT)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::41])
        by smtp.gmail.com with ESMTPSA id y1-20020a056830108100b00660fe564e12sm3092167oto.58.2022.10.31.13.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 13:05:46 -0700 (PDT)
Date:   Mon, 31 Oct 2022 15:05:43 -0500
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, konrad.dybcio@somainline.org,
        robh+dt@kernel.org, quic_cang@quicinc.com,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, dmitry.baryshkov@linaro.org
Subject: Re: [PATCH v2 11/15] scsi: ufs: ufs-qcom: Use dev_err_probe() for
 printing probe error
Message-ID: <20221031200543.7j3pw4idrawxge2h@halaney-x13s>
References: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
 <20221031180217.32512-12-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031180217.32512-12-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 31, 2022 at 11:32:13PM +0530, Manivannan Sadhasivam wrote:
> Make use of dev_err_probe() for printing the probe error.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/ufs/host/ufs-qcom.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 8bb0f4415f1a..38e2ed749d75 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1441,9 +1441,9 @@ static int ufs_qcom_probe(struct platform_device *pdev)
>  	/* Perform generic probe */
>  	err = ufshcd_pltfrm_init(pdev, &ufs_hba_qcom_vops);
>  	if (err)
> -		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
> +		return dev_err_probe(dev, err, "ufshcd_pltfrm_init() failed\n");
>  
> -	return err;
> +	return 0;
>  }
>  
>  /**
> -- 
> 2.25.1
> 

