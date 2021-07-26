Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBB8C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 17:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 017FD60F6D
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 17:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhGZRTP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 13:19:15 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:36502 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhGZRTP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 13:19:15 -0400
Received: by mail-pj1-f45.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso86843pjb.1;
        Mon, 26 Jul 2021 10:59:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Cku6Rze8FYvo3mRLiCQNQ614ck9Z1LgtQwmHqzhZnQ=;
        b=Oyh9YQRUeDmPzj5Mahvl5C4l0NDUBm/YL3ccY4lIUfuoF1/sxJFX8E7smDL9x1oIHy
         gD0uYYFLvAO8c/GVug7hRohErDia17IijOf8sdS5Nit9I52E4i43cIExHVVkJb1GGSFY
         AfpeyR/F5MA3wmMy+7SO0oJo+aKmFE1Zr/dKGhi2wz23hu1hFLlI/g/NuxK1pgxxctds
         zQIrPikFwNjwJ7w9W8r8XPXOoJqKPtzWxchG03WrOaM4tDGhPuNNuZkaLbJ8XTfpGXx/
         AIfmJkMJSj2DFFHgoG5QrSGCSIbFqSU2nNJA+EPgWujtcr9NDNAkT4G0sF/LX5hqM1UJ
         tl1w==
X-Gm-Message-State: AOAM531Cu0Pltpu8KYYovU7B+/F555svcDG3oGrE8Nisj9jhGItGxG7F
        1E6Vptk4mdx79otrEjkMiI+Ub/Ef0xJTmS8q
X-Google-Smtp-Source: ABdhPJyqqdSMxLUKWTrIpCwWEiv2aqujjYIwSwGKXgw8gZKdcN1sIWvgYSJj/i0IHVYwbMPLp9jRgA==
X-Received: by 2002:a17:90a:f296:: with SMTP id fs22mr172129pjb.155.1627322383125;
        Mon, 26 Jul 2021 10:59:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:6048:349e:fe7d:d8c7])
        by smtp.gmail.com with ESMTPSA id a13sm362007pgt.58.2021.07.26.10.59.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 10:59:42 -0700 (PDT)
Subject: Re: [PATCH -next] scsi: ufs: fix build warning without CONFIG_PM
To:     YueHaibing <yuehaibing@huawei.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210611130601.34336-1-yuehaibing@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <99c99d97-5849-cf40-709b-aebe53b80ce3@acm.org>
Date:   Mon, 26 Jul 2021 10:59:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210611130601.34336-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/11/21 6:06 AM, YueHaibing wrote:
> drivers/scsi/ufs/ufshcd.c:9770:12: warning: ‘ufshcd_rpmb_resume’ defined but not used [-Wunused-function]
>   static int ufshcd_rpmb_resume(struct device *dev)
>              ^~~~~~~~~~~~~~~~~~
> drivers/scsi/ufs/ufshcd.c:9037:12: warning: ‘ufshcd_wl_runtime_resume’ defined but not used [-Wunused-function]
>   static int ufshcd_wl_runtime_resume(struct device *dev)
>              ^~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/ufs/ufshcd.c:9017:12: warning: ‘ufshcd_wl_runtime_suspend’ defined but not used [-Wunused-function]
>   static int ufshcd_wl_runtime_suspend(struct device *dev)
>              ^~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Move it into #ifdef block to fix this.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b87ff68aa9aa..0c54589e186a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8926,6 +8926,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   	return ret;
>   }
>   
> +#ifdef CONFIG_PM_SLEEP
>   static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   {
>   	int ret;
> @@ -9053,7 +9054,6 @@ static int ufshcd_wl_runtime_resume(struct device *dev)
>   	return ret;
>   }
>   
> -#ifdef CONFIG_PM_SLEEP
>   static int ufshcd_wl_suspend(struct device *dev)
>   {
>   	struct scsi_device *sdev = to_scsi_device(dev);
> @@ -9766,6 +9766,7 @@ static inline int ufshcd_clear_rpmb_uac(struct ufs_hba *hba)
>   	return ret;
>   }
>   
> +#ifdef CONFIG_PM_SLEEP
>   static int ufshcd_rpmb_resume(struct device *dev)
>   {
>   	struct ufs_hba *hba = wlun_dev_to_hba(dev);
> @@ -9774,6 +9775,7 @@ static int ufshcd_rpmb_resume(struct device *dev)
>   		ufshcd_clear_rpmb_uac(hba);
>   	return 0;
>   }
> +#endif
>   
>   static const struct dev_pm_ops ufs_rpmb_pm_ops = {
>   	SET_RUNTIME_PM_OPS(NULL, ufshcd_rpmb_resume, NULL)

Hi YueHaibing,

Can you take a look at 
https://lore.kernel.org/linux-scsi/20210722033439.26550-1-bvanassche@acm.org/T/#m6e7a02fc79634b5b77cfb77849253ac41d021389? 
I let the kernel robot verify that patch before I posted it on the 
linux-scsi mailing list.

Thanks,

Bart.
