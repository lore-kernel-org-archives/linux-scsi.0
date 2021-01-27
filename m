Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB217C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 762552079A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbhA0PWp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:22:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235787AbhA0PWb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Jan 2021 10:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74B1F20771;
        Wed, 27 Jan 2021 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611760910;
        bh=2uev51IdAE8vxEsn947bFchQg5iNHuHTtd62e1j+hLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sBjzzoliSDWvHeZ6ne/FYuU7zSzzwYi0xyHPFIE6p0FSMpNL9qk/RxUGQ7DHdLo1s
         N0idasmPnw81ouJUynJbCwgW25x5DBarvIntBjUhani4hSYpIWGbxhDnjUirFd6itm
         48ykKC+rRW7opYdrcuxh9IhxLUO+9QXrF41kyX4Y=
Date:   Wed, 27 Jan 2021 16:21:47 +0100
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
Subject: Re: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Message-ID: <YBGFC+XcibjRg7Y/@kroah.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
 <20210127151217.24760-4-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210127151217.24760-4-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 27, 2021 at 05:12:12PM +0200, Avri Altman wrote:
> In host control mode, reads are the major source of activation trials.
> Keep track of those reads counters, for both active as well inactive
> regions.
> 
> We reset the read counter upon write - we are only interested in "clean"
> reads.  less intuitive however, is that we also reset it upon region's
> deactivation.  Region deactivation is often due to the fact that
> eviction took place: a region become active on the expense of another.
> This is happening when the max-active-regions limit has crossed. If we
> don’t reset the counter, we will trigger a lot of trashing of the HPB
> database, since few reads (or even one) to the region that was
> deactivated, will trigger a re-activation trial.
> 
> Keep those counters normalized, as we are using those reads as a
> comparative score, to make various decisions.
> If during consecutive normalizations an active region has exhaust its
> reads - inactivate it.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 96 +++++++++++++++++++++++++++++++++------
>  drivers/scsi/ufs/ufshpb.h |  5 ++
>  2 files changed, 86 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 5fa1f5bc08e6..51c3607166bc 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -16,6 +16,9 @@
>  #include "ufshpb.h"
>  #include "../sd.h"
>  
> +#define WORK_PENDING 0
> +#define ACTIVATION_THRSHLD 4 /* 4 IOs */
> +
>  /* memory management */
>  static struct kmem_cache *ufshpb_mctx_cache;
>  static mempool_t *ufshpb_mctx_pool;
> @@ -261,6 +264,21 @@ ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lrbp,
>  	cdb[14] = transfer_len;
>  }
>  
> +static void ufshpb_update_active_info(struct ufshpb_lu *hpb, int rgn_idx,
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
> +}
> +
>  /*
>   * This function will set up HPB read command using host-side L2P map data.
>   * In HPB v1.0, maximum size of HPB read command is 4KB.
> @@ -276,6 +294,7 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  	unsigned long flags;
>  	int transfer_len, rgn_idx, srgn_idx, srgn_offset;
>  	int err = 0;
> +	u64 reads;
>  
>  	hpb = ufshpb_get_hpb_data(cmd->device);
>  	if (!hpb)
> @@ -306,12 +325,39 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
>  				 transfer_len);
>  		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +
> +		if (ufshpb_mode == HPB_HOST_CONTROL)
> +			atomic64_set(&rgn->reads, 0);
> +
>  		return;
>  	}
>  
> +	if (ufshpb_mode == HPB_HOST_CONTROL)
> +		reads = atomic64_inc_return(&rgn->reads);
> +
>  	if (!ufshpb_is_support_chunk(transfer_len))
>  		return;
>  
> +	if (ufshpb_mode == HPB_HOST_CONTROL) {
> +		/*
> +		 * in host control mode, reads are the main source for
> +		 * activation trials.
> +		 */
> +		if (reads == ACTIVATION_THRSHLD) {
> +			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> +			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
> +			hpb->stats.rb_active_cnt++;
> +			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> +			dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
> +				"activate region %d-%d\n", rgn_idx, srgn_idx);
> +		}
> +
> +		/* keep those counters normalized */
> +		if (reads > hpb->entries_per_srgn &&
> +		    !test_and_set_bit(WORK_PENDING, &hpb->work_data_bits))
> +			schedule_work(&hpb->ufshpb_normalization_work);
> +	}
> +
>  	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
>  	if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
>  				   transfer_len)) {
> @@ -396,21 +442,6 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
>  	return 0;
>  }
>  
> -static void ufshpb_update_active_info(struct ufshpb_lu *hpb, int rgn_idx,
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
>  static void ufshpb_update_inactive_info(struct ufshpb_lu *hpb, int rgn_idx)
>  {
>  	struct ufshpb_region *rgn;
> @@ -646,6 +677,9 @@ static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
>  
>  	ufshpb_cleanup_lru_info(lru_info, rgn);
>  
> +	if (ufshpb_mode == HPB_HOST_CONTROL)
> +		atomic64_set(&rgn->reads, 0);
> +
>  	for_each_sub_region(rgn, srgn_idx, srgn)
>  		ufshpb_purge_active_subregion(hpb, srgn);
>  }
> @@ -1044,6 +1078,33 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
>  	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
>  }
>  
> +static void ufshpb_normalization_work_handler(struct work_struct *work)
> +{
> +	struct ufshpb_lu *hpb;
> +	int rgn_idx;
> +
> +	hpb = container_of(work, struct ufshpb_lu, ufshpb_normalization_work);
> +
> +	for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
> +		struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;
> +		u64 reads = atomic64_read(&rgn->reads);
> +
> +		if (reads)
> +			atomic64_set(&rgn->reads, reads >> 1);
> +
> +		if (rgn->rgn_state != HPB_RGN_ACTIVE ||
> +			atomic64_read(&rgn->reads))
> +			continue;
> +
> +		/* if region is active but has no reads - inactivate it */
> +		spin_lock(&hpb->rsp_list_lock);
> +		ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
> +		spin_unlock(&hpb->rsp_list_lock);
> +	}
> +
> +	clear_bit(WORK_PENDING, &hpb->work_data_bits);
> +}
> +
>  static void ufshpb_map_work_handler(struct work_struct *work)
>  {
>  	struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu, map_work);
> @@ -1308,6 +1369,9 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
>  	INIT_LIST_HEAD(&hpb->list_hpb_lu);
>  
>  	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
> +	if (ufshpb_mode == HPB_HOST_CONTROL)
> +		INIT_WORK(&hpb->ufshpb_normalization_work,
> +			  ufshpb_normalization_work_handler);
>  
>  	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
>  			  sizeof(struct ufshpb_req), 0, 0, NULL);
> @@ -1394,6 +1458,8 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
>  
>  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
>  {
> +	if (ufshpb_mode == HPB_HOST_CONTROL)
> +		cancel_work_sync(&hpb->ufshpb_normalization_work);
>  	cancel_work_sync(&hpb->map_work);
>  }
>  
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index 8a34b0f42754..b0e78728af38 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -115,6 +115,9 @@ struct ufshpb_region {
>  	/* below information is used by lru */
>  	struct list_head list_lru_rgn;
>  	unsigned long rgn_flags;
> +
> +	/* region reads - for host mode */
> +	atomic64_t reads;

Why do you need an atomic variable for this?  What are you trying to
"protect" here by flushing the cpus all the time?  What protects this
variable from changing right after you have read from it (hint, you do
that above...)

atomics are not race-free, use a real lock if you need that.

thanks,

greg k-h
