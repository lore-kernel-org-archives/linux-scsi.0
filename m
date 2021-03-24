Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73BFC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 09:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6018761A07
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 09:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhCXJZ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 05:25:58 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:39869 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhCXJZs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 05:25:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1616577948; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=uGzL7pp3kEyLH8Z3B1DFI8O6ESe1kEXR4hYo06Ds+5A=;
 b=Ya/+pP4MfuLWltY+CzpYpeLyNXJO7yN/Z340Lu2REY29GdHFQzA4phrof0XLnlM4zztaOWiw
 hJ91QIZ0q1Hn2OKyGHFf71/uTdCq7fVJXNk7sTzlN8UukLqrVT1O7EozLTTKg+yQv2myF5PS
 96FLm/uS4Yumy4GLXR6yR+BJEXo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 605b05875d70193f88129fe5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 24 Mar 2021 09:25:27
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5C373C43467; Wed, 24 Mar 2021 09:25:27 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9A6F3C433C6;
        Wed, 24 Mar 2021 09:25:25 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 24 Mar 2021 17:25:25 +0800
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
Subject: Re: [PATCH v6 03/10] scsi: ufshpb: Add region's reads counter
In-Reply-To: <20210322081044.62003-4-avri.altman@wdc.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
 <20210322081044.62003-4-avri.altman@wdc.com>
