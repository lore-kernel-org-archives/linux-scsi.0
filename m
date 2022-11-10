Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75383C43217
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 14:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiKJObH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 09:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiKJObG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 09:31:06 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999A0EBE
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 06:31:02 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id u2so1290136ljl.3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 06:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H3KQSOcmRZRe8eXKkMFLNydGLgOFEzO4/EepRDgpcw4=;
        b=F6RFNAiUFI04PKGllVPiJbcqwWeE/IjIIgZIK3TXjGlwI57v5KxPPQ4/R5X7Zll+Qv
         QUqtC/ZY7GQI+o/dDY6RUxOwAk7eMDpRofuKH0f6Gns2W/Qxj85krojoR5AcD41SRyvr
         YRpyh2qG2tQGeubJ4z8GZtmzN5Uox9JtO2ik2RuKcwsUFD8noKMK4Nkc5oaWle6L7tsZ
         19HOYYMP1BO3iMqpdFTz3ZFF5AmDj2qdAbkxumKEf/YoPN0Z20qNsF9N81LB9Xgr21vt
         9efoHaZ8I/cvjuKD3PfXsyOACxwXo6DdiAg+x8FAeep+hqY4l3tDQHSMh2mjmzzhw2lM
         56nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H3KQSOcmRZRe8eXKkMFLNydGLgOFEzO4/EepRDgpcw4=;
        b=02vgOIyIccsrjSFQKK/DbTJpLSs1smOaa9P6eBShUNr390x3e+iB+JTeopesQT5UrV
         9aYBxp/51HAMKPD6+4dC3mkGajfdI1awvM+dSh9gEbUgo5S5Cs6V+voW2iWeE3zNClS/
         JDIIjAtNZuQucO8/ilmzuWo/+GLacmK4ytWFvzQub+gVURBNptCUOU/LG51hQTANmPFZ
         NtYMrd4Kqi00jNNh2H31XbczARd2HDYKmsjd1gw44Ob2ZS6jM+n2aTjHVIn+VcLR5I+J
         EIGVA1XR4Mt1MxvtYg/shkIuvkiqblbvEgMcciJDpxYUZxl1IWapHD31fVIHHuRxrDxi
         820w==
X-Gm-Message-State: ACrzQf0kB55W9aHvp//RtCD8z5dLbsStS8e/mNo/w/qcxub/LFDT3GWH
        edxfCvEFYUIUoDOoM24imfaTaw==
X-Google-Smtp-Source: AMsMyM42coPpCBk8BVmbLY03RyN1KzyWjkypbNYRZO56ZnE5ho1sQInRcZeHzatSLf395rZO+pqrPQ==
X-Received: by 2002:a2e:9f42:0:b0:277:1295:31ca with SMTP id v2-20020a2e9f42000000b00277129531camr8743368ljk.280.1668090660989;
        Thu, 10 Nov 2022 06:31:00 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id m5-20020a056512358500b004a27d2ea029sm2768618lfr.172.2022.11.10.06.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 06:31:00 -0800 (PST)
Message-ID: <2a219c34-b23c-61f0-1833-2f97aa219a4e@linaro.org>
Date:   Thu, 10 Nov 2022 15:30:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/2] scsi: ufs-unisoc: Add support for Unisoc UFS host
 controller
Content-Language: en-US
To:     Zhe Wang <zhewang116@gmail.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com
Cc:     linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        zhe.wang1@unisoc.com, orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com
References: <20221110133640.30522-1-zhewang116@gmail.com>
 <20221110133640.30522-3-zhewang116@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221110133640.30522-3-zhewang116@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/11/2022 14:36, Zhe Wang wrote:
> From: Zhe Wang <zhe.wang1@unisoc.com>
> 
> Add driver code for Unisoc ufs host controller, along with ufs
> initialization.

(...)

