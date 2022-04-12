Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA1FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 12:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbiDLMyn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 08:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355213AbiDLMxy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 08:53:54 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E631BF4C
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 05:24:50 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r13so37017273ejd.5
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 05:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=J2HOD4HkMW/WZyqU0scb3DkqJOIyVXtxXfFpqLF39LA=;
        b=BSDBx092na8G09obDs12KLpu14UVloBiQJ/OUqzJv5waDFB27iZt7LmuLRQTcdF/QK
         UtNLeaZbQhMYajiLfZd/CPAPvD72Oip6XFlqRlHfSmlQgCZdKt86+UWjNoqTQZbx8iss
         Z6zJJTUs+vldkwfbjABxL3NstE0QtnGNApADZhtMIRQXKNl4NL1zSQbCtlQpbBqPTurp
         BS2mG4nHSwf1Ev64IKyULv1yZVa194WpIIdWp2q6rknBZt1aPAYsqiqFpG/7WDO5/KAJ
         /lseMUcKB4NbnuDW2O8dx9HyyqsD63nzIbDIgc3CW5RmEhujFJwuTmxSwTTLy0ej/1rZ
         mYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J2HOD4HkMW/WZyqU0scb3DkqJOIyVXtxXfFpqLF39LA=;
        b=CFsamsAR557JYuxI+MYGRHPSvCzoT+RpeTCAPofkHn21Bs1WtfVXA3wg2oONcfrbUS
         hkWmccdVOh/hvgeKT4In9AFfPQVazawVX3kmbxuGU3H6W2+PCjtbX39fcjsFjyVZ80+Q
         eG2Bdqlwa1mIAYyaoHEfA6U7AoQJOr6Q/jOgUtmPSsX7n/SkeOmiKv4EzHHsSUuLjMug
         +7XbkfoEjeueEgn0/93ZI6pXxgwyuKXh4xMH4ZYBM75zSr6ba5TXEmhJByJYG0GuY64g
         7MOjZH/8vDBOL1oHMtQq2mgYEjYFtXbmOMw9pbldeGWFv48iBjNpqNsI5UeB/Dv64azN
         dswg==
X-Gm-Message-State: AOAM532QcK4mSNxttk9ztVCI5rPyZh08QnJVXzngm/mfRnBdGkpDhYm9
        v9FmjopeMVqg1Oq0it6PG/KNSg==
X-Google-Smtp-Source: ABdhPJwxDokvnjMDNUOHEQrLSn0IBIa0rpIgwtzTTXscmRrZbvnL+qTQQZS+r1WuNbxU2d4mzcczrg==
X-Received: by 2002:a17:906:5d11:b0:6e5:344f:22e7 with SMTP id g17-20020a1709065d1100b006e5344f22e7mr32096986ejt.178.1649766288912;
        Tue, 12 Apr 2022 05:24:48 -0700 (PDT)
Received: from [192.168.0.195] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id c13-20020a17090654cd00b006e0db351d01sm13147984ejp.124.2022.04.12.05.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 05:24:48 -0700 (PDT)
Message-ID: <69ae7c10-0967-7581-18df-8ec19e9aa410@linaro.org>
Date:   Tue, 12 Apr 2022 14:24:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 4/7] scsi: ufs-renesas: Add support for Renesas R-Car UFS
 controller
Content-Language: en-US
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, robh+dt@kernel.org,
        krzk+dt@kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20220412073647.3808493-1-yoshihiro.shimoda.uh@renesas.com>
 <20220412073647.3808493-5-yoshihiro.shimoda.uh@renesas.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220412073647.3808493-5-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/04/2022 09:36, Yoshihiro Shimoda wrote:
> Add support for Renesas R-Car UFS controller which needs vender specific
> initialization.

Thank you for your patch. There is something to discuss/improve.

> +static const struct of_device_id ufs_renesas_of_match[] = {
> +	{ .compatible = "renesas,r8a779f0-ufs" },
> +};
> +MODULE_DEVICE_TABLE(of, ufs_renesas_of_match);
> +
> +static int ufs_renesas_probe(struct platform_device *pdev)
> +{
> +	return ufshcd_pltfrm_init(pdev, &ufs_renesas_vops);
> +}
> +
> +static int ufs_renesas_remove(struct platform_device *pdev)
> +{
> +	struct ufs_hba *hba = platform_get_drvdata(pdev);
> +
> +	ufshcd_remove(hba);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver ufs_renesas_platform = {
> +	.probe	= ufs_renesas_probe,
> +	.remove	= ufs_renesas_remove,
> +	.driver	= {
> +		.name	= "ufshcd-renesas",
> +		.of_match_table	= of_match_ptr(ufs_renesas_of_match),

You probably need "__maybe_unused" if you want to keep of_match_ptr.
Compile test with W=1 on other platforms should point it out. Other
solution is to remove of_match_ptr().

Best regards,
Krzysztof
