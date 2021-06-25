Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9522DC2B9F4
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 12:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69CB46191C
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 12:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhFYMix (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Jun 2021 08:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbhFYMia (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jun 2021 08:38:30 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367A2C061574
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2021 05:36:09 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id i24so13174068edx.4
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2021 05:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=IA2cmI857SFP8VTa8k/Drhm9xAqP6cYPB3j56AlSAeQ=;
        b=FVUAf+Y84wtsor1oYwQLWw8xTyJDlo+iTxXxgS2JmV8mefEPFR331/6vkR0uJdKGVC
         SJO1oJA2dNLmY14SnoXlLw00CtfSPvYqB2LC5WX76lbTVDWmzDZ+9MeiSIlbETQ/7gEP
         VJIE66Cj88zBcNSI3T2uv4Sga7iTjPmwzIZWrn6GKzLjFybmTF/XBYsrauVfl7xcTTLi
         RveAYaFZeJguRAxOE+lWXdvqW3F5VUOS6pk0CnLDQUPb29BY/iqeJxX7a14fXDbdkPWr
         XDcaIO2VlNUEd3nzN//NIEIzxR9kicX7+xKENUKeLV3G7uMkouFDri3ocgmqwpMIMDvh
         ghMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IA2cmI857SFP8VTa8k/Drhm9xAqP6cYPB3j56AlSAeQ=;
        b=HNKlW26m6Xj4MgfEAJBaVsoE4w4xgEsEDfZBtfdVfLPObcxN46Dk4JH5VrL7Vo1nnS
         85H3sN/LHGgek13kw/HjgmUiBsM65uQNDMQd+fw0hKwLldw0aKWg0Yo4VygBxdbImBO3
         3cC7r73ZsOtOcWI8FSDe/vqHRyrS1ZtgAg070gF0P5sasKEN/oY3BsZcdBKAxUmgtKQd
         1t0dJuKQPSNc8tyqOEP1FZnCe21HmzUrb5s/YhhaJe81iwhOiORWViuQQYwqWMumMCab
         wDjq1GIdarUYxiAc7Kxc6b78l7F2x3bhx13WKuRZFf1Bj6b9ShE6FwgrCRifhl/DtuqC
         vCsA==
X-Gm-Message-State: AOAM532FrYiBJRziHstKKMfRbT6Fn27eAUTgpC8V1fxfSh8Vtj2BnAq+
        7WR9otGTTqzIv5+BzHMNrI4=
X-Google-Smtp-Source: ABdhPJwO2mZ1tvPhy+QXhElZNg/aolz4ufeYk5X5GlBl675TG2IjEHeA2UJeREJxGdC3VWFxJGMJ1w==
X-Received: by 2002:a05:6402:516b:: with SMTP id d11mr14373840ede.252.1624624567831;
        Fri, 25 Jun 2021 05:36:07 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id o5sm3905697edt.44.2021.06.25.05.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 05:36:07 -0700 (PDT)
Message-ID: <d90360ef1cececf74af1a295bdce8792d41ca179.camel@gmail.com>
Subject: Re: [PATCH v2 1/3] ufs: Reduce code duplication in the runtime
 power managment implementation
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Yue Hu <huyue2@yulong.com>, Kiwoong Kim <kwmad.kim@samsung.com>
Date:   Fri, 25 Jun 2021 14:36:06 +0200
In-Reply-To: <20210624232957.6805-2-bvanassche@acm.org>
References: <20210624232957.6805-1-bvanassche@acm.org>
         <20210624232957.6805-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-06-24 at 16:29 -0700, Bart Van Assche wrote:
>  static const struct dev_pm_ops tc_dwc_g210_pci_pm_ops = {
> 
> -       .suspend        = tc_dwc_g210_pci_suspend,
> 
> -       .resume         = tc_dwc_g210_pci_resume,
> 
> -       .runtime_suspend = tc_dwc_g210_pci_runtime_suspend,
> 
> -       .runtime_resume  = tc_dwc_g210_pci_runtime_resume,
> 
> -       .runtime_idle    = tc_dwc_g210_pci_runtime_idle,
> 
> +       .suspend         = ufshcd_system_suspend,
> 
> +       .resume          = ufshcd_system_resume,
> 
> +       .runtime_suspend = ufshcd_runtime_suspend,
> 
> +       .runtime_resume  = ufshcd_runtime_resume,
> 
>         .prepare         = ufshcd_suspend_prepare,
> 
>         .complete        = ufshcd_resume_complete,

Hi Bart,
you need to update this patch since you forgot to change the vendor's
driver.


drivers/scsi/ufs/cdns-pltfrm.c
drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
drivers/scsi/ufs/ufs-exynos.c
drivers/scsi/ufs/ufs-hisi.c
drivers/scsi/ufs/ufs-mediatek.c
drivers/scsi/ufs/ufs-qcom.c


Bean

