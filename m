Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE4DC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 17:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiKRRaL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 12:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240803AbiKRRaI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 12:30:08 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC951A814
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 09:30:08 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id y10so3961498plp.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 09:30:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FE6/oTXN2ta3Lwtigwi9CDndY4Q5JNcj6qFjAD85F4M=;
        b=7Zky/PY03twPG5JJ4+exeYvN4He1usCSRXHNLFBH9ZHbjir2GjVL/6VTRXIup3P+Yr
         hew9EJI0mk2PpjiQouvpYWXcSM77j4WPUl22YMmMwAK3gsqH38eBGA0MHQuKrFk+BREF
         uRYS9yudWpAmkJz+fylBTuK5TZGMBW+Oym/IzfnYIpsw40zax80OLMr+1w4j0VRd4a2r
         dvYnckqIH3yAucY69x+l0OonMNHRu0WzjyPxP8hXP2KpJVhfsO2zvl+WQdcX8jaDkrZ/
         Aa8++5kL/HCCMHme6p+C1F/Vht4l2BjT4k7eaFu7by3bRODB9gGhH2Zgqd2gg+Fz5LdH
         EIZw==
X-Gm-Message-State: ANoB5plPZo65DsNXnaawxq2hNW49XIyDM5fpXOfuU6wuLvaywkzmSWFq
        AERvojciPP3q1fg0V9JiKEo=
X-Google-Smtp-Source: AA0mqf6tARTG+FlbQARPkZSnLhlXZplxfkj67QxmEyJxkRZwGsvM38JVTEClvYabBVzUBj0md6Pgcw==
X-Received: by 2002:a17:902:f651:b0:188:50c2:89fb with SMTP id m17-20020a170902f65100b0018850c289fbmr399775plg.130.1668792607648;
        Fri, 18 Nov 2022 09:30:07 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5392:f94c:13ff:af1a? ([2620:15c:211:201:5392:f94c:13ff:af1a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7960d000000b0054ee4b632dasm3380040pfg.169.2022.11.18.09.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 09:30:06 -0800 (PST)
Message-ID: <db25901b-8537-ca16-aaac-0daaa636d84d@acm.org>
Date:   Fri, 18 Nov 2022 09:30:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Modify the return value
Content-Language: en-US
To:     Chanwoo Lee <cw9316.lee@samsung.com>, stanley.chu@mediatek.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        matthias.bgg@gmail.com, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org
References: <CGME20221118045326epcas1p408c9e16a58201043c9eb3c99110fab0c@epcas1p4.samsung.com>
 <20221118045242.2770-1-cw9316.lee@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221118045242.2770-1-cw9316.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/17/22 20:52, Chanwoo Lee wrote:
> From: ChanWoo Lee <cw9316.lee@samsung.com>
> 
> Change the same as the other code to return bool type.
>    91: 	return !!(host->caps & UFS_MTK_CAP_BOOST_CRYPT_ENGINE);
>    98: 	return !!(host->caps & UFS_MTK_CAP_VA09_PWR_CTRL);
>    105:	return !!(host->caps & UFS_MTK_CAP_BROKEN_VCC);
> 
> Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
> ---
>   drivers/ufs/host/ufs-mediatek.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> index 7d13878dff47..ef5816d82326 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -109,7 +109,7 @@ static bool ufs_mtk_is_pmc_via_fastauto(struct ufs_hba *hba)
>   {
>   	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
>   
> -	return (host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO);
> +	return !!(host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO);
>   }

Hi ChanWoo,

Please drop this patch and instead remove the !! from the other functions
that have return type 'bool'. There is more Linux kernel code that relies on
the implicit conversion from type 'int' to 'bool' than code that converts
explicitly from 'int' to 'bool'.

Thanks,

Bart.

