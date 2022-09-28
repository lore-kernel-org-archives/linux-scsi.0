Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FF0C32771
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 16:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbiI1Qrx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 12:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbiI1Qrw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 12:47:52 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEB071737
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 09:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664383671; x=1695919671;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0k4ata89o8XSPrW5DrYMuU2Om5bPSJSie0h0k/DIHJI=;
  b=kefzlsgQXLBSnLvjybUpc+35eu3hupaxK+r6o5/OHN4nEqdVpIqzPaAf
   +TulcEsEU7lIE5qBCHLDqNKXoYp7SrJBa+yWX5YjMF3KlG2JdvCJRdtuI
   2jG9skchIowX2stmG+mLlF8HWUNRZSyDpOKdtdZc2vmhSBlJrodMM4R0C
   5X7oRfI/53SbAlD640sLzIfjuB1ozul4eoB5GgJvdzvUbjcfjm2q9uOeT
   VyRjS5almM8Cy/RyUSnfdiDAeA3m5RZkgtZl97l4NGKgIAV/tN8m9dKyL
   w6Kmqh3L7HhAmUmAQgwLz4lXHGU68uDmZc/AiV/CkXerF9NLSqxwUSrD2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="303138162"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="303138162"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 09:47:35 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="599647488"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="599647488"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.61.24])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 09:47:32 -0700
Message-ID: <9272d8ad-75b5-e521-c77c-24c72112e832@intel.com>
Date:   Wed, 28 Sep 2022 19:47:26 +0300
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220927184309.2223322-9-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/09/22 21:43, Bart Van Assche wrote:
> The following deadlock has been observed on multiple test setups:
> * ufshcd_wl_suspend() is waiting for blk_execute_rq() to complete while it
>   holds host_sem.
> * ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and the
>   latter function tries to obtain host_sem.
> This is a deadlock because blk_execute_rq() can't execute SCSI commands
> while the host is in the SHOST_RECOVERY state and because the error
> handler cannot make progress either.
> 
> Fix this deadlock as follows:
> * Fail attempts to suspend the system while the SCSI error handler is in
>   progress.
> * If the system is suspending and a START STOP UNIT command times out,
>   handle the SCSI command timeout from inside the context of the SCSI
>   timeout handler instead of activating the SCSI error handler.
> * Reduce the START STOP UNIT command timeout to one second since on
>   Android devices a kernel panic is triggered if an attempt to suspend
>   the system takes more than 20 seconds. One second should be enough for
>   the START STOP UNIT command since this command completes in less than
>   a millisecond for the UFS devices I have access to.
> 
> The runtime power management code is not affected by this deadlock since
> hba->host_sem is not touched by the runtime power management functions
> in the UFS driver.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 51 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5507d93a4bba..010a5d1b984b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8295,6 +8295,54 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>  	}
>  }
>  
> +static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
> +{
> +	struct ufs_hba *hba = shost_priv(scmd->device->host);
> +	bool reset_controller = false;
> +	int tag, ret;
> +
> +	if (!hba->system_suspending) {
> +		/* Activate the error handler in the SCSI core. */
> +		return SCSI_EH_NOT_HANDLED;
> +	}
> +
> +	/*
> +	 * Handle errors directly to prevent a deadlock between
> +	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
> +	 */
> +	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
> +		ret = ufshcd_try_to_abort_task(hba, tag);
> +		dev_info(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
> +			 hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
> +			 ret == 0 ? "succeeded" : "failed");
> +		if (ret != 0) {
> +			reset_controller = true;
> +			break;
> +		}
> +	}
> +	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
> +		ret = ufshcd_clear_tm_cmd(hba, tag);
> +		dev_info(hba->dev, "Aborting TMF %d %s\n", tag,
> +			 ret == 0 ? "succeeded" : "failed");
> +		if (ret != 0) {
> +			reset_controller = true;
> +			break;
> +		}
> +	}
> +	if (reset_controller) {
> +		dev_info(hba->dev, "Resetting controller\n");
> +		ufshcd_reset_and_restore(hba);
> +		if (ufshcd_clear_cmds(hba, 0xffffffff))
> +			dev_err(hba->dev,
> +				"Clearing outstanding commands failed\n");
> +	}
> +	ufshcd_complete_requests(hba);
> +	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
> +		 __func__, hba->outstanding_tasks);

Would it be possible to reuse the existing error handler rather
than creating a mini version?

> +
> +	return hba->outstanding_tasks ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
> +}
> +
>  static const struct attribute_group *ufshcd_driver_groups[] = {
>  	&ufs_sysfs_unit_descriptor_group,
>  	&ufs_sysfs_lun_attributes_group,
> @@ -8329,6 +8377,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>  	.eh_abort_handler	= ufshcd_abort,
>  	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
>  	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
> +	.eh_timed_out		= ufshcd_eh_timed_out,
>  	.this_id		= -1,
>  	.sg_tablesize		= SG_ALL,
>  	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
> @@ -8783,7 +8832,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>  	 */
>  	for (retries = 3; retries > 0; --retries) {
>  		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> -				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
> +				   1 * HZ, 0, REQ_FAILFAST_DEV, RQF_PM, NULL);
>  		if (ret < 0)
>  			break;
>  		if (host_byte(ret) == 0 && scsi_status_is_good(ret))

