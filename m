Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354ADC49EA7
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 08:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1659261C2E
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 08:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhF1IUC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 04:20:02 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:20830 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231698AbhF1IUB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Jun 2021 04:20:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624868256; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=fmq207BM31jsieJxptxBR/dPO/u1pLJLTsd/5LV//AU=;
 b=HNChJEftVPjIVtiMIW0ubbUUOKrg67b6D2WDaNWvuWL7YerpOFE10nbFDufWGM8zh3jrQy23
 1+4pKcBk1BQuhNmgaQA4k9PY1II1qb6BLkWZwWXKufBQIVvVpuHDpa4F0TDEgFmsdtZnbesf
 wbRWnV+ccdTDk3UwdhUXlVstvTc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60d985841938941955c7d61b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 28 Jun 2021 08:17:08
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0D323C43144; Mon, 28 Jun 2021 08:17:08 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 72831C433D3;
        Mon, 28 Jun 2021 08:17:05 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 28 Jun 2021 16:17:05 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] scsi: ufs: Remove host_sem used in
 suspend/resume
In-Reply-To: <7ba226fe-789c-bf20-076b-cc635530db42@acm.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-8-git-send-email-cang@codeaurora.org>
 <ed59d61a-6951-2acd-4f89-40f8dc5015e1@intel.com>
 <9105f328ee6ce916a7f01027b0d28332@codeaurora.org>
 <a87e5ca5-390f-8ca0-41bf-27cdc70e3316@intel.com>
 <1b351766a6e40d0df90b3adec964eb33@codeaurora.org>
 <a654d2ef-b333-1c56-42c6-3d69e9f44bd0@intel.com>
 <3970b015e444c1f1714c7e7bd4c44651@codeaurora.org>
 <7ba226fe-789c-bf20-076b-cc635530db42@acm.org>
Message-ID: <ea968eb95ef03ef16a420e7483680b75@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-06-25 01:11, Bart Van Assche wrote:
> On 6/23/21 11:31 PM, Can Guo wrote:
>> Using back host_sem in suspend_prepare()/resume_complete() won't have 
>> this
>> problem of deadlock, right?
> 
> Although that would solve the deadlock discussed in this email thread, 
> it
> wouldn't solve the issue of potential adverse interactions of the UFS 
> error
> handler and the SCSI error handler running concurrently.

I think I've explained it before, paste it here -

ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and flushes 
it,
so SCSI error handler and UFS error handler can safely run together.

> How about using the
> standard approach for invoking the UFS error handler instead of using a 
> custom
> mechanism, e.g. by using something like the (untested) patch below? 
> This
> approach guarantees that the UFS error handler is only activated after 
> all
> pending SCSI commands have failed or timed out and also guarantees that 
> no new
> SCSI commands will be queued while the UFS error handler is in progress 
> (see
> also scsi_host_queue_ready()).

Per my understanding, SCSI error handling is scsi cmd based, meaning it 
only
works when certain SCSI cmds failed and are added to shost->eh_cmd_q (by 
calling
scsi_eh_scmd_add(struct scsi_cmnd *scmd)).

scsi_schedule_eh() ->
   scsi_error_handler() ->
     scsi_unjam_host()

where scsi_unjam_host() may or may NOT invoke scsi_eh_ready_devs(),
and scsi_eh_ready_devs() invokes ufshcd_eh_host_reset_handler().