> +
> +static struct platform_driver ufs_sprd_pltform = {
> +	.probe = ufs_sprd_probe,
> +	.remove = ufs_sprd_remove,
> +	.shutdown = ufshcd_pltfrm_shutdown,
> +	.driver = {
> +		.name = "ufshcd-sprd",
> +		.pm = &ufs_sprd_pm_ops,
> +		.of_match_table = of_match_ptr(ufs_sprd_of_match),

Drop of_match_ptr

> +	},
> +};
> +module_platform_driver(ufs_sprd_pltform);
> +
> +MODULE_AUTHOR("Zhe Wang <zhe.wang1@unisoc.com>");
> +MODULE_DESCRIPTION("Unisoc UFS Host Driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/ufs/host/ufs-sprd.h b/drivers/ufs/host/ufs-sprd.h
> new file mode 100644
> index 000000000000..215e7483d1e8
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-sprd.h
> @@ -0,0 +1,125 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * UNISOC UFS Host Controller driver
> + *
> + * Copyright (C) 2022 Unisoc, Inc.
> + * Author: Zhe Wang <zhe.wang1@unisoc.com>
> + */
> +
> +#ifndef _UFS_SPRD_H_
> +#define _UFS_SPRD_H_
> +
> +#define APB_UFSDEV_REG		0xCE8
> +#define APB_UFSDEV_REFCLK_EN	0x2
> +#define APB_USB31PLL_CTRL	0xCFC
> +#define APB_USB31PLLV_REF2MPHY	0x1
> +
> +#define SPRD_SIP_SVC_STORAGE_UFS_CRYPTO_ENABLE				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   ARM_SMCCC_OWNER_SIP,				\
> +			   0x0301)
> +
> +enum SPRD_UFS_CLK_INDEX {
> +	SPRD_UFS_HCLK,
> +	SPRD_UFS_HCLK_SOURCE,
> +
> +	SPRD_UFS_CLK_MAX
> +};
> +
> +enum SPRD_UFS_RST_INDEX {
> +	SPRD_UFSHCI_SOFT_RST,
> +	SPRD_UFS_DEV_RST,
> +
> +	SPRD_UFS_RST_MAX
> +};
> +
> +enum SPRD_UFS_SYSCON_INDEX {
> +	SPRD_UFS_ANLG_REG,
> +	SPRD_UFS_AON_APB,
> +
> +	SPRD_UFS_SYSCON_MAX
> +};
> +
> +enum SPRD_UFS_VREG_INDEX {
> +	SPRD_UFS_VDD_MPHY,
> +
> +	SPRD_UFS_VREG_MAX
> +};
> +
> +struct ufs_sprd_clk {
> +	const char *name;
> +	struct clk *clk;
> +};
> +
> +struct ufs_sprd_rst {
> +	const char *name;
> +	struct reset_control *rc;
> +};
> +
> +struct ufs_sprd_syscon {
> +	const char *name;
> +	struct regmap *regmap;
> +};
> +
> +struct ufs_sprd_vreg {
> +	const char *name;
> +	struct regulator *vreg;
> +};
> +
> +struct ufs_sprd_priv {
> +	struct ufs_sprd_clk clki[SPRD_UFS_CLK_MAX];
> +	struct ufs_sprd_rst rci[SPRD_UFS_RST_MAX];
> +	struct ufs_sprd_syscon sysci[SPRD_UFS_SYSCON_MAX];
> +	struct ufs_sprd_vreg vregi[SPRD_UFS_VREG_MAX];
> +	const struct ufs_hba_variant_ops ufs_hba_sprd_vops;
> +};
> +
> +struct ufs_sprd_host {
> +	struct ufs_hba *hba;
> +	struct ufs_sprd_priv *priv;
> +	void __iomem *ufs_dbg_mmio;
> +
> +	enum ufs_unipro_ver unipro_ver;
> +};
> +
> +static inline struct ufs_sprd_priv *ufs_sprd_get_priv_data(struct ufs_hba *hba)
> +{
> +	struct ufs_sprd_host *host = ufshcd_get_variant(hba);
> +
> +	WARN_ON(!host->priv);
> +	return host->priv;
> +}
> +
> +static inline void ufs_sprd_regmap_update(struct ufs_sprd_priv *priv, unsigned int index,
> +		unsigned int reg, unsigned int bits,  unsigned int val)
> +{
> +	regmap_update_bits(priv->sysci[index].regmap, reg, bits, val);
> +}
> +
> +static inline void ufs_sprd_regmap_read(struct ufs_sprd_priv *priv, unsigned int index,
> +		unsigned int reg, unsigned int *val)
> +{
> +	regmap_read(priv->sysci[index].regmap, reg, val);
> +}
> +
> +static inline void ufs_sprd_get_unipro_ver(struct ufs_hba *hba)
> +{
> +	struct ufs_sprd_host *host = ufshcd_get_variant(hba);
> +
> +	if (ufshcd_dme_get(hba, UIC_ARG_MIB(PA_LOCALVERINFO), &host->unipro_ver))
> +		host->unipro_ver = 0;
> +}
> +
> +static inline void ufs_sprd_ctrl_uic_compl(struct ufs_hba *hba, bool enable)
> +{
> +	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> +
> +	if (enable == true)
> +		set |= UIC_COMMAND_COMPL;
> +	else
> +		set &= ~UIC_COMMAND_COMPL;
> +	ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
> +}

Drop functions from headers. These are not stubs and your task is not to
micro-optimize code.

> +
> +#endif /* _UFS_SPRD_H_ */

Best regards,
Krzysztof

