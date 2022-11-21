Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7E3C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Nov 2022 19:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiKUTUb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 14:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiKUTUb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 14:20:31 -0500
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A318511A
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 11:20:30 -0800 (PST)
Received: by mail-pj1-f45.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so15145703pjc.3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 11:20:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lFl6W+hJWN2bBrYpxjrjqhS8rEn7D4qA6sOkPbKFAnk=;
        b=NZptR4a4sn4bYLwUiqUiqq0TUhJTkceCsK6ZAP/kE3jy8q5TaLp6s4tZII3SaDCT1u
         j8I/oZqVBWBOvER6v7wHMi7dhsUKxulL/SFBZb7U9X3m/P8BHttuY6jWN9osPUE7QGgj
         eTsFsjfAxTloUu81zo4VZlKg9RU1+FSjPtI1MyFqqpuzhlu5U/YRJLXwjvRe88hKzkK+
         ZRv4bO1z3bzTPR2upgEJy4RXIasY7LJzVkHkwNCD0ajvkPa4M8JkZcT3vZcNK9Uadm36
         QXobjFj3nAnsvx0XavvRYFklFve5xlMkrSDVHJAL/tVY26AOZ/qaGQymPF+RxeaHEzPT
         OCpA==
X-Gm-Message-State: ANoB5pm0VdG9LIad0joLXU33NVFEyMTV1o8kW6woUGjVYRpTWnXo1/TB
        Xg1/1VPVY/k5yLNmd3gdvhg=
X-Google-Smtp-Source: AA0mqf7mssBevcyEoi7qDQBmDzSoUMpnQItLUjvd39bg3ZFkO02GqAAEYvbYar7IOPBTgdxWhfdFmg==
X-Received: by 2002:a17:902:b407:b0:186:9c25:7ef0 with SMTP id x7-20020a170902b40700b001869c257ef0mr12999580plr.164.1669058430008;
        Mon, 21 Nov 2022 11:20:30 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:545d:bfd:7b53:8e94? ([2620:15c:211:201:545d:bfd:7b53:8e94])
        by smtp.gmail.com with ESMTPSA id y15-20020aa79aef000000b00565cbad9616sm9034114pfp.6.2022.11.21.11.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 11:20:29 -0800 (PST)
Message-ID: <daa50593-d7a4-ce50-fda1-662c3ee89252@acm.org>
Date:   Mon, 21 Nov 2022 11:20:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Remove unnecessary return code
Content-Language: en-US
To:     Chanwoo Lee <cw9316.lee@samsung.com>, stanley.chu@mediatek.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        matthias.bgg@gmail.com, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org
References: <CGME20221121003431epcas1p1429429bf4bc1670c7b82b3889c017049@epcas1p1.samsung.com>
 <20221121003338.11034-1-cw9316.lee@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221121003338.11034-1-cw9316.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/20/22 16:33, Chanwoo Lee wrote:
> From: ChanWoo Lee <cw9316.lee@samsung.com>
> 
> Modify to remove unnecessary 'return 0' code.
> 
> Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
> ---
>   drivers/ufs/host/ufs-mediatek.c | 11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> index ef5816d82326..21d9b047539f 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1095,7 +1095,7 @@ static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
>   	}
>   }
>   
> -static int ufs_mtk_post_link(struct ufs_hba *hba)
> +static void ufs_mtk_post_link(struct ufs_hba *hba)
>   {
>   	/* enable unipro clock gating feature */
>   	ufs_mtk_cfg_unipro_cg(hba, true);
> @@ -1106,8 +1106,6 @@ static int ufs_mtk_post_link(struct ufs_hba *hba)
>   			FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
>   
>   	ufs_mtk_setup_clk_gating(hba);
> -
> -	return 0;
>   }
>   
>   static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
> @@ -1120,7 +1118,7 @@ static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
>   		ret = ufs_mtk_pre_link(hba);
>   		break;
>   	case POST_CHANGE:
> -		ret = ufs_mtk_post_link(hba);
> +		ufs_mtk_post_link(hba);
>   		break;
>   	default:
>   		ret = -EINVAL;
> @@ -1272,9 +1270,8 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
>   	struct arm_smccc_res res;
>   
>   	if (status == PRE_CHANGE) {
> -		if (!ufshcd_is_auto_hibern8_supported(hba))
> -			return 0;
> -		ufs_mtk_auto_hibern8_disable(hba);
> +		if (ufshcd_is_auto_hibern8_supported(hba))
> +			ufs_mtk_auto_hibern8_disable(hba);
>   		return 0;
>   	}

The last hunk is not related to the other hunks and hence probably 
should have been a separate patch. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
