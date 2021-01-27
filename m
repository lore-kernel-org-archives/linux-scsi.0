Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3C9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D5E420771
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235987AbhA0P0V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:26:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:32966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343881AbhA0PYG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Jan 2021 10:24:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 944CE207B0;
        Wed, 27 Jan 2021 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611761005;
        bh=bUaHqKG/IoHAawf9yAR4S3Kaji5t7hZh/OYxKzctjq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xHAO+HDcLNsDqqFYVnYY9RbWIM2d2j/S3iZPj4rFTVZtZtUd7dOP6fg/senoypzmx
         +SX4TrZ+/+U+FULYcw00top68ss7hFPumbVgp7WMaXfYtjqUmHE6ThkORxctPxDuQ6
         pGSIfR9ZuTzqP20mXqDvuPhewvqLTitMmjf8En+8=
Date:   Wed, 27 Jan 2021 16:23:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com
Subject: Re: [PATCH 7/8] scsi: ufshpb: Add "Cold" regions timer
Message-ID: <YBGFamLN83K5AHZe@kroah.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
 <20210127151217.24760-8-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210127151217.24760-8-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 27, 2021 at 05:12:16PM +0200, Avri Altman wrote:
> In order not to hang on to “cold” regions, we shall inactivate a
> region that has no READ access for a predefined amount of time -
> READ_TO_MS. For that purpose we shall monitor the active regions list,
> polling it on every POLLING_INTERVAL_MS. On timeout expiry we shall add
> the region to the "to-be-inactivated" list, unless it is clean and did
> not exahust its READ_TO_EXPIRIES - another parameter.
> 
> All this does not apply to pinned regions.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 75 ++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/ufs/ufshpb.h |  7 ++++
>  2 files changed, 81 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index cb99b57b4319..482f01c3b3ee 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -18,8 +18,12 @@
>  
>  #define WORK_PENDING 0
>  #define RESET_PENDING 1
> +#define TIMEOUT_WORK_PENDING 2
>  #define ACTIVATION_THRSHLD 4 /* 4 IOs */
>  #define EVICTION_THRSHLD (ACTIVATION_THRSHLD << 6) /* 256 IOs */
> +#define READ_TO_MS 1000
> +#define READ_TO_EXPIRIES 100
> +#define POLLING_INTERVAL_MS 200
>  
>  /* memory management */
>  static struct kmem_cache *ufshpb_mctx_cache;
> @@ -671,12 +675,69 @@ static int ufshpb_check_srgns_issue_state(struct ufshpb_lu *hpb,
>  	return 0;
>  }
>  
> +static void ufshpb_read_to_handler(struct work_struct *work)
> +{
> +	struct delayed_work *dwork = to_delayed_work(work);
> +	struct ufshpb_lu *hpb;
> +	struct victim_select_info *lru_info;
> +	struct ufshpb_region *rgn, *next_rgn;
> +	unsigned long flags;
> +	LIST_HEAD(expired_list);
> +
> +	hpb = container_of(dwork, struct ufshpb_lu, ufshpb_read_to_work);
> +
> +	if (test_and_set_bit(TIMEOUT_WORK_PENDING, &hpb->work_data_bits))
> +		return;
> +
> +	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> +
> +	lru_info = &hpb->lru_info;
> +
> +	list_for_each_entry_safe(rgn, next_rgn, &lru_info->lh_lru_rgn,
> +				 list_lru_rgn) {
> +		bool timedout = ktime_after(ktime_get(), rgn->read_timeout);
> +		bool dirty, expired;
> +
> +		if (!timedout)
> +			continue;
> +
> +		dirty = is_rgn_dirty(rgn);
> +		expired = atomic_dec_and_test(&rgn->read_timeout_expiries);
> +
> +		if (dirty || expired)
> +			list_add(&rgn->list_expired_rgn, &expired_list);
> +		else
> +			rgn->read_timeout = ktime_add_ms(ktime_get(),
> +							 READ_TO_MS);
> +	}
> +
> +	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +
> +	list_for_each_entry_safe(rgn, next_rgn, &expired_list,
> +				 list_expired_rgn) {
> +		list_del_init(&rgn->list_expired_rgn);
> +		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> +		ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
> +		hpb->stats.rb_inactive_cnt++;
> +		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> +	}
> +
> +	clear_bit(TIMEOUT_WORK_PENDING, &hpb->work_data_bits);
> +
> +	schedule_delayed_work(&hpb->ufshpb_read_to_work,
> +			      msecs_to_jiffies(POLLING_INTERVAL_MS));
> +}
> +
>  static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
> -				       struct ufshpb_region *rgn)
> +				struct ufshpb_region *rgn)
>  {
>  	rgn->rgn_state = HPB_RGN_ACTIVE;
>  	list_add_tail(&rgn->list_lru_rgn, &lru_info->lh_lru_rgn);
>  	atomic_inc(&lru_info->active_cnt);
> +	if (ufshpb_mode == HPB_HOST_CONTROL) {
> +		rgn->read_timeout = ktime_add_ms(ktime_get(), READ_TO_MS);
> +		atomic_set(&rgn->read_timeout_expiries, READ_TO_EXPIRIES);
> +	}
>  }
>  
>  static void ufshpb_hit_lru_info(struct victim_select_info *lru_info,
> @@ -1404,6 +1465,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
>  
>  		INIT_LIST_HEAD(&rgn->list_inact_rgn);
>  		INIT_LIST_HEAD(&rgn->list_lru_rgn);
> +		INIT_LIST_HEAD(&rgn->list_expired_rgn);
>  
>  		if (rgn_idx == hpb->rgns_per_lu - 1)
>  			srgn_cnt = ((hpb->srgns_per_lu - 1) %
> @@ -1536,6 +1598,8 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
>  			  ufshpb_normalization_work_handler);
>  		INIT_WORK(&hpb->ufshpb_lun_reset_work,
>  			  ufshpb_reset_work_handler);
> +		INIT_DELAYED_WORK(&hpb->ufshpb_read_to_work,
> +				  ufshpb_read_to_handler);
>  	}
>  
>  	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
> @@ -1562,6 +1626,10 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
>  
>  	ufshpb_stat_init(hpb);
>  
> +	if (ufshpb_mode == HPB_HOST_CONTROL)
> +		schedule_delayed_work(&hpb->ufshpb_read_to_work,
> +				      msecs_to_jiffies(POLLING_INTERVAL_MS));
> +
>  	return 0;
>  
>  release_m_page_cache:
> @@ -1624,6 +1692,7 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
>  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
>  {
>  	if (ufshpb_mode == HPB_HOST_CONTROL) {
> +		cancel_delayed_work_sync(&hpb->ufshpb_read_to_work);
>  		cancel_work_sync(&hpb->ufshpb_lun_reset_work);
>  		cancel_work_sync(&hpb->ufshpb_normalization_work);
>  	}
> @@ -1734,6 +1803,10 @@ void ufshpb_resume(struct ufs_hba *hba)
>  			continue;
>  		ufshpb_set_state(hpb, HPB_PRESENT);
>  		ufshpb_kick_map_work(hpb);
> +		if (ufshpb_mode == HPB_HOST_CONTROL)
> +			schedule_delayed_work(&hpb->ufshpb_read_to_work,
> +				msecs_to_jiffies(POLLING_INTERVAL_MS));
> +
>  	}
>  }
>  
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index 4bf77169af00..86c16a4127bd 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -121,6 +121,12 @@ struct ufshpb_region {
>  
>  	/* region reads - for host mode */
>  	atomic64_t reads;
> +
> +	/* region "cold" timer - for host mode */
> +	ktime_t read_timeout;
> +	atomic_t read_timeout_expiries;

Why does this have to be an atomic when you have a lock to protect this
structure already taken?

thanks,

greg k-h
