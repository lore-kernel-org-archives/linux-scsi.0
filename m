Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFC0C677F1
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Jan 2023 19:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjAMTd7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 14:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjAMTdh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 14:33:37 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0205687F0B
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 11:31:52 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id l139so23557135ybl.12
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 11:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q3w2TiU+Lm4nUzsmAN2R9y6Z1pBbZIeSZTFy+e+i1Wk=;
        b=wwkkD/BbYvU5NuTiZHjqY6R/O+FRehpJ86yRYqvetizP1k1TrxND2a8wx5XckTHlAR
         +bzA9nNbrS8Hi2ckThe8kGGYkIxYsP9CReFyV5gT9J4XPS8UJ7Cp7zUobVzaDAxHL+Rd
         29Xk+FkVcheDmHH0IhvWxzPdfRREwBTEbwmN6Ssd+33B7k+QEHeUedzmqn7VIvFFSw6U
         AAohESqAXJJNdAOFkDqC6I6VRaxf8qWA+GveIBguZcE+sk92sku8QQdQbLOh1pjKaXnI
         0L2eTI4kOu03otfB272qaDnq8eASvQfg2uFIuIMEzYAv724TEzM12sAWMNa1wrw3XOtu
         Q6wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q3w2TiU+Lm4nUzsmAN2R9y6Z1pBbZIeSZTFy+e+i1Wk=;
        b=MIdpmQDI0xvCkmTiExGwRqkAEk/Fh7KhKn8++/TBwCGyM722igacsBIJCHUJEXQe/d
         EZuX0AmlPT4s2wjM0EGhXMtUVeImyGod1OP7yGjwZVbqj9e1i98jLRIBg3xVObtsRInT
         kWWD1YwEGloCdBNWsVJQ/5hV+lQMF9WvzDISW7kgvHsLd2A4zdduWLjm5q7Ig+aQlEsw
         MiQkPkZ1ImTmwGtxAAXbBInMGLu9+r7Z8bcwIlJHZ6aHPcGUMhkMg3fUw0SOamgCQLij
         IA+2W5HG2nFbBNwVc2ZlCfMbEWf+0QpZjyGquv3p6WuJAqSQx/tZc5cOQrDUfVdhrffS
         FDQg==
X-Gm-Message-State: AFqh2kpJeLrirXZ9gPlvKv4b4W63ZWm5d3Z4uKYf0YXpfh6RZVHJgLD1
        P2gxAE3c+KyzIcJyRm80/xUB2gbuSVgwF5mOTXd5lQ==
X-Google-Smtp-Source: AMrXdXtimzxWwdAam5pUjv6lnc370dF1DqEq+lHlc6Ucv3r0ITCLyfKNu6YkXfF2piMkkorsB+TRlnbtQAkbkc0H55Q=
X-Received: by 2002:a25:cc7:0:b0:6e0:c7d3:f026 with SMTP id
 190-20020a250cc7000000b006e0c7d3f026mr8920588ybm.275.1673638311180; Fri, 13
 Jan 2023 11:31:51 -0800 (PST)
MIME-Version: 1.0
References: <20230108195336.388349-1-they@mint.lgbt> <20230108195336.388349-4-they@mint.lgbt>
In-Reply-To: <20230108195336.388349-4-they@mint.lgbt>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date:   Fri, 13 Jan 2023 21:31:40 +0200
Message-ID: <CAA8EJpp-RwPOv61MtoXYb3Tuy5LDWWBCvYSrGUOvg8vWhid_tw@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] phy: qcom-qmp: Add SM6125 UFS PHY support
To:     Lux Aliaga <they@mint.lgbt>
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, kishon@kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, keescook@chromium.org,
        tony.luck@intel.com, gpiccoli@igalia.com,
        ~postmarketos/upstreaming@lists.sr.ht,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
        phone-devel@vger.kernel.org, martin.botka@somainline.org,
        marijn.suijten@somainline.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 8 Jan 2023 at 21:54, Lux Aliaga <they@mint.lgbt> wrote:
>
> The SM6125 UFS PHY is compatible with the one from SM6115. Add a
> compatible for it and modify the config from SM6115 to make them
> compatible with the SC8280XP binding
>
> Signed-off-by: Lux Aliaga <they@mint.lgbt>
> Reviewed-by: Martin Botka <martin.botka@somainline.org>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> index 318eea35b972..f33c84578940 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> @@ -693,6 +693,8 @@ static const struct qmp_phy_cfg sdm845_ufsphy_cfg = {
>  static const struct qmp_phy_cfg sm6115_ufsphy_cfg = {
>         .lanes                  = 1,
>
> +       .offsets                = &qmp_ufs_offsets_v5,

Please don't randomly reuse generation-specific structures. This
structure is clearly related to v5, while the PHY is from the v2
generation.

> +
>         .serdes_tbl             = sm6115_ufsphy_serdes_tbl,
>         .serdes_tbl_num         = ARRAY_SIZE(sm6115_ufsphy_serdes_tbl),
>         .tx_tbl                 = sm6115_ufsphy_tx_tbl,
> @@ -1172,6 +1174,9 @@ static const struct of_device_id qmp_ufs_of_match_table[] = {
>         }, {
>                 .compatible = "qcom,sm6115-qmp-ufs-phy",
>                 .data = &sm6115_ufsphy_cfg,
> +       }, {
> +               .compatible = "qcom,sm6125-qmp-ufs-phy",
> +               .data = &sm6115_ufsphy_cfg,
>         }, {
>                 .compatible = "qcom,sm6350-qmp-ufs-phy",
>                 .data = &sdm845_ufsphy_cfg,
> --
> 2.39.0
>


-- 
With best wishes
Dmitry
