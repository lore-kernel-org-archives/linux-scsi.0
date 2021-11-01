Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDA5C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 09:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA5D361058
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 09:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhKAJT1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 05:19:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:36025 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230520AbhKAJT0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Nov 2021 05:19:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="231241499"
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="231241499"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 02:16:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,198,1631602800"; 
   d="scan'208";a="448892373"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga006.jf.intel.com with ESMTP; 01 Nov 2021 02:16:49 -0700
Subject: Re: [PATCH RFC] scsi: ufs-core: Do not use clk_scaling_lock in
 ufshcd_queuecommand()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org
References: <20211029133751.420015-1-adrian.hunter@intel.com>
 <24e21ff3-c992-c71e-70e3-e0c3926fbcda@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <c2d76154-b2ef-2e66-0a56-cd22ac8c652f@intel.com>
Date:   Mon, 1 Nov 2021 11:16:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <24e21ff3-c992-c71e-70e3-e0c3926fbcda@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/10/2021 19:31, Bart Van Assche wrote:
> On 10/29/21 6:37 AM, Adrian Hunter wrote:
>> Use flags and memory barriers instead of the clk_scaling_lock in
>> ufshcd_queuecommand().  This is done to prepare for potentially faster IOPS
>> in the future.
>>
>> On an x86 test system (Samsung Galaxy Book S), for random 4k reads this cut
>> the time of ufshcd_queuecommand() from about 690 ns to 460 ns.  With larger
>> I/O sizes, the increased duration of DMA mapping made the difference
>> increasingly negligible. Random 4k read IOPS was not affected, remaining at
>> about 97 kIOPS.
> 
> Hi Adrian,
> 
> That's an excellent performance improvement!
> 
> Earlier this week I looked into this myself and came up with a different
> approach. My patches add less new code. Please take a look at the patches
> below.
> 
> Thanks,
> 
> Bart.
> 
> 
> [PATCH 1/3] scsi: ufs: Do not block SCSI requests from the EE handler
> 
> It is not necessary to prevent ufshcd_queuecommand() calls while the EE
> handler is in progress. Additionally, calling ufshcd_scsi_block_requests()
> only prevents new ufshcd_queuecommand() calls and does not wait until
> existing calls have finished. Hence remove the ufshcd_scsi_block_requests()
> and ufshcd_scsi_unblock_requests() calls from the EE handler.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index bd0178b284f1..903750c836be 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5815,12 +5815,11 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
>      u32 status = 0;
>      hba = container_of(work, struct ufs_hba, eeh_work);
> 
> -    ufshcd_scsi_block_requests(hba);

I suspect that this was to facilitate the quick handling of urgent background ops,
so I am not sure it should be removed.

