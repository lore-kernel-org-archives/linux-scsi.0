Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22FF0C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 03:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C42E664D99
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 03:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbhA2DXc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 22:23:32 -0500
Received: from mail-pl1-f170.google.com ([209.85.214.170]:33229 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhA2DX3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 22:23:29 -0500
Received: by mail-pl1-f170.google.com with SMTP id d13so4512060plg.0;
        Thu, 28 Jan 2021 19:23:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d94CRsJCQF1Y+h4BwfepQS4bBLgA5tdBUPODOebZJXY=;
        b=Ndqlidps0iDgeyGOc4WTnnUIuJIxRCgYtWFKSHMS5460jJupV58XmdBn5nRhb8V7Hu
         CtVdjEOSVjj2P0lVUQMnF9Vp46klK6wLzybgnhfn9c736rc3iq+yG5xv1sgMUlpuSkW8
         o35JA2RLNPMqxAfJE4Gs4a7mUYlg0RogOsX19LVqkgZGAwvI34C1ihU+6Y4vl0Z59oPz
         i8HT4XJCY+FvWTadHs80tzZJ3TPVynvwVDqs/kGPfXjRA9yp+sOobzpfiPB5djoCzyHR
         Mc9700TGujquw2i7OFRYRAzBkbkWDWdG4BmQtG0WDQkTaoKYUFUYoPW7R9plGj1F3Wk3
         qSdg==
X-Gm-Message-State: AOAM5325p24f4QMygXqK1ow6Gg4PmT1w0VIXnpdpKsQxcpQvLVnvtJxY
        zptCObP2r0Zt8/FmY+neMc2x0/+5W0M=
X-Google-Smtp-Source: ABdhPJw2q8V9P6x7IvUoTpmGbj2YHPoKEJiU5wpZDCVpkFTEZpm6WOiIYNEtZLW/JIDwTtH/hayVRQ==
X-Received: by 2002:a17:902:854b:b029:db:c725:edcd with SMTP id d11-20020a170902854bb02900dbc725edcdmr2207634plo.64.1611890567837;
        Thu, 28 Jan 2021 19:22:47 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:fd12:a590:9797:4acb? ([2601:647:4000:d7:fd12:a590:9797:4acb])
        by smtp.gmail.com with ESMTPSA id z18sm7006201pfj.102.2021.01.28.19.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:22:47 -0800 (PST)
Subject: Re: [PATCH v3 1/3] scsi: ufs: Fix task management request completion
 timeout
To:     Can Guo <cang@codeaurora.org>, jaegeuk@kernel.org,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
 <1611807365-35513-2-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b73ad496-1658-d587-146a-138ac8f522a9@acm.org>
Date:   Thu, 28 Jan 2021 19:22:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611807365-35513-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/21 8:16 PM, Can Guo wrote:
> ufshcd_tmc_handler() calls blk_mq_tagset_busy_iter(fn = ufshcd_compl_tm()),
> but since blk_mq_tagset_busy_iter() only iterates over all reserved tags
> and requests which are not in IDLE state, ufshcd_compl_tm() never gets a
> chance to run. Thus, TMR always ends up with completion timeout. Fix it by
> calling blk_mq_start_request() in  __ufshcd_issue_tm_cmd().
> 
> Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs")
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8da75e6..c0c5925 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6395,6 +6395,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>  
>  	spin_lock_irqsave(host->host_lock, flags);
>  	task_tag = hba->nutrs + free_slot;
> +	blk_mq_start_request(req);
>  
>  	treq->req_header.dword_0 |= cpu_to_be32(task_tag);

blk_mq_start_request() not only marks a request as in-flight but also
starts a timer. However, no timeout handler has been defined in
ufshcd_tmf_ops. Should a timeout handler be defined in that data structure?

Thanks,

Bart.
