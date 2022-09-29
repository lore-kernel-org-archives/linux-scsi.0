Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E647C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 10:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbiI2K64 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 06:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbiI2K64 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 06:58:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB68D14979A
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 03:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664449134; x=1695985134;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dIx8BSYA/NGduBOGcMEu2PJaxGFR34cjqf/KzLFiCEY=;
  b=icMNRBI94tFw/9OHYhoIoFz8HKJ0POHm35jgPUuxWMy/OavvF6OM68/H
   gxfzEeHW2ZYFpvQbdTZ/UiIPFnd2nvyVYGMv0ibxeWOGJir/n6PrNAgaa
   twn/kleSMKW+AB5S1legTO7+KHrZNX8yMQMKer+v6vivICPBwvnGQZXbr
   7n80uMzlf3ePY9WIJZQ1fX3MzNKwTE2Oeca97KBPcJT34ofi9smqZ/kGU
   J7w3XqqYm+7+pP2lIdbUM13RKh+K5c1BAeXKsmPXqFLdAWc/4VjtmP+43
   eZAbayhGInOaOYHZdC6sXHUR3pzcb8ZnGtujfUno4fJZb4xSCeThcF2jj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="365907413"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="365907413"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 03:58:53 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="726357474"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="726357474"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.37.6])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 03:58:51 -0700
Message-ID: <7199a60b-6442-4b15-8090-a0776b20bcc2@intel.com>
Date:   Thu, 29 Sep 2022 13:58:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v2 8/8] scsi: ufs: Fix a deadlock between PM and the SCSI
 error handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220927184309.2223322-1-bvanassche@acm.org>
 <20220927184309.2223322-9-bvanassche@acm.org>
 <9272d8ad-75b5-e521-c77c-24c72112e832@intel.com>
 <a5a7d6d4-ab9b-c69b-ace7-f6c41855e219@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <a5a7d6d4-ab9b-c69b-ace7-f6c41855e219@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/09/22 02:15, Bart Van Assche wrote:
> On 9/28/22 09:47, Adrian Hunter wrote:
>> On 27/09/22 21:43, Bart Van Assche wrote:
>>> +    ufshcd_complete_requests(hba);
>>> +    dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
>>> +         __func__, hba->outstanding_tasks);
>>
>> Would it be possible to reuse the existing error handler rather
>> than creating a mini version?
> 
> Hi Adrian,
> 
> How about replacing this patch with the two patches below?
> 
> Thanks,
> 
> Bart.
> 
> -------------------------------------------------------------------------
> 
> Subject: [PATCH] scsi: ufs: Introduce ufshcd_abort_all()
> 
> Move the code for aborting all SCSI commands and TMFs into a new
> function. The next patch in this series will introduce a new caller for
> that function.

This is a nice tidy-up in any case.  Definitely keep this patch.

> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 62 +++++++++++++++++++++------------------
>  1 file changed, 34 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5507d93a4bba..fa1022926ab7 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6201,6 +6201,38 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
>      return false;
>  }
> 
> +static bool ufshcd_abort_all(struct ufs_hba *hba)
> +{
> +    bool needs_reset = false;
> +    unsigned int tag, ret;
> +
> +    /* Clear pending transfer requests */
> +    for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
> +        ret = ufshcd_try_to_abort_task(hba, tag);
> +        dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
> +            hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
> +            ret ? "failed" : "succeeded");
> +        if (ret) {
> +            needs_reset = true;
> +            goto out;
> +        }
> +    }
> +
> +    /* Clear pending task management requests */
> +    for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
> +        if (ufshcd_clear_tm_cmd(hba, tag)) {
> +            needs_reset = true;
> +            goto out;
> +        }
> +    }
> +
> +out:
> +    /* Complete the requests that are cleared by s/w */
> +    ufshcd_complete_requests(hba);
> +
> +    return needs_reset;
> +}
> +
>  /**
>   * ufshcd_err_handler - handle UFS errors that require s/w attention
>   * @work: pointer to work structure
> @@ -6212,10 +6244,7 @@ static void ufshcd_err_handler(struct work_struct *work)
>      unsigned long flags;
>      bool needs_restore;
>      bool needs_reset;
> -    bool err_xfer;
> -    bool err_tm;
>      int pmc_err;
> -    int tag;
> 
>      hba = container_of(work, struct ufs_hba, eh_work);
> 
> @@ -6244,8 +6273,6 @@ static void ufshcd_err_handler(struct work_struct *work)
>  again:
>      needs_restore = false;
>      needs_reset = false;
> -    err_xfer = false;
> -    err_tm = false;
> 
>      if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
>          hba->ufshcd_state = UFSHCD_STATE_RESET;
> @@ -6314,34 +6341,13 @@ static void ufshcd_err_handler(struct work_struct *work)
>      hba->silence_err_logs = true;
>      /* release lock as clear command might sleep */
>      spin_unlock_irqrestore(hba->host->host_lock, flags);
> -    /* Clear pending transfer requests */
> -    for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
> -        if (ufshcd_try_to_abort_task(hba, tag)) {
> -            err_xfer = true;
> -            goto lock_skip_pending_xfer_clear;
> -        }
> -        dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
> -            hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
> -    }
> 
> -    /* Clear pending task management requests */
> -    for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
> -        if (ufshcd_clear_tm_cmd(hba, tag)) {
> -            err_tm = true;
> -            goto lock_skip_pending_xfer_clear;
> -        }
> -    }
> -
> -lock_skip_pending_xfer_clear:
> -    /* Complete the requests that are cleared by s/w */
> -    ufshcd_complete_requests(hba);
> +    needs_reset = ufshcd_abort_all(hba);
> 
>      spin_lock_irqsave(hba->host->host_lock, flags);
>      hba->silence_err_logs = false;
> -    if (err_xfer || err_tm) {
> -        needs_reset = true;
> +    if (needs_reset)
>          goto do_reset;
> -    }
> 
>      /*
>       * After all reqs and tasks are cleared from doorbell,
> 
> -------------------------------------------------------------------------
> 
> Subject: [PATCH] scsi: ufs: Fix a deadlock between PM and the SCSI error
>  handler
> 
> The following deadlock has been observed on multiple test setups:
> * ufshcd_wl_suspend() is waiting for blk_execute_rq() to complete while it
>   holds host_sem.
> * ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and the
>   latter function tries to obtain host_sem.
> This is a deadlock because blk_execute_rq() can't execute SCSI commands
> while the host is in the SHOST_RECOVERY state and because the error
> handler cannot make progress either.
> 
> Fix this deadlock as follows:
> * Fail attempts to suspend the system while the SCSI error handler is in
>   progress.
> * If the system is suspending and a START STOP UNIT command times out,
>   handle the SCSI command timeout from inside the context of the SCSI
>   timeout handler instead of activating the SCSI error handler.
> * Reduce the START STOP UNIT command timeout to one second since on
>   Android devices a kernel panic is triggered if an attempt to suspend
>   the system takes more than 20 seconds. One second should be enough for
>   the START STOP UNIT command since this command completes in less than
>   a millisecond for the UFS devices I have access to.
> 
> The runtime power management code is not affected by this deadlock since
> hba->host_sem is not touched by the runtime power management functions
> in the UFS driver.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index fa1022926ab7..2b6c1efea447 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8301,6 +8301,29 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>      }
>  }
> 
> +static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
> +{
> +    struct ufs_hba *hba = shost_priv(scmd->device->host);
> +
> +    if (!hba->system_suspending) {
> +        /* Activate the error handler in the SCSI core. */
> +        return SCSI_EH_NOT_HANDLED;
> +    }
> +
> +    /*
> +     * Handle errors directly to prevent a deadlock between
> +     * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
> +     */
> +    if (ufshcd_abort_all(hba)) {
> +        dev_info(hba->dev, "Resetting controller\n");
> +        ufshcd_reset_and_restore(hba);
> +    }

This is good, but it seems like it assumes there are no UIC errors etc
that need the other handling that ufshcd_err_handler() does.

> +    dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
> +         __func__, hba->outstanding_tasks);
> +
> +    return hba->outstanding_tasks ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
> +}
> +
>  static const struct attribute_group *ufshcd_driver_groups[] = {
>      &ufs_sysfs_unit_descriptor_group,
>      &ufs_sysfs_lun_attributes_group,
> @@ -8335,6 +8358,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>      .eh_abort_handler    = ufshcd_abort,
>      .eh_device_reset_handler = ufshcd_eh_device_reset_handler,
>      .eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
> +    .eh_timed_out        = ufshcd_eh_timed_out,
>      .this_id        = -1,
>      .sg_tablesize        = SG_ALL,
>      .cmd_per_lun        = UFSHCD_CMD_PER_LUN,
> @@ -8789,7 +8813,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>       */
>      for (retries = 3; retries > 0; --retries) {
>          ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> -                START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
> +                   1 * HZ, 0, REQ_FAILFAST_DEV, RQF_PM, NULL);
>          if (ret < 0)
>              break;
>          if (host_byte(ret) == 0 && scsi_status_is_good(ret))