>      err = ufshcd_get_ee_status(hba, &status);
>      if (err) {
>          dev_err(hba->dev, "%s: failed to get exception status %d\n",
>                  __func__, err);
> -        goto out;
> +        return;
>      }
> 
>      trace_ufshcd_exception_event(dev_name(hba->dev), status);
> @@ -5832,8 +5831,6 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
>          ufshcd_temp_exception_event_handler(hba, status);
> 
>      ufs_debugfs_exception_event(hba, status);
> -out:
> -    ufshcd_scsi_unblock_requests(hba);
>  }
> 
>  /* Complete requests that have door-bell cleared */
> 
> 
> 
> Subject: [PATCH 2/3] scsi: ufs: Fix a race condition related to clock scaling
> 
> Calling ufshcd_scsi_block_requests() after ungate_work has been queued
> does not guarantee that SCSI requests are blocked before the clock ungating
> work starts. Fix this race condition by moving the
> ufshcd_scsi_block_requests() call into ufshcd_ungate_work().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 903750c836be..f35e7ab9054e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1624,6 +1624,8 @@ static void ufshcd_ungate_work(struct work_struct *work)
> 
>      cancel_delayed_work_sync(&hba->clk_gating.gate_work);
> 
> +    ufshcd_scsi_block_requests(hba);
> +
>      spin_lock_irqsave(hba->host->host_lock, flags);
>      if (hba->clk_gating.state == CLKS_ON) {
>          spin_unlock_irqrestore(hba->host->host_lock, flags);
> @@ -1714,9 +1716,8 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>          hba->clk_gating.state = REQ_CLKS_ON;
>          trace_ufshcd_clk_gating(dev_name(hba->dev),
>                      hba->clk_gating.state);
> -        if (queue_work(hba->clk_gating.clk_gating_workq,
> -                   &hba->clk_gating.ungate_work))
> -            ufshcd_scsi_block_requests(hba);
> +        queue_work(hba->clk_gating.clk_gating_workq,
> +               &hba->clk_gating.ungate_work);
>          /*
>           * fall through to check if we should wait for this
>           * work to be done or not.
> 
> 
> 
> Subject: [PATCH 3/3] scsi: ufs: Remove the clock scaling lock
> 
> Remove the clock scaling lock since it is a performance bottleneck for the
> hot path. Freeze request queues instead of calling scsi_block_requests()
> from inside ufshcd_clock_scaling_prepare(). Use synchronize_rcu() to
> wait for ongoing ufshcd_queuecommand() calls.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 146 ++++++++++----------------------------
>  drivers/scsi/ufs/ufshcd.h |   1 -
>  2 files changed, 38 insertions(+), 109 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f35e7ab9054e..1b694be807bd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1069,65 +1069,6 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
>      return false;
>  }
> 
> -static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
> -                    u64 wait_timeout_us)
> -{
> -    unsigned long flags;
> -    int ret = 0;
> -    u32 tm_doorbell;
> -    u32 tr_doorbell;
> -    bool timeout = false, do_last_check = false;
> -    ktime_t start;
> -
> -    ufshcd_hold(hba, false);
> -    spin_lock_irqsave(hba->host->host_lock, flags);
> -    /*
> -     * Wait for all the outstanding tasks/transfer requests.
> -     * Verify by checking the doorbell registers are clear.
> -     */
> -    start = ktime_get();
> -    do {
> -        if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
> -            ret = -EBUSY;
> -            goto out;
> -        }
> -
> -        tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> -        tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -        if (!tm_doorbell && !tr_doorbell) {
> -            timeout = false;
> -            break;
> -        } else if (do_last_check) {
> -            break;
> -        }
> -
> -        spin_unlock_irqrestore(hba->host->host_lock, flags);
> -        schedule();
> -        if (ktime_to_us(ktime_sub(ktime_get(), start)) >
> -            wait_timeout_us) {
> -            timeout = true;
> -            /*
> -             * We might have scheduled out for long time so make
> -             * sure to check if doorbells are cleared by this time
> -             * or not.
> -             */
> -            do_last_check = true;
> -        }
> -        spin_lock_irqsave(hba->host->host_lock, flags);
> -    } while (tm_doorbell || tr_doorbell);
> -
> -    if (timeout) {
> -        dev_err(hba->dev,
> -            "%s: timedout waiting for doorbell to clear (tm=0x%x, tr=0x%x)\n",
> -            __func__, tm_doorbell, tr_doorbell);
> -        ret = -EBUSY;
> -    }
> -out:
> -    spin_unlock_irqrestore(hba->host->host_lock, flags);
> -    ufshcd_release(hba);
> -    return ret;
> -}
> -
>  /**
>   * ufshcd_scale_gear - scale up/down UFS gear
>   * @hba: per adapter instance
> @@ -1175,20 +1116,22 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
> 
>  static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>  {
> -    #define DOORBELL_CLR_TOUT_US        (1000 * 1000) /* 1 sec */
>      int ret = 0;
> +
>      /*
> -     * make sure that there are no outstanding requests when
> -     * clock scaling is in progress
> +     * Make sure that there are no outstanding requests while clock scaling
> +     * is in progress. Since the error handler may submit TMFs, limit the
> +     * time during which to wait for the doorbell registers to clear in
> +     * order not to block the UFS error handler.
>       */
> -    ufshcd_scsi_block_requests(hba);
> -    down_write(&hba->clk_scaling_lock);
> -
> -    if (!hba->clk_scaling.is_allowed ||
> -        ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
> +    blk_freeze_queue_start(hba->cmd_queue);
> +    blk_freeze_queue_start(hba->tmf_queue);
> +    if (blk_mq_freeze_queue_wait_timeout(hba->cmd_queue, HZ) <= 0 ||
> +        blk_mq_freeze_queue_wait_timeout(hba->tmf_queue, HZ / 10) <= 0 ||
> +        !READ_ONCE(hba->clk_scaling.is_allowed)) {
>          ret = -EBUSY;
> -        up_write(&hba->clk_scaling_lock);
> -        ufshcd_scsi_unblock_requests(hba);
> +        blk_mq_unfreeze_queue(hba->tmf_queue);
> +        blk_mq_unfreeze_queue(hba->cmd_queue);
>          goto out;
>      }
> 
> @@ -1199,13 +1142,10 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>      return ret;
>  }
> 
> -static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
> +static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
>  {
> -    if (writelock)
> -        up_write(&hba->clk_scaling_lock);
> -    else
> -        up_read(&hba->clk_scaling_lock);
> -    ufshcd_scsi_unblock_requests(hba);
> +    blk_mq_unfreeze_queue(hba->tmf_queue);
> +    blk_mq_unfreeze_queue(hba->cmd_queue);
>      ufshcd_release(hba);
>  }
> 
> @@ -1220,8 +1160,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
>   */
>  static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
>  {
> -    int ret = 0;
> -    bool is_writelock = true;
> +    int ret;
> 
>      ret = ufshcd_clock_scaling_prepare(hba);
>      if (ret)
> @@ -1249,14 +1188,19 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
>              goto out_unprepare;
>          }
>      }
> -
> -    /* Enable Write Booster if we have scaled up else disable it */
> -    downgrade_write(&hba->clk_scaling_lock);
> -    is_writelock = false;
> +    ufshcd_scsi_block_requests(hba);
> +    ufshcd_clock_scaling_unprepare(hba);
> +    /*
> +     * Enable the Write Booster if we have scaled up else disable it.
> +     * ufshcd_wb_toggle() calls ufshcd_exec_dev_cmd() indirectly and hence
> +     * must be called after ufshcd_clock_scaling_unprepare().
> +     */
>      ufshcd_wb_toggle(hba, scale_up);
> +    ufshcd_scsi_unblock_requests(hba);
> +    return ret;
> 
>  out_unprepare:
> -    ufshcd_clock_scaling_unprepare(hba, is_writelock);
> +    ufshcd_clock_scaling_unprepare(hba);
>      return ret;
>  }
> 
> @@ -2696,9 +2640,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
> 
>      WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
> 
> -    if (!down_read_trylock(&hba->clk_scaling_lock))
> -        return SCSI_MLQUEUE_HOST_BUSY;
> -
>      switch (hba->ufshcd_state) {
>      case UFSHCD_STATE_OPERATIONAL:
>          break;
> @@ -2782,9 +2723,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>      }
> 
>      ufshcd_send_command(hba, tag);
> -out:
> -    up_read(&hba->clk_scaling_lock);
> 
> +out:
>      if (ufs_trigger_eh()) {
>          unsigned long flags;
> 
> @@ -2946,8 +2886,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>      int err;
>      int tag;
> 
> -    down_read(&hba->clk_scaling_lock);
> -
>      /*
>       * Get free slot, sleep if slots are unavailable.
>       * Even though we use wait_event() which sleeps indefinitely,
> @@ -2982,7 +2920,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>  out:
>      blk_put_request(req);
>  out_unlock:
> -    up_read(&hba->clk_scaling_lock);
>      return err;
>  }
> 
> @@ -5936,9 +5873,7 @@ void ufshcd_schedule_eh_work(struct ufs_hba *hba)
> 
>  static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
>  {
> -    down_write(&hba->clk_scaling_lock);
> -    hba->clk_scaling.is_allowed = allow;
> -    up_write(&hba->clk_scaling_lock);
> +    WRITE_ONCE(hba->clk_scaling.is_allowed, allow);
>  }
> 
>  static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
> @@ -5985,9 +5920,12 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>          ufshcd_clk_scaling_allow(hba, false);
>      }
>      ufshcd_scsi_block_requests(hba);
> -    /* Drain ufshcd_queuecommand() */
> -    down_write(&hba->clk_scaling_lock);
> -    up_write(&hba->clk_scaling_lock);
> +    /*
> +     * Drain ufshcd_queuecommand(). Since ufshcd_queuecommand() does not
> +     * sleep, calling synchronize_rcu() is sufficient to wait for ongoing
> +     * ufshcd_queuecommand calls.
> +     */
> +    synchronize_rcu();

This depends upon block layer internals, so it must be called via a block
layer function i.e. the block layer must guarantee this will always work.

Also, scsi_unjam_host() does not look like it uses RCU when issuing
requests.

>      cancel_work_sync(&hba->eeh_work);
>  }
> 
> @@ -6212,11 +6150,8 @@ static void ufshcd_err_handler(struct work_struct *work)
>       */
>      if (needs_restore) {
>          spin_unlock_irqrestore(hba->host->host_lock, flags);
> -        /*
> -         * Hold the scaling lock just in case dev cmds
> -         * are sent via bsg and/or sysfs.
> -         */
> -        down_write(&hba->clk_scaling_lock);
> +        /* Block TMF submission, e.g. through BSG or sysfs. */

What about dev cmds?

Also, there is the outstanding question of synchronization for the call to
ufshcd_reset_and_restore() further down.

> +        blk_mq_freeze_queue(hba->tmf_queue);
>          hba->force_pmc = true;
>          pmc_err = ufshcd_config_pwr_mode(hba, &(hba->pwr_info));
>          if (pmc_err) {
> @@ -6226,7 +6161,7 @@ static void ufshcd_err_handler(struct work_struct *work)
>          }
>          hba->force_pmc = false;
>          ufshcd_print_pwr_info(hba);
> -        up_write(&hba->clk_scaling_lock);
> +        blk_mq_unfreeze_queue(hba->tmf_queue);
>          spin_lock_irqsave(hba->host->host_lock, flags);
>      }
> 
> @@ -6725,8 +6660,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>      int tag;
>      u8 upiu_flags;
> 
> -    down_read(&hba->clk_scaling_lock);
> -
>      req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
>      if (IS_ERR(req)) {
>          err = PTR_ERR(req);
> @@ -6804,7 +6737,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
> 
>      blk_put_request(req);
>  out_unlock:
> -    up_read(&hba->clk_scaling_lock);
>      return err;
>  }
> 
> @@ -7982,7 +7914,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>              &hba->pwr_info,
>              sizeof(struct ufs_pa_layer_attr));
>          hba->clk_scaling.saved_pwr_info.is_valid = true;
> -        hba->clk_scaling.is_allowed = true;
> +        WRITE_ONCE(hba->clk_scaling.is_allowed, true);
> 
>          ret = ufshcd_devfreq_init(hba);
>          if (ret)
> @@ -9558,8 +9490,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>      /* Initialize mutex for exception event control */
>      mutex_init(&hba->ee_ctrl_mutex);
> 
> -    init_rwsem(&hba->clk_scaling_lock);
> -
>      ufshcd_init_clk_gating(hba);
> 
>      ufshcd_init_clk_scaling(hba);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 0820d409585a..5514528cca58 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -902,7 +902,6 @@ struct ufs_hba {
>      enum bkops_status urgent_bkops_lvl;
>      bool is_urgent_bkops_lvl_checked;
> 
> -    struct rw_semaphore clk_scaling_lock;
>      unsigned char desc_size[QUERY_DESC_IDN_MAX];
>      atomic_t scsi_block_reqs_cnt;
> 

