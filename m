Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EBAC19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 19:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbiHCTaD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 15:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238725AbiHCT3f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 15:29:35 -0400
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8058F5927E
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 12:28:55 -0700 (PDT)
Received: by mail-vs1-f53.google.com with SMTP id 129so18922911vsq.8
        for <linux-scsi@vger.kernel.org>; Wed, 03 Aug 2022 12:28:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=RCxZcYJN9rkKZCIis3ewORAEM/I+F6Y2IS/7dkOJB6o=;
        b=NH7BLhAZt8Q7gj7DUTYwIyju7mbfSSErbDyvjxA2R9NWgdOXszoUmmllb8Gr4ydva8
         Cl5EMCAq5ghjpBAveAx0oX1bQWvib4e+NyEFB4w1GHmlNakfQQEI76Xr15VOW8lG+FNa
         7exA2QbLi7Qadmg/7EXvVCV6HogxjIfaKX7JGF9fy71jeGKkMKF9BWK4KRK5Jl9Pb6OE
         ThYB0rRmmfIQTSS9nkMfUsfBrhNJwZvwehHo3HAf+9VVgvW2ndLh6BF2MmSvEKyg5Yg3
         ei38sbDR+4+jY7r7gKaQ6hvBMzQB4wcrhn+2OB0NHimlcVSUTdYhEvyxctOH0VDhP2AN
         FPiA==
X-Gm-Message-State: ACgBeo3G713h+0yc9Z3EO+nP2aFLlpqdz5cDu+611Ylmi7pYQL5pnG9n
        GCO8lbElmHXlQYs35+Y+HyEyTRLmLVk=
X-Google-Smtp-Source: AA6agR5JPTv9cCZgg/k8OdPdC5xEIL2jgCN9700hcZo/9c1ZtDwXDp1PvaN7CtUksCOK77lA0OXfhw==
X-Received: by 2002:a17:902:694c:b0:16d:cc5a:8485 with SMTP id k12-20020a170902694c00b0016dcc5a8485mr27650119plt.90.1659554923341;
        Wed, 03 Aug 2022 12:28:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:db71:edb7:462a:44af? ([2620:15c:211:201:db71:edb7:462a:44af])
        by smtp.gmail.com with ESMTPSA id v66-20020a626145000000b0052e6854e665sm80107pfb.109.2022.08.03.12.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 12:28:42 -0700 (PDT)
Message-ID: <2070dd08-371b-a660-388e-ec2481781db9@acm.org>
Date:   Wed, 3 Aug 2022 12:28:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4] ufs: allow host driver disable wb toggle druing clock
 scaling
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220803030329.5897-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220803030329.5897-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/2/22 20:03, peter.wang@mediatek.com wrote:
> 

disable -> to disable?

toggle -> toggling?

druing -> during?

> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index 0a088b47d557..7f41f2a69b04 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -225,7 +225,8 @@ static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
>   	unsigned int wb_enable;
>   	ssize_t res;
>   
> -	if (!ufshcd_is_wb_allowed(hba) || ufshcd_is_clkscaling_supported(hba)) {
> +	if (!ufshcd_is_wb_allowed(hba) || (ufshcd_is_clkscaling_supported(hba)
> +		&& ufshcd_enable_wb_if_scaling_up(hba))) {

The "&&" is misplaced - it should occur at the end of the previous line. 
Isn't this something that checkpatch complains about?

>   	/* Enable Write Booster if we have scaled up else disable it */
> -	downgrade_write(&hba->clk_scaling_lock);
> -	is_writelock = false;
> -	ufshcd_wb_toggle(hba, scale_up);
> +	if (ufshcd_enable_wb_if_scaling_up(hba)) {
> +		downgrade_write(&hba->clk_scaling_lock);
> +		is_writelock = false;
> +		ufshcd_wb_toggle(hba, scale_up);
> +	}

Since this code is being modified, please move the "/* Enable" comment 
to where it should occur (just above the ufshcd_wb_toggle() call).

> @@ -1004,6 +1010,10 @@ static inline bool ufshcd_is_wb_allowed(struct ufs_hba *hba)
>   {
>   	return hba->caps & UFSHCD_CAP_WB_EN;
>   }
> +static inline bool ufshcd_enable_wb_if_scaling_up(struct ufs_hba *hba)
> +{
> +	return hba->caps & UFSHCD_CAP_WB_WITH_CLK_SCALING;
> +}

It seems like a blank line is missing above the new function definition?

Otherwise this patch looks good to me.

Thanks,

Bart.
