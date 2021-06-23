Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8259EC48BC2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 21:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6562C61241
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 21:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhFWVW5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:22:57 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:37825 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWVW4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 17:22:56 -0400
Received: by mail-pf1-f176.google.com with SMTP id w71so3375681pfd.4;
        Wed, 23 Jun 2021 14:20:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RSI/JXZQicsqAJ2ORJ8fz8xv3YMbDQ+62b+V7553KxM=;
        b=uS3EBc82Z8ISqXP1eFa2FiBQrRSs7YOm5mN5nbwTPebNbql33pF+pt+b8/Q87qgs73
         q7bh7rJHuVkJyYozjl5M307oHyEHzfACFfAdAhlffKcIFdlhZx/SreVuAAtUnWIQVNsR
         EO1mOO/Ng0HSkxXcM4gnbgxxgtVYdhWXe/oJSujEg3tmDwS+zMX8qRm3rc6PzY+To40d
         fd8WUEUZmrkeHO19ZPRUqySUUjJWs2gBXoWzzW5ugIZcp9ESstQGArmhWpx4tvoAejGn
         NfM0KQoJhwCuBebjmZCwKUY1rRfJdKMLjIPZ22UeyZUiZAVXAS2nzdxM8bA5EH9QuKKi
         RKgQ==
X-Gm-Message-State: AOAM531JGpJ5l4k+7f1SF15TnVP77qS/HNWH7rlEKO/AsQp/ErPdLWSg
        MASlTJ342kBwkIUhkvV5mtDcxeYFc6k=
X-Google-Smtp-Source: ABdhPJzxaqIhTRzzt2ENNN0NuOAOQEOOBfd7hvkjpL4CtkE1VzY4MlibYhJDflVkE5AY6LuwvNtQsA==
X-Received: by 2002:a63:ff4b:: with SMTP id s11mr1370190pgk.436.1624483237602;
        Wed, 23 Jun 2021 14:20:37 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id o12sm41109pgq.83.2021.06.23.14.20.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:20:36 -0700 (PDT)
Subject: Re: [PATCH v4 04/10] scsi: ufs: Enable IRQ after enabling clocks in
 error handling preparation
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-5-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6883ba75-be7c-96a2-9c33-62a244a15f6e@acm.org>
Date:   Wed, 23 Jun 2021 14:20:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624433711-9339-5-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/21 12:35 AM, Can Guo wrote:
> In error handling preparation, enable IRQ after enabling clocks in case
> unclocked register access happens.
> 
> Fixes: c72e79c0ad2bd ("scsi: ufs: Recover HBA runtime PM error in error handler")
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ee70522..5f837c4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5927,13 +5927,14 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>  		 * can be OFF or in LPM.
>  		 */
>  		ufshcd_setup_hba_vreg(hba, true);
> -		ufshcd_enable_irq(hba);
>  		ufshcd_setup_vreg(hba, true);
>  		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
>  		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq2);
>  		ufshcd_hold(hba, false);
> -		if (!ufshcd_is_clkgating_allowed(hba))
> +		if (!ufshcd_is_clkgating_allowed(hba)) {
>  			ufshcd_setup_clocks(hba, true);
> +			ufshcd_enable_irq(hba);
> +		}
>  		ufshcd_release(hba);
>  		pm_op = hba->is_wlu_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
>  		ufshcd_vops_resume(hba, pm_op);

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
