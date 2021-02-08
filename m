Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3DBC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 06:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D7AF64E59
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 06:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBHGge (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 01:36:34 -0500
Received: from so15.mailgun.net ([198.61.254.15]:61876 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229975AbhBHGf7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Feb 2021 01:35:59 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612766122; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=aGCR27sxriXSP2sHRlIjaba2Ih4zgq9B75pB0sV0ugU=;
 b=FcV0ydPuwFl05INYA6bS1y8prGDGJLj1q99zMUURcqjx648A6o9Tq5zt7VCW2Otdx0PjnN9U
 2YaE/DVmQdyCduXQimB17Wba4AdNek39qcofZtn11l3o/Ko5wF/cob0O5UqAWy1SDpbKecy0
 IiJmrwtjaHW+mWnoKKTPJyBZhgA=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6020db8d34db06ef79a7f74c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 06:34:53
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8B1FDC43462; Mon,  8 Feb 2021 06:34:53 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 568C4C433C6;
        Mon,  8 Feb 2021 06:34:51 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Feb 2021 14:34:51 +0800
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
Subject: Re: [PATCH v2 6/9] scsi: ufshpb: Add hpb dev reset response
In-Reply-To: <20210202083007.104050-7-avri.altman@wdc.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-7-avri.altman@wdc.com>
Message-ID: <91845a884facd63d9e9d62e2e3424cfd@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-02 16:30, Avri Altman wrote:
> The spec does not define what is the host's recommended response when
> the device send hpb dev reset response (oper 0x2).
> 
> We will update all active hpb regions: mark them and do that on the 
> next
> read.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 54 ++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/ufs/ufshpb.h |  1 +
>  2 files changed, 52 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 49c74de539b7..28e0025507a1 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -17,6 +17,7 @@
>  #include "../sd.h"
> 
>  #define WORK_PENDING 0
> +#define RESET_PENDING 1
>  #define ACTIVATION_THRSHLD 4 /* 4 IOs */
>  #define EVICTION_THRSHLD (ACTIVATION_THRSHLD << 6) /* 256 IOs */
> 
> @@ -349,7 +350,8 @@ void ufshpb_prep(struct ufs_hba *hba, struct
> ufshcd_lrb *lrbp)
>  		if (rgn->reads == ACTIVATION_THRSHLD)
>  			activate = true;
>  		spin_unlock_irqrestore(&rgn->rgn_lock, flags);
> -		if (activate) {
> +		if (activate ||
> +		    test_and_clear_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags)) {
>  			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
>  			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
>  			hpb->stats.rb_active_cnt++;
> @@ -1068,6 +1070,24 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>  	case HPB_RSP_DEV_RESET:
>  		dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>  			 "UFS device lost HPB information during PM.\n");
> +
> +		if (hpb->is_hcm) {
> +			struct ufshpb_lu *h;
> +			struct scsi_device *sdev;
> +
> +			shost_for_each_device(sdev, hba->host) {

I haven't test it yet, but this line shall cause recursive spin lock -
in current code base, ufshpb_rsp_upiu() is called with host_lock held.

Regards,

Can Guo.

> +				h = sdev->hostdata;
> +				if (!h)
> +					continue;
> +
> +				if (test_and_set_bit(RESET_PENDING,
> +						     &h->work_data_bits))
> +					continue;
> +
> +				schedule_work(&h->ufshpb_lun_reset_work);
> +			}
> +		}
> +
>  		break;
>  	default:
>  		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
> @@ -1200,6 +1220,27 @@ static void
> ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
>  	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
>  }
> 
> +static void ufshpb_reset_work_handler(struct work_struct *work)
> +{
> +	struct ufshpb_lu *hpb;
> +	struct victim_select_info *lru_info;
> +	struct ufshpb_region *rgn;
> +	unsigned long flags;
> +
> +	hpb = container_of(work, struct ufshpb_lu, ufshpb_lun_reset_work);
> +
> +	lru_info = &hpb->lru_info;
> +
> +	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> +
> +	list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn)
> +		set_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags);
> +
> +	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +
> +	clear_bit(RESET_PENDING, &hpb->work_data_bits);
> +}
> +
>  static void ufshpb_normalization_work_handler(struct work_struct 
> *work)
>  {
>  	struct ufshpb_lu *hpb;
> @@ -1392,6 +1433,8 @@ static int ufshpb_alloc_region_tbl(struct
> ufs_hba *hba, struct ufshpb_lu *hpb)
>  		} else {
>  			rgn->rgn_state = HPB_RGN_INACTIVE;
>  		}
> +
> +		rgn->rgn_flags = 0;
>  	}
> 
>  	return 0;
> @@ -1502,9 +1545,12 @@ static int ufshpb_lu_hpb_init(struct ufs_hba
> *hba, struct ufshpb_lu *hpb)
>  	INIT_LIST_HEAD(&hpb->list_hpb_lu);
> 
>  	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
> -	if (hpb->is_hcm)
> +	if (hpb->is_hcm) {
>  		INIT_WORK(&hpb->ufshpb_normalization_work,
>  			  ufshpb_normalization_work_handler);
> +		INIT_WORK(&hpb->ufshpb_lun_reset_work,
> +			  ufshpb_reset_work_handler);
> +	}
> 
>  	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
>  			  sizeof(struct ufshpb_req), 0, 0, NULL);
> @@ -1591,8 +1637,10 @@ static void ufshpb_discard_rsp_lists(struct
> ufshpb_lu *hpb)
> 
>  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
>  {
> -	if (hpb->is_hcm)
> +	if (hpb->is_hcm) {
> +		cancel_work_sync(&hpb->ufshpb_lun_reset_work);
>  		cancel_work_sync(&hpb->ufshpb_normalization_work);
> +	}
>  	cancel_work_sync(&hpb->map_work);
>  }
> 
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index 71b082ee7876..e55892ceb3fc 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -184,6 +184,7 @@ struct ufshpb_lu {
>  	/* for selecting victim */
>  	struct victim_select_info lru_info;
>  	struct work_struct ufshpb_normalization_work;
> +	struct work_struct ufshpb_lun_reset_work;
>  	unsigned long work_data_bits;
> 
>  	/* pinned region information */
