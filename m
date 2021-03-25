Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F899C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 05:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECAC761A1B
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 05:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCYFfY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 01:35:24 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:15799 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhCYFel (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 01:34:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1616650480; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=X12qIuxJ2CSbTarauFRf/LvxSGoKlHCGw1X4+sEEydg=;
 b=sTrVQtIAJpKo1Oy67RLZHIE2IrqVZLvmfdtOi+26Il/FmiqYSRHmGzxtnUqrlxPE/tICP4E5
 4K+/RoxENYhpUXtWLtEKYwKZJbXmaFbl9wdGcAAmOI+u412ooXMoN+a+6U1+OdKAxr0SnFbi
 dsf4+zbC9JBkZr3oxNFSWyQDKIg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 605c20df1d4d56494187cc79 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 25 Mar 2021 05:34:23
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A637BC43465; Thu, 25 Mar 2021 05:34:22 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9CA34C433CA;
        Thu, 25 Mar 2021 05:34:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 25 Mar 2021 13:34:21 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, stanley.chu@mediatek.com
Subject: Re: [PATCH v6 04/10] scsi: ufshpb: Make eviction depends on region's
 reads
In-Reply-To: <20210322081044.62003-5-avri.altman@wdc.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
 <20210322081044.62003-5-avri.altman@wdc.com>
Message-ID: <b06c0bcc3ea51ab7d6b8e5fb46ed6bdb@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-22 16:10, Avri Altman wrote:
> In host mode, eviction is considered an extreme measure.
> verify that the entering region has enough reads, and the exiting
> region has much less reads.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index a1519cbb4ce0..5e757220d66a 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -17,6 +17,7 @@
>  #include "../sd.h"
> 
>  #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
> +#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 5) /* 256 IOs */
> 
>  /* memory management */
>  static struct kmem_cache *ufshpb_mctx_cache;
> @@ -1047,6 +1048,13 @@ static struct ufshpb_region
> *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
>  		if (ufshpb_check_srgns_issue_state(hpb, rgn))
>  			continue;
> 
> +		/*
> +		 * in host control mode, verify that the exiting region
> +		 * has less reads
> +		 */
> +		if (hpb->is_hcm && rgn->reads > (EVICTION_THRESHOLD >> 1))
> +			continue;
> +
>  		victim_rgn = rgn;
>  		break;
>  	}
> @@ -1219,7 +1227,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu 
> *hpb,
> 
>  static int ufshpb_add_region(struct ufshpb_lu *hpb, struct 
> ufshpb_region *rgn)
>  {
> -	struct ufshpb_region *victim_rgn;
> +	struct ufshpb_region *victim_rgn = NULL;
>  	struct victim_select_info *lru_info = &hpb->lru_info;
>  	unsigned long flags;
>  	int ret = 0;
> @@ -1246,7 +1254,15 @@ static int ufshpb_add_region(struct ufshpb_lu
> *hpb, struct ufshpb_region *rgn)
>  			 * It is okay to evict the least recently used region,
>  			 * because the device could detect this region
>  			 * by not issuing HPB_READ
> +			 *
> +			 * in host control mode, verify that the entering
> +			 * region has enough reads
>  			 */
> +			if (hpb->is_hcm && rgn->reads < EVICTION_THRESHOLD) {
> +				ret = -EACCES;
> +				goto out;
> +			}
> +

I cannot understand the logic behind this. A rgn which host chooses to 
activate,
is in INACTIVE state now, if its rgn->reads < 256, then don't activate 
it.
Could you please elaborate?

Thanks,
Can Guo.

>  			victim_rgn = ufshpb_victim_lru_info(hpb);
>  			if (!victim_rgn) {
>  				dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
