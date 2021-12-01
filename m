Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189A7C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 14:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349603AbhLAOLg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 09:11:36 -0500
Received: from mga06.intel.com ([134.134.136.31]:8022 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239378AbhLAOLf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Dec 2021 09:11:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="297263981"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="297263981"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 06:08:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="459260201"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga003.jf.intel.com with ESMTP; 01 Dec 2021 06:08:11 -0800
Subject: Re: [PATCH v3 15/17] scsi: ufs: Stop using the clock scaling lock in
 the error handler
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
 <20211130233324.1402448-16-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <4bd431ad-9038-e9d7-7b22-ba3cdb222068@intel.com>
Date:   Wed, 1 Dec 2021 16:08:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211130233324.1402448-16-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/12/2021 01:33, Bart Van Assche wrote:
> Instead of locking and unlocking the clock scaling lock, surround the
> command queueing code with an RCU reader lock and call synchronize_rcu().
> This patch prepares for removal of the clock scaling lock.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/scsi/ufs/ufshcd.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 074ea9ae54e0..c4cf5c4b4893 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2684,6 +2684,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  	if (!down_read_trylock(&hba->clk_scaling_lock))
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  
> +	/*
> +	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
> +	 * calls.
> +	 */
> +	rcu_read_lock();
> +
>  	switch (hba->ufshcd_state) {
>  	case UFSHCD_STATE_OPERATIONAL:
>  		break;
> @@ -2762,7 +2768,10 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  	}
>  
>  	ufshcd_send_command(hba, tag);
> +
>  out:
> +	rcu_read_unlock();
> +
>  	up_read(&hba->clk_scaling_lock);
>  
>  	if (ufs_trigger_eh()) {
> @@ -5951,8 +5960,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>  	}
>  	ufshcd_scsi_block_requests(hba);
>  	/* Drain ufshcd_queuecommand() */
> -	down_write(&hba->clk_scaling_lock);
> -	up_write(&hba->clk_scaling_lock);
> +	synchronize_rcu();
>  	cancel_work_sync(&hba->eeh_work);
>  }
>  
> 

