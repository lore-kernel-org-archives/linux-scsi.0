Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664C0C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 20:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43A7A63241
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 20:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhKOUmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 15:42:42 -0500
Received: from mail-pj1-f41.google.com ([209.85.216.41]:34731 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348431AbhKOTwk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 14:52:40 -0500
Received: by mail-pj1-f41.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so490495pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 11:49:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vFKzuQlU2ExoKG36bibN1FnGyNO3yT/Oc3goa7vHiN8=;
        b=khZJZgyOz/bwBvfJVPO80hCX9/LRLBb/gtJKFy6sfs1izxrD2DXFfvabQG/wKjRDQz
         6jluGzZvPkCCRuy6dzrVwcU1o4xwtm5d00WLQP1XkWtwZQaxUFG/X3HscOrQ4QTShTaI
         ZutMYixKunD32yy1fYbb314XfNCRfyYl6qh6pCjtgg4NBBccL5E7FGZ49/BqFryaaw3U
         Asc7IczUwlvJNhMdx7kpdT0lPgL/nAZQJ3mRrn2JBBlvtyCEQ3lhr7yCyk0xPQd5yez/
         2iZrGJzqsxFSNIvr2UG2PP5uY2lwLH6EZ/Vbm8uUnaTb1mVux8HFsR4495tc3XmSJ1+I
         KhLg==
X-Gm-Message-State: AOAM530EIav/Wffy52NUePbApgDglRGAEjFksoXSo4Zl4hvxHJXzHTEt
        eqaP53w48g6P4uWS43SaaiM=
X-Google-Smtp-Source: ABdhPJymuIuJ56AkZaBpJS6NC3I8OklnJtNhtbZ1ojRWxKu86YizEaReWhp5MoEduuANO2WXrV9hvA==
X-Received: by 2002:a17:90b:33cf:: with SMTP id lk15mr1360061pjb.85.1637005784020;
        Mon, 15 Nov 2021 11:49:44 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c779:caf7:7b7f:3ecd])
        by smtp.gmail.com with ESMTPSA id m184sm12250356pga.61.2021.11.15.11.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 11:49:43 -0800 (PST)
Subject: Re: [PATCH v1] scsi: ufs: fix tm cmd timeout/ISR racing issue
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        jonathan.hsu@mediatek.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com, mikebi@micron.com
References: <20211111094939.14991-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <08cff383-d944-56f3-e61e-ad6fdf4bb885@acm.org>
Date:   Mon, 15 Nov 2021 11:49:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211111094939.14991-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/21 1:49 AM, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> When tmc 100 ms timeout and recevied tmc complete ISR concurrently,
> Bug happen because complete NULL poiner and KE.
> Fix this racing issue by check NULL and use host_lock protect.
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5c6a58a666d2..6821ceb6783e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6442,7 +6442,8 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
>   		struct request *req = hba->tmf_rqs[tag];
>   		struct completion *c = req->end_io_data;
>   
> -		complete(c);
> +		if (c)
> +			complete(c);
>   		ret = IRQ_HANDLED;
>   	}
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
> @@ -6597,7 +6598,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>   		 * Make sure that ufshcd_compl_tm() does not trigger a
>   		 * use-after-free.
>   		 */
> +		spin_lock_irqsave(hba->host->host_lock, flags);
>   		req->end_io_data = NULL;
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
>   		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_ERR);
>   		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
>   				__func__, tm_function);

Isn't this already addressed by Adrian Hunter's patches? See also
https://lore.kernel.org/linux-scsi/20211108064815.569494-1-adrian.hunter@intel.com/

Thanks,

Bart.


