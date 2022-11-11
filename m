Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C130FC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 05:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiKKFaQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Nov 2022 00:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbiKKFaM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2022 00:30:12 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55BF13D23;
        Thu, 10 Nov 2022 21:30:11 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id bj12so10156307ejb.13;
        Thu, 10 Nov 2022 21:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Gl2gTD6fyiyvGBtgAIjqdtNWW0efyP30sJQ9sWjlCnc=;
        b=jvJH8r5f6/8wx7qVxyeAvkPZK9h+c5JyGMFc/aTuqN1r6s79kQfYLEK4XZDUH5TD4K
         CADwyHNpLViOz0cjscCq0kcTL3732SfDfVRBf4/pXoHd1sXtFzh95ujDQflyXh2i8Y4f
         Z/fPLAxgTJiCkIKnEY7rjdDzLJLMEJiuIrYAhf0Vu3XquWnyqbug1sCtcmA6XMvurc9G
         eavW2HGlKGBsnkW++mWh+bb+t2pwsOiRopmudCqGSfYabYWrobfLYHDbEglX+0cBVuW4
         CjO6eZuLcefrYCuzKEICnFY4ZTKt1Lu3f7n9e6C+HvRpN8tTSbVu7wELX6X1tN79ZZxH
         eeqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gl2gTD6fyiyvGBtgAIjqdtNWW0efyP30sJQ9sWjlCnc=;
        b=gysdRVtC0/kEuXfAY7RzGnq+lQMoBMVQCQq1PpwwFh2xpuJpkOHN9WBhIAHvyvdaTn
         oybblS78X9yIM9c/5mIiOYPdlOz+pwOF5XDB0lDz6oWDTGkg/Q+Ky+LckbjHZzFHrjpo
         +/1WB3TUpeppS8EbkS4EWdSr3aCi+rrCyNxKBnasl1HzxH7JWL5eo4ofLOYI7HkpBhVS
         W2Dfa3JanAELndnu2m0SCrKm7dtVRFixi7wPK+E1nRB7qUdEvuEn5DhiJGS81riMvTpP
         vcyxfZOWv03LJdC5ZNN4Z8cqufmCuKinsC4M3PdDzF8Ik0IXq2yjM260Lu/2xK0L8tv0
         nuiw==
X-Gm-Message-State: ANoB5pmv3FEU1mX3lqD8tRimx5dkBAvpOTPKoBUYO2J7UcLLS9FIPaUU
        KmYYCadUNLOWzGW3oyfVnw605bjPSTKEpldbZNU=
X-Google-Smtp-Source: AA0mqf6MN6hD361DOq8oM0uQvWfql6CIlg1yzGXGzljbtsZbZ6hJvoZtoNNrKnqcoTdFdiMm8Zw4HVgCaNtHgXKdenA=
X-Received: by 2002:a17:906:1d08:b0:7a9:ecc1:2bd2 with SMTP id
 n8-20020a1709061d0800b007a9ecc12bd2mr607068ejh.545.1668144610414; Thu, 10 Nov
 2022 21:30:10 -0800 (PST)
MIME-Version: 1.0
References: <20221110133640.30522-1-zhewang116@gmail.com> <20221110133640.30522-3-zhewang116@gmail.com>
 <2a219c34-b23c-61f0-1833-2f97aa219a4e@linaro.org>
In-Reply-To: <2a219c34-b23c-61f0-1833-2f97aa219a4e@linaro.org>
From:   Zhe Wang <zhewang116@gmail.com>
Date:   Fri, 11 Nov 2022 13:29:59 +0800
Message-ID: <CAJxzgGoHQjJKvNwC3+R66GOn0cM3bDx5Dy0PmQGmSdTTZ18XSQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs-unisoc: Add support for Unisoc UFS host controller
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        zhe.wang1@unisoc.com, orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Krzysztof,

Thank you for your review!

