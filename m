Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 183ABC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 16:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D543B221F2
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 16:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbhAAQFr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jan 2021 11:05:47 -0500
Received: from mail-pl1-f170.google.com ([209.85.214.170]:34069 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbhAAQFq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jan 2021 11:05:46 -0500
Received: by mail-pl1-f170.google.com with SMTP id t6so11230191plq.1;
        Fri, 01 Jan 2021 08:05:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C02k2lVQV4BY4JNeZeCIxYmhRctA7lTjARTl+uthnK4=;
        b=FMTTJYpLyPLE5w+DeL40lEngi7H6jgsZwrmAC4FlXeFDqIUpKZzBfj106cfQdLdtZN
         7i0IjgNHhY2njfAJ1DWGzNGYt8qPXRbsG4CsF/DzMzh7A+v3vrKQTPCnTYPGdhDZtEsB
         NABBbiTs6FiNWO5VUmtdtcupr7ltEEnH1rpGPJUa3q/qMWhN+KTH1csu6ClpaOI53xlu
         9lqcsgfInksnz44L7iCRTkQTpXn6Z/ywLv9JeL4CcQQBG1HuaHVjquTJ44BbHpXkqZFy
         U5VPA83sBOy+XWEA+/z50UegRHmaJkAfKabdEyoS3bmi8lOw9ZturnPJU9gSZNBI6Eo7
         H/hA==
X-Gm-Message-State: AOAM5305Nd6tKnEKtFDGHbZiutfwPwwr9vVZPX/6VFr7Fz/PG8vtL5+P
        TXV+v/7cFx8a3ZKsZuUB2ATnVajau4I=
X-Google-Smtp-Source: ABdhPJz4tP4UcpAY+7kHazDsyvutQznO68u3nakYQCZnitmwaJssTbyMK6LvJMIWHpZnlAfa8FyFew==
X-Received: by 2002:a17:902:b7c3:b029:da:76bc:2aa9 with SMTP id v3-20020a170902b7c3b02900da76bc2aa9mr62271011plz.21.1609517105100;
        Fri, 01 Jan 2021 08:05:05 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id js9sm17588351pjb.2.2021.01.01.08.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jan 2021 08:05:03 -0800 (PST)
Subject: Re: [PATCH v2 1/2] scsi: ufs: Fix a possible NULL pointer issue
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1609479893-8889-1-git-send-email-cang@codeaurora.org>
 <1609479893-8889-2-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7cff30c3-6df8-7b8c-0f5b-a95980b8f706@acm.org>
Date:   Fri, 1 Jan 2021 08:05:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1609479893-8889-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/31/20 9:44 PM, Can Guo wrote:
> During system resume/suspend, hba could be NULL. In this case, do not touch
> eh_sem.
> 
> Fixes: 88a92d6ae4fe ("scsi: ufs: Serialize eh_work with system PM events and async scan")
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e221add..34e2541 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8896,8 +8896,11 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
>  	int ret = 0;
>  	ktime_t start = ktime_get();
>  
> +	if (!hba)
> +		return 0;
> +
>  	down(&hba->eh_sem);
> -	if (!hba || !hba->is_powered)
> +	if (!hba->is_powered)
>  		return 0;
>  
>  	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
> @@ -8945,10 +8948,8 @@ int ufshcd_system_resume(struct ufs_hba *hba)
>  	int ret = 0;
>  	ktime_t start = ktime_get();
>  
> -	if (!hba) {
> -		up(&hba->eh_sem);
> +	if (!hba)
>  		return -EINVAL;
> -	}
>  
>  	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
>  		/*

Hi Can,

How can ufshcd_system_suspend() or ufshcd_system_resume() be called with a
NULL argument? In ufshcd_pci_probe() I see that pci_set_drvdata() is called
before pm_runtime_allow(). ufshcd_pci_remove() calls pm_runtime_forbid().

Thanks,

Bart.

