Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF13C636CD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 14:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbjBJOXP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 09:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbjBJOXO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 09:23:14 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1AF5C49A
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 06:23:13 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id gr7so16280273ejb.5
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 06:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NdOKf6k8eK+sXpOR2GpgLamFWEpEBWz1DJi9w3zHAm0=;
        b=PBvq4dcZIxj8vMsnaGqzql49N0UbkaGxOy92q0QCF8whnxTtGv0xWVX2tAdshUqBca
         bZhH+HlemdsWE64JXWvVyTvZbEH9XUW0tS6JSVDz1/arF+1nt5uxafKrtxxDgKFQALjg
         001i6/ZbdQ/Yh11KwxQ8pkOwA3RfPKRHIdvPVnGY7n+ar/d6+oUvzikr32dlqPkg1t6U
         Db5cCzyxHYlBfBmcup3TuYWZJzke1N+sT3ykDG4wp8lY2DuNPsaKc567lAVArV6YkyvP
         1j2DLab8LRfMYzJquC+drDViSlMZDZ7jnjS/JLpQatyl74GDKl0NqP7vl1dZySoWRNfL
         EjVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NdOKf6k8eK+sXpOR2GpgLamFWEpEBWz1DJi9w3zHAm0=;
        b=T738WNAr+QeKB8MXfKGG2sa0FakpUDYG4Cw7lC4y3V3BzbHvvp4u2c36OKD0rL/CGm
         Zb12PU/0bqmF9iJe2RhLqNpa/jRDYHN6+eo5pK7J6eEnpIgOig0Re5KWwPoUN71I+lb/
         0cTG+W+XhD6efAgDk57WKUqEGnq8lun96zXNWGN9caDqjdm8s2V1VR6s2IHKrzPhkMFf
         rUce/qr7b6q6nOtglPmvOaNkK8rFykhL8SRs/Jh+7LyBbYd2c4SyGN5cDBuL9klhxdBt
         hS9v2Fu3s3Lo5WJia1ZW9Yu29QzaJgImLB/gJJpYuHJwADmLHzGBPh/Wa5pc1E2TgJY/
         3CHg==
X-Gm-Message-State: AO0yUKUyh+1iaDbi+LSdVLnhhKgfOTJSjP2nzJxCNjCnZ94IW5WpJy/I
        yq/pP4t8sFD8kceiPZ7hHz46ou8krsF62g==
X-Google-Smtp-Source: AK7set+6a0sEaoLncKh+v1gyS08+B/wS0hJiisHbWo2TNA8UG6QmiD9oLFKyEc2sRYzQf9hCBpacbA==
X-Received: by 2002:a17:906:584:b0:888:6294:a1fa with SMTP id 4-20020a170906058400b008886294a1famr15690885ejn.14.1676038992011;
        Fri, 10 Feb 2023 06:23:12 -0800 (PST)
Received: from [10.176.235.173] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id s20-20020a170906061400b0088ba2de323csm2426131ejb.181.2023.02.10.06.23.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 06:23:11 -0800 (PST)
Message-ID: <7996f1a6-a6b1-cec1-e3c2-db3508034772@gmail.com>
Date:   Fri, 10 Feb 2023 15:23:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] scsi: ufs: Make the TC G210 driver dependent on CONFIG_OF
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Joao Pinto <jpinto@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Eric Biggers <ebiggers@google.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Zhe Wang <zhe.wang1@unisoc.com>
References: <20230209184914.2762172-1-bvanassche@acm.org>
From:   Bean Huo <huobean@gmail.com>
In-Reply-To: <20230209184914.2762172-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09.02.23 7:49 PM, Bart Van Assche wrote:
> The TC G210 driver only supports devices declared in the device tree.
> Hence make this driver dependent on CONFIG_OF. This patch fixes the
> following compiler error:
>
> drivers/ufs/host/tc-dwc-g210-pltfrm.c:36:34: error: ‘tc_dwc_g210_pltfm_match’ defined but not used [-Werror=unused-const-variable=]
>     36 | static const struct of_device_id tc_dwc_g210_pltfm_match[] = {
>        |
>
> Cc: Joao Pinto<jpinto@synopsys.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

