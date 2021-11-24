Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E274C43217
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 12:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242674AbhKXMP1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 07:15:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:64854 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241742AbhKXMMN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Nov 2021 07:12:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="232759367"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="232759367"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 04:03:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="740968752"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga006.fm.intel.com with ESMTP; 24 Nov 2021 04:03:36 -0800
Subject: Re: [PATCH v2 14/20] scsi: ufs: Introduce ufshcd_release_scsi_cmd()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-15-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <1383eeb3-dc40-6498-7388-b5d35b923f88@intel.com>
Date:   Wed, 24 Nov 2021 14:03:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211119195743.2817-15-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/11/2021 21:57, Bart Van Assche wrote:
> The only functional change in this patch is that scsi_done() is now called
> after ufshcd_release() and ufshcd_clk_scaling_update_busy().
> 
> The next patch in this series will introduce a call to
> ufshcd_release_scsi_cmd() in the abort handler.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 03f4772fc2e2..39dcf997a638 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5248,6 +5248,18 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
>  	return retval;
>  }
>  
> +/* Release the resources allocated for processing a SCSI command. */
> +static void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
> +				    struct ufshcd_lrb *lrbp)
> +{
> +	struct scsi_cmnd *cmd = lrbp->cmd;
> +
> +	scsi_dma_unmap(cmd);
> +	lrbp->cmd = NULL;	/* Mark the command as completed. */
> +	ufshcd_release(hba);
> +	ufshcd_clk_scaling_update_busy(hba);
> +}

That seems to leave a gap in the handling of tracing.

Wouldn't we be better served to tweak the monitoring code
in __ufshcd_transfer_req_compl() and then use
 __ufshcd_transfer_req_compl()? i.e.

	result = ufshcd_transfer_rsp_status(hba, lrbp);
	if (unlikely(!result && ufshcd_should_inform_monitor(hba, lrbp)))
		ufshcd_update_monitor(hba, lrbp);


> +
>  /**
>   * __ufshcd_transfer_req_compl - handle SCSI and query command completion
>   * @hba: per adapter instance
> @@ -5258,9 +5270,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>  {
>  	struct ufshcd_lrb *lrbp;
>  	struct scsi_cmnd *cmd;
> -	int result;
>  	int index;
> -	bool update_scaling = false;
>  
>  	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
>  		lrbp = &hba->lrb[index];
> @@ -5270,26 +5280,19 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>  			if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
>  				ufshcd_update_monitor(hba, lrbp);
>  			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
> -			result = ufshcd_transfer_rsp_status(hba, lrbp);
> -			scsi_dma_unmap(cmd);
> -			cmd->result = result;
> -			/* Mark completed command as NULL in LRB */
> -			lrbp->cmd = NULL;
> +			cmd->result = ufshcd_transfer_rsp_status(hba, lrbp);
> +			ufshcd_release_scsi_cmd(hba, lrbp);
>  			/* Do not touch lrbp after scsi done */
>  			scsi_done(cmd);
> -			ufshcd_release(hba);
> -			update_scaling = true;
>  		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
>  			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
>  			if (hba->dev_cmd.complete) {
>  				ufshcd_add_command_trace(hba, index,
>  							 UFS_DEV_COMP);
>  				complete(hba->dev_cmd.complete);
> -				update_scaling = true;
> +				ufshcd_clk_scaling_update_busy(hba);
>  			}
>  		}
> -		if (update_scaling)
> -			ufshcd_clk_scaling_update_busy(hba);
>  	}
>  }
>  
> 

