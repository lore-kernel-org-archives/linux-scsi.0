Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5D5C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Mar 2022 11:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346752AbiCULYN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Mar 2022 07:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243316AbiCULYM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2022 07:24:12 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7518BE19
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 04:22:47 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id j2so27502008ybu.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 04:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=59/+29AfugXrFjzNAA/AleHnJFc3FQCIzeHJaozhbYs=;
        b=m8XwpHjKU/W+0aeE0aPhwzwKwy85wfRo4sPTe4jYG6ugw9k55IP7wQxyjtUlrsYH6L
         vFwf5X7rYpPMGoZFzSGwYJXPJUhhU4vS3KxGFE7zo6tMzsRA0EDCmqOJ38RjXh4aZTQi
         B6Cxjhpbq0VX/zpyHtpaFWgO6Sb/XqE970Af3s89fgoDUWPk9HvLdPDyKwn3SBEkMOrd
         5A0fFiNLHfesAR1aGGivG9Z8mI5iYsgSF/z6NoXTm1gsSQ5Nszw1za0F3pfafe21R8tA
         VUU2+JfQYqGDFCwJZe+ClHoqpUO/YzBcw3+pl0UxJO3btWaKLVma4kA4NAyWFtk/9qnM
         DxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=59/+29AfugXrFjzNAA/AleHnJFc3FQCIzeHJaozhbYs=;
        b=VT+KdS3j/4hwaxJiBHN33I3uV9lbQvvnB0bm9CZz26JYP420XzCdlj1DDK2GOzDpm6
         al89jaEm7SQeArtPCRg75VXSOIrrxxDuoabt57FvvMfWiy+sj7GNG8HEiH/axZS9GU7a
         l7YgCkdLPBHnC/dl6sd7LS5E5z+hPt+NVZjohUA5D3RATcBgHg5nr0yx6X4GCqm2Xq9F
         WYYomiQGeLXr302TnSi3enAOCyFIywd3es7E8r5sSvNzYMgUfaDcPzCZEnM8mk0GeP2l
         FImIefdw3WVH71cPWPzvZbr0ODuqPJDC/BFWBp6VPa9Upn5EegF3gtMDEAjyjV/bnjnJ
         J/Vg==
X-Gm-Message-State: AOAM532/48kgr8b0LfduV+CgjMvugyVeHNJYM8XCVYcc7aNRCp7PyVjv
        njn7YtoIvJKHFkuFxiU06wcJZ5VqeMRoXNHmoh6+xw==
X-Google-Smtp-Source: ABdhPJzWhuELzmeHPG56Ha7BZy3OBGHZOV0q502yNMMRvCHzJ3G4EqBNQBJ2L5I4VLWlR1XUtgBEqVKLi8rTJQxjiwA=
X-Received: by 2002:a5b:848:0:b0:633:716f:1fb0 with SMTP id
 v8-20020a5b0848000000b00633716f1fb0mr19901896ybq.522.1647861766807; Mon, 21
 Mar 2022 04:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220320110616.18355-1-krzk@kernel.org>
In-Reply-To: <20220320110616.18355-1-krzk@kernel.org>
From:   Amit Pundir <amit.pundir@linaro.org>
Date:   Mon, 21 Mar 2022 16:52:10 +0530
Message-ID: <CAMi1Hd0T6bBdOCe4o_-RSaHdmG3oT9KtqDpHOiQpGQxmoBVa0w@mail.gmail.com>
Subject: Re: [RFT] ufs: qcom: drop custom Android boot parameters
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 20 Mar 2022 at 16:36, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> The QCOM UFS driver requires an androidboot.bootdevice command line
> argument matching the UFS device name.  If the name is different, it
> refuses to probe.  Thise androidboot.bootdevice is provided by
> stock/vendor (from an Android-based device) bootloader.
>
> This does not make sense from Linux point of view.  Driver should be
> able to boot regardless of bootloader.  Driver should not depend on some
> Android custom environment data.
>

No obvious regression on QCOM devboards DB845c (sdm845) and RB5
(sm8250), and Xiaomi Pocophone F1 (sdm845) running AOSP.

Tested-by: Amit Pundir <amit.pundir@linaro.org>

> Cc: Luca Weiss <luca.weiss@fairphone.com>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
>
> ---
>
> Not tested, please kindly provide tests.
>
> See also:
> https://lore.kernel.org/linux-devicetree/f61abc2b-3ce8-7b1f-3d28-8a4a03ec58eb@kernel.org/T/#u
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 15 ---------------
>  1 file changed, 15 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 0d2e950d0865..586c0e567ff9 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -957,18 +957,6 @@ static const struct reset_control_ops ufs_qcom_reset_ops = {
>         .deassert = ufs_qcom_reset_deassert,
>  };
>
> -#define        ANDROID_BOOT_DEV_MAX    30
> -static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
> -
> -#ifndef MODULE
> -static int __init get_android_boot_dev(char *str)
> -{
> -       strlcpy(android_boot_dev, str, ANDROID_BOOT_DEV_MAX);
> -       return 1;
> -}
> -__setup("androidboot.bootdevice=", get_android_boot_dev);
> -#endif
> -
>  /**
>   * ufs_qcom_init - bind phy with controller
>   * @hba: host controller instance
> @@ -988,9 +976,6 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>         struct resource *res;
>         struct ufs_clk_info *clki;
>
> -       if (strlen(android_boot_dev) && strcmp(android_boot_dev, dev_name(dev)))
> -               return -ENODEV;
> -
>         host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
>         if (!host) {
>                 err = -ENOMEM;
> --
> 2.32.0
>
