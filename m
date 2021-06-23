Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE5AC4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 08:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1D176100B
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 08:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhFWIL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 04:11:26 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:46477 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbhFWILY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 04:11:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624435747; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=UlLykNknjknU1+G+VUC8eKaHj1amKYamz25Sx4ytiGE=;
 b=ixMf09jFxlRAxijaThqzDAVMLKVgjs0BIpY91065xv0RtKakuHtwdJdssMtjhZ2KrNLDSF0r
 VnUHNAXU7xT/l+raRcbnTIiztJUpfuKLhIxmvW54ljph/UDTA5jZsNXTRfrUvpkqw5KwT2ii
 0VCHEt23UQXnjI85zBJ8wUxA6pY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60d2ec075e3e57240bb5907d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Jun 2021 08:08:39
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5CD30C4360C; Wed, 23 Jun 2021 08:08:38 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 04DF9C433D3;
        Wed, 23 Jun 2021 08:08:36 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 23 Jun 2021 16:08:36 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: Re: [PATCH RFC 4/4] ufs: Make host controller state change handling
 more systematic
In-Reply-To: <20210619005228.28569-5-bvanassche@acm.org>
References: <20210619005228.28569-1-bvanassche@acm.org>
 <20210619005228.28569-5-bvanassche@acm.org>
