Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A187C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Nov 2022 13:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiKUNtB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 08:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiKUNtA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 08:49:00 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB34265B9
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 05:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669038538; x=1700574538;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0hUqa2yofDnt2wYQvRQMnzUNFYvc7mDY3FHm7zqlVBc=;
  b=RSya92E/96N/TdcNDDdh5pYvAPnpN3fgVkzGQgbbcXRR38QXPOPDqf+n
   JAlY60o+ryWTXpgVkRFh1xofu9pOPzhGv8DR5J0gTxlpY4QWxyNBuoaMe
   PWjkRO6VLiV4PdkeICQNpxpohOjdofM27QJYIj+nc9Oylx7fZFZauwNjv
   UW5d4EiZ4+luJzLy2DDtlNXkNAqEsvFrHIIEAR9fxk7oFE4Wls7gKSq+z
   9btWcNVVpSk27U4+9tbHb4oP4rwNIYQ5hUMkU+dj7H6aTUlbcEGpc2fxC
   nrhMjcYpaYGYPu6fBhlR1EOPIuQ5W1mKkwRhzGpqyWF1eOqLPh8GfPPpT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="312260379"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="312260379"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 05:48:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="641023960"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="641023960"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.35.94])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 05:48:55 -0800
Message-ID: <298fc637-cf7f-28ba-9e88-6e26cdb45f69@intel.com>
Date:   Mon, 21 Nov 2022 15:48:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH v2] scsi: ufs: Fix the polling implementation
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20221118233717.441298-1-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20221118233717.441298-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/11/22 01:37, Bart Van Assche wrote:
> Fix the following issues in ufshcd_poll():
> - If polling succeeds, return a positive value.
> - Do not complete polling requests from interrupt context because the
>   block layer expects these requests to be completed from thread
>   context. From block/bio.c:
> 
>     If REQ_ALLOC_CACHE is set, the final put of the bio MUST be done
>     from process context, not hard/soft IRQ.
> 
> Fixes: eaab9b573054 ("scsi: ufs: Implement polling support")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> 
> Changes compared to v1:
> - Made sure that polled requests are not completed from interrupt context.
> 
>  drivers/ufs/core/ufshcd.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 768cb49d269c..b4bf3c3bef0c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5344,6 +5344,26 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>  	}
>  }
>  
> +/* Any value that is not an existing queue number is fine for this constant. */
> +enum {
> +	UFSHCD_POLL_FROM_INTERRUPT_CONTEXT = -1
> +};
> +
> +static void ufshcd_clear_polled(struct ufs_hba *hba,
> +				unsigned long *completed_reqs)
> +{
> +	int tag;
> +
> +	for_each_set_bit(tag, completed_reqs, hba->nutrs) {
> +		struct scsi_cmnd *cmd = hba->lrb[tag].cmd;
> +
> +		if (!cmd)
> +			continue;
> +		if (scsi_cmd_to_rq(cmd)->cmd_flags & REQ_POLLED)
> +			__clear_bit(tag, completed_reqs);
> +	}
> +}
> +
>  /*
>   * Returns > 0 if one or more commands have been completed or 0 if no
>   * requests have been completed.
> @@ -5360,13 +5380,17 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
>  	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
>  		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
>  		  hba->outstanding_reqs);
> +	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
> +		/* Do not complete polled requests from interrupt context. */
> +		ufshcd_clear_polled(hba, &completed_reqs);
> +	}
>  	hba->outstanding_reqs &= ~completed_reqs;
>  	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
>  
>  	if (completed_reqs)
>  		__ufshcd_transfer_req_compl(hba, completed_reqs);
>  
> -	return completed_reqs;
> +	return completed_reqs != 0;
>  }
>  
>  /**
> @@ -5397,7 +5421,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
>  	 * Ignore the ufshcd_poll() return value and return IRQ_HANDLED since we
>  	 * do not want polling to trigger spurious interrupt complaints.
>  	 */
> -	ufshcd_poll(hba->host, 0);
> +	ufshcd_poll(hba->host, UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
>  
>  	return IRQ_HANDLED;
>  }

