Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8527EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 21:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiGTVkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jul 2022 17:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiGTVks (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2022 17:40:48 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314A542AC6
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 14:40:45 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id c139so11328789pfc.2
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 14:40:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uZGVR1LPdhcF7N10kJ7EbkpxNgGbPbWiXCwyialE7gk=;
        b=zs7uOULZ4K+3ieJdj8xZrSFKpCCtTk/lDLniAllhSxAgyd1WxVpVzY8Lo8RgqLlBbp
         XYZgGOrRSTBbUeyz33PCSnXeNN6ncEcFCNlIk0bQ74ujJ3KNYxWZqPmiwqjnn4g7Uv5A
         jz/H/WpGy2AkHnV3eUneJcwy22FhYx3C0nGwxOm/p8301wJTQc6Lar8OA7eXLnULJpwn
         s+g3PrBTxdcR4x6O3yv4hL4WHVW3k8AaZL58NrIbLcKDjJDs0rk2tycWV4qy0kvpk96N
         zbM30rQSQUN0Ht9CJhOLOIJa/9ZZy5BvAz08IWUnL9UMMritlunrR4bTra0sA9WtplyZ
         7qlA==
X-Gm-Message-State: AJIora9iTB/vnI/hxmFVicyeJSzs0IqIiiNe+1sfZMRFUGxGhPOblg24
        X3jtaAZUEh+J8UXXNBhYX5e+WhO9ImCB+g==
X-Google-Smtp-Source: AGRyM1ttaQnkhF0Py+k74+2GSOUJ0rbxLNRDdmMF3y7oJQp5O5OnSxGDvTosBfjEabno80eSBCxS+w==
X-Received: by 2002:a63:c006:0:b0:411:c33f:b4bb with SMTP id h6-20020a63c006000000b00411c33fb4bbmr35483801pgg.433.1658353245244;
        Wed, 20 Jul 2022 14:40:45 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:2514:3c34:9133:f304:9ee9? ([2620:0:1000:2514:3c34:9133:f304:9ee9])
        by smtp.gmail.com with ESMTPSA id b4-20020a62cf04000000b0052ab92772a0sm108276pfg.98.2022.07.20.14.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 14:40:44 -0700 (PDT)
Message-ID: <afb8d403-f8f5-5161-4680-ce2c3ae7787d@acm.org>
Date:   Wed, 20 Jul 2022 14:40:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] scsi: ufs: correct ufshcd_shutdown flow
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220719130208.29032-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220719130208.29032-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/19/22 06:02, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> After ufshcd_wl_shutdown set device poweroff and link off,
> ufshcd_shutdown not turn off regulators/clocks.
> Correct the flow to wait ufshcd_wl_shutdown done and turn off
> regulators/clocks by polling ufs device/link state 500ms.
> Also remove pm_runtime_get_sync because it is unnecessary.

Please explain in the patch description why the pm_runtime_get_sync() 
call is not necessary.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c7b337480e3e..1c11af48b584 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9461,10 +9461,14 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
>    */
>   int ufshcd_shutdown(struct ufs_hba *hba)
>   {
> -	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
> -		goto out;
> +	ktime_t timeout = ktime_add_ms(ktime_get(), 500);

Where does the 500 ms timeout come from?

Additionally, given the large timeout, please use jiffies instead of 
ktime_get().

> -	pm_runtime_get_sync(hba->dev);
> +	/* Wait ufshcd_wl_shutdown clear ufs state, timeout 500 ms */
> +	while (!ufshcd_is_ufs_dev_poweroff(hba) || !ufshcd_is_link_off(hba)) {
> +		if (ktime_after(ktime_get(), timeout))
> +			goto out;
> +		msleep(1);
> +	}

Please explain why this wait loop has been introduced.

Thanks,

Bart.