2140 static void scsi_unjam_host(struct Scsi_Host *shost)
2141 {
2142 	unsigned long flags;
2143 	LIST_HEAD(eh_work_q);
2144 	LIST_HEAD(eh_done_q);
2145
2146 	spin_lock_irqsave(shost->host_lock, flags);
2147 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
2148 	spin_unlock_irqrestore(shost->host_lock, flags);
...
2152 	if (!scsi_eh_get_sense(&eh_work_q, &eh_done_q))
2153 		scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
...

However, most UFS (UIC) errors happens during gear scaling, clk gating
and suspend/resume (due to power mode changes and/or hibern8 
enter/exit),
during which there is NO scsi cmds in UFS driver at all (because these
contexts start only when there is no ongoing data transactions). Thus,
scsi_unjam_host() won't even call scsi_eh_ready_devs() because
scsi_eh_get_sense() always returns TRUE in these cases (eh_work_q is 
empty).

Thanks,

Can Guo.

> 
> Thanks,
> 
> Bart.
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 0ac1e15ac914..c6303ea9e5db 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -17,6 +17,8 @@
>  #include <linux/blk-pm.h>
>  #include <linux/blkdev.h>
>  #include <scsi/scsi_driver.h>
> +#include <scsi/scsi_transport.h>
> +#include "../scsi_transport_api.h"
>  #include "ufshcd.h"
>  #include "ufs_quirks.h"
>  #include "unipro.h"
> @@ -233,7 +235,6 @@ static int ufshcd_scale_clks(struct ufs_hba *hba,
> bool scale_up);
>  static irqreturn_t ufshcd_intr(int irq, void *__hba);
>  static int ufshcd_change_power_mode(struct ufs_hba *hba,
>  			     struct ufs_pa_layer_attr *pwr_mode);
> -static void ufshcd_schedule_eh_work(struct ufs_hba *hba);
>  static int ufshcd_setup_hba_vreg(struct ufs_hba *hba, bool on);
>  static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
>  static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
> @@ -2697,26 +2698,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
> 
>  	switch (hba->ufshcd_state) {
>  	case UFSHCD_STATE_OPERATIONAL:
> -	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
>  		break;
> -	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
> -		/*
> -		 * pm_runtime_get_sync() is used at error handling preparation
> -		 * stage. If a scsi cmd, e.g. the SSU cmd, is sent from hba's
> -		 * PM ops, it can never be finished if we let SCSI layer keep
> -		 * retrying it, which gets err handler stuck forever. Neither
> -		 * can we let the scsi cmd pass through, because UFS is in bad
> -		 * state, the scsi cmd may eventually time out, which will get
> -		 * err handler blocked for too long. So, just fail the scsi cmd
> -		 * sent from PM ops, err handler can recover PM error anyways.
> -		 */
> -		if (hba->pm_op_in_progress) {
> -			hba->force_reset = true;
> -			set_host_byte(cmd, DID_BAD_TARGET);
> -			cmd->scsi_done(cmd);
> -			goto out;
> -		}
> -		fallthrough;
>  	case UFSHCD_STATE_RESET:
>  		err = SCSI_MLQUEUE_HOST_BUSY;
>  		goto out;
> @@ -3954,6 +3936,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba
> *hba, struct uic_command *cmd)
>  	u8 status;
>  	int ret;
>  	bool reenable_intr = false;
> +	bool schedule_eh = false;
> 
>  	mutex_lock(&hba->uic_cmd_mutex);
>  	init_completion(&uic_async_done);
> @@ -4021,10 +4004,12 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba
> *hba, struct uic_command *cmd)
>  		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
>  	if (ret) {
>  		ufshcd_set_link_broken(hba);
> -		ufshcd_schedule_eh_work(hba);
> +		schedule_eh = true;
>  	}
>  out_unlock:
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +	if (schedule_eh)
> +		scsi_schedule_eh(hba->host);
>  	mutex_unlock(&hba->uic_cmd_mutex);
> 
>  	return ret;
> @@ -4085,8 +4070,6 @@ static bool ufshcd_set_state(struct ufs_hba
> *hba, enum ufshcd_state new_state)
>  		}
>  		break;
>  	case UFSHCD_STATE_RESET:
> -	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
> -	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
>  		allowed = hba->ufshcd_state != UFSHCD_STATE_ERROR;
>  		break;
>  	case UFSHCD_STATE_ERROR:
> @@ -5886,22 +5869,6 @@ static inline bool
> ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
>  	       (hba->saved_err & (INT_FATAL_ERRORS | 
> UFSHCD_UIC_HIBERN8_MASK));
>  }
> 
> -/* host lock must be held before calling this func */
> -static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
> -{
> -	bool proceed;
> -
> -	if (hba->force_reset || ufshcd_is_link_broken(hba) ||
> -	    ufshcd_is_saved_err_fatal(hba))
> -		proceed = ufshcd_set_state(hba,
> -					   UFSHCD_STATE_EH_SCHEDULED_FATAL);
> -	else
> -		proceed = ufshcd_set_state(hba,
> -					   UFSHCD_STATE_EH_SCHEDULED_NON_FATAL);
> -	if (proceed)
> -		queue_work(hba->eh_wq, &hba->eh_work);
> -}
> -
>  static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
>  {
>  	down_write(&hba->clk_scaling_lock);
> @@ -5924,7 +5891,7 @@ static void ufshcd_clk_scaling_suspend(struct
> ufs_hba *hba, bool suspend)
> 
>  static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>  {
> -	ufshcd_rpm_get_sync(hba);
> +	pm_runtime_get_noresume(&hba->sdev_ufs_device->sdev_gendev);
>  	if (pm_runtime_status_suspended(&hba->sdev_ufs_device->sdev_gendev) 
> ||
>  	    hba->is_sys_suspended) {
>  		enum ufs_pm_op pm_op;
> @@ -6035,11 +6002,12 @@ static bool
> ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
> 
>  /**
>   * ufshcd_err_handler - handle UFS errors that require s/w attention
> - * @work: pointer to work structure
> + * @host: SCSI host pointer
>   */
> -static void ufshcd_err_handler(struct work_struct *work)
> +static void ufshcd_err_handler(struct Scsi_Host *host)
>  {
> -	struct ufs_hba *hba;
> +	struct ufs_hba *hba = shost_priv(host);
> +	struct completion *eh_compl = NULL;
>  	unsigned long flags;
>  	bool err_xfer = false;
>  	bool err_tm = false;
> @@ -6047,10 +6015,10 @@ static void ufshcd_err_handler(struct 
> work_struct *work)
>  	int tag;
>  	bool needs_reset = false, needs_restore = false;
> 
> -	hba = container_of(work, struct ufs_hba, eh_work);
> -
>  	down(&hba->host_sem);
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> +	/* Clear host_eh_scheduled which has been set by scsi_schedule_eh(). 
> */
> +	hba->host->host_eh_scheduled = 0;
>  	if (ufshcd_err_handling_should_stop(hba)) {
>  		ufshcd_set_state(hba, UFSHCD_STATE_OPERATIONAL);
>  		spin_unlock_irqrestore(hba->host->host_lock, flags);
> @@ -6202,9 +6170,12 @@ static void ufshcd_err_handler(struct 
> work_struct *work)
>  			    __func__, hba->saved_err, hba->saved_uic_err);
>  	}
>  	ufshcd_clear_eh_in_progress(hba);
> +	swap(hba->eh_compl, eh_compl);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  	ufshcd_err_handling_unprepare(hba);
>  	up(&hba->host_sem);
> +	if (eh_compl)
> +		complete(eh_compl);
>  }
> 
>  /**
> @@ -6361,7 +6332,6 @@ static irqreturn_t ufshcd_check_errors(struct
> ufs_hba *hba, u32 intr_status)
>  					 "host_regs: ");
>  			ufshcd_print_pwr_info(hba);
>  		}
> -		ufshcd_schedule_eh_work(hba);
>  		retval |= IRQ_HANDLED;
>  	}
>  	/*
> @@ -6373,6 +6343,8 @@ static irqreturn_t ufshcd_check_errors(struct
> ufs_hba *hba, u32 intr_status)
>  	hba->errors = 0;
>  	hba->uic_error = 0;
>  	spin_unlock(hba->host->host_lock);
> +	if (queue_eh_work)
> +		scsi_schedule_eh(hba->host);
>  	return retval;
>  }
> 
> @@ -7045,8 +7017,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		set_bit(tag, &hba->outstanding_reqs);
>  		spin_lock_irqsave(host->host_lock, flags);
>  		hba->force_reset = true;
> -		ufshcd_schedule_eh_work(hba);
>  		spin_unlock_irqrestore(host->host_lock, flags);
> +		scsi_schedule_eh(hba->host);
>  		goto out;
>  	}
> 
> @@ -7172,7 +7144,8 @@ static int ufshcd_reset_and_restore(struct 
> ufs_hba *hba)
>   */
>  static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
>  {
> -	int err = SUCCESS;
> +	DECLARE_COMPLETION_ONSTACK(eh_compl);
> +	int err = SUCCESS, res;
>  	unsigned long flags;
>  	struct ufs_hba *hba;
> 
> @@ -7180,11 +7153,15 @@ static int ufshcd_eh_host_reset_handler(struct
> scsi_cmnd *cmd)
> 
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	hba->force_reset = true;
> -	ufshcd_schedule_eh_work(hba);
> +	hba->eh_compl = &eh_compl;
>  	dev_err(hba->dev, "%s: reset in progress - 1\n", __func__);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> 
> -	flush_work(&hba->eh_work);
> +	scsi_schedule_eh(hba->host);
> +	res = wait_for_completion_interruptible_timeout(&eh_compl, 180 * HZ);
> +	WARN_ONCE(res <= 0,
> +		  "wait_for_completion_interruptible_timeout() returned %d",
> +		  res);
> 
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	if (hba->ufshcd_state == UFSHCD_STATE_ERROR)
> @@ -8511,8 +8488,6 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
>  	if (hba->is_powered) {
>  		ufshcd_exit_clk_scaling(hba);
>  		ufshcd_exit_clk_gating(hba);
> -		if (hba->eh_wq)
> -			destroy_workqueue(hba->eh_wq);
>  		ufs_debugfs_hba_exit(hba);
>  		ufshcd_variant_hba_exit(hba);
>  		ufshcd_setup_vreg(hba, false);
> @@ -9371,6 +9346,10 @@ static int ufshcd_set_dma_mask(struct ufs_hba 
> *hba)
>  	return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
>  }
> 
> +static struct scsi_transport_template ufshcd_transport_template = {
> +	.eh_strategy_handler = ufshcd_err_handler,
> +};
> +
>  /**
>   * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
>   * @dev: pointer to device handle
> @@ -9397,6 +9376,7 @@ int ufshcd_alloc_host(struct device *dev, struct
> ufs_hba **hba_handle)
>  		err = -ENOMEM;
>  		goto out_error;
>  	}
> +	host->transportt = &ufshcd_transport_template;
>  	hba = shost_priv(host);
>  	hba->host = host;
>  	hba->dev = dev;
> @@ -9434,7 +9414,6 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  	int err;
>  	struct Scsi_Host *host = hba->host;
>  	struct device *dev = hba->dev;
> -	char eh_wq_name[sizeof("ufs_eh_wq_00")];
> 
>  	if (!mmio_base) {
>  		dev_err(hba->dev,
> @@ -9488,17 +9467,6 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
> 
>  	hba->max_pwr_info.is_valid = false;
> 
> -	/* Initialize work queues */
> -	snprintf(eh_wq_name, sizeof(eh_wq_name), "ufs_eh_wq_%d",
> -		 hba->host->host_no);
> -	hba->eh_wq = create_singlethread_workqueue(eh_wq_name);
> -	if (!hba->eh_wq) {
> -		dev_err(hba->dev, "%s: failed to create eh workqueue\n",
> -				__func__);
> -		err = -ENOMEM;
> -		goto out_disable;
> -	}
> -	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
>  	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
> 
>  	sema_init(&hba->host_sem, 1);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index f2796ea25598..d4f7ab0171c6 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -482,18 +482,12 @@ struct ufs_stats {
>   *	processing.
>   * @UFSHCD_STATE_OPERATIONAL: The host controller is operational and
> can process
>   *	SCSI commands.
> - * @UFSHCD_STATE_EH_SCHEDULED_NON_FATAL: The error handler has been 
> scheduled.
> - *	SCSI commands may be submitted to the controller.
> - * @UFSHCD_STATE_EH_SCHEDULED_FATAL: The error handler has been 
> scheduled. Fail
> - *	newly submitted SCSI commands with error code DID_BAD_TARGET.
>   * @UFSHCD_STATE_ERROR: An unrecoverable error occurred, e.g. link 
> recovery
>   *	failed. Fail all SCSI commands with error code DID_ERROR.
>   */
>  enum ufshcd_state {
>  	UFSHCD_STATE_RESET,
>  	UFSHCD_STATE_OPERATIONAL,
> -	UFSHCD_STATE_EH_SCHEDULED_NON_FATAL,
> -	UFSHCD_STATE_EH_SCHEDULED_FATAL,
>  	UFSHCD_STATE_ERROR,
>  };
> 
> @@ -715,8 +709,7 @@ struct ufs_hba_monitor {
>   * @is_powered: flag to check if HBA is powered
>   * @shutting_down: flag to check if shutdown has been invoked
>   * @host_sem: semaphore used to serialize concurrent contexts
> - * @eh_wq: Workqueue that eh_work works on
> - * @eh_work: Worker to handle UFS errors that require s/w attention
> + * @eh_compl: Signaled by the UFS error handler after error handling 
> finished.
>   * @eeh_work: Worker to handle exception events
>   * @errors: HBA errors
>   * @uic_error: UFS interconnect layer error status
> @@ -817,9 +810,7 @@ struct ufs_hba {
>  	bool shutting_down;
>  	struct semaphore host_sem;
> 
> -	/* Work Queues */
> -	struct workqueue_struct *eh_wq;
> -	struct work_struct eh_work;
> +	struct completion *eh_compl;
>  	struct work_struct eeh_work;
> 
>  	/* HBA Errors */
