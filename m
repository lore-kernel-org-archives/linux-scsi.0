Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F71CCA47D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 09:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239810AbiFMJrP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 05:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239330AbiFMJrP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 05:47:15 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94C91928B
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 02:47:11 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r187-20020a1c44c4000000b0039c76434147so4245823wma.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 02:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QBbQ5RlehgZnaAFrfhn8bcmuDJisLZ8n0VZI5+tVYd0=;
        b=Z3v0eSGeIIXyS+chr/DHZqDXVP9ghpBeOpyTPZnRzgvBMK2KTKcmPqiJQKdaYyAUFN
         /5I3VKtpsPS2LnAfqV4Wt5PnVqFDqh5lxiRB9AfwBzQFucpd0XxU++wTExjO1rPgcUJh
         hRDUoFoC0QnkrGyym9py85jy3rwrZS78VeOvzaiWNOVeoK0jOGfMUm9kRZ4gYAcJx1qO
         eWsCODyQWnmNHe5Nj00hoLKS0IdxF6kO8DPpvf65RTkwf/uBvbsNghF5OQ+XT0+KoA8l
         Q/Pwj0p60nA7MvqurDqt35ZXIfidOhub5Ukw59AbL3imUl8oD+xQ3l9yVVvUC4mC98ne
         DuHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QBbQ5RlehgZnaAFrfhn8bcmuDJisLZ8n0VZI5+tVYd0=;
        b=X+NdZpKoq7UpBujhQ9bb0isf7EhSPwU4iGNBIziRyiujNQxqDjKUycQ6azPu+0rjgV
         sGy/2g9izvoJQkPC8jD9ltyoze2F3CmMncfDMlUz1Lddj7sON44ARp0z7mCp0RLl6ias
         ojj9U6x+k4zhWNv4n+5Fq1vE2rhw30eeMY1c6pHOaw1u4U2Mvu+Exl/x7aYDMul1m20L
         S0aTrWq5EPDvINaVruoouAP2gcoyFYRkeiM9p7eJVBiEvAvuBsEgSl/wQR4fTWRHNDR3
         DFvgzeospwMaVX1C0n2cWDEpl3NjNacIzEiVmoB9ofZGSPVLSATy6L1LSi69064jyX1K
         W6dg==
X-Gm-Message-State: AOAM533Bu6Y02FYIro6IWTrllA3J1HFLhMtrC/mG4NIErFsKtn6xrWoD
        Ir/3i4GMdNCgFT6xjtzTFy9Jnw==
X-Google-Smtp-Source: ABdhPJy7gGaJAsLK4y+fIQ/Ft4Fmg9Bv62EVmuuU3nkUVCLfFTuDLBrT56zqaFARL7o+XzGT3C/n8Q==
X-Received: by 2002:a7b:ce98:0:b0:39c:4dc7:6707 with SMTP id q24-20020a7bce98000000b0039c4dc76707mr13988444wmj.51.1655113630472;
        Mon, 13 Jun 2022 02:47:10 -0700 (PDT)
Received: from [10.227.148.193] (80-254-69-65.dynamic.monzoon.net. [80.254.69.65])
        by smtp.gmail.com with ESMTPSA id 10-20020a05600c228a00b00397342bcfb7sm8762339wmf.46.2022.06.13.02.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 02:47:09 -0700 (PDT)
Message-ID: <71874de3-10f3-aad5-6f86-373f13bf4d90@linaro.org>
Date:   Mon, 13 Jun 2022 11:47:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 3/6] phy: samsung-ufs: add support for FSD ufs phy
 driver
Content-Language: en-US
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
Cc:     devicetree@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, chanho61.park@samsung.com,
        pankaj.dubey@samsung.com, Bharat Uppal <bharat.uppal@samsung.com>
References: <20220610104119.66401-1-alim.akhtar@samsung.com>
 <CGME20220610104350epcas5p2a42643432e60d7ba18f2a2afcffadfaf@epcas5p2.samsung.com>
 <20220610104119.66401-4-alim.akhtar@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220610104119.66401-4-alim.akhtar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/06/2022 12:41, Alim Akhtar wrote:
> Adds support for Tesla Full Self-Driving (FSD) ufs phy driver.
> This SoC has different cdr lock status offset.
> 
> Signed-off-by: Bharat Uppal <bharat.uppal@samsung.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> Reviewed-by: Chanho Park <chanho61.park@samsung.com>



Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
