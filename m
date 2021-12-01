Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DADDC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 15:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243098AbhLAPhV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 10:37:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:19698 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234031AbhLAPhU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Dec 2021 10:37:20 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="216496995"
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="216496995"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 07:33:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,278,1631602800"; 
   d="scan'208";a="459286894"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga003.jf.intel.com with ESMTP; 01 Dec 2021 07:33:54 -0800
Subject: Re: [PATCH v3 13/17] scsi: ufs: Improve SCSI abort handling further
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Vishak G <vishak.g@samsung.com>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>
References: <20211130233324.1402448-1-bvanassche@acm.org>
 <20211130233324.1402448-14-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <ba11f47f-9498-a4d1-7dff-730ab755f554@intel.com>
Date:   Wed, 1 Dec 2021 17:33:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211130233324.1402448-14-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/12/2021 01:33, Bart Van Assche wrote:
> Release resources when aborting a command. Make sure that aborted commands
> are completed once by clearing the corresponding tag bit from
> hba->outstanding_reqs. This patch is an improved version of commit
> 3ff1f6b6ba6f ("scsi: ufs: core: Improve SCSI abort handling").
> 
> Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/scsi/ufs/ufshcd.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8703e4a70256..1a4f2ebf955e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6984,6 +6984,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
>  	unsigned long flags;
>  	int err = FAILED;
> +	bool outstanding;
>  	u32 reg;
>  
>  	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
> @@ -7061,6 +7062,17 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		goto release;
>  	}
>  
> +	/*
> +	 * Clear the corresponding bit from outstanding_reqs since the command
> +	 * has been aborted successfully.
> +	 */
> +	spin_lock_irqsave(&hba->outstanding_lock, flags);
> +	outstanding = __test_and_clear_bit(tag, &hba->outstanding_reqs);
> +	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> +
> +	if (outstanding)
> +		ufshcd_release_scsi_cmd(hba, lrbp);
> +
>  	err = SUCCESS;
>  
>  release:
> 

