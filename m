Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA1EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 09:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 297FB64E81
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 09:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhCOJgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 05:36:45 -0400
Received: from m42-2.mailgun.net ([69.72.42.2]:59320 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhCOJgm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Mar 2021 05:36:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615801002; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=lLf6xLv6j6kjmGnZxe7LXmYbE7Y8IzEhAXO3Hf+8ZBM=;
 b=LMEMIcHA+262a69F2LTMNx2darHLtMHPsRVt2BPOWaDlSSMrGkrHUKwxeZZLJpxFVhWDzFGK
 DmtBNnzoFy9uqP4ONdWqstCad2ZTBDCTxIF2B2cfUCe2er9pV9I31IfmDNnv6rrjroqKe14i
 ufuF2ro4E+FADWO8oOz4+SN9weg=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 604f2a9f3f267701a4762bfa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 15 Mar 2021 09:36:31
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D6DC4C433C6; Mon, 15 Mar 2021 09:36:31 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0D9A4C433CA;
        Mon, 15 Mar 2021 09:36:28 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 15 Mar 2021 17:36:28 +0800
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
Subject: Re: [PATCH v5 07/10] scsi: ufshpb: Add "Cold" regions timer
In-Reply-To: <20210302132503.224670-8-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-8-avri.altman@wdc.com>
Message-ID: <be5c0c390d7c0cf13e67f51cdc7dd8c2@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-02 21:25, Avri Altman wrote:
> In order not to hang on to “cold” regions, we shall inactivate a
> region that has no READ access for a predefined amount of time -
> READ_TO_MS. For that purpose we shall monitor the active regions list,
> polling it on every POLLING_INTERVAL_MS. On timeout expiry we shall add
> the region to the "to-be-inactivated" list, unless it is clean and did
> not exhaust its READ_TO_EXPIRIES - another parameter.
> 
> All this does not apply to pinned regions.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 65 +++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshpb.h |  6 ++++
>  2 files changed, 71 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 0034fa03fdc6..89a930e72cff 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -18,6 +18,9 @@
> 
>  #define ACTIVATION_THRESHOLD 4 /* 4 IOs */
>  #define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 6) /* 256 IOs */
> +#define READ_TO_MS 1000
> +#define READ_TO_EXPIRIES 100
> +#define POLLING_INTERVAL_MS 200
> 
>  /* memory management */
>  static struct kmem_cache *ufshpb_mctx_cache;
> @@ -1024,12 +1027,61 @@ static int
> ufshpb_check_srgns_issue_state(struct ufshpb_lu *hpb,
>  	return 0;
>  }
> 
> +static void ufshpb_read_to_handler(struct work_struct *work)
> +{
> +	struct delayed_work *dwork = to_delayed_work(work);
> +	struct ufshpb_lu *hpb;
> +	struct victim_select_info *lru_info;
> +	struct ufshpb_region *rgn;
> +	unsigned long flags;
> +	LIST_HEAD(expired_list);
> +
> +	hpb = container_of(dwork, struct ufshpb_lu, ufshpb_read_to_work);
> +
> +	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> +
> +	lru_info = &hpb->lru_info;
> +
> +	list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn) {
> +		bool timedout = ktime_after(ktime_get(), rgn->read_timeout);
> +
> +		if (timedout) {
> +			rgn->read_timeout_expiries--;
> +			if (is_rgn_dirty(rgn) ||
> +			    rgn->read_timeout_expiries == 0)
> +				list_add(&rgn->list_expired_rgn, &expired_list);
> +			else
> +				rgn->read_timeout = ktime_add_ms(ktime_get(),
> +							 READ_TO_MS);
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +
> +	list_for_each_entry(rgn, &expired_list, list_expired_rgn) {

Here can be problematic - since you don't have the native expired_list 
initialized
before use, if above loop did not insert anything to expired_list, it 
shall become
a dead loop here.

And, which lock is protecting rgn->list_expired_rgn? If two 
read_to_handler works
are running in parallel, one can be inserting it to its expired_list 
while another
can be deleting it.

Can Guo.

> +		list_del_init(&rgn->list_expired_rgn);
> +		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> +		ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
> +		hpb->stats.rb_inactive_cnt++;
> +		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
> +	}
> +
> +	ufshpb_kick_map_work(hpb);
> +
> +	schedule_delayed_work(&hpb->ufshpb_read_to_work,
> +			      msecs_to_jiffies(POLLING_INTERVAL_MS));
> +}
> +
>  static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
>  				struct ufshpb_region *rgn)
>  {
>  	rgn->rgn_state = HPB_RGN_ACTIVE;
>  	list_add_tail(&rgn->list_lru_rgn, &lru_info->lh_lru_rgn);
>  	atomic_inc(&lru_info->active_cnt);
> +	if (rgn->hpb->is_hcm) {
> +		rgn->read_timeout = ktime_add_ms(ktime_get(), READ_TO_MS);
> +		rgn->read_timeout_expiries = READ_TO_EXPIRIES;
> +	}
>  }
> 
>  static void ufshpb_hit_lru_info(struct victim_select_info *lru_info,
> @@ -1813,6 +1865,7 @@ static int ufshpb_alloc_region_tbl(struct
> ufs_hba *hba, struct ufshpb_lu *hpb)
> 
>  		INIT_LIST_HEAD(&rgn->list_inact_rgn);
>  		INIT_LIST_HEAD(&rgn->list_lru_rgn);
> +		INIT_LIST_HEAD(&rgn->list_expired_rgn);
> 
>  		if (rgn_idx == hpb->rgns_per_lu - 1) {
>  			srgn_cnt = ((hpb->srgns_per_lu - 1) %
> @@ -1834,6 +1887,7 @@ static int ufshpb_alloc_region_tbl(struct
> ufs_hba *hba, struct ufshpb_lu *hpb)
>  		}
> 
>  		rgn->rgn_flags = 0;
> +		rgn->hpb = hpb;
>  	}
> 
>  	return 0;
> @@ -2053,6 +2107,8 @@ static int ufshpb_lu_hpb_init(struct ufs_hba
> *hba, struct ufshpb_lu *hpb)
>  			  ufshpb_normalization_work_handler);
>  		INIT_WORK(&hpb->ufshpb_lun_reset_work,
>  			  ufshpb_reset_work_handler);
> +		INIT_DELAYED_WORK(&hpb->ufshpb_read_to_work,
> +				  ufshpb_read_to_handler);
>  	}
> 
>  	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
> @@ -2087,6 +2143,10 @@ static int ufshpb_lu_hpb_init(struct ufs_hba
> *hba, struct ufshpb_lu *hpb)
>  	ufshpb_stat_init(hpb);
>  	ufshpb_param_init(hpb);
> 
> +	if (hpb->is_hcm)
> +		schedule_delayed_work(&hpb->ufshpb_read_to_work,
> +				      msecs_to_jiffies(POLLING_INTERVAL_MS));
> +
>  	return 0;
> 
>  release_pre_req_mempool:
> @@ -2154,6 +2214,7 @@ static void ufshpb_discard_rsp_lists(struct
> ufshpb_lu *hpb)
>  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
>  {
>  	if (hpb->is_hcm) {
> +		cancel_delayed_work_sync(&hpb->ufshpb_read_to_work);
>  		cancel_work_sync(&hpb->ufshpb_lun_reset_work);
>  		cancel_work_sync(&hpb->ufshpb_normalization_work);
>  	}
> @@ -2264,6 +2325,10 @@ void ufshpb_resume(struct ufs_hba *hba)
>  			continue;
>  		ufshpb_set_state(hpb, HPB_PRESENT);
>  		ufshpb_kick_map_work(hpb);
> +		if (hpb->is_hcm)
> +			schedule_delayed_work(&hpb->ufshpb_read_to_work,
> +				msecs_to_jiffies(POLLING_INTERVAL_MS));
> +
>  	}
>  }
> 
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index 37c1b0ea0c0a..b49e9a34267f 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -109,6 +109,7 @@ struct ufshpb_subregion {
>  };
> 
>  struct ufshpb_region {
> +	struct ufshpb_lu *hpb;
>  	struct ufshpb_subregion *srgn_tbl;
>  	enum HPB_RGN_STATE rgn_state;
>  	int rgn_idx;
> @@ -126,6 +127,10 @@ struct ufshpb_region {
>  	/* region reads - for host mode */
>  	spinlock_t rgn_lock;
>  	unsigned int reads;
> +	/* region "cold" timer - for host mode */
> +	ktime_t read_timeout;
> +	unsigned int read_timeout_expiries;
> +	struct list_head list_expired_rgn;
>  };
> 
>  #define for_each_sub_region(rgn, i, srgn)				\
> @@ -219,6 +224,7 @@ struct ufshpb_lu {
>  	struct victim_select_info lru_info;
>  	struct work_struct ufshpb_normalization_work;
>  	struct work_struct ufshpb_lun_reset_work;
> +	struct delayed_work ufshpb_read_to_work;
> 
>  	/* pinned region information */
>  	u32 lu_pinned_start;
