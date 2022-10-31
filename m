Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 088B5FA3741
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 20:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJaUce (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 16:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiJaUcc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 16:32:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AA05F8B
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 13:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667248299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6iglFbtxmswy6Wel7/DoB7/VCgHF3PqnZ3i1JdiWSK0=;
        b=L2QrKSSNLcUy5R6qkvBtlx30SzEUyHQezcsvCteXNgWJQI5ugAwgFRQQN4cPqIUgh6esPv
        UInB80q4aNyOgCzQE0u2RxMSQqP0cmWrJL2cx3CwMcxCO4fm34e9Gsso9Cc5kwpcg9UTTV
        UDVjgfQKIi7iLV9AyZu1d8FYc/Ogp6M=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-t39GjvQ1OJakBNxUscRJmQ-1; Mon, 31 Oct 2022 16:31:38 -0400
X-MC-Unique: t39GjvQ1OJakBNxUscRJmQ-1
Received: by mail-oo1-f69.google.com with SMTP id l22-20020a4a3516000000b0049071d1de99so4380282ooa.18
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 13:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6iglFbtxmswy6Wel7/DoB7/VCgHF3PqnZ3i1JdiWSK0=;
        b=yAHVXunVCp/nGewMeWLydn57EcHH5qjb3MFZIvVcxcEDCSTTknZc2V8RTQq4MSE3zP
         uldTnPwNpbSif9U82IYU+BO0Wpg3XBLLVF+uw9VGpHD0oGcCXthfqRcC/ykfDuS+o+D/
         KN4T3f+5AsJQ1qoth98CWk1e/O8VM4DSUWLIv+1hinhytsweVvS6zLqqFSLv9sSDp0rm
         c7AT46feI8ggU49LCc6XSvvCa7xX1UQatoJu4F5lbvIdyxCaDAVY4J75BS9fvoM68p+a
         K8u0C+/Z42BjscLN6RZPUPq8VB9Naw255dpPPJOHKJigPup1TxCNQyx8m14TNgFRkeh+
         /KLQ==
X-Gm-Message-State: ACrzQf2zT61NM64+cM8v2a3gA8o9JOiyEPKqyzM5vSaZcHOBJz5fQKGB
        IwKrQ1tqaisuGpdeakGcxmx5yxBMLzgkN8UEd6nTor5m+fMlWwrLK0dD9rRL+RZYm9fhp/gM8wS
        JMJ/ONitHuZRfkNcgLS0BtA==
X-Received: by 2002:a05:6808:1693:b0:353:e980:30bf with SMTP id bb19-20020a056808169300b00353e98030bfmr7619339oib.206.1667248296676;
        Mon, 31 Oct 2022 13:31:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6B6/z0lcd7D5OLl9WDtE+Mx0BJBDVllYVLYSG10XWz2v15lMdxxewtOH4kYWzU7mQ+tcnlRQ==
X-Received: by 2002:a05:6808:1693:b0:353:e980:30bf with SMTP id bb19-20020a056808169300b00353e98030bfmr7619312oib.206.1667248296393;
        Mon, 31 Oct 2022 13:31:36 -0700 (PDT)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::41])
        by smtp.gmail.com with ESMTPSA id x13-20020a056830114d00b0066c34486aa7sm3113890otq.73.2022.10.31.13.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 13:31:35 -0700 (PDT)
Date:   Mon, 31 Oct 2022 15:31:33 -0500
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, konrad.dybcio@somainline.org,
        robh+dt@kernel.org, quic_cang@quicinc.com,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, dmitry.baryshkov@linaro.org
Subject: Re: [PATCH v2 13/15] scsi: ufs: ufs-qcom: Factor out the logic
 finding the HS Gear
Message-ID: <20221031203133.vmqqig7wlryrgiwv@halaney-x13s>
References: <20221031180217.32512-1-manivannan.sadhasivam@linaro.org>
 <20221031180217.32512-14-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031180217.32512-14-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 31, 2022 at 11:32:15PM +0530, Manivannan Sadhasivam wrote:
> In the preparation of adding support for new gears, let's move the
> logic that finds the gear for each platform to a new function. This helps
> with code readability and also allows the logic to be used in other places
> of the driver in future.
> 
> While at it, let's make it clear that this driver only supports symmetric
> gear setting (hs_tx_gear == hs_rx_gear).
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/ufs/host/ufs-qcom.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 38e2ed749d75..c93d2d38b43e 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -278,6 +278,26 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
>  	return 0;
>  }
>  
> +static u32 ufs_qcom_get_hs_gear(struct ufs_hba *hba, u32 hs_gear)
> +{
> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> +
> +	if (host->hw_ver.major == 0x1) {
> +		/*
> +		 * HS-G3 operations may not reliably work on legacy QCOM
> +		 * UFS host controller hardware even though capability
> +		 * exchange during link startup phase may end up
> +		 * negotiating maximum supported gear as G3.
> +		 * Hence downgrade the maximum supported gear to HS-G2.
> +		 */
> +		if (hs_gear > UFS_HS_G2)
> +			return UFS_HS_G2;
> +	}
> +
> +	/* Default is HS-G3 */
> +	return UFS_HS_G3;
> +}
> +
>  static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> @@ -692,19 +712,9 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
>  		ufshcd_init_pwr_dev_param(&ufs_qcom_cap);
>  		ufs_qcom_cap.hs_rate = UFS_QCOM_LIMIT_HS_RATE;
>  
> -		if (host->hw_ver.major == 0x1) {
> -			/*
> -			 * HS-G3 operations may not reliably work on legacy QCOM
> -			 * UFS host controller hardware even though capability
> -			 * exchange during link startup phase may end up
> -			 * negotiating maximum supported gear as G3.
> -			 * Hence downgrade the maximum supported gear to HS-G2.
> -			 */
> -			if (ufs_qcom_cap.hs_tx_gear > UFS_HS_G2)
> -				ufs_qcom_cap.hs_tx_gear = UFS_HS_G2;
> -			if (ufs_qcom_cap.hs_rx_gear > UFS_HS_G2)
> -				ufs_qcom_cap.hs_rx_gear = UFS_HS_G2;
> -		}
> +		/* This driver only supports symmetic gear setting i.e., hs_tx_gear == hs_rx_gear */
> +		ufs_qcom_cap.hs_tx_gear = ufs_qcom_cap.hs_rx_gear = ufs_qcom_get_hs_gear(hba,
> +									ufs_qcom_cap.hs_tx_gear);
>  
>  		ret = ufshcd_get_pwr_dev_param(&ufs_qcom_cap,
>  					       dev_max_params,
> -- 
> 2.25.1
> 

