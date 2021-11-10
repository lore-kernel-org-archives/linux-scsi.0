Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD1AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 08:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4B00610A8
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 08:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhKJJBC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 04:01:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:6475 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230141AbhKJJAr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Nov 2021 04:00:47 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10163"; a="219833931"
X-IronPort-AV: E=Sophos;i="5.87,223,1631602800"; 
   d="scan'208";a="219833931"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 00:58:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,223,1631602800"; 
   d="scan'208";a="492016951"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga007.jf.intel.com with ESMTP; 10 Nov 2021 00:57:50 -0800
Subject: Re: [PATCH 08/11] scsi: ufs: Improve SCSI abort handling further
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vishak G <vishak.g@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-9-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <509e2b2c-689a-04e3-e773-b8b99d9f6d0e@intel.com>
Date:   Wed, 10 Nov 2021 10:57:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211110004440.3389311-9-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/11/2021 02:44, Bart Van Assche wrote:
> Make sure that aborted commands are completed once by clearing the
> corresponding tag bit from hba->outstanding_reqs. This patch is a
> follow-up for commit cd892096c940 ("scsi: ufs: core: Improve SCSI
> abort handling").
> 
> Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8f5640647054..1e15ed1f639f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7090,6 +7090,15 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  		goto release;
>  	}
>  
> +	/*
> +	 * ufshcd_try_to_abort_task() cleared the 'tag' bit in the doorbell
> +	 * register. Clear the corresponding bit from outstanding_reqs to
> +	 * prevent early completion.
> +	 */
> +	spin_lock_irqsave(&hba->outstanding_lock, flags);
> +	__clear_bit(tag, &hba->outstanding_reqs);
> +	spin_unlock_irqrestore(&hba->outstanding_lock, flags);

Seems like something ufshcd_clear_cmd() should be doing instead?

> +
>  	lrbp->cmd = NULL;
>  	err = SUCCESS;
>  
> 

