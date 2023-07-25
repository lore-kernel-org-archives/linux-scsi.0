Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49A0C001DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 12:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbjGYMDR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 08:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjGYMDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 08:03:15 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD1010D4
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 05:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690286595; x=1721822595;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u6GxodBYhqnIYRik/JvpWSNKhCOm9JsD2VpD/+0IppY=;
  b=NXO7DmO6FQXftu8t/XOht86F2xrG/QvJPMvo1fOcN3k57yRiRh1rIqDm
   MT76jMY7HMhYUqnXlACeLiRrHQIXymB6/cQ0BDy7fj5DjHCXl4yciFc2n
   94Aaet7zilvGSUgf1RX6PZ5DpQDWTTRlgdVRPxMWx+urb3iowo/upKlC6
   ch+w89O3+YxvSKcW1ng45Lp4BfmOGWRvgpb2rHaUmFH0SKHhq2dg32BYq
   xuKIQyCiyNysL8ujZpx3QDPGY5qDbZGRuvj7ur8voOqx9dS07tFYLWy42
   ar4ykjvb4Bwy8sVtAFLbFZ8aangOdnY3VTrqDg5krgqliNJLvwTubpmkU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="370371004"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="370371004"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 05:03:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="726094144"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="726094144"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.249.37.150])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 05:03:00 -0700
Message-ID: <dcc45c7f-f8f0-ebff-15c7-69d10399a942@intel.com>
Date:   Tue, 25 Jul 2023 15:02:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [PATCH v2 1/2] scsi: ufs: Fix residual handling
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230724200843.3376570-1-bvanassche@acm.org>
 <20230724200843.3376570-2-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230724200843.3376570-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/07/23 23:08, Bart Van Assche wrote:
> Only call scsi_set_resid() in case of an underflow. Do not call
> scsi_set_resid() in case of an overflow.
> 
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Fixes: cb38845d90fc ("scsi: ufs: core: Set the residual byte count")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/core/ufshcd.c | 12 ++++++++++--
>  include/ufs/ufs.h         |  6 ++++++
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c394dc50504a..27e1a4914837 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5222,9 +5222,17 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
>  	int result = 0;
>  	int scsi_status;
>  	enum utp_ocs ocs;
> +	u8 upiu_flags;
> +	u32 resid;
>  
> -	scsi_set_resid(lrbp->cmd,
> -		be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count));
> +	upiu_flags = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_0) >> 16;
> +	resid = be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count);
> +	/*
> +	 * Test !overflow instead of underflow to support UFS devices that do
> +	 * not set either flag.
> +	 */
> +	if (resid && !(upiu_flags & UPIU_RSP_FLAG_OVERFLOW))
> +		scsi_set_resid(lrbp->cmd, resid);
>  
>  	/* overall command status of utrd */
>  	ocs = ufshcd_get_tr_ocs(lrbp, cqe);
> diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
> index 0dd546a20503..c789252b5fad 100644
> --- a/include/ufs/ufs.h
> +++ b/include/ufs/ufs.h
> @@ -104,6 +104,12 @@ enum {
>  	UPIU_CMD_FLAGS_READ	= 0x40,
>  };
>  
> +/* UPIU response flags */
> +enum {
> +	UPIU_RSP_FLAG_UNDERFLOW	= 0x20,
> +	UPIU_RSP_FLAG_OVERFLOW	= 0x40,
> +};
> +
>  /* UPIU Task Attributes */
>  enum {
>  	UPIU_TASK_ATTR_SIMPLE	= 0x00,

