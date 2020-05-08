Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2B4C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 16:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62F08208CA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 16:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="jZpBM1WW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgEHQ15 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 12:27:57 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:31514 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726756AbgEHQ14 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 12:27:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588955275; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=qB2bS14fhdIt0BpwIyYHdF4S6yvPiSAFKy4qqwnKDFk=; b=jZpBM1WWDdkCw1QcD4CGlqWGOC3q/ElIzT+jJvZufI653xcUq8nHgL44KSWjbw4fhSwIQTiB
 YunU05/XyFP72XFryWCxi5G7SSdh1I/pEdrsbaBDP+bmKLs2RmWpCnwHbSTQehfRD2Hkq3GZ
 t5vJNDQ4YbjNeFmJ4mxxHZKhAPo=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb58889.7f33db8c1bc8-smtp-out-n02;
 Fri, 08 May 2020 16:27:53 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 185AAC4478C; Fri,  8 May 2020 16:27:53 +0000 (UTC)
Received: from [192.168.8.176] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 545E2C433D2;
        Fri,  8 May 2020 16:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 545E2C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH RFC] ufs: Make ufshcd_wait_for_register() sleep instead of
 busy-waiting
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
References: <20200507222750.19113-1-bvanassche@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <198a1467-09db-f846-e153-a9681ff15b71@codeaurora.org>
Date:   Fri, 8 May 2020 09:27:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507222750.19113-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/7/2020 3:27 PM, Bart Van Assche wrote:
> The ufshcd_wait_for_register() function either sleeps or spins until the
> specified register has reached the desired value. Busy-waiting is not
> only considered a bad practice but also has a bad impact on energy
> consumption. Always sleep instead of spinning by making sure that all
> ufshcd_wait_for_register() calls happen from a context where it is
> allowed to sleep. The only function call that has to be moved is the
> ufshcd_hba_stop() call in ufshcd_host_reset_and_restore().
> 
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>


