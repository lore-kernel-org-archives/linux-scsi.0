Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A95A8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 09:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiGEJgN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jul 2022 05:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiGEJgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2022 05:36:12 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DACECEA
        for <linux-scsi@vger.kernel.org>; Tue,  5 Jul 2022 02:36:11 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id z21so19514155lfb.12
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jul 2022 02:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DVpNA/tLD/wvwSxUeEUrSF+gBAXB9p0G4i2gTUY7urk=;
        b=Kl1wLaVX0l0SkIKLe+s6DLVY5Wie08GC35B2K0NpcRRIxKdH7fbwvzcZGq/3TB49so
         9npPluaHmv29OPp44rcZGSxxc8azqw8MgTbBi5FboSN0yNOf7aTzhkA4q6Tgo+p/D+fB
         alij7kkxVwVDnunV6i/5yTjIAXHUc/47g8NznZFe4jIkGcnmH/lOEPcbdYhfmsFZb5An
         83b67neobRFsT0lCpQ+Rp6dBbhsn1QvjBDKyA2alZq3LS2NhfAWCRnUF7hUiGgns5CD/
         3tqtYEZApRjUoPveGsXsoHYRjEfvmGf022D1FOkzeNGfXSzybQ6HRM/Ef4NElQ+4MONC
         67dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DVpNA/tLD/wvwSxUeEUrSF+gBAXB9p0G4i2gTUY7urk=;
        b=LpXAUay8bDMLXwqJrKjFcSyexO9J9AXy7qNqvVKUc4IF09LCezLiIN5t/OAcB6Lo9d
         s1FFHKs2SPIMWgsF4dOWhnKoN+urArv3FIncQiGK2T2W9oWrD3HY7KxmJuu/lqbdhGU7
         xBQ0fpar0st2jlrQt3nigzDPTHmK1G3xZg7ijoOswlP2OdgNG7Lfo+SV/TX6aUdM9lg8
         ItH1ppvujraGH7Pj4BXjSZ9MrlcqryPbVJfiNNjRKnkUR9xpT+GaVKmOeC8MnrVtdLrk
         Vy1xtcXq0Y6cV9Pd+cghSrnPSzoJkHqj1AB5Eu8N6i57X+XQDWP54z4Ilu/Bs45Se3Ix
         vtdw==
X-Gm-Message-State: AJIora82GeYoJlS8PrbUzS9dppeR1kWHpZ5da43rn73TkfQHprXgEfo/
        FFFig0VnEaEpahOXu+urwvyjtQ==
X-Google-Smtp-Source: AGRyM1sYGyEqkaCnXtTCeKFV77xk0RouTj+keeHZY5v3cr5MdA2/69gP8t4dwAwlMR1FESY1AQydhA==
X-Received: by 2002:a05:6512:32c1:b0:47f:9d05:b6be with SMTP id f1-20020a05651232c100b0047f9d05b6bemr21155038lfg.335.1657013769673;
        Tue, 05 Jul 2022 02:36:09 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id q14-20020a056512210e00b0048389c88ba6sm249336lfr.40.2022.07.05.02.36.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 02:36:09 -0700 (PDT)
Message-ID: <d23604f8-f6b3-0f2f-6ab0-418a6fb9549f@linaro.org>
Date:   Tue, 5 Jul 2022 11:36:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] ufs: ufs-exynos: change ufs phy control sequence
Content-Language: en-US
To:     Chanho Park <chanho61.park@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
References: <20220705065440.117864-1-chanho61.park@samsung.com>
 <CGME20220705065722epcas2p3f9970697f6d1f1fed43e10fe17019619@epcas2p3.samsung.com>
 <20220705065440.117864-4-chanho61.park@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220705065440.117864-4-chanho61.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/07/2022 08:54, Chanho Park wrote:
> Since commit 1599069a62c6 ("phy: core: Warn when phy_power_on is called
> before phy_init"), below warning has been reported.
> 
> phy_power_on was called before phy_init
> 
> To address this, we need to remove phy_power_on from
> exynos_ufs_phy_init and move it after phy_init. phy_power_off and
> phy_exit are also necessary in exynos_ufs_remove.
> 
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  drivers/ufs/host/ufs-exynos.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> index f971569bafc7..5718296e2521 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -908,6 +908,8 @@ static int exynos_ufs_phy_init(struct exynos_ufs *ufs)
>  		goto out_exit_phy;
>  	}
>  
> +	phy_power_on(generic_phy);


What about phy_power_on() return code?

> +
>  	return 0;
>  
>  out_exit_phy:
> @@ -1169,10 +1171,6 @@ static int exynos_ufs_init(struct ufs_hba *hba)
>  		goto out;
>  	}
>  
> -	ret = phy_power_on(ufs->phy);
> -	if (ret)
> -		goto phy_off;
> -


Best regards,
Krzysztof
