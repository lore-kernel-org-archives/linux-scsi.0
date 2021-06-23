Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA891C48BC2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 21:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 804D061350
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 21:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFWVKo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:10:44 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:33782 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWVKn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 17:10:43 -0400
Received: by mail-pl1-f175.google.com with SMTP id f10so1840813plg.0;
        Wed, 23 Jun 2021 14:08:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gZwBdBLs++V9xhBPmC4GV0Qda84sztnFz2ba/5gwfkE=;
        b=VRL0AKyi0vRSWjaoDx9AV+a8tEwG4NX2PMZLeXLmUFSmA+PkXYVeJwMKsOpvZpmjG7
         IWQBdW0l4QkSEMYQ+8Yh2yStKh3y/ptfI5Gcg8ZSSY2EUtXrkV8iVLlOoVHFjvIipyq+
         DsRtMTMBDD0dBEt022Rahe2g6ctov98IxcVmopbziaqLuoKwED0NHpig30JVpEymfN/l
         xXefRy2UtWbm2/hZnPrf3YJVmnwyIbM/OJ4R8k+TqoJCNMYoQXC8X6Lp1KJq310GBCid
         VV+fJvzLKEKDaH+R/bUxWBuAfzrLhjMRYKLsx4sdXLSej9BHwfPoM4HYHBomz4ltc4QV
         9cfA==
X-Gm-Message-State: AOAM5333I+K8ObqVETivm4Ep3rAEtmuivgBmrhK5Ig/PBUNa7zqjmYoa
        VokuQCX/3NgVPc+khJQNS9yWqezxytI=
X-Google-Smtp-Source: ABdhPJxii+00hklQYX3DtNqvsT283hSS5BmiQecIdlMkoYIdNt05v5WIT760fBQWGkNL7aRZm9tXpQ==
X-Received: by 2002:a17:90b:2306:: with SMTP id mt6mr11846433pjb.71.1624482504794;
        Wed, 23 Jun 2021 14:08:24 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k35sm41869pgi.21.2021.06.23.14.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:08:23 -0700 (PDT)
Subject: Re: [PATCH v4 03/10] scsi: ufs: Update the return value of supplier
 pm ops
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
 <1624433711-9339-4-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <59b0c04a-298a-4eae-7938-8170835c00b7@acm.org>
Date:   Wed, 23 Jun 2021 14:08:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624433711-9339-4-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/21 12:35 AM, Can Guo wrote:
> rpm_get_suppliers() is returning an error only if the error is negative.
> However, ufshcd_wl_resume() may return a positive error code, e.g., when
> hibern8 or SSU cmd fails. Make the positive return value a negative error
> code so that consumers are aware of any resume failure from their supplier.
> Make the same change to ufshcd_wl_suspend() just to keep symmetry.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index abe5f2d..ee70522 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8922,7 +8922,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  		ufshcd_release(hba);
>  	}
>  	hba->wlu_pm_op_in_progress = false;
> -	return ret;
> +	return ret <= 0 ? ret : -EINVAL;
>  }
>  
>  static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
> @@ -9009,7 +9009,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  	hba->clk_gating.is_suspended = false;
>  	ufshcd_release(hba);
>  	hba->wlu_pm_op_in_progress = false;
> -	return ret;
> +	return ret <= 0 ? ret : -EINVAL;
>  }

I think the above patch shows that indicating failure by either
returning a positive or a negative value is a booby trap. Please modify
ufshcd_send_request_sense() and ufshcd_set_dev_pwr_mode() such that
these return a value that is either zero or negative. Are there any
other functions than that need to be modified?

Thanks,

Bart.