>   drivers/scsi/ufs/ufshcd.c | 51 +++++++++++++++++++++------------------
>   drivers/scsi/ufs/ufshcd.h |  2 +-
>   2 files changed, 29 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index bf7caea2253b..72069d4faa1e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -563,21 +563,21 @@ void ufshcd_delay_us(unsigned long us, unsigned long tolerance)
>   }
>   EXPORT_SYMBOL_GPL(ufshcd_delay_us);
>   
> -/*
> +/**
>    * ufshcd_wait_for_register - wait for register value to change
> - * @hba - per-adapter interface
> - * @reg - mmio register offset
> - * @mask - mask to apply to read register value
> - * @val - wait condition
> - * @interval_us - polling interval in microsecs
> - * @timeout_ms - timeout in millisecs
> - * @can_sleep - perform sleep or just spin
> + * @hba: per-adapter interface
> + * @reg: mmio register offset
> + * @mask: mask to apply to the read register value
> + * @val: value to wait for
> + * @interval_us: polling interval in microseconds
> + * @timeout_ms: timeout in milliseconds
>    *
> - * Returns -ETIMEDOUT on error, zero on success
> + * Return:
> + * -ETIMEDOUT on error, zero on success.
>    */
>   int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
>   				u32 val, unsigned long interval_us,
> -				unsigned long timeout_ms, bool can_sleep)
> +				unsigned long timeout_ms)
>   {
>   	int err = 0;
>   	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
> @@ -586,10 +586,7 @@ int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
>   	val = val & mask;
>   
>   	while ((ufshcd_readl(hba, reg) & mask) != val) {
> -		if (can_sleep)
> -			usleep_range(interval_us, interval_us + 50);
> -		else
> -			udelay(interval_us);
> +		usleep_range(interval_us, interval_us + 50);
>   		if (time_after(jiffies, timeout)) {
>   			if ((ufshcd_readl(hba, reg) & mask) != val)
>   				err = -ETIMEDOUT;
> @@ -2589,7 +2586,7 @@ ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
>   	 */
>   	err = ufshcd_wait_for_register(hba,
>   			REG_UTP_TRANSFER_REQ_DOOR_BELL,
> -			mask, ~mask, 1000, 1000, true);
> +			mask, ~mask, 1000, 1000);
>   
>   	return err;
>   }
> @@ -4258,16 +4255,23 @@ EXPORT_SYMBOL_GPL(ufshcd_make_hba_operational);
>   /**
>    * ufshcd_hba_stop - Send controller to reset state
>    * @hba: per adapter instance
> - * @can_sleep: perform sleep or just spin
>    */
> -static inline void ufshcd_hba_stop(struct ufs_hba *hba, bool can_sleep)
> +static inline void ufshcd_hba_stop(struct ufs_hba *hba)
>   {
> +	unsigned long flags;
>   	int err;
>   
> +	/*
> +	 * Obtain the host lock to prevent that the controller is disabled
> +	 * while the UFS interrupt handler is active on another CPU.
> +	 */
> +	spin_lock_irqsave(hba->host->host_lock, flags);
>   	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
>   	err = ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE,
>   					CONTROLLER_ENABLE, CONTROLLER_DISABLE,
> -					10, 1, can_sleep);
> +					10, 1);
>   	if (err)
>   		dev_err(hba->dev, "%s: Controller disable failed\n", __func__);
>   }
> @@ -4288,7 +4292,7 @@ int ufshcd_hba_enable(struct ufs_hba *hba)
>   
>   	if (!ufshcd_is_hba_active(hba))
>   		/* change controller state to "reset state" */
> -		ufshcd_hba_stop(hba, true);
> +		ufshcd_hba_stop(hba);
>   
>   	/* UniPro link is disabled at this point */
>   	ufshcd_set_link_off(hba);
> @@ -5911,7 +5915,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
>   	/* poll for max. 1 sec to clear door bell register by h/w */
>   	err = ufshcd_wait_for_register(hba,
>   			REG_UTP_TASK_REQ_DOOR_BELL,
> -			mask, 0, 1000, 1000, true);
> +			mask, 0, 1000, 1000);
>   out:
>   	return err;
>   }
> @@ -6478,8 +6482,9 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>   	 * Stop the host controller and complete the requests
>   	 * cleared by h/w
>   	 */
> +	ufshcd_hba_stop(hba);
> +
>   	spin_lock_irqsave(hba->host->host_lock, flags);
> -	ufshcd_hba_stop(hba, false);
>   	hba->silence_err_logs = true;
>   	ufshcd_complete_requests(hba);
>   	hba->silence_err_logs = false;
> @@ -7986,7 +7991,7 @@ static int ufshcd_link_state_transition(struct ufs_hba *hba,
>   		 * Change controller state to "reset state" which
>   		 * should also put the link in off/reset state
>   		 */
> -		ufshcd_hba_stop(hba, true);
> +		ufshcd_hba_stop(hba);
>   		/*
>   		 * TODO: Check if we need any delay to make sure that
>   		 * controller is reset
> @@ -8545,7 +8550,7 @@ void ufshcd_remove(struct ufs_hba *hba)
>   	scsi_remove_host(hba->host);
>   	/* disable interrupts */
>   	ufshcd_disable_intr(hba, hba->intr_mask);
> -	ufshcd_hba_stop(hba, true);
> +	ufshcd_hba_stop(hba);
>   
>   	ufshcd_exit_clk_scaling(hba);
>   	ufshcd_exit_clk_gating(hba);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 733722840794..5c944530cde5 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -822,7 +822,7 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
>   void ufshcd_delay_us(unsigned long us, unsigned long tolerance);
>   int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
>   				u32 val, unsigned long interval_us,
> -				unsigned long timeout_ms, bool can_sleep);
> +				unsigned long timeout_ms);
>   void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba, struct clk *refclk);
>   void ufshcd_update_reg_hist(struct ufs_err_reg_hist *reg_hist,
>   			    u32 reg);
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
