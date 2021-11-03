Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73020C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 520D660F10
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhKCQcU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:32:20 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:13719 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbhKCQcT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 12:32:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635956983; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=z1O1jp1OiYeZMciUuw3+un/DonbiHRCsNM29ww8uA10=; b=N4mah3TxY2stJFRZAYHRgfxi7fQ3iTM9y6sJEa31IitVi9hbYxp19yE/ce03ERGEsTfpUOsQ
 9iziPhkqwaflqejEehVeGUL+LnkRVlaKjpK5inF02Ec1uq+u4wnh0UqVl9ObL6UjWg8EMhE5
 2I20+53elVDXuvo4d/eb7wdXvak=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 6182b8f4c7e915356f3dc315 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 03 Nov 2021 16:29:40
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0E8E6C43460; Wed,  3 Nov 2021 16:29:40 +0000 (UTC)
Received: from [192.168.1.3] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7C9CFC4338F;
        Wed,  3 Nov 2021 16:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 7C9CFC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <49099972-8192-f7ed-167e-7f5dfc1450c2@codeaurora.org>
Date:   Wed, 3 Nov 2021 09:29:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC] scsi: ufs-core: Do not use clk_scaling_lock in
 ufshcd_queuecommand()
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org
References: <20211029133751.420015-1-adrian.hunter@intel.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <20211029133751.420015-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/29/2021 6:37 AM, Adrian Hunter wrote:
> Use flags and memory barriers instead of the clk_scaling_lock in
> ufshcd_queuecommand().  This is done to prepare for potentially faster IOPS
> in the future.
> 
> On an x86 test system (Samsung Galaxy Book S), for random 4k reads this cut
> the time of ufshcd_queuecommand() from about 690 ns to 460 ns.  With larger
> I/O sizes, the increased duration of DMA mapping made the difference
> increasingly negligible. Random 4k read IOPS was not affected, remaining at
> about 97 kIOPS.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---

Hi Adrian,

Thanks for the change.
I've validated clock scaling with this on a Qualcomm SoC.

-asd

