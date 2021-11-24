Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8D2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 11:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240787AbhKXLPL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 06:15:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:25934 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234726AbhKXLPK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Nov 2021 06:15:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="222479929"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="222479929"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 03:12:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="740956792"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga006.fm.intel.com with ESMTP; 24 Nov 2021 03:11:57 -0800
Subject: Re: [PATCH v2 10/20] scsi: ufs: Remove dead code
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-11-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <a3b2b7f1-1ff5-ad71-9ca7-8963935364a9@intel.com>
Date:   Wed, 24 Nov 2021 13:11:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211119195743.2817-11-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/11/2021 21:57, Bart Van Assche wrote:
> Commit 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating tag
> conflicts") guarantees that 'tag' is not in use by any SCSI command.
> Remove the check that returns early if a conflict occurs.
> 
> Acked-by: Avri Altman <avri.altman@wdc.com>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ff9532968ae7..fced4528ee90 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6730,11 +6730,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>  	tag = req->tag;
>  	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
>  
> -	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
> -		err = -EBUSY;
> -		goto out;
> -	}
> -
>  	lrbp = &hba->lrb[tag];
>  	WARN_ON(lrbp->cmd);
>  	lrbp->cmd = NULL;
> @@ -6802,8 +6797,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>  	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
>  				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
>  
> -out:
> -	blk_mq_free_request(req);

Removing blk_mq_free_request() looks unintended

>  out_unlock:
>  	up_read(&hba->clk_scaling_lock);
>  	return err;
> 

