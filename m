Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21DC7C38A02
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Oct 2022 21:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJ2Vs2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Oct 2022 17:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJ2Vs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2022 17:48:26 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E387643
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 14:48:24 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h12so5733826ljg.9
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 14:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=60gE0VpcoGAPlbRv1xoX9SZPevsEIxkl5Hy3ZJtcGLM=;
        b=MAtfuTHl4dtfu3T77+nZgTnE7t3bSENdQJryoXbdhhVaonf/mbK8WoPIj9pmr8Q4CD
         DO3kqyYsY6EctI6xxXhuNIhg/xkTyttwKO2HNgUh/JU1ScMHfG5o4tXClupgc97uCNP1
         vaagYkVuaQdqrhKFtMOFYQT4a2cZO0bG9RfbvNHuyW0wCpCWJSti7mZD6GNjt6wHCs0D
         RoPR+z2BqTFaCEEY3lmUeiLB0vj8rGB8eudbVH5kcsiibKCfOHCtX9cOih+TXIR1QmHk
         uGUqK913/lIQd/WYTN0fqEOtF8WpkhrzAN6UHoUYbp6rMaQGpHzkrohhMKNxd4tvQ+To
         1xjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=60gE0VpcoGAPlbRv1xoX9SZPevsEIxkl5Hy3ZJtcGLM=;
        b=ou+iTui/gF9KjYH2kRAyYb0Is/mOkIarVYzQj2a9nKiwZaLzZR/3zyjdTWl45argGS
         jhy8kwJJSFRDMGIxkDlIzlPDhHKWimDIL5K4tABwP6wSaFkbzkL49y8f94EEJNUXglZO
         82KvKPmfWmIyXUZdw+QqGkkXY342KlUcDOqepwe5Z8WvL5VN10ViIbjr4q7O9xuHaxZN
         4LoJG1ZRo9kxlxjMPEO47Y89XsTYaRelgmpPqN38stl2t+2bM3aTafX0Qrvz8pZccDuO
         uYwAQBBljuGh19AKaD305FU+nBdAhcIRCJNY0s+5dvLpV/uEmwmm8nDgWL99lGLiBUUb
         DAwQ==
X-Gm-Message-State: ACrzQf3Or1H22zWDYJeX8wk0AAVemxHTjZl9Tiqu8chgs9EHSx8CeG2j
        HBeFRPaSg+VPip11TMr8YY7/WQ==
X-Google-Smtp-Source: AMsMyM6yzSiQ96HOcDj/ORv3kfBljuuQYibHSlOCiCEiivXOHwWoN/gIdjwW9GvlC69HZGmF5O+thg==
X-Received: by 2002:a2e:8397:0:b0:277:35fa:84d6 with SMTP id x23-20020a2e8397000000b0027735fa84d6mr2126944ljg.429.1667080103304;
        Sat, 29 Oct 2022 14:48:23 -0700 (PDT)
Received: from [10.27.10.248] ([195.165.23.90])
        by smtp.gmail.com with ESMTPSA id h4-20020ac24da4000000b004a45ed1ae21sm443956lfe.224.2022.10.29.14.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Oct 2022 14:48:22 -0700 (PDT)
Message-ID: <cf8dcf53-f131-68f4-c6aa-d41e02ac6d5c@linaro.org>
Date:   Sun, 30 Oct 2022 00:48:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH 14/15] scsi: ufs: ufs-qcom: Add support for finding HS
 gear on new UFS versions
Content-Language: en-GB
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
 <20221029141633.295650-15-manivannan.sadhasivam@linaro.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20221029141633.295650-15-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/10/2022 17:16, Manivannan Sadhasivam wrote:
