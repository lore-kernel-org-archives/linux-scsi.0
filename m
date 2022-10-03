Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7871EC4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 06:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJCGSv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 02:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJCGSp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 02:18:45 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5970D3EA50
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2022 23:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664777924; x=1696313924;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8+UrxgbBAwFZ+aUEm8aLW505MXitJNSzWbUa5kfRqtQ=;
  b=cZmIZYvWKehQODIM5K0SVqh9voJnBCNDsQnvteHqxMCBQMGirJEu+zlJ
   RzcUQmHL7cn3oLWPXkudE9Ycc+RrIALdLjDlaEUTY8ETJ3ttl4jvaVNdu
   p3l77NFPV91W7REtufINhQ2FTewz5ZRVI+emnffE+RhOkAXCuEYxL8AaV
   Vg2C9iume/n71lPeu7QV36H7h/t0CJr1taGIVILikdaAa4NKnNMjNkwEg
   PRIFsx5XtUCZCdV8VBKpATnmLPRsRjrYDPbFQpBKnLC7mXnEyYTrlS1Wg
   qICTi1+wNsEwew/ApFaEH+Kay+YOJmJqVJ7BXonNAvxXDcm/mWAZpk/PQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="285692927"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="285692927"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 23:18:43 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10488"; a="618623127"
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="618623127"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.60.77])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 23:18:41 -0700
Message-ID: <888e39e3-4c0e-2fcb-aee8-39ae2ace0da1@intel.com>
Date:   Mon, 3 Oct 2022 09:18:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v3 8/8] scsi: ufs: Fix a deadlock between PM and the SCSI
 error handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-9-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220929220021.247097-9-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/09/22 01:00, Bart Van Assche wrote:
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

Comment below.  Nevertheless,

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5507d93a4bba..0294b51e776a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8295,6 +8295,26 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>  	}
>  }
>  
> +static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
> +{
> +	struct ufs_hba *hba = shost_priv(scmd->device->host);
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
> +	ufshcd_link_recovery(hba);

This is OK for now, but ufshcd_link_recovery() doesn't check for errors
*after* reset, and retry error handling - in which case it might need also
the error handling that ufshcd_err_handler() does.

It might be better to have only 1 error handling function.

> +	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
> +		 __func__, hba->outstanding_tasks);
> +
> +	return hba->outstanding_tasks ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
> +}
> +
>  static const struct attribute_group *ufshcd_driver_groups[] = {
>  	&ufs_sysfs_unit_descriptor_group,
>  	&ufs_sysfs_lun_attributes_group,
> @@ -8329,6 +8349,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>  	.eh_abort_handler	= ufshcd_abort,
>  	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
>  	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
> +	.eh_timed_out		= ufshcd_eh_timed_out,
>  	.this_id		= -1,
>  	.sg_tablesize		= SG_ALL,
>  	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
> @@ -8783,7 +8804,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>  	 */
>  	for (retries = 3; retries > 0; --retries) {
>  		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> -				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
> +				   1 * HZ, 0, REQ_FAILFAST_DEV, RQF_PM, NULL);
>  		if (ret < 0)
>  			break;
>  		if (host_byte(ret) == 0 && scsi_status_is_good(ret))

