Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24A1C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 11:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239324AbiKQLeG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 06:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbiKQLeF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 06:34:05 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2834FFA9
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 03:34:04 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o7so1418136pjj.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 03:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FDkIugz1/mRNVETST6IbQaDgBOb8+GBszmb2VS3UN2s=;
        b=uw1uKLKp4/MuS9ulsVTuQB6gNAAMwFkV0SDMB2uxUNtfkqKmJDnb3wS+NbJXNsQ3rt
         /hqM+wGXxku3YrBXawf/qmPZHhcpvvodMK/szk0jElP/8losaFkI2A/tBNPnHEGfXjzB
         D0OvTS4grLlzwuZZr3GuM2mKFQ1wha78nHjZ3umEw92/EK/y/CTdVjm37Ok7RelVE6vq
         UaJnmnvSO/RmZT/Gjw+sSgizFBQs7cbfpUA42uI1TScqYEj9AgcsGZLuMmI/Gy//JXyp
         btTmo4gv4i1lxHUwLKhPvs7gSNgJDifjPJs7TpLlLLWW7c+s3sKr23wpKyU+RSb5my1T
         rlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FDkIugz1/mRNVETST6IbQaDgBOb8+GBszmb2VS3UN2s=;
        b=KsUKxLDFKB6t5ZmA+ggGUPGZ5meOfWe16Zyh6D3yLK2ikBtMXtKzgQr3zuTopkkAxr
         3915wXfPqJk9O6ARpH+1e9v3gTo2+8XVlR1fJj/nTQru8dfTP36hTWXaIV7Isj3iUKwO
         6PUWZbinurlfJ1zK/MWUZ4iG1S7R/qeXFLTdl/f26vPy6/yuHwK6fSHOzoEm/zjfljT9
         ItyG6pf014yHxyMG+0WMrJsKLsgZimxFr49rc/Cx17xyL8d/k06KjVASytiRJbTyrrlN
         mEAsBcgWBh4eQXVJSWXy1Df9EMQ2ucGITH4zAMpBafBGZsNqP79/UqQTpNh5lGH6t/wq
         jViQ==
X-Gm-Message-State: ANoB5plBq1F8D9XlV2Ld0YXhxsPhO5nljJZsVAJ3CfbTd/Se2E8Vxja5
        R6VWlKStHfH7f1QnXSTSlqt1
X-Google-Smtp-Source: AA0mqf6AmSKCk80SLfZx3vcFbb0uXwFGb1BSMV8/Q8KtIf65DRNYaiu453V6v/md5Ww30NBrc05rLg==
X-Received: by 2002:a17:902:7e47:b0:186:944a:2560 with SMTP id a7-20020a1709027e4700b00186944a2560mr2380013pln.84.1668684844024;
        Thu, 17 Nov 2022 03:34:04 -0800 (PST)
Received: from thinkpad ([117.193.208.31])
        by smtp.gmail.com with ESMTPSA id h129-20020a625387000000b00571bdf45888sm881780pfb.154.2022.11.17.03.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 03:34:03 -0800 (PST)
Date:   Thu, 17 Nov 2022 17:03:57 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Brian Masney <bmasney@redhat.com>
Cc:     andersson@kernel.org, agross@kernel.org, konrad.dybcio@linaro.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: ufs: ufs-qcom: add basic interconnect support
Message-ID: <20221117113357.GB93179@thinkpad>
References: <20221117104957.254648-1-bmasney@redhat.com>
 <20221117104957.254648-2-bmasney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221117104957.254648-2-bmasney@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 17, 2022 at 05:49:56AM -0500, Brian Masney wrote:
> The firmware on the Qualcomm platforms expects the interconnect votes to
> be present. Let's add very basic support where the maximum throughput is
> requested to match what's done in a few other drivers.
> 
> This will not break boot on systems where the interconnects and
> interconnect-names properties are not specified in device tree for UFS
> since the interconnect framework will silently return.
> 
> Signed-off-by: Brian Masney <bmasney@redhat.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 8ad1415e10b6..55bf8dd88985 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -7,6 +7,7 @@
>  #include <linux/time.h>
>  #include <linux/clk.h>
>  #include <linux/delay.h>
> +#include <linux/interconnect.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> @@ -936,6 +937,22 @@ static const struct reset_control_ops ufs_qcom_reset_ops = {
>  	.deassert = ufs_qcom_reset_deassert,
>  };
>  
> +static int ufs_qcom_icc_init(struct device *dev, char *pathname)
> +{
> +	struct icc_path *path;
> +	int ret;
> +
> +	path = devm_of_icc_get(dev, pathname);
> +	if (IS_ERR(path))
> +		return dev_err_probe(dev, PTR_ERR(path), "failed to acquire interconnect path\n");
> +
> +	ret = icc_set_bw(path, 0, UINT_MAX);

Please use icc macros for setting the bandwidth. Like, GBps_to_icc(),
MBps_to_icc() etc...

Also, during the init stage you can set a minimum bandwidth that will allow the
controller to get probed successfully. Then, you should update the bandwidth
based on the gear in pwr_change_notify() callback.

> +	if (ret < 0)
> +		return dev_err_probe(dev, ret, "failed to set bandwidth request\n");
> +
> +	return 0;
> +}
> +
>  /**
>   * ufs_qcom_init - bind phy with controller
>   * @hba: host controller instance
> @@ -991,6 +1008,14 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  			err = dev_err_probe(dev, PTR_ERR(host->generic_phy), "Failed to get PHY\n");
>  			goto out_variant_clear;
>  		}
> +
> +		err = ufs_qcom_icc_init(dev, "ufs-ddr");
> +		if (err)
> +			goto out_variant_clear;
> +
> +		err = ufs_qcom_icc_init(dev, "cpu-ufs");
> +		if (err)
> +			goto out_variant_clear;

It'd be nice to have a single function that initializes both paths.

Thanks,
Mani

>  	}
>  
>  	host->device_reset = devm_gpiod_get_optional(dev, "reset",
> -- 
> 2.38.1
> 

-- 
மணிவண்ணன் சதாசிவம்
