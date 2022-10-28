Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837B9ECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Oct 2022 05:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJ1Fm6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Oct 2022 01:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiJ1Fm5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Oct 2022 01:42:57 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466E21B65F0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2022 22:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666935777; x=1698471777;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GdwkanKbAqFn033rTUyBqjVD+Ib+qXTFfFmxbpApEMw=;
  b=g+WIHDpAccAbnAsANGTWR8QMA8vgxFIDIQ34YW+9pJfvZAjqAfv8A+nO
   PnDL2DF0dYymhArX9PNKfbQqE20szsYF16Nfx5UK5RAAvy85lsqE4O+98
   r5qkyzNOz9QqTMmHJfGfqFAwHYfqpxoBQvabylWL9o/z3fgb+CkSsVhXB
   H1dCfgW2+vJ2HjxZ4bdYrTbCmQm72wmpnDPqVZCqW89m34PzbII9zwvMK
   Hisj7i3FbrkThdwuyWsNl0SRt3YpXZUKsaiNDpITRdfBtm+QX6ZgBXLHs
   ZqkiDMMdr+jMy0Q+l9BrXbKoVgLVt9omORNwIGoMzDNzoyghPuuN3Qigd
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="288811231"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="288811231"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 22:42:56 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="583814295"
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="583814295"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.55.74])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 22:42:54 -0700
Message-ID: <dafe263d-de70-5324-653c-b55d1a6b89fa@intel.com>
Date:   Fri, 28 Oct 2022 08:42:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH] scsi: ufs: Introduce ufshcd_abort_all()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20221027204356.1146212-1-bvanassche@acm.org>
Content-Language: en-US
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20221027204356.1146212-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/10/22 23:43, Bart Van Assche wrote:
> Move the code for aborting all SCSI commands and TMFs into a new function.
> This patch makes the ufshcd_err_handler() easier to read. Except for adding
> more logging, this patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Comment below, otherwise:

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 62 +++++++++++++++++++++------------------
>  1 file changed, 34 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ee73d7036133..05feec10fad3 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6157,6 +6157,38 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
>  	return false;
>  }
>  
> +static bool ufshcd_abort_all(struct ufs_hba *hba)
> +{
> +	bool needs_reset = false;
> +	unsigned int tag, ret;

'ret' is normally 'int'

Also we seem to use 'int' for 'tag' a lot and it would match the
dev_err %d

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
> @@ -6168,10 +6200,7 @@ static void ufshcd_err_handler(struct work_struct *work)
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
> @@ -6200,8 +6229,6 @@ static void ufshcd_err_handler(struct work_struct *work)
>  again:
>  	needs_restore = false;
>  	needs_reset = false;
> -	err_xfer = false;
> -	err_tm = false;
>  
>  	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
>  		hba->ufshcd_state = UFSHCD_STATE_RESET;
> @@ -6270,34 +6297,13 @@ static void ufshcd_err_handler(struct work_struct *work)
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

