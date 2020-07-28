Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED99C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 05:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78D5F20792
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 05:33:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="cvO/AjHC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgG1Fd2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 01:33:28 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:56178 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgG1Fd2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Jul 2020 01:33:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595914406; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=lymWLJxYr7t7/cGd4UgmusHXnyuA797Hs5zPZ3Avdps=;
 b=cvO/AjHCFKLfb/Mu9Q3gayYryIKdVbuJkbNX0C/rd3IVQG62Tbnb4c8mr5wGfX49TvPxTTSM
 J0L2XorYqxm1ck0m8RhSv9H9aB4uUnMMUlXIKiF6TFfrQZeD+IEC3nod0aZXwLY3gLpwix37
 QxiUvzXU7E31b59wa167Tq/q4cM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n13.prod.us-west-2.postgun.com with SMTP id
 5f1fb878845c4d05a36db691 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 28 Jul 2020 05:32:40
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B813CC43391; Tue, 28 Jul 2020 05:32:40 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hongwus)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5F723C433C6;
        Tue, 28 Jul 2020 05:32:39 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 28 Jul 2020 13:32:39 +0800
From:   hongwus@codeaurora.org
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, sh425.lee@samsung.com,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
Subject: Re: [PATCH v7 4/8] scsi: ufs: Add some debug infos to
 ufshcd_print_host_state
In-Reply-To: <1595912460-8860-5-git-send-email-cang@codeaurora.org>
References: <1595912460-8860-1-git-send-email-cang@codeaurora.org>
 <1595912460-8860-5-git-send-email-cang@codeaurora.org>
Message-ID: <444570ffdd0f34dcf83f7fe49593e601@codeaurora.org>
X-Sender: hongwus@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-28 13:00, Can Guo wrote:
> The infos of the last interrupt status and its timestamp are very 
> helpful
> when debug system stability issues, e.g. IRQ starvation, so add them to
> ufshcd_print_host_state. Meanwhile, UFS device infos like model name 
> and
> its FW version also come in handy during debug. In addition, this 
> change
> makes cleanup to some prints in ufshcd_print_host_regs as similar 
> prints
> are already available in ufshcd_print_host_state.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 31 ++++++++++++++++++-------------
>  drivers/scsi/ufs/ufshcd.h |  5 +++++
>  2 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 99bd3e4..eda4dc6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -411,15 +411,6 @@ static void ufshcd_print_err_hist(struct ufs_hba 
> *hba,
>  static void ufshcd_print_host_regs(struct ufs_hba *hba)
>  {
>  	ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
> -	dev_err(hba->dev, "hba->ufs_version = 0x%x, hba->capabilities = 
> 0x%x\n",
> -		hba->ufs_version, hba->capabilities);
> -	dev_err(hba->dev,
> -		"hba->outstanding_reqs = 0x%x, hba->outstanding_tasks = 0x%x\n",
> -		(u32)hba->outstanding_reqs, (u32)hba->outstanding_tasks);
> -	dev_err(hba->dev,
> -		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt = %d\n",
> -		ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
> -		hba->ufs_stats.hibern8_exit_cnt);
> 
>  	ufshcd_print_err_hist(hba, &hba->ufs_stats.pa_err, "pa_err");
>  	ufshcd_print_err_hist(hba, &hba->ufs_stats.dl_err, "dl_err");
> @@ -438,8 +429,6 @@ static void ufshcd_print_host_regs(struct ufs_hba 
> *hba)
>  	ufshcd_print_err_hist(hba, &hba->ufs_stats.host_reset, "host_reset");
>  	ufshcd_print_err_hist(hba, &hba->ufs_stats.task_abort, "task_abort");
> 
> -	ufshcd_print_clk_freqs(hba);
> -
>  	ufshcd_vops_dbg_register_dump(hba);
>  }
> 
> @@ -499,6 +488,8 @@ static void ufshcd_print_tmrs(struct ufs_hba *hba,
> unsigned long bitmap)
> 
>  static void ufshcd_print_host_state(struct ufs_hba *hba)
>  {
> +	struct scsi_device *sdev_ufs = hba->sdev_ufs_device;
> +
>  	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
>  	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
>  		hba->outstanding_reqs, hba->outstanding_tasks);
> @@ -511,12 +502,24 @@ static void ufshcd_print_host_state(struct 
> ufs_hba *hba)
>  	dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
>  		hba->auto_bkops_enabled, hba->host->host_self_blocked);
>  	dev_err(hba->dev, "Clk gate=%d\n", hba->clk_gating.state);
> +	dev_err(hba->dev,
> +		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt=%d\n",
> +		ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
> +		hba->ufs_stats.hibern8_exit_cnt);
> +	dev_err(hba->dev, "last intr at %lld us, last intr status=0x%x\n",
> +		ktime_to_us(hba->ufs_stats.last_intr_ts),
> +		hba->ufs_stats.last_intr_status);
>  	dev_err(hba->dev, "error handling flags=0x%x, req. abort count=%d\n",
>  		hba->eh_flags, hba->req_abort_count);
> -	dev_err(hba->dev, "Host capabilities=0x%x, caps=0x%x\n",
> -		hba->capabilities, hba->caps);
> +	dev_err(hba->dev, "hba->ufs_version=0x%x, Host capabilities=0x%x,
> caps=0x%x\n",
> +		hba->ufs_version, hba->capabilities, hba->caps);
>  	dev_err(hba->dev, "quirks=0x%x, dev. quirks=0x%x\n", hba->quirks,
>  		hba->dev_quirks);
> +	if (sdev_ufs)
> +		dev_err(hba->dev, "UFS dev info: %.8s %.16s rev %.4s\n",
> +			sdev_ufs->vendor, sdev_ufs->model, sdev_ufs->rev);
> +
> +	ufshcd_print_clk_freqs(hba);
>  }
> 
>  /**
> @@ -5951,6 +5954,8 @@ static irqreturn_t ufshcd_intr(int irq, void 
> *__hba)
> 
>  	spin_lock(hba->host->host_lock);
>  	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> +	hba->ufs_stats.last_intr_status = intr_status;
> +	hba->ufs_stats.last_intr_ts = ktime_get();
> 
>  	/*
>  	 * There could be max of hba->nutrs reqs in flight and in worst case
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 656c069..5b2cdaf 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -406,6 +406,8 @@ struct ufs_err_reg_hist {
> 
>  /**
>   * struct ufs_stats - keeps usage/err statistics
> + * @last_intr_status: record the last interrupt status.
> + * @last_intr_ts: record the last interrupt timestamp.
>   * @hibern8_exit_cnt: Counter to keep track of number of exits,
>   *		reset this after link-startup.
>   * @last_hibern8_exit_tstamp: Set time after the hibern8 exit.
> @@ -425,6 +427,9 @@ struct ufs_err_reg_hist {
>   * @tsk_abort: tracks task abort events
>   */
>  struct ufs_stats {
> +	u32 last_intr_status;
> +	ktime_t last_intr_ts;
> +
>  	u32 hibern8_exit_cnt;
>  	ktime_t last_hibern8_exit_tstamp;

Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
