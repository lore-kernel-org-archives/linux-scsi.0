Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DA5ECAAA1
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 20:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJaUDE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 16:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJaUDB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 16:03:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F2513F85
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 13:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667246526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GyQzSTgHMXAqR4GW328JWqSw6Ba5Dp1IwqrsJPnSvqw=;
        b=dTDLs370P5RhdKM4hR4xhAA4bWs92Fwq+BmUlpqfNuypkZqYL3ipk8iEz5vYQcaHHZLcvW
        9C2uttWgAlh3CnpYKGvade5cOv7ePd5d9XmfrkKe8ji7GRkpz3iY/wvEYzWk6Xa0Z0DxIe
        JMtY3YyLm3JHW3r9EcJGzXNalcHU8z4=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-248-e0ml-0gvMlOgc4vo1UAjjg-1; Mon, 31 Oct 2022 16:02:04 -0400
X-MC-Unique: e0ml-0gvMlOgc4vo1UAjjg-1
Received: by mail-ot1-f69.google.com with SMTP id ck9-20020a056830648900b0066c56ff7b33so1437942otb.20
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 13:02:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyQzSTgHMXAqR4GW328JWqSw6Ba5Dp1IwqrsJPnSvqw=;
        b=UdiC/J0q9ZlFeCmKFzoCS8zzAhhj3cQB+FGCJnuHViNDglqF1xarDijrIGR83krWQH
         3fnJJYo5OMf9nSDciYK7eayrKZ/l7kbuo++u/H/qu1Pw/2O5IvwVTm5tQBaLA1ZsVdI2
         ce8vEIuhjo1YDt+KZtlzbllyeQhfNxFh2XppTRZfpIxWkRp0fgmgcxHDGrdr8WG+nsHw
         2ExwdrWcPCwBrymJYwU0RBvlvEoTUBuRi+j9jmpnB0ZS3YoisWV7Pu3RCT3cONBetGay
         Lzl800Beg+M19Da/RhXqz3ZQTLh6NE2gBtdm23RxdJiTyyYLuE3cA48AYJ8X4hImy40A
         rOxQ==
X-Gm-Message-State: ACrzQf37fMslMHh1WiTA6paeF9QpKHCeNTmls0T+oqZ7my6RcA/zLwxW
        qW//3R8hPjmwI/yIZgCfocAYDM7gCHbDkXG4VENdKB+MRQ0de/TGKuL4tl6bH8aUuSBmtiy+obK
        LkqerRHnbQ8Ts54FIFr23cg==
X-Received: by 2002:a05:6870:51a:b0:130:ae8d:daaf with SMTP id j26-20020a056870051a00b00130ae8ddaafmr17100862oao.103.1667246521927;
        Mon, 31 Oct 2022 13:02:01 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4COwYawDiGVOrrxMUqz/QkdUPpj62cIx+cSPHKLQLGQk5fYVCCWkgMetIObtdOgQWrNI5yJQ==
X-Received: by 2002:a05:6870:51a:b0:130:ae8d:daaf with SMTP id j26-20020a056870051a00b00130ae8ddaafmr17100841oao.103.1667246521646;
        Mon, 31 Oct 2022 13:02:01 -0700 (PDT)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::41])
        by smtp.gmail.com with ESMTPSA id o37-20020a05687096a500b00131c3d4d38fsm3497667oaq.39.2022.10.31.13.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 13:02:01 -0700 (PDT)
Date:   Mon, 31 Oct 2022 15:01:58 -0500
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, konrad.dybcio@somainline.org,
        robh+dt@kernel.org, quic_cang@quicinc.com,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, dmitry.baryshkov@linaro.org
Subject: Re: [PATCH v2 09/15] scsi: ufs: ufs-qcom: Remove un-necessary
 WARN_ON()
Message-ID: <20221031200158.ph6f4ucbjhzw5knt@halaney-x13s>
References: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
 <20221031180217.32512-10-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031180217.32512-10-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 31, 2022 at 11:32:11PM +0530, Manivannan Sadhasivam wrote:
> In the reset assert and deassert callbacks, the supplied "id" is not used
> at all and only the hba reset is performed all the time. So there is no
> reason to use a WARN_ON on the "id".
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/ufs/host/ufs-qcom.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 7cd996ac180b..8bb0f4415f1a 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -895,8 +895,6 @@ ufs_qcom_reset_assert(struct reset_controller_dev *rcdev, unsigned long id)
>  {
>  	struct ufs_qcom_host *host = rcdev_to_ufs_host(rcdev);
>  
> -	/* Currently this code only knows about a single reset. */
> -	WARN_ON(id);
>  	ufs_qcom_assert_reset(host->hba);
>  	/* provide 1ms delay to let the reset pulse propagate. */
>  	usleep_range(1000, 1100);
> @@ -908,8 +906,6 @@ ufs_qcom_reset_deassert(struct reset_controller_dev *rcdev, unsigned long id)
>  {
>  	struct ufs_qcom_host *host = rcdev_to_ufs_host(rcdev);
>  
> -	/* Currently this code only knows about a single reset. */
> -	WARN_ON(id);
>  	ufs_qcom_deassert_reset(host->hba);
>  
>  	/*
> -- 
> 2.25.1
> 

