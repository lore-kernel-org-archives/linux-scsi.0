Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A979C07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 19:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7196B61361
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 19:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbhGMTIy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 15:08:54 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:45918 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhGMTIy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 15:08:54 -0400
Received: by mail-pf1-f175.google.com with SMTP id q10so20462917pfj.12;
        Tue, 13 Jul 2021 12:06:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kgHbFRM6VxIszRNHG24rOOolVqPqE99AJsomwCHAvw4=;
        b=olYePmT+CQzsBl7v7ne5RP75vBVs9TmjcbdUN0D2XGZpK3Biodn7IELR48vz8zcXF/
         2GhqRIfha44u69cftVy1Xp3lG/G/DcKmOYk0VzdqlqDhIOwoS23AvrISwFGXnPLVhG/B
         iOn0w/nqcMRPAWv1XWeVMhx9MJU73AoBQQQZZwyNVCgKVuWnULHUV+fZWhaK9oScBhev
         uO8NIvOTqtQ1Cq+02Qo6RniP3Y5VEm1zy01PabWevdZyFoC1E6zXU7beBcAn9oZHGLbC
         Hf8aNL56SYV/M0i6dB6Xeu3xhJruy0mHScl9uldfdZxXSFckt7A2/I3HJZvs8gmmS6Y/
         cLDg==
X-Gm-Message-State: AOAM533K69TLICB6Xl6Fser60iugABv9YW/4f3uiw8MOoD3ZfuXutFEG
        Ae/N0sUOOrmqiM4Oz1jiWq0=
X-Google-Smtp-Source: ABdhPJwvZzMg4JmP6ENsw3Ml8oqQbHHZvM0sTVIBvj95aMws5HsAiZK9SNelACo8vuwhKIRPKw3uvQ==
X-Received: by 2002:a62:dd83:0:b029:2e8:e511:c32f with SMTP id w125-20020a62dd830000b02902e8e511c32fmr6100366pff.49.1626203163497;
        Tue, 13 Jul 2021 12:06:03 -0700 (PDT)
Received: from ?IPv6:2620:0:1000:2004:d6d0:1357:913a:795c? ([2620:0:1000:2004:d6d0:1357:913a:795c])
        by smtp.gmail.com with ESMTPSA id l8sm3092432pjc.17.2021.07.13.12.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 12:06:02 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: add missing host_lock in setup_xfer_req
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20210701005117.3846179-1-jaegeuk@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <38432018-e8bf-f9f3-00bf-cd4b81c95c88@acm.org>
Date:   Tue, 13 Jul 2021 12:06:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701005117.3846179-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/21 5:51 PM, Jaegeuk Kim wrote:
> This patch adds a host_lock which existed before on ufshcd_vops_setup_xfer_req.
> 
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Fixes: a45f937110fa ("scsi: ufs: Optimize host lock on transfer requests send/compl paths")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>   drivers/scsi/ufs/ufshcd.h | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index c98d540ac044..194755c9ddfe 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1229,8 +1229,13 @@ static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
>   static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
>   					bool is_scsi_cmd)
>   {
> -	if (hba->vops && hba->vops->setup_xfer_req)
> -		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
> +	if (hba->vops && hba->vops->setup_xfer_req) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(hba->host->host_lock, flags);
> +		hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	}
>   }
>   
>   static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,

Can anyone help with reviewing this patch?

Thanks,

Bart.


