Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACB1C6FD1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 12:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbjCOM7f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 08:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbjCOM7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 08:59:34 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7FF2A6D1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 05:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678885173; x=1710421173;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CfmBTol9nGMqYVfwmQRN+Q5jm/EpGd1dc7fUVYfh5Ks=;
  b=GY/PkedOZdt6M1sZg7Eeqga/9B5LktPOTrFYILAFJvNoC9HmkZXGpR2O
   86qH/dPlu7fIgruR05IQnG+nJYsg1Xbhz7WJzv2eRgX1Z/A+uRJitZ2k6
   5znEEvYbDZAkUGuQq8DvHKgJUh4sZIL6D+QwZSLlHaPVomC10mazEeePF
   +2XWADdbEiohAJaY0gFzwk5tSqbhpLiBtxRonvjDUY2QRscq09s6y47pr
   UPvvhkmlvpNxIBa+IL/FQ4LpeC7sPLGFHm34FVEKiBf6q2DLrj6EB/5kV
   bOXsYEI3BK9bTiG614ChiAXrQBLC34v3S6Aru8XNJigqlk6oiInokvQm6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="402562401"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="402562401"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:59:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="1008823669"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="1008823669"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.220.200])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:59:29 -0700
Message-ID: <c93b751f-1300-bb85-bf33-42147f0b3353@intel.com>
Date:   Wed, 15 Mar 2023 14:59:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH 2/2] scsi: ufs: core: Set the residual byte count
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
References: <20230314205844.313519-1-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230314205844.313519-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/03/23 22:58, Bart Van Assche wrote:
> It is important for the SCSI core to know the residual byte count.
> Hence, extract the residual byte count from the UFS response and pass it to
> the SCSI core. A few examples of the output of a debugging patch that has
> been applied on top of this patch:
> 
> [    1.937750] cmd 0x12: len = 255; resid = 241
> [ ... ]
> [    1.993400] cmd 0xa0: len = 4096; resid = 4048
> [ ... ]

Should this be a fix for stable?

> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ce7b765aa2af..7bbbae9c7c61 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5238,6 +5238,9 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
>  	int scsi_status;
>  	enum utp_ocs ocs;
>  
> +	scsi_set_resid(lrbp->cmd,
> +		be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count));
> +
>  	/* overall command status of utrd */
>  	ocs = ufshcd_get_tr_ocs(lrbp, cqe);
>  