On Thu, Nov 10, 2022 at 10:31 PM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 10/11/2022 14:36, Zhe Wang wrote:
> > From: Zhe Wang <zhe.wang1@unisoc.com>
> >
> > Add driver code for Unisoc ufs host controller, along with ufs
> > initialization.
>
> (...)
>
> > +
> > +static struct platform_driver ufs_sprd_pltform = {
> > +     .probe = ufs_sprd_probe,
> > +     .remove = ufs_sprd_remove,
> > +     .shutdown = ufshcd_pltfrm_shutdown,
> > +     .driver = {
> > +             .name = "ufshcd-sprd",
> > +             .pm = &ufs_sprd_pm_ops,
> > +             .of_match_table = of_match_ptr(ufs_sprd_of_match),
>
> Drop of_match_ptr
>

I'll drop this.

> > +     },
> > +};
> > +module_platform_driver(ufs_sprd_pltform);
> > +
> > +MODULE_AUTHOR("Zhe Wang <zhe.wang1@unisoc.com>");
> > +MODULE_DESCRIPTION("Unisoc UFS Host Driver");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/ufs/host/ufs-sprd.h b/drivers/ufs/host/ufs-sprd.h
> > new file mode 100644
> > index 000000000000..215e7483d1e8
> > --- /dev/null
> > +++ b/drivers/ufs/host/ufs-sprd.h
> > @@ -0,0 +1,125 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * UNISOC UFS Host Controller driver
> > + *
> > + * Copyright (C) 2022 Unisoc, Inc.
> > + * Author: Zhe Wang <zhe.wang1@unisoc.com>
> > + */
> > +
> > +#ifndef _UFS_SPRD_H_
> > +#define _UFS_SPRD_H_
> > +
> > +#define APB_UFSDEV_REG               0xCE8
> > +#define APB_UFSDEV_REFCLK_EN 0x2
> > +#define APB_USB31PLL_CTRL    0xCFC
> > +#define APB_USB31PLLV_REF2MPHY       0x1
> > +
> > +#define SPRD_SIP_SVC_STORAGE_UFS_CRYPTO_ENABLE                               \
> > +     ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                         \
> > +                        ARM_SMCCC_SMC_32,                            \
> > +                        ARM_SMCCC_OWNER_SIP,                         \
> > +                        0x0301)
> > +
> > +enum SPRD_UFS_CLK_INDEX {
> > +     SPRD_UFS_HCLK,
> > +     SPRD_UFS_HCLK_SOURCE,
> > +
> > +     SPRD_UFS_CLK_MAX
> > +};
> > +
> > +enum SPRD_UFS_RST_INDEX {
> > +     SPRD_UFSHCI_SOFT_RST,
> > +     SPRD_UFS_DEV_RST,
> > +
> > +     SPRD_UFS_RST_MAX
> > +};
> > +
> > +enum SPRD_UFS_SYSCON_INDEX {
> > +     SPRD_UFS_ANLG_REG,
> > +     SPRD_UFS_AON_APB,
> > +
> > +     SPRD_UFS_SYSCON_MAX
> > +};
> > +
> > +enum SPRD_UFS_VREG_INDEX {
> > +     SPRD_UFS_VDD_MPHY,
> > +
> > +     SPRD_UFS_VREG_MAX
> > +};
> > +
> > +struct ufs_sprd_clk {
> > +     const char *name;
> > +     struct clk *clk;
> > +};
> > +
> > +struct ufs_sprd_rst {
> > +     const char *name;
> > +     struct reset_control *rc;
> > +};
> > +
> > +struct ufs_sprd_syscon {
> > +     const char *name;
> > +     struct regmap *regmap;
> > +};
> > +
> > +struct ufs_sprd_vreg {
> > +     const char *name;
> > +     struct regulator *vreg;
> > +};
> > +
> > +struct ufs_sprd_priv {
> > +     struct ufs_sprd_clk clki[SPRD_UFS_CLK_MAX];
> > +     struct ufs_sprd_rst rci[SPRD_UFS_RST_MAX];
> > +     struct ufs_sprd_syscon sysci[SPRD_UFS_SYSCON_MAX];
> > +     struct ufs_sprd_vreg vregi[SPRD_UFS_VREG_MAX];
> > +     const struct ufs_hba_variant_ops ufs_hba_sprd_vops;
> > +};
> > +
> > +struct ufs_sprd_host {
> > +     struct ufs_hba *hba;
> > +     struct ufs_sprd_priv *priv;
> > +     void __iomem *ufs_dbg_mmio;
> > +
> > +     enum ufs_unipro_ver unipro_ver;
> > +};
> > +
> > +static inline struct ufs_sprd_priv *ufs_sprd_get_priv_data(struct ufs_hba *hba)
> > +{
> > +     struct ufs_sprd_host *host = ufshcd_get_variant(hba);
> > +
> > +     WARN_ON(!host->priv);
> > +     return host->priv;
> > +}
> > +
> > +static inline void ufs_sprd_regmap_update(struct ufs_sprd_priv *priv, unsigned int index,
> > +             unsigned int reg, unsigned int bits,  unsigned int val)
> > +{
> > +     regmap_update_bits(priv->sysci[index].regmap, reg, bits, val);
> > +}
> > +
> > +static inline void ufs_sprd_regmap_read(struct ufs_sprd_priv *priv, unsigned int index,
> > +             unsigned int reg, unsigned int *val)
> > +{
> > +     regmap_read(priv->sysci[index].regmap, reg, val);
> > +}
> > +
> > +static inline void ufs_sprd_get_unipro_ver(struct ufs_hba *hba)
> > +{
> > +     struct ufs_sprd_host *host = ufshcd_get_variant(hba);
> > +
> > +     if (ufshcd_dme_get(hba, UIC_ARG_MIB(PA_LOCALVERINFO), &host->unipro_ver))
> > +             host->unipro_ver = 0;
> > +}
> > +
> > +static inline void ufs_sprd_ctrl_uic_compl(struct ufs_hba *hba, bool enable)
> > +{
> > +     u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> > +
> > +     if (enable == true)
> > +             set |= UIC_COMMAND_COMPL;
> > +     else
> > +             set &= ~UIC_COMMAND_COMPL;
> > +     ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
> > +}
>
> Drop functions from headers. These are not stubs and your task is not to
> micro-optimize code.
>

Will move these functions to c file.

Best regards,
Zhe Wang

> > +
> > +#endif /* _UFS_SPRD_H_ */
>
> Best regards,
> Krzysztof
>
