Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C84C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 12:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343651AbhKXMee (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 07:34:34 -0500
Received: from mga18.intel.com ([134.134.136.126]:46411 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244729AbhKXMc2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Nov 2021 07:32:28 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="222142203"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="222142203"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 04:28:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="740974741"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga006.fm.intel.com with ESMTP; 24 Nov 2021 04:28:31 -0800
Subject: Re: [PATCH v2 15/20] scsi: ufs: Improve SCSI abort handling
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Namjae Jeon <linkinjeon@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-16-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <502c4980-32e3-8c77-76c5-4be814b8fab6@intel.com>
Date:   Wed, 24 Nov 2021 14:28:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211119195743.2817-16-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/11/2021 21:57, Bart Van Assche wrote:
> Release resources when aborting a command. Make sure that aborted commands
> are completed once by clearing the corresponding tag bit from
> hba->outstanding_reqs.
> 
> Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 39dcf997a638..7e27d6436889 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7042,8 +7042,12 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  
>  	ufshcd_hold(hba, false);
>  	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -	/* If command is already aborted/completed, return FAILED. */
> -	if (!(test_bit(tag, &hba->outstanding_reqs))) {
> +	/*
> +	 * If the command is already aborted/completed, return FAILED. This
> +	 * should never happen since the SCSI core serializes error handling
> +	 * and scsi_done() calls.

I don't think that is correct. ufshcd_transfer_req_compl() gets called directly
by the interrupt handler.

> +	 */
> +	if (WARN_ON_ONCE(!(test_bit(tag, &hba->outstanding_reqs)))) {
>  		dev_err(hba->dev,
>  			"%s: cmd at tag %d already completed, outstanding=0x%lx, doorbell=0x%x\n",
>  			__func__, tag, hba->outstanding_reqs, reg);
> @@ -7113,6 +7117,16 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		goto release;
>  	}
>  
> +	/*
> +	 * Clear the corresponding bit from outstanding_reqs since the command
> +	 * has been aborted successfully.
> +	 */
> +	spin_lock_irqsave(&hba->outstanding_lock, flags);
> +	__clear_bit(tag, &hba->outstanding_reqs);
> +	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> +
> +	ufshcd_release_scsi_cmd(hba, lrbp);

ufshcd_release_scsi_cmd() must not be called if the bit was already clear
i.e.

	spin_lock_irqsave(&hba->outstanding_lock, flags);
	rel = __test_and_clear_bit(tag, &hba->outstanding_reqs);
	spin_unlock_irqrestore(&hba->outstanding_lock, flags);

	if (rel)
		ufshcd_release_scsi_cmd(hba, lrbp);

> +
>  	err = SUCCESS;
>  
>  release:
> 

