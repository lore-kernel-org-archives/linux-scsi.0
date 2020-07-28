Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A952BC433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 18:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DF4620825
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 18:02:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="R8mwcMOy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732123AbgG1SCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 14:02:08 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:10618 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732122AbgG1SCH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Jul 2020 14:02:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595959326; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=GEtDnRclLMMSGwFlOv36azGgB3IYarTZkST0DQ+XtC0=; b=R8mwcMOy1sz1+xjUOV6ddIvDPEk8uzylFYwxNDCbVMC5ecHHnyPoiauaqiiH33eUNNDCVabw
 k7sh5aqFV3dwuOiOALwuAvLBi2S5Lgsjs56r5qrjXA9oT/jmA5ZX5cKjbRBlB/3b6KTcZlRK
 MydFMcYjCWnhp1U/VWTAarOdXfc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5f20680749176bd3822fbef3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 28 Jul 2020 18:01:43
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5523DC4339C; Tue, 28 Jul 2020 18:01:43 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 40495C433C6;
        Tue, 28 Jul 2020 18:01:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 40495C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v7 4/8] scsi: ufs: Add some debug infos to
 ufshcd_print_host_state
To:     Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        sh425.lee@samsung.com, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1595912460-8860-1-git-send-email-cang@codeaurora.org>
 <1595912460-8860-5-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <f4425c57-921a-688c-c69e-9067647247fe@codeaurora.org>
Date:   Tue, 28 Jul 2020 11:01:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595912460-8860-5-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/27/2020 10:00 PM, Can Guo wrote:
> The infos of the last interrupt status and its timestamp are very helpful
> when debug system stability issues, e.g. IRQ starvation, so add them to
> ufshcd_print_host_state. Meanwhile, UFS device infos like model name and
> its FW version also come in handy during debug. In addition, this change
> makes cleanup to some prints in ufshcd_print_host_regs as similar prints
> are already available in ufshcd_print_host_state.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

> ---
>   drivers/scsi/ufs/ufshcd.c | 31 ++++++++++++++++++-------------
>   drivers/scsi/ufs/ufshcd.h |  5 +++++
>   2 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 99bd3e4..eda4dc6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -411,15 +411,6 @@ static void ufshcd_print_err_hist(struct ufs_hba *hba,
>   static void ufshcd_print_host_regs(struct ufs_hba *hba)
>   {
>   	ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
> -	dev_err(hba->dev, "hba->ufs_version = 0x%x, hba->capabilities = 0x%x\n",
> -		hba->ufs_version, hba->capabilities);
> -	dev_err(hba->dev,
> -		"hba->outstanding_reqs = 0x%x, hba->outstanding_tasks = 0x%x\n",
> -		(u32)hba->outstanding_reqs, (u32)hba->outstanding_tasks);
> -	dev_err(hba->dev,
> -		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt = %d\n",
> -		ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
> -		hba->ufs_stats.hibern8_exit_cnt);
>   
>   	ufshcd_print_err_hist(hba, &hba->ufs_stats.pa_err, "pa_err");
>   	ufshcd_print_err_hist(hba, &hba->ufs_stats.dl_err, "dl_err");
> @@ -438,8 +429,6 @@ static void ufshcd_print_host_regs(struct ufs_hba *hba)
>   	ufshcd_print_err_hist(hba, &hba->ufs_stats.host_reset, "host_reset");
>   	ufshcd_print_err_hist(hba, &hba->ufs_stats.task_abort, "task_abort");
>   
> -	ufshcd_print_clk_freqs(hba);
> -
>   	ufshcd_vops_dbg_register_dump(hba);
>   }
>   
> @@ -499,6 +488,8 @@ static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
>   
>   static void ufshcd_print_host_state(struct ufs_hba *hba)
>   {
> +	struct scsi_device *sdev_ufs = hba->sdev_ufs_device;
> +
>   	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
>   	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
>   		hba->outstanding_reqs, hba->outstanding_tasks);
> @@ -511,12 +502,24 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)
>   	dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
>   		hba->auto_bkops_enabled, hba->host->host_self_blocked);
>   	dev_err(hba->dev, "Clk gate=%d\n", hba->clk_gating.state);
> +	dev_err(hba->dev,
> +		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt=%d\n",
> +		ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
> +		hba->ufs_stats.hibern8_exit_cnt);
> +	dev_err(hba->dev, "last intr at %lld us, last intr status=0x%x\n",
> +		ktime_to_us(hba->ufs_stats.last_intr_ts),
> +		hba->ufs_stats.last_intr_status);
>   	dev_err(hba->dev, "error handling flags=0x%x, req. abort count=%d\n",
>   		hba->eh_flags, hba->req_abort_count);
> -	dev_err(hba->dev, "Host capabilities=0x%x, caps=0x%x\n",
> -		hba->capabilities, hba->caps);
> +	dev_err(hba->dev, "hba->ufs_version=0x%x, Host capabilities=0x%x, caps=0x%x\n",
> +		hba->ufs_version, hba->capabilities, hba->caps);
>   	dev_err(hba->dev, "quirks=0x%x, dev. quirks=0x%x\n", hba->quirks,
>   		hba->dev_quirks);
> +	if (sdev_ufs)
> +		dev_err(hba->dev, "UFS dev info: %.8s %.16s rev %.4s\n",
> +			sdev_ufs->vendor, sdev_ufs->model, sdev_ufs->rev);
> +
> +	ufshcd_print_clk_freqs(hba);
>   }
>   
>   /**
> @@ -5951,6 +5954,8 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
>   
>   	spin_lock(hba->host->host_lock);
>   	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> +	hba->ufs_stats.last_intr_status = intr_status;
> +	hba->ufs_stats.last_intr_ts = ktime_get();
>   
>   	/*
>   	 * There could be max of hba->nutrs reqs in flight and in worst case
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 656c069..5b2cdaf 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -406,6 +406,8 @@ struct ufs_err_reg_hist {
>   
>   /**
>    * struct ufs_stats - keeps usage/err statistics
> + * @last_intr_status: record the last interrupt status.
> + * @last_intr_ts: record the last interrupt timestamp.
>    * @hibern8_exit_cnt: Counter to keep track of number of exits,
>    *		reset this after link-startup.
>    * @last_hibern8_exit_tstamp: Set time after the hibern8 exit.
> @@ -425,6 +427,9 @@ struct ufs_err_reg_hist {
>    * @tsk_abort: tracks task abort events
>    */
>   struct ufs_stats {
> +	u32 last_intr_status;
> +	ktime_t last_intr_ts;
> +
>   	u32 hibern8_exit_cnt;
>   	ktime_t last_hibern8_exit_tstamp;
>   
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