>   drivers/scsi/ufs/ufshcd.c | 110 +++++++++++++++++++++++++++++++++++---
>   drivers/scsi/ufs/ufshcd.h |   4 ++
>   2 files changed, 106 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 115ea16f5a22..36536e11db78 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -294,6 +294,82 @@ static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
>   		scsi_block_requests(hba->host);
>   }
>   
> +static void ufshcd_check_issuing(struct ufs_hba *hba, unsigned long *issuing)
> +{
> +	int tag;
> +
> +	/*
> +	 * A memory barrier is needed to ensure changes to lrbp->issuing will be
> +	 * seen here.
> +	 */
> +	smp_rmb();
> +	for_each_set_bit(tag, issuing, hba->nutrs) {
> +		struct ufshcd_lrb *lrbp = &hba->lrb[tag];
> +
> +		if (!lrbp->issuing)
> +			__clear_bit(tag, issuing);
> +	}
> +}
> +
> +struct issuing {
> +	struct ufs_hba *hba;
> +	unsigned long issuing;
> +};
> +
> +static bool ufshcd_is_issuing(struct request *req, void *priv, bool reserved)
> +{
> +	int tag = req->tag;
> +	struct issuing *issuing = priv;
> +	struct ufshcd_lrb *lrbp = &issuing->hba->lrb[tag];
> +
> +	if (lrbp->issuing)
> +		__set_bit(tag, &issuing->issuing);
> +	return false;
> +}
> +
> +static void ufshcd_flush_queuecommand(struct ufs_hba *hba)
> +{
> +	struct request_queue *q = hba->cmd_queue;
> +	struct issuing issuing = { .hba = hba };
> +	int i;
> +
> +	/*
> +	 * Ensure any changes will be visible in ufshcd_queuecommand(), before
> +	 * finding requests that are currently in ufshcd_queuecommand(). Any
> +	 * requests not yet past the memory barrier in ufshcd_queuecommand()
> +	 * will therefore certainly see any changes that this task has made.
> +	 * Any requests that are past the memory barrier in
> +	 * ufshcd_queuecommand() will be found below, unless they are already
> +	 * exiting ufshcd_queuecommand().
> +	 */
> +	smp_mb();
> +
> +	/*
> +	 * Requests coming through ufshcd_queuecommand() will always have been
> +	 * "started", so blk_mq_tagset_busy_iter() will find them.
> +	 */
> +	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_is_issuing, &issuing);
> +
> +	/*
> +	 * Spin briefly, to wait for tasks currently executing
> +	 * ufshcd_queuecommand(), assuming ufshcd_queuecommand() typically takes
> +	 * less that 10 microseconds.
> +	 */
> +	for (i = 0; i < 10 && issuing.issuing; i++) {
> +		udelay(1);
> +		ufshcd_check_issuing(hba, &issuing.issuing);
> +	}
> +
> +	/*
> +	 * Anything still in ufshcd_queuecommand() presumably got preempted, so
> +	 * sleep while polling.
> +	 */
> +	while (issuing.issuing) {
> +		usleep_range(100, 500);
> +		ufshcd_check_issuing(hba, &issuing.issuing);
> +	}
> +}
> +
>   static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
>   				      enum ufs_trace_str_t str_t)
>   {
> @@ -1195,6 +1271,8 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>   	/* let's not get into low power until clock scaling is completed */
>   	ufshcd_hold(hba, false);
>   
> +	hba->clk_scaling.in_progress = true;
> +	ufshcd_flush_queuecommand(hba);
>   out:
>   	return ret;
>   }
> @@ -1205,6 +1283,9 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
>   		up_write(&hba->clk_scaling_lock);
>   	else
>   		up_read(&hba->clk_scaling_lock);
> +	/* Ensure writes are done before setting in_progress to false */
> +	smp_wmb();
> +	hba->clk_scaling.in_progress = false;
>   	ufshcd_scsi_unblock_requests(hba);
>   	ufshcd_release(hba);
>   }
> @@ -2111,7 +2192,11 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
>   	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>   	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
>   
> -	/* Make sure that doorbell is committed immediately */
> +	/*
> +	 * Make sure that doorbell is committed immediately.
> +	 * Also provides synchronization for ufshcd_queuecommand() wrt
> +	 * ufshcd_flush_queuecommand().
> +	 */
>   	wmb();
>   }
>   
> @@ -2695,8 +2780,15 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   
>   	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
>   
> -	if (!down_read_trylock(&hba->clk_scaling_lock))
> -		return SCSI_MLQUEUE_HOST_BUSY;
> +	lrbp = &hba->lrb[tag];
> +	lrbp->issuing = true;
> +	/* Synchronize with ufshcd_flush_queuecommand() */
> +	smp_mb();
> +
> +	if (unlikely(hba->clk_scaling.in_progress)) {
> +		err = SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	}
>   
>   	switch (hba->ufshcd_state) {
>   	case UFSHCD_STATE_OPERATIONAL:
> @@ -2751,7 +2843,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   	WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
>   		(hba->clk_gating.state != CLKS_ON));
>   
> -	lrbp = &hba->lrb[tag];
>   	WARN_ON(lrbp->cmd);
>   	lrbp->cmd = cmd;
>   	lrbp->sense_bufflen = UFS_SENSE_SIZE;
> @@ -2782,7 +2873,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   
>   	ufshcd_send_command(hba, tag);
>   out:
> -	up_read(&hba->clk_scaling_lock);
> +	/*
> +	 * Leverages wmb() in ufshcd_send_command() for synchronization with
> +	 * ufshcd_flush_queuecommand(), otherwise if no command was sent, then
> +	 * there is no need to synchronize anyway.
> +	 */
> +	lrbp->issuing = false;
>   
>   	if (ufs_trigger_eh()) {
>   		unsigned long flags;
> @@ -5987,9 +6083,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>   		ufshcd_clk_scaling_allow(hba, false);
>   	}
>   	ufshcd_scsi_block_requests(hba);
> -	/* Drain ufshcd_queuecommand() */
> -	down_write(&hba->clk_scaling_lock);
> -	up_write(&hba->clk_scaling_lock);
> +	ufshcd_flush_queuecommand(hba);
>   	cancel_work_sync(&hba->eeh_work);
>   }
>   
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index b9492f300bd1..46f385133aaa 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -188,6 +188,7 @@ struct ufs_pm_lvl_states {
>    * @task_tag: Task tag of the command
>    * @lun: LUN of the command
>    * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
> + * @issuing: Is in ufshcd_queuecommand()
>    * @issue_time_stamp: time stamp for debug purposes
>    * @compl_time_stamp: time stamp for statistics
>    * @crypto_key_slot: the key slot to use for inline crypto (-1 if none)
> @@ -214,6 +215,7 @@ struct ufshcd_lrb {
>   	int task_tag;
>   	u8 lun; /* UPIU LUN id field is only 8-bit wide */
>   	bool intr_cmd;
> +	bool issuing;
>   	ktime_t issue_time_stamp;
>   	ktime_t compl_time_stamp;
>   #ifdef CONFIG_SCSI_UFS_CRYPTO
> @@ -425,6 +427,7 @@ struct ufs_saved_pwr_info {
>    * @is_initialized: Indicates whether clock scaling is initialized or not
>    * @is_busy_started: tracks if busy period has started or not
>    * @is_suspended: tracks if devfreq is suspended or not
> + * @in_progress: clock_scaling is in progress
>    */
>   struct ufs_clk_scaling {
>   	int active_reqs;
> @@ -442,6 +445,7 @@ struct ufs_clk_scaling {
>   	bool is_initialized;
>   	bool is_busy_started;
>   	bool is_suspended;
> +	bool in_progress;
>   };
>   
>   #define UFS_EVENT_HIST_LENGTH 8
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
