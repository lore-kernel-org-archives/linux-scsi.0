Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A351C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 07:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E276F60F94
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 07:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238557AbhJMHpc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 03:45:32 -0400
Received: from mga05.intel.com ([192.55.52.43]:46202 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238548AbhJMHpb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 03:45:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="313571902"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="313571902"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 00:43:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="480690259"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga007.jf.intel.com with ESMTP; 13 Oct 2021 00:43:17 -0700
Subject: Re: [PATCH 4/5] scsi: ufs: Log error handler activity
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211012215433.3725777-1-bvanassche@acm.org>
 <20211012215433.3725777-5-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <fe99cfea-41b7-58f5-8b79-1f3bbc56fec1@intel.com>
Date:   Wed, 13 Oct 2021 10:43:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012215433.3725777-5-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/10/2021 00:54, Bart Van Assche wrote:
> Kernel logs are hard to comprehend without information about what the
> UFS error handler is doing. Hence this patch that logs information
> about error handler activity.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index cb55ba3cb3e6..ecfe1f124f8a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -134,6 +134,14 @@ enum {
>  	UFSHCD_CAN_QUEUE	= 32,
>  };
>  
> +static const char *const ufshcd_state_name[] = {
> +	[UFSHCD_STATE_RESET]			= "reset",
> +	[UFSHCD_STATE_OPERATIONAL]		= "operational",
> +	[UFSHCD_STATE_ERROR]			= "error",
> +	[UFSHCD_STATE_EH_SCHEDULED_FATAL]	= "eh_will_reset",
> +	[UFSHCD_STATE_EH_SCHEDULED_NON_FATAL]	= "eh_wont_reset",

Currently, the error handler can do a reset for 
UFSHCD_STATE_EH_SCHEDULED_NON_FATAL, so that description is
misleading.

There is code like:

	if (hba->force_reset || ufshcd_is_link_broken(hba) ||
	    ufshcd_is_saved_err_fatal(hba) ||
	    ((hba->saved_err & UIC_ERROR) &&
	     (hba->saved_uic_err & (UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
				    UFSHCD_UIC_DL_TCx_REPLAY_ERROR)))) {
		needs_reset = true;
		goto do_reset;
	}

where UFSHCD_UIC_DL_NAC_RECEIVED_ERROR and UFSHCD_UIC_DL_TCx_REPLAY_ERROR
are non-fatal errors.  I think the spec. says they should not need a reset
but the driver does anyway.

> +};
> +
>  /* UFSHCD error handling flags */
>  enum {
>  	UFSHCD_EH_IN_PROGRESS = (1 << 0),
> @@ -6065,6 +6073,13 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
>  	int pmc_err;
>  	int tag;
>  
> +	dev_info(hba->dev,
> +		 "%s started; HBA state %s; powered %d; shutting down %d; saved_err = %d; saved_uic_err = %d; force_reset = %d%s\n",
> +		 __func__, ufshcd_state_name[hba->ufshcd_state],
> +		 hba->is_powered, hba->shutting_down, hba->saved_err,
> +		 hba->saved_uic_err, hba->force_reset,
> +		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
> +
>  	down(&hba->host_sem);
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	hba->host->host_eh_scheduled = 0;
> @@ -6160,6 +6175,8 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
>  			err_xfer = true;
>  			goto lock_skip_pending_xfer_clear;
>  		}
> +		dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
> +			hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
>  	}
>  
>  	/* Clear pending task management requests */
> @@ -6240,6 +6257,9 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  	ufshcd_err_handling_unprepare(hba);
>  	up(&hba->host_sem);
> +
> +	dev_info(hba->dev, "%s finished; HBA state %s\n", __func__,
> +		 ufshcd_state_name[hba->ufshcd_state]);
>  }
>  
>  /**
> @@ -6554,6 +6574,10 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
>  	err = ufshcd_wait_for_register(hba,
>  			REG_UTP_TASK_REQ_DOOR_BELL,
>  			mask, 0, 1000, 1000);
> +
> +	dev_err(hba->dev, "Clearing task management function with tag %d %s\n",
> +		tag, err ? "succeeded" : "failed");
> +
>  out:
>  	return err;
>  }
> 