Message-ID: <f237403527eab4f180a3aabed2510d41@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-06-19 08:52, Bart Van Assche wrote:
> Introduce a function that reports whether or not a controller state 
> change
> is allowed instead of duplicating these checks in every context that
> changes the host controller state. This patch includes a behavior 
> change:
> ufshcd_link_recovery() no longer can change the host controller state 
> from
> UFSHCD_STATE_ERROR into UFSHCD_STATE_RESET.
> 
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 59 ++++++++++++++++++++++++---------------
>  1 file changed, 36 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c213daec20f7..a10c8ec28468 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4070,16 +4070,32 @@ static int ufshcd_uic_change_pwr_mode(struct
> ufs_hba *hba, u8 mode)
>  	return ret;
>  }
> 
> +static bool ufshcd_set_state(struct ufs_hba *hba, enum ufshcd_state 
> new_state)
> +{
> +	lockdep_assert_held(hba->host->host_lock);
> +
> +	if (old_state != UFSHCD_STATE_ERROR || new_state == 
> UFSHCD_STATE_ERROR)
> +		hba->ufshcd_state = new_state;
> +		return true;
> +	}
> +	return false;
> +}
> +
>  int ufshcd_link_recovery(struct ufs_hba *hba)
>  {
>  	int ret;
>  	unsigned long flags;
> +	bool proceed;
> 
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> -	hba->ufshcd_state = UFSHCD_STATE_RESET;
> -	ufshcd_set_eh_in_progress(hba);
> +	proceed = ufshcd_set_state(hba, UFSHCD_STATE_RESET);
> +	if (proceed)
> +		ufshcd_set_eh_in_progress(hba);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> 
> +	if (!proceed)
> +		return -EPERM;
> +
>  	/* Reset the attached device */
>  	ufshcd_device_reset(hba);
> 
> @@ -4087,7 +4103,7 @@ int ufshcd_link_recovery(struct ufs_hba *hba)

I want to remove this function since it is only used by ufs-mediatek.c
through ufshcd_vops_resume(). Althrough it does not race with error
handling as of now, by removing it we can reduce one more caller of
full reset. I will ask Stanley help comment on this.

> 
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	if (ret)
> -		hba->ufshcd_state = UFSHCD_STATE_ERROR;
> +		ufshcd_set_state(hba, UFSHCD_STATE_ERROR);
>  	ufshcd_clear_eh_in_progress(hba);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> 
> @@ -5856,15 +5872,17 @@ static inline bool
> ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
>  /* host lock must be held before calling this func */
>  static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
>  {
> -	/* handle fatal errors only when link is not in error state */
> -	if (hba->ufshcd_state != UFSHCD_STATE_ERROR) {
> -		if (hba->force_reset || ufshcd_is_link_broken(hba) ||
> -		    ufshcd_is_saved_err_fatal(hba))
> -			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
> -		else
> -			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
> +	bool proceed;
> +
> +	if (hba->force_reset || ufshcd_is_link_broken(hba) ||
> +	    ufshcd_is_saved_err_fatal(hba))
> +		proceed = ufshcd_set_state(hba,
> +					   UFSHCD_STATE_EH_SCHEDULED_FATAL);
> +	else
> +		proceed = ufshcd_set_state(hba,
> +					   UFSHCD_STATE_EH_SCHEDULED_NON_FATAL);
> +	if (proceed)
>  		queue_work(hba->eh_wq, &hba->eh_work);
> -	}
>  }
> 
>  static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
> @@ -6017,8 +6035,7 @@ static void ufshcd_err_handler(struct work_struct 
> *work)
>  	down(&hba->host_sem);
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	if (ufshcd_err_handling_should_stop(hba)) {
> -		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
> -			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
> +		ufshcd_set_state(hba, UFSHCD_STATE_OPERATIONAL);
>  		spin_unlock_irqrestore(hba->host->host_lock, flags);
>  		up(&hba->host_sem);
>  		return;
> @@ -6029,8 +6046,7 @@ static void ufshcd_err_handler(struct work_struct 
> *work)
>  	/* Complete requests that have door-bell cleared by h/w */
>  	ufshcd_complete_requests(hba);
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> -	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
> -		hba->ufshcd_state = UFSHCD_STATE_RESET;
> +	ufshcd_set_state(hba, UFSHCD_STATE_RESET);
>  	/*
>  	 * A full reset and restore might have happened after preparation
>  	 * is finished, double check whether we should stop.
> @@ -6163,8 +6179,7 @@ static void ufshcd_err_handler(struct work_struct 
> *work)
> 
>  skip_err_handling:
>  	if (!needs_reset) {
> -		if (hba->ufshcd_state == UFSHCD_STATE_RESET)
> -			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
> +		ufshcd_set_state(hba, UFSHCD_STATE_OPERATIONAL);
>  		if (hba->saved_err || hba->saved_uic_err)
>  			dev_err_ratelimited(hba->dev, "%s: exit: saved_err 0x%x 
> saved_uic_err 0x%x",
>  			    __func__, hba->saved_err, hba->saved_uic_err);
> @@ -7135,7 +7150,7 @@ static int ufshcd_reset_and_restore(struct 
> ufs_hba *hba)
>  	 */
>  	scsi_report_bus_reset(hba->host, 0);
>  	if (err) {
> -		hba->ufshcd_state = UFSHCD_STATE_ERROR;
> +		ufshcd_set_state(hba, UFSHCD_STATE_ERROR);
>  		hba->saved_err |= saved_err;
>  		hba->saved_uic_err |= saved_uic_err;
>  	}
> @@ -7951,7 +7966,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba,
> bool init_dev_params)
>  	unsigned long flags;
>  	ktime_t start = ktime_get();
> 
> -	hba->ufshcd_state = UFSHCD_STATE_RESET;
> +	ufshcd_set_state(hba, UFSHCD_STATE_RESET);

1. We don't hold host lock here, but ufshcd_set_state() is expecting it.

2. Here we need to override the state to RESET anyways even state is 
ERROR,
because in ufshcd_reset_and_restore(), ufshcd_probe_hba() can be called 
5
times (retries == 5, see below code snippet). Otherwise, say on the 2nd
retry of ufshcd_probe_hba(), even if ufshcd_probe_hba() pass through 
without
an error (ret == 0), the ufshcd_set_state() (down below) cannot set the
state back to OPERATIONAL.

7042 	do {
7043 		/* Reset the attached device */
7044 		ufshcd_vops_device_reset(hba);
7045
7046 		err = ufshcd_host_reset_and_restore(hba);
7047 	} while (err && --retries);

Thanks,

Can Guo.

> 
>  	ret = ufshcd_link_startup(hba);
>  	if (ret)
> @@ -8024,10 +8039,8 @@ static int ufshcd_probe_hba(struct ufs_hba
> *hba, bool init_dev_params)
> 
>  out:
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> -	if (ret)
> -		hba->ufshcd_state = UFSHCD_STATE_ERROR;
> -	else if (hba->ufshcd_state == UFSHCD_STATE_RESET)
> -		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
> +	ufshcd_set_state(hba, ret ? UFSHCD_STATE_ERROR :
> +			 UFSHCD_STATE_OPERATIONAL);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> 
>  	trace_ufshcd_init(dev_name(hba->dev), ret,
