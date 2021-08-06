Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD35C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 16:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC44611BF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 16:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhHFQS4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 12:18:56 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:51817 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhHFQS4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 12:18:56 -0400
Received: by mail-pj1-f44.google.com with SMTP id mt6so17420764pjb.1;
        Fri, 06 Aug 2021 09:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p3rBRmOBkgd6cYXMqUy2mTW65ehnVEhVyBjfYiYZ49c=;
        b=Ft/+PAGqWzR2DZ64c2I6zN7s8steSiN8MItx/uu+C3SoEUnZ5IIvRSK14LFO0gvEI7
         E5Dwndt87kkbRr6J57LHznk8L6wEQSWn6OVmKZMEHiOmts1BzOLpmSMtQbEasbXjRKi8
         Ntut29aPLfKjqD4XqPBThlqyWUJNJjaW/IrvjwbLK60NqogvUCldPJUUvPrKsYyNMXzB
         P9O9SXNtKi2sirqzTiFa3SzirZMcQzZ3dzzdlNbS/WRldH5oBSF45N2OBRIvBsxuXXFB
         IzjjsJ+x63DymqDMvnJni7QcTuLt8poff+JWNIJtP8CjFize/ZKO0bytlavMFUpaPLkM
         CSzQ==
X-Gm-Message-State: AOAM533eVl9YsJ0erxZFA1rUe4K/ySGRzl2jfQt7k1iKiaK5NdUEwmMB
        dnudHJxWOxeqs5HFz0g/6DY=
X-Google-Smtp-Source: ABdhPJwoLOdnPbqUmpZuul8Jr7BM/T9TyjTdWuLdetvKuJVWryZR3HqO6KgNgiLOGQEHq5i5v9GFSQ==
X-Received: by 2002:aa7:8750:0:b029:3be:347:a0d with SMTP id g16-20020aa787500000b02903be03470a0dmr11102682pfo.25.1628266719954;
        Fri, 06 Aug 2021 09:18:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:1655:15af:599e:3de1])
        by smtp.gmail.com with ESMTPSA id 37sm11967610pgt.28.2021.08.06.09.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 09:18:39 -0700 (PDT)
Subject: Re: [RFC PATCH v1 1/2] scsi: ufs: introduce vendor isr
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
References: <cover.1628231581.git.kwmad.kim@samsung.com>
 <CGME20210806064924epcas2p4572538fd1fa7a73d8262737e38a9b537@epcas2p4.samsung.com>
 <0f6f2337e98f8a8a7dfae816bc001af28fa3a7be.1628231581.git.kwmad.kim@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9ed9f56c-d7a4-8e68-0968-da0eccb0b38d@acm.org>
Date:   Fri, 6 Aug 2021 09:18:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <0f6f2337e98f8a8a7dfae816bc001af28fa3a7be.1628231581.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/21 11:34 PM, Kiwoong Kim wrote:
> This patch is to activate some interrupt sources
> that aren't defined in UFSHCI specifications. Those
> purpose could be error handling, workaround or whatever.
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 10 ++++++++++
>   drivers/scsi/ufs/ufshcd.h |  8 ++++++++
>   2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 05495c34a2b7..f85a9b335e0b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6428,6 +6428,16 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
>   static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
>   {
>   	irqreturn_t retval = IRQ_NONE;
> +	int res = 0;
> +	unsigned long flags;
> +
> +	retval = ufshcd_vops_intr(hba, &res);
> +	if (res) {
> +		spin_lock_irqsave(hba->host->host_lock, flags);
> +		hba->force_reset = true;
> +		ufshcd_schedule_eh_work(hba);
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	}

How can a non-standard extension have error handling code in common 
code? Please move the code under if (res) into the vendor code.

>   	if (intr_status & UFSHCD_UIC_MASK)
>   		retval |= ufshcd_uic_cmd_compl(hba, intr_status);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 971cfabc4a1e..1ed0a911f864 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -356,6 +356,7 @@ struct ufs_hba_variant_ops {
>   			       const union ufs_crypto_cfg_entry *cfg, int slot);
>   	void	(*event_notify)(struct ufs_hba *hba,
>   				enum ufs_event_type evt, void *data);
> +	irqreturn_t	(*intr)(struct ufs_hba *hba, int *res);
>   };
>   
>   /* clock gating state  */
> @@ -1296,6 +1297,13 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
>   		hba->vops->config_scaling_param(hba, profile, data);
>   }
>   
> +static inline irqreturn_t ufshcd_vops_intr(struct ufs_hba *hba, int *res)
> +{
> +	if (hba->vops && hba->vops->intr)
> +		return hba->vops->intr(hba, res);
> +	return IRQ_NONE;
> +}
> +
>   extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];

So this code adds an indirect function call in the interrupt handler? 
This will have a negative impact on performance, especially on a kernel 
with security mitigations enabled. See also 
https://lwn.net/Articles/774743/.

Thanks,

Bart.
