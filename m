Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05371C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 08:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD9E664E86
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 08:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhCOIb0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 04:31:26 -0400
Received: from m42-2.mailgun.net ([69.72.42.2]:17446 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhCOIbA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Mar 2021 04:31:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615797060; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Ci6S2U/9V2fhFK9n1GscxocWUYLkBqUN9SmqC6qYi10=;
 b=AEK2D5N5J7f/TTH5iu/2wr+mydgxhEM1INIiTlwybHmTRN5p6vRMlAyn/Z5Hj+tOS7q3LQJM
 /C2mMaQdJ9MZxGLFo+zDz2bM2afPAPeKIQhyWAtTicSq6ToQv0boZ4VxHnzOtYkJZzuFhPAb
 8drZNedHwC+zxsm1ejdJNao9/Ik=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 604f1b271de5dd7b99d7d97e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 15 Mar 2021 08:30:31
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DBB7CC433C6; Mon, 15 Mar 2021 08:30:30 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DD3A0C433CA;
        Mon, 15 Mar 2021 08:30:29 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Mar 2021 16:30:29 +0800
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
Subject: Re: [PATCH v5 04/10] scsi: ufshpb: Make eviction depends on region's
 reads
In-Reply-To: <20210302132503.224670-5-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-5-avri.altman@wdc.com>
Message-ID: <7cf2ce1235075c2925561d180b1bd233@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-02 21:24, Avri Altman wrote:
> In host mode, eviction is considered an extreme measure.
> verify that the entering region has enough reads, and the exiting
> region has much less reads.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index a8f8d13af21a..6f4fd22eaf2f 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -17,6 +17,7 @@
>  #include "../sd.h"
> 
>  #define ACTIVATION_THRESHOLD 4 /* 4 IOs */
> +#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 6) /* 256 IOs */
> 
>  /* memory management */
>  static struct kmem_cache *ufshpb_mctx_cache;
> @@ -1050,6 +1051,13 @@ static struct ufshpb_region
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
> @@ -1235,7 +1243,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu 
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
> @@ -1263,6 +1271,16 @@ static int ufshpb_add_region(struct ufshpb_lu
> *hpb, struct ufshpb_region *rgn)
>  			 * because the device could detect this region
>  			 * by not issuing HPB_READ
>  			 */
> +
> +			/*
> +			 * in host control mode, verify that the entering
> +			 * region has enough reads
> +			 */

Maybe merge the new comments with the original comments above?

Thanks,
Can Guo.

> +			if (hpb->is_hcm && rgn->reads < EVICTION_THRESHOLD) {
> +				ret = -EACCES;
> +				goto out;
> +			}
> +
>  			victim_rgn = ufshpb_victim_lru_info(hpb);
>  			if (!victim_rgn) {
>  				dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