Message-ID: <48758404e172e8faca07c3fab8a3bd5c@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-22 16:10, Avri Altman wrote:
> In host control mode, reads are the major source of activation trials.
> Keep track of those reads counters, for both active as well inactive
> regions.
> 
> We reset the read counter upon write - we are only interested in 
> "clean"
> reads.
> 
> Keep those counters normalized, as we are using those reads as a
> comparative score, to make various decisions.
> If during consecutive normalizations an active region has exhaust its
> reads - inactivate it.
> 
> while at it, protect the {active,inactive}_count stats by adding them
> into the applicable handler.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 100 +++++++++++++++++++++++++++++++-------
>  drivers/scsi/ufs/ufshpb.h |   5 ++
>  2 files changed, 88 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index d4f0bb6d8fa1..a1519cbb4ce0 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -16,6 +16,8 @@
>  #include "ufshpb.h"
>  #include "../sd.h"
> 
> +#define ACTIVATION_THRESHOLD 8 /* 8 IOs */
> +
>  /* memory management */
>  static struct kmem_cache *ufshpb_mctx_cache;
>  static mempool_t *ufshpb_mctx_pool;
> @@ -546,6 +548,23 @@ static int ufshpb_issue_pre_req(struct ufshpb_lu
> *hpb, struct scsi_cmnd *cmd,
>  	return ret;
>  }
> 
> +static void ufshpb_update_active_info(struct ufshpb_lu *hpb, int 
> rgn_idx,
> +				      int srgn_idx)
> +{
> +	struct ufshpb_region *rgn;
> +	struct ufshpb_subregion *srgn;
> +
> +	rgn = hpb->rgn_tbl + rgn_idx;
> +	srgn = rgn->srgn_tbl + srgn_idx;
> +
> +	list_del_init(&rgn->list_inact_rgn);
> +
> +	if (list_empty(&srgn->list_act_srgn))
> +		list_add_tail(&srgn->list_act_srgn, &hpb->lh_act_srgn);
> +
> +	hpb->stats.rb_active_cnt++;
> +}
> +
>  /*
>   * This function will set up HPB read command using host-side L2P map 
> data.
>   */
> @@ -596,12 +615,43 @@ int ufshpb_prep(struct ufs_hba *hba, struct
> ufshcd_lrb *lrbp)
>  		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
>  				 transfer_len);
>  		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +
> +		if (hpb->is_hcm) {
> +			spin_lock(&rgn->rgn_lock);
> +			rgn->reads = 0;
> +			spin_unlock(&rgn->rgn_lock);
> +		}
> +
>  		return 0;
>  	}
> 
>  	if (!ufshpb_is_support_chunk(hpb, transfer_len))
>  		return 0;
> 
> +	if (hpb->is_hcm) {
> +		bool activate = false;
> +		/*
> +		 * in host control mode, reads are the main source for
> +		 * activation trials.
> +		 */
> +		spin_lock(&rgn->rgn_lock);
> +		rgn->reads++;
> +		if (rgn->reads == ACTIVATION_THRESHOLD)
> +			activate = true;
> +		spin_unlock(&rgn->rgn_lock);
> +		if (activate) {
> +			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> +			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);

If a transfer_len (possible with HPB2.0) sits accross two 
regions/sub-regions,
here it only updates active info of the first region/sub-region.

Thanks,
Can Guo.

> +			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> +			dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
> +				"activate region %d-%d\n", rgn_idx, srgn_idx);
> +		}
> +
> +		/* keep those counters normalized */
> +		if (rgn->reads > hpb->entries_per_srgn)
> +			schedule_work(&hpb->ufshpb_normalization_work);
> +	}
> +
>  	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
>  	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
>  				   transfer_len)) {
> @@ -741,21 +791,6 @@ static int ufshpb_clear_dirty_bitmap(struct 
> ufshpb_lu *hpb,
>  	return 0;
>  }
> 
> -static void ufshpb_update_active_info(struct ufshpb_lu *hpb, int 
> rgn_idx,
> -				      int srgn_idx)
> -{
> -	struct ufshpb_region *rgn;
> -	struct ufshpb_subregion *srgn;
> -
> -	rgn = hpb->rgn_tbl + rgn_idx;
> -	srgn = rgn->srgn_tbl + srgn_idx;
> -
> -	list_del_init(&rgn->list_inact_rgn);
> -
> -	if (list_empty(&srgn->list_act_srgn))
> -		list_add_tail(&srgn->list_act_srgn, &hpb->lh_act_srgn);
> -}
> -
>  static void ufshpb_update_inactive_info(struct ufshpb_lu *hpb, int 
> rgn_idx)
>  {
>  	struct ufshpb_region *rgn;
> @@ -769,6 +804,8 @@ static void ufshpb_update_inactive_info(struct
> ufshpb_lu *hpb, int rgn_idx)
> 
>  	if (list_empty(&rgn->list_inact_rgn))
>  		list_add_tail(&rgn->list_inact_rgn, &hpb->lh_inact_rgn);
> +
> +	hpb->stats.rb_inactive_cnt++;
>  }
> 
>  static void ufshpb_activate_subregion(struct ufshpb_lu *hpb,
> @@ -1089,6 +1126,7 @@ static int ufshpb_evict_region(struct ufshpb_lu
> *hpb, struct ufshpb_region *rgn)
>  			 rgn->rgn_idx);
>  		goto out;
>  	}
> +
>  	if (!list_empty(&rgn->list_lru_rgn)) {
>  		if (ufshpb_check_srgns_issue_state(hpb, rgn)) {
>  			ret = -EBUSY;
> @@ -1283,7 +1321,6 @@ static void ufshpb_rsp_req_region_update(struct
> ufshpb_lu *hpb,
>  		if (srgn->srgn_state == HPB_SRGN_VALID)
>  			srgn->srgn_state = HPB_SRGN_INVALID;
>  		spin_unlock(&hpb->rgn_state_lock);
> -		hpb->stats.rb_active_cnt++;
>  	}
> 
>  	if (hpb->is_hcm) {
> @@ -1315,7 +1352,6 @@ static void ufshpb_rsp_req_region_update(struct
> ufshpb_lu *hpb,
>  		}
>  		spin_unlock(&hpb->rgn_state_lock);
> 
> -		hpb->stats.rb_inactive_cnt++;
>  	}
> 
>  out:
> @@ -1514,6 +1550,29 @@ static void
> ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
>  	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
>  }
> 
> +static void ufshpb_normalization_work_handler(struct work_struct 
> *work)
> +{
> +	struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu,
> +					     ufshpb_normalization_work);
> +	int rgn_idx;
> +
> +	for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
> +		struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;
> +
> +		spin_lock(&rgn->rgn_lock);
> +		rgn->reads = (rgn->reads >> 1);
> +		spin_unlock(&rgn->rgn_lock);
> +
> +		if (rgn->rgn_state != HPB_RGN_ACTIVE || rgn->reads)
> +			continue;
> +
> +		/* if region is active but has no reads - inactivate it */
> +		spin_lock(&hpb->rsp_list_lock);
> +		ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
> +		spin_unlock(&hpb->rsp_list_lock);
> +	}
> +}
> +
>  static void ufshpb_map_work_handler(struct work_struct *work)
>  {
>  	struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu, 
> map_work);
> @@ -1673,6 +1732,8 @@ static int ufshpb_alloc_region_tbl(struct
> ufs_hba *hba, struct ufshpb_lu *hpb)
>  		rgn = rgn_table + rgn_idx;
>  		rgn->rgn_idx = rgn_idx;
> 
> +		spin_lock_init(&rgn->rgn_lock);
> +
>  		INIT_LIST_HEAD(&rgn->list_inact_rgn);
>  		INIT_LIST_HEAD(&rgn->list_lru_rgn);
> 
> @@ -1914,6 +1975,9 @@ static int ufshpb_lu_hpb_init(struct ufs_hba
> *hba, struct ufshpb_lu *hpb)
>  	INIT_LIST_HEAD(&hpb->list_hpb_lu);
> 
>  	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
> +	if (hpb->is_hcm)
> +		INIT_WORK(&hpb->ufshpb_normalization_work,
> +			  ufshpb_normalization_work_handler);
> 
>  	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
>  			  sizeof(struct ufshpb_req), 0, 0, NULL);
> @@ -2013,6 +2077,8 @@ static void ufshpb_discard_rsp_lists(struct
> ufshpb_lu *hpb)
> 
>  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
>  {
> +	if (hpb->is_hcm)
> +		cancel_work_sync(&hpb->ufshpb_normalization_work);
>  	cancel_work_sync(&hpb->map_work);
>  }
> 
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index 032672114881..32d72c46c57a 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -123,6 +123,10 @@ struct ufshpb_region {
>  	struct list_head list_lru_rgn;
>  	unsigned long rgn_flags;
>  #define RGN_FLAG_DIRTY 0
> +
> +	/* region reads - for host mode */
> +	spinlock_t rgn_lock;
> +	unsigned int reads;
>  };
> 
>  #define for_each_sub_region(rgn, i, srgn)				\
> @@ -212,6 +216,7 @@ struct ufshpb_lu {
> 
>  	/* for selecting victim */
>  	struct victim_select_info lru_info;
> +	struct work_struct ufshpb_normalization_work;
> 
>  	/* pinned region information */
>  	u32 lu_pinned_start;
