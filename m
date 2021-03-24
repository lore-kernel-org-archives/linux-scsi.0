Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12111C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 03:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEFEA619E9
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 03:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbhCXDbr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 23:31:47 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3380 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbhCXDbP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 23:31:15 -0400
Received: from dggeme759-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4F4txP5hCVz5fjd;
        Wed, 24 Mar 2021 11:28:41 +0800 (CST)
Received: from shaphisprc48410 (100.108.177.173) by
 dggeme759-chm.china.huawei.com (10.3.19.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Wed, 24 Mar 2021 11:31:11 +0800
Date:   Wed, 24 Mar 2021 03:31:04 +0000
From:   Zang Leigang <zangleigang@hisilicon.com>
To:     Avri Altman <avri.altman@wdc.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        <alim.akhtar@samsung.com>, <asutoshd@codeaurora.org>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, <cang@codeaurora.org>,
        <stanley.chu@mediatek.com>
Subject: Re: [PATCH v6 02/10] scsi: ufshpb: Add host control mode support to
 rsp_upiu
Message-ID: <20210324033104.5kms7pez6arnkaoz@shaphisprc48410>
References: <20210322081044.62003-1-avri.altman@wdc.com>
 <20210322081044.62003-3-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210322081044.62003-3-avri.altman@wdc.com>
User-Agent: NeoMutt/20171215
X-Originating-IP: [100.108.177.173]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggeme759-chm.china.huawei.com (10.3.19.105)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 22, 2021 at 10:10:36AM +0200, Avri Altman wrote:
> In device control mode, the device may recommend the host to either
> activate or inactivate a region, and the host should follow. Meaning
> those are not actually recommendations, but more of instructions.
> 
> On the contrary, in host control mode, the recommendation protocol is
> slightly changed:
> a) The device may only recommend the host to update a subregion of an
>    already-active region. And,
> b) The device may *not* recommend to inactivate a region.
> 
> Furthermore, in host control mode, the host may choose not to follow any
> of the device's recommendations. However, in case of a recommendation to
> update an active and clean subregion, it is better to follow those
> recommendation because otherwise the host has no other way to know that
> some internal relocation took place.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 34 +++++++++++++++++++++++++++++++++-
>  drivers/scsi/ufs/ufshpb.h |  2 ++
>  2 files changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index fb10afcbb49f..d4f0bb6d8fa1 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -166,6 +166,8 @@ static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
>  	else
>  		set_bit_len = cnt;
>  
> +	set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
> +
>  	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
>  	    srgn->srgn_state == HPB_SRGN_VALID)
>  		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
> @@ -235,6 +237,11 @@ static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
>  	return false;
>  }
>  
> +static inline bool is_rgn_dirty(struct ufshpb_region *rgn)
> +{
> +	return test_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
> +}
> +
>  static int ufshpb_fill_ppn_from_page(struct ufshpb_lu *hpb,
>  				     struct ufshpb_map_ctx *mctx, int pos,
>  				     int len, u64 *ppn_buf)
> @@ -713,6 +720,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
>  static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
>  				     struct ufshpb_subregion *srgn)
>  {
> +	struct ufshpb_region *rgn;
>  	u32 num_entries = hpb->entries_per_srgn;
>  
>  	if (!srgn->mctx) {
> @@ -726,6 +734,10 @@ static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
>  		num_entries = hpb->last_srgn_entries;
>  
>  	bitmap_zero(srgn->mctx->ppn_dirty, num_entries);
> +
> +	rgn = hpb->rgn_tbl + srgn->rgn_idx;
> +	clear_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
> +
>  	return 0;
>  }
>  
> @@ -1245,6 +1257,18 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
>  		srgn_i =
>  			be16_to_cpu(rsp_field->hpb_active_field[i].active_srgn);
>  
> +		rgn = hpb->rgn_tbl + rgn_i;
> +		if (hpb->is_hcm &&
> +		    (rgn->rgn_state != HPB_RGN_ACTIVE || is_rgn_dirty(rgn))) {
> +			/*
> +			 * in host control mode, subregion activation
> +			 * recommendations are only allowed to active regions.
> +			 * Also, ignore recommendations for dirty regions - the
> +			 * host will make decisions concerning those by himself
> +			 */
> +			continue;
> +		}
> +

Hi Avri, host control mode also need the recommendations from device,
because the bkops would make the ppn invalid, is that right?

>  		dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
>  			"activate(%d) region %d - %d\n", i, rgn_i, srgn_i);
>  
> @@ -1252,7 +1276,6 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
>  		ufshpb_update_active_info(hpb, rgn_i, srgn_i);
>  		spin_unlock(&hpb->rsp_list_lock);
>  
> -		rgn = hpb->rgn_tbl + rgn_i;
>  		srgn = rgn->srgn_tbl + srgn_i;
>  
>  		/* blocking HPB_READ */
> @@ -1263,6 +1286,14 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
>  		hpb->stats.rb_active_cnt++;
>  	}
>  
> +	if (hpb->is_hcm) {
> +		/*
> +		 * in host control mode the device is not allowed to inactivate
> +		 * regions
> +		 */
> +		goto out;
> +	}
> +
>  	for (i = 0; i < rsp_field->inactive_rgn_cnt; i++) {
>  		rgn_i = be16_to_cpu(rsp_field->hpb_inactive_field[i]);
>  		dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
> @@ -1287,6 +1318,7 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
>  		hpb->stats.rb_inactive_cnt++;
>  	}
>  
> +out:
>  	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "Noti: #ACT %u #INACT %u\n",
>  		rsp_field->active_rgn_cnt, rsp_field->inactive_rgn_cnt);
>  
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index 7df30340386a..032672114881 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -121,6 +121,8 @@ struct ufshpb_region {
>  
>  	/* below information is used by lru */
>  	struct list_head list_lru_rgn;
> +	unsigned long rgn_flags;
> +#define RGN_FLAG_DIRTY 0
>  };
>  
>  #define for_each_sub_region(rgn, i, srgn)				\
> -- 
> 2.25.1
> 
