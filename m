Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 256C9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 14:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239205AbhLAOzA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 09:55:00 -0500
Received: from mga18.intel.com ([134.134.136.126]:43275 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239482AbhLAOy7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Dec 2021 09:54:59 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="223348263"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="223348263"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 06:51:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="459274554"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga003.jf.intel.com with ESMTP; 01 Dec 2021 06:51:33 -0800
Subject: Re: [PATCH v3 12/17] scsi: ufs: Introduce ufshcd_release_scsi_cmd()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
 <20211130233324.1402448-13-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <50a101a1-08a3-d419-195e-672e001266c3@intel.com>
Date:   Wed, 1 Dec 2021 16:51:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211130233324.1402448-13-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/12/2021 01:33, Bart Van Assche wrote:
> The only functional change in this patch is that scsi_done() is now called
> after ufshcd_release() and ufshcd_clk_scaling_update_busy() instead of
> before.
> 
> The next patch in this series will introduce a call to
> ufshcd_release_scsi_cmd() in the abort handler.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/scsi/ufs/ufshcd.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 4e9755c060af..8703e4a70256 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5213,6 +5213,18 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
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
> +
>  /**
>   * __ufshcd_transfer_req_compl - handle SCSI and query command completion
>   * @hba: per adapter instance
> @@ -5223,7 +5235,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>  {
>  	struct ufshcd_lrb *lrbp;
>  	struct scsi_cmnd *cmd;
> -	int result;
>  	int index;
>  
>  	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
> @@ -5234,15 +5245,10 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
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
> -			ufshcd_clk_scaling_update_busy(hba);
>  		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
>  			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
>  			if (hba->dev_cmd.complete) {
> 

