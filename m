Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22441FA3741
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 18:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiJaSv0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 14:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiJaSvM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 14:51:12 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F2E13EAF
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 11:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667242271; x=1698778271;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PA5fyMqNL5/ac9cHotmIiHx2+YF92ulPlNxl6VHoWE0=;
  b=X4lO1s1K+ixtFTSl81uhzUiseVQQu8+JkSdDyl9lWWuQCLd2xtSMwjCH
   za+T7H62NI72N+OySJfHO/saK2v2bu3ErTNO+EwlHBqb83UyPNAt1eULc
   TA2B1vlc8/9rtk8CItRbY1FgVv6KI7299MUeBZWQIFecbeAEjrGd8yeek
   tUKGlXM71VSESuu+zJ1yFYw071vhGVV9wIH3sC4vp8OhosWEAf6w8QaBS
   eV3RlAw7DWYK5I0x/2//bc4L9+meO+lqG/Li+/VKKcYzQF7P7tnyfTnQR
   1vUQqoTYKeBDs/m3Ld7x82bVcE23bMGcgnay7GUrvId23FkxXhZVc2tcL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="292271314"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="292271314"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 11:51:10 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="878838171"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="878838171"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.47.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 11:51:07 -0700
Message-ID: <1183b01f-63a8-5854-6c94-1b62c32cc280@intel.com>
Date:   Mon, 31 Oct 2022 20:51:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH v2] scsi: ufs: Introduce ufshcd_abort_all()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20221031183433.2443554-1-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20221031183433.2443554-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/10/22 20:34, Bart Van Assche wrote:
> Move the code for aborting all SCSI commands and TMFs into a new function.
> This patch makes the ufshcd_err_handler() easier to read. Except for adding
> more logging, this patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> 
> Changes compared to v1:
> - changed type of 'tag' and 'ret' from 'unsigned int' into 'int'.
> 
>  drivers/ufs/core/ufshcd.c | 62 +++++++++++++++++++++------------------
>  1 file changed, 34 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b81a218f5644..d91e1f31c66f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6159,6 +6159,38 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
>  	return false;
>  }
>  
> +static bool ufshcd_abort_all(struct ufs_hba *hba)
> +{
> +	bool needs_reset = false;
> +	int tag, ret;
> +
> +	/* Clear pending transfer requests */
> +	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
> +		ret = ufshcd_try_to_abort_task(hba, tag);
> +		dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
> +			hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
> +			ret ? "failed" : "succeeded");
> +		if (ret) {
> +			needs_reset = true;
> +			goto out;
> +		}
> +	}
> +
> +	/* Clear pending task management requests */
> +	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
> +		if (ufshcd_clear_tm_cmd(hba, tag)) {
> +			needs_reset = true;
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	/* Complete the requests that are cleared by s/w */
> +	ufshcd_complete_requests(hba);
> +
> +	return needs_reset;
> +}
> +
>  /**
>   * ufshcd_err_handler - handle UFS errors that require s/w attention
>   * @work: pointer to work structure
> @@ -6170,10 +6202,7 @@ static void ufshcd_err_handler(struct work_struct *work)
>  	unsigned long flags;
>  	bool needs_restore;
>  	bool needs_reset;
> -	bool err_xfer;
> -	bool err_tm;
>  	int pmc_err;
> -	int tag;
>  
>  	hba = container_of(work, struct ufs_hba, eh_work);
>  
> @@ -6202,8 +6231,6 @@ static void ufshcd_err_handler(struct work_struct *work)
>  again:
>  	needs_restore = false;
>  	needs_reset = false;
> -	err_xfer = false;
> -	err_tm = false;
>  
>  	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
>  		hba->ufshcd_state = UFSHCD_STATE_RESET;
> @@ -6272,34 +6299,13 @@ static void ufshcd_err_handler(struct work_struct *work)
>  	hba->silence_err_logs = true;
>  	/* release lock as clear command might sleep */
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> -	/* Clear pending transfer requests */
> -	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
> -		if (ufshcd_try_to_abort_task(hba, tag)) {
> -			err_xfer = true;
> -			goto lock_skip_pending_xfer_clear;
> -		}
> -		dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
> -			hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
> -	}
>  
> -	/* Clear pending task management requests */
> -	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
> -		if (ufshcd_clear_tm_cmd(hba, tag)) {
> -			err_tm = true;
> -			goto lock_skip_pending_xfer_clear;
> -		}
> -	}
> -
> -lock_skip_pending_xfer_clear:
> -	/* Complete the requests that are cleared by s/w */
> -	ufshcd_complete_requests(hba);
> +	needs_reset = ufshcd_abort_all(hba);
>  
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	hba->silence_err_logs = false;
> -	if (err_xfer || err_tm) {
> -		needs_reset = true;
> +	if (needs_reset)
>  		goto do_reset;
> -	}
>  
>  	/*
>  	 * After all reqs and tasks are cleared from doorbell,