> Starting from UFS controller v4, Qcom supports dual gear mode (i.e., the
> controller/PHY can be configured to run in two gear speeds). But that
> requires an agreement between the UFS controller and the UFS device.
> This commit finds the max gear supported by both controller and device
> then decides which one to use.
> 
> UFS controller's max gear can be read from the REG_UFS_PARAM0 register and
> UFS device's max gear can be read from the "max-gear" devicetree property.
> 
> The UFS PHY also needs to be configured with the decided gear using the
> phy_set_mode_ext() API.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>   drivers/ufs/host/ufs-qcom.c | 35 ++++++++++++++++++++++++++++++++---
>   drivers/ufs/host/ufs-qcom.h |  4 ++++
>   2 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index f952cc76919f..268463e92d67 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -281,6 +281,9 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
>   static u32 ufs_qcom_get_hs_gear(struct ufs_hba *hba, u32 hs_gear)
>   {
>   	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> +	struct device *dev = hba->dev;
> +	u32 max_gear, hcd_max_gear, reg;
> +	int ret;
>   
>   	if (host->hw_ver.major == 0x1) {
>   		/*
> @@ -292,8 +295,33 @@ static u32 ufs_qcom_get_hs_gear(struct ufs_hba *hba, u32 hs_gear)
>   		 */
>   		if (hs_gear > UFS_HS_G2)
>   			return UFS_HS_G2;
> +	} else if (host->hw_ver.major > 0x3) {
> +		/*
> +		 * Starting from UFS controller v4, Qcom supports dual gear mode (i.e., the
> +		 * controller/PHY can be configured to run in two gear speeds). But that
> +		 * requires an agreement between the UFS controller and the device. Below
> +		 * code tries to find the max gear of both and decides which gear to use.
> +		 *
> +		 * First get the max gear supported by the UFS device if available.
> +		 * If the property is not defined in devicetree, then use the default gear.
> +		 */
> +		ret = of_property_read_u32(dev->of_node, "max-gear", &max_gear);
> +		if (ret)
> +			goto err_out;

Can we detect the UFS device's max gear somehow? If not, the 'max-gear' 
property name doesn't sound good. Maybe calling it 'device-gear' would 
be better.

> +
> +		/* Next get the max gear supported by the UFS controller */
> +		reg = ufshcd_readl(hba, REG_UFS_PARAM0);
> +		hcd_max_gear = UFS_QCOM_MAX_GEAR(reg);
> +
> +		/*
> +		 * Now compare both the gears. If the max gear supported by the UFS device
> +		 * is compatible with UFS controller, then use the UFS device's max gear
> +		 * speed. Otherwise, use the UFS controller supported max gear speed.
> +		 */
> +		return (max_gear <= hcd_max_gear) ? max_gear : hcd_max_gear;

return max(max_gear, hcd_max_gear); ?

>   	}
>   
> +err_out:
>   	/* Default is HS-G3 */
>   	return UFS_HS_G3;
>   }
> @@ -303,7 +331,7 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>   	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>   	struct phy *phy = host->generic_phy;
>   	int ret;
> -	bool is_rate_B = UFS_QCOM_LIMIT_HS_RATE == PA_HS_MODE_B;
> +	u32 hs_gear;
>   
>   	/* Reset UFS Host Controller and PHY */
>   	ret = ufs_qcom_host_reset(hba);
> @@ -311,8 +339,9 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>   		dev_warn(hba->dev, "%s: host reset returned %d\n",
>   				  __func__, ret);
>   
> -	if (is_rate_B)
> -		phy_set_mode(phy, PHY_MODE_UFS_HS_B);
> +	/* UFS_HS_G2 is used here since that's the least gear supported by legacy Qcom platforms */
> +	hs_gear = ufs_qcom_get_hs_gear(hba, UFS_HS_G2);
> +	phy_set_mode_ext(phy, PHY_MODE_UFS_HS_B, hs_gear);
>   
>   	/* phy initialization - calibrate the phy */
>   	ret = phy_init(phy);
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index 214ea50acab9..c93bc52ea848 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -89,6 +89,10 @@ enum {
>   #define TMRLUT_HW_CGC_EN	BIT(6)
>   #define OCSC_HW_CGC_EN		BIT(7)
>   
> +/* bit definitions for REG_UFS_PARAM0 */
> +#define MAX_HS_GEAR_MASK	GENMASK(6, 4)
> +#define UFS_QCOM_MAX_GEAR(x)	FIELD_GET(MAX_HS_GEAR_MASK, (x))
> +
>   /* bit definition for UFS_UFS_TEST_BUS_CTRL_n */
>   #define TEST_BUS_SUB_SEL_MASK	GENMASK(4, 0)  /* All XXX_SEL fields are 5 bits wide */
>   

-- 
With best wishes
Dmitry

