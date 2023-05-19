Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F815C7EE2D
	for <linux-scsi@archiver.kernel.org>; Fri, 19 May 2023 17:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjESRUw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 May 2023 13:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjESRUt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2023 13:20:49 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267DE1A7
        for <linux-scsi@vger.kernel.org>; Fri, 19 May 2023 10:20:43 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4efe8b3f3f7so4001171e87.2
        for <linux-scsi@vger.kernel.org>; Fri, 19 May 2023 10:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684516841; x=1687108841;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aI4Ct9ZNbQ/SUl5JzXHU1ru0q3U69oZVlCThA9I8H3I=;
        b=lBSmxER24QeX7xwpniQr4N70VZBB0FbHwfoJ1IdDtkGHPUnW/6jPw6qRbVa590f0cs
         9RaAUk9JZOvoET83pb5t7t/QgZaQtKmsWNQWHeBtxkY+x3Sclu1C098f262ugb7UQ5WC
         0tVCs+mMTOBdPBJA56fycgDyyoQyEeOnyPaPv1HcXuU1NHjJVdnfEJdtGfTcawzXv+wn
         Z3QXMf19Z7mo8jhHJsBSwzZARvKANsjpu1KLCXexbascw+RUV37bNc7yS1kgfx0KV9LY
         yY8f21Uv5yn/YSKfggdhGYWuil7v+hR4Z3ZE4ZwHPFzvpnf+r8tKSW94hpfC+4YU1OVm
         Mc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684516841; x=1687108841;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aI4Ct9ZNbQ/SUl5JzXHU1ru0q3U69oZVlCThA9I8H3I=;
        b=cshxUKPx97XKC13CEA9xKK3xDuA9IQvnTWFaOllIEGgWFRbHLJ4BOpaOO8os48kcEW
         pRVeitR3Qfhnkr4LXnV5F5Ci1KSfi8W7SsTkByBkmApqY5UrOmCnCYw+VOjiEsUOxaKr
         90Qky7XCuKmLuGubosDdgkO9wBcgBOeTm1YonZpJGVAcm1uB0a4cZZ/C8BM53pv3iLRW
         0f5/SeerZDaIkQCDLasR6TXex/eOQPFau2guhoda1ISEA8HiO0JqRCtAe5sgLHfAaD5E
         8NFaSX8Ro4xaXTecQqKrISDFCQsWtpxvWXsXBkxnFj691260RXxH564bBDSHIsJ3VkdV
         q80Q==
X-Gm-Message-State: AC+VfDxb81KBisbZOIIXkceRWSn4doM08sAckWaKABNuXX3ZwsD9YwI0
        MDJ84QeucUGHGmFskQMzdmJt6g==
X-Google-Smtp-Source: ACHHUZ4ZtY87AlYLqMzZMI/H+YwCz8aUIUg1BGHjMQhVZ85fHr9UboDnwYj4WsgHwUHkUQsLv0exag==
X-Received: by 2002:ac2:4182:0:b0:4f3:93d6:377b with SMTP id z2-20020ac24182000000b004f393d6377bmr843159lfh.37.1684516841069;
        Fri, 19 May 2023 10:20:41 -0700 (PDT)
Received: from [192.168.1.101] (abxi58.neoplus.adsl.tpnet.pl. [83.9.2.58])
        by smtp.gmail.com with ESMTPSA id y19-20020ac24473000000b004eff0bcb276sm670552lfl.7.2023.05.19.10.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 10:20:40 -0700 (PDT)
Message-ID: <470651fb-e4d1-2576-df6c-ded60d0b1242@linaro.org>
Date:   Fri, 19 May 2023 19:20:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/2] scsi: ufs: ufs-qcom: add basic interconnect support
Content-Language: en-US
To:     Brian Masney <bmasney@redhat.com>, andersson@kernel.org
Cc:     agross@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20221117104957.254648-1-bmasney@redhat.com>
 <20221117104957.254648-2-bmasney@redhat.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20221117104957.254648-2-bmasney@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 17.11.2022 11:49, Brian Masney wrote:
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
Hi everyone!

This was never merged, but it's actually strictly necessary!

For example UFS dies on SM8450 if we add sync_state to its interconnect
driver, as there's no votes cast.

Can we look into this again?

Konrad
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
>  	}
>  
>  	host->device_reset = devm_gpiod_get_optional(dev, "reset",
