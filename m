Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F1BC54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 17:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiI0RGw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 13:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbiI0RGT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 13:06:19 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454331BE9B
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 10:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664298377; x=1695834377;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r4EVevV39DQJs/zilkxdms6R0TmpXWmd8MM/nCMA1HE=;
  b=K9zWYO2GnqTaLzkYBhHBgT7ALWfRa0g74huLco7j/UN2hCRQPDcUK6Ye
   nS1TP6wv3XsFfhRIt6xc/iUWg2wIIQRbI+6liwvaU4Q+poT7m6t3bissg
   uDmWK+IjFMHcq0cPRNeIj6Il00Z4lm+La90glGr8lLCs+LdA5vQXF2UAL
   1GBXB27rylhPJtWricY1SxXnQ7rmG7ZRwg+52dtJWNbEOdD4TnnjQNiQy
   bKn2lYEBtL4b+VQ+WiEH705FgwaR2dfknqHBgi/BXRROe/PCvpQlVI3Fn
   Z0oje+K8NVTKLAjcNubMP1LLHzJoiUjnPDeSckO7j6TzkhW/mkU/Ldsdm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="284498763"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="284498763"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 10:06:16 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="654800190"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="654800190"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.35.200])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 10:06:14 -0700
Message-ID: <a39f76f2-1415-1cc4-9de6-d9a4aaf93d9b@intel.com>
Date:   Tue, 27 Sep 2022 20:06:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 8/8] scsi: ufs: Fix deadlock between power management and
 error handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220923201138.2113123-1-bvanassche@acm.org>
 <20220923201138.2113123-9-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220923201138.2113123-9-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/09/22 23:11, Bart Van Assche wrote:
> The following deadlock has been observed on multiple test setups:
> * ufshcd_wl_suspend() is waiting for blk_execute_rq() to complete while it
>   holds host_sem.
> * ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and the
>   latter function tries to obtain host_sem.
> This is a deadlock because blk_execute_rq() can't execute SCSI commands
> while the host is in the SHOST_RECOVERY state and because the error
> handler cannot make progress either.
> 
> Fix this deadlock by calling the UFS error handler directly during system
> suspend instead of relying on the error handling mechanism in the SCSI
> core.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 43 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 40 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index abeb120b12eb..996641fc1176 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6405,9 +6405,19 @@ static void ufshcd_err_handler(struct work_struct *work)
>  {
>  	struct ufs_hba *hba = container_of(work, struct ufs_hba, eh_work);
>  
> -	down(&hba->host_sem);
> -	ufshcd_recover_link(hba);
> -	up(&hba->host_sem);
> +	/*
> +	 * Serialize suspend/resume and error handling because a deadlock
> +	 * occurs if the error handler runs concurrently with
> +	 * ufshcd_set_dev_pwr_mode().
> +	 */
> +	if (mutex_trylock(&system_transition_mutex)) {

This is effectively disabling the UFS driver's error handler work.
It would be better to add the ability to do that explicitly within
the UFS driver and avoid using system_transition_mutex.

> +		down(&hba->host_sem);
> +		ufshcd_recover_link(hba);
> +		up(&hba->host_sem);
> +		mutex_unlock(&system_transition_mutex);
> +	} else {
> +		pr_info("%s: suspend or resume is ongoing\n", __func__);
> +	}
>  }
>  
>  /**
> @@ -8298,6 +8308,25 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>  	}
>  }
>  
> +static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
> +{
> +	struct ufs_hba *hba = shost_priv(scmd->device->host);
> +
> +	if (!hba->system_suspending) {

Is a PM notifier needed - couldn't hba->system_suspending
have been set in ufshcd_wl_suspend() ?

Doesn't resume have the same issue ?

> +		/* Apply the SCSI core error handling strategy. */
> +		return SCSI_EH_NOT_HANDLED;
> +	}
> +
> +	/*
> +	 * Fail START STOP UNIT commands without activating the SCSI error
> +	 * handler to prevent a deadlock between ufshcd_set_dev_pwr_mode() and
> +	 * ufshcd_err_handler().
> +	 */
> +	set_host_byte(scmd, DID_TIME_OUT);
> +	scsi_done(scmd);
> +	return SCSI_EH_DONE;
> +}
> +
>  static const struct attribute_group *ufshcd_driver_groups[] = {
>  	&ufs_sysfs_unit_descriptor_group,
>  	&ufs_sysfs_lun_attributes_group,
> @@ -8332,6 +8361,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>  	.eh_abort_handler	= ufshcd_abort,
>  	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
>  	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
> +	.eh_timed_out		= ufshcd_eh_timed_out,
>  	.this_id		= -1,
>  	.sg_tablesize		= SG_ALL,
>  	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
> @@ -8791,6 +8821,13 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>  			break;
>  		if (host_byte(ret) == 0 && scsi_status_is_good(ret))
>  			break;
> +		/*
> +		 * Calling the error handler directly when suspending or
> +		 * resuming the system since the callers of this function hold
> +		 * hba->host_sem in that case.

Runtime PM doesn't hold host_sem

> +		 */
> +		if (host_byte(ret) != 0 && hba->system_suspending)
> +			ufshcd_recover_link(hba);
>  	}
>  	if (ret) {
>  		sdev_printk(KERN_WARNING, sdp,

