Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BBBC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1919613B8
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243638AbhDFExk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:53:40 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:48050 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242526AbhDFExj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 00:53:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617684812; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=szNNeiCS/kTAolvAUSHi359xelGhpdkFDg5SZbfmdC0=;
 b=hkgKNvZP/iwjHyOAonZ6sVSSdqd6yW1y+is61YPlef6jJvdqxsOc4xzvWIR0LxT/v9uNzrgm
 TBIfIctkv0m2OKSSXMrmfdaWnqxrZ6wHLhmDxbKSQqiVdb1yZZGL80/V3/f7DuM7I6t9vw1x
 UGLxgkJFlfU+FAy0B9hq/GwFWSg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 606be94c03cfff3452a817aa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 06 Apr 2021 04:53:32
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6A1E3C433ED; Tue,  6 Apr 2021 04:53:31 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D918DC433CA;
        Tue,  6 Apr 2021 04:53:29 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 06 Apr 2021 12:53:29 +0800
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
Subject: Re: [PATCH v7 06/11] scsi: ufshpb: Region inactivation in host mode
In-Reply-To: <20210331073952.102162-7-avri.altman@wdc.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
 <20210331073952.102162-7-avri.altman@wdc.com>
Message-ID: <e29e33769f23036f936a6b60c7430387@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-31 15:39, Avri Altman wrote:
> In host mode, the host is expected to send HPB-WRITE-BUFFER with
> buffer-id = 0x1 when it inactivates a region.
> 
> Use the map-requests pool as there is no point in assigning a
> designated cache for umap-requests.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 35 +++++++++++++++++++++++++++++++----
>  drivers/scsi/ufs/ufshpb.h |  1 +
>  2 files changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index aefb6dc160ee..fcc954f51bcf 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -914,6 +914,7 @@ static int ufshpb_execute_umap_req(struct ufshpb_lu 
> *hpb,
> 
>  	blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
> 
> +	hpb->stats.umap_req_cnt++;
>  	return 0;
>  }
> 
> @@ -1110,18 +1111,37 @@ static int ufshpb_issue_umap_req(struct 
> ufshpb_lu *hpb,
>  	return -EAGAIN;
>  }
> 
> +static int ufshpb_issue_umap_single_req(struct ufshpb_lu *hpb,
> +					struct ufshpb_region *rgn)
> +{
> +	return ufshpb_issue_umap_req(hpb, rgn);
> +}
> +
>  static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
>  {
>  	return ufshpb_issue_umap_req(hpb, NULL);
>  }
> 
> -static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
> -				  struct ufshpb_region *rgn)
> +static int __ufshpb_evict_region(struct ufshpb_lu *hpb,
> +				 struct ufshpb_region *rgn)
>  {
>  	struct victim_select_info *lru_info;
>  	struct ufshpb_subregion *srgn;
>  	int srgn_idx;
> 
> +	lockdep_assert_held(&hpb->rgn_state_lock);
> +
> +	if (hpb->is_hcm) {
> +		unsigned long flags;
> +		int ret;
> +
> +		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);

Never seen a usage like this... Here flags is used without being 
intialized.
The flag is needed when spin_unlock_irqrestore -> 
local_irq_restore(flags) to
restore the DAIF register (in terms of ARM).

Thanks,

Can Guo.

> +		ret = ufshpb_issue_umap_single_req(hpb, rgn);
> +		spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	lru_info = &hpb->lru_info;
> 
>  	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n", 
> rgn->rgn_idx);
> @@ -1130,6 +1150,8 @@ static void __ufshpb_evict_region(struct 
> ufshpb_lu *hpb,
> 
>  	for_each_sub_region(rgn, srgn_idx, srgn)
>  		ufshpb_purge_active_subregion(hpb, srgn);
> +
> +	return 0;
>  }
> 
>  static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct
> ufshpb_region *rgn)
> @@ -1151,7 +1173,7 @@ static int ufshpb_evict_region(struct ufshpb_lu
> *hpb, struct ufshpb_region *rgn)
>  			goto out;
>  		}
> 
> -		__ufshpb_evict_region(hpb, rgn);
> +		ret = __ufshpb_evict_region(hpb, rgn);
>  	}
>  out:
>  	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> @@ -1285,7 +1307,9 @@ static int ufshpb_add_region(struct ufshpb_lu
> *hpb, struct ufshpb_region *rgn)
>  				"LRU full (%d), choose victim %d\n",
>  				atomic_read(&lru_info->active_cnt),
>  				victim_rgn->rgn_idx);
> -			__ufshpb_evict_region(hpb, victim_rgn);
> +			ret = __ufshpb_evict_region(hpb, victim_rgn);
> +			if (ret)
> +				goto out;
>  		}
> 
>  		/*
> @@ -1856,6 +1880,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
>  ufshpb_sysfs_attr_show_func(rb_active_cnt);
>  ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
>  ufshpb_sysfs_attr_show_func(map_req_cnt);
> +ufshpb_sysfs_attr_show_func(umap_req_cnt);
> 
>  static struct attribute *hpb_dev_stat_attrs[] = {
>  	&dev_attr_hit_cnt.attr,
> @@ -1864,6 +1889,7 @@ static struct attribute *hpb_dev_stat_attrs[] = {
>  	&dev_attr_rb_active_cnt.attr,
>  	&dev_attr_rb_inactive_cnt.attr,
>  	&dev_attr_map_req_cnt.attr,
> +	&dev_attr_umap_req_cnt.attr,
>  	NULL,
>  };
> 
> @@ -1988,6 +2014,7 @@ static void ufshpb_stat_init(struct ufshpb_lu 
> *hpb)
>  	hpb->stats.rb_active_cnt = 0;
>  	hpb->stats.rb_inactive_cnt = 0;
>  	hpb->stats.map_req_cnt = 0;
> +	hpb->stats.umap_req_cnt = 0;
>  }
> 
>  static void ufshpb_param_init(struct ufshpb_lu *hpb)
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index 87495e59fcf1..1ea58c17a4de 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -191,6 +191,7 @@ struct ufshpb_stats {
>  	u64 rb_inactive_cnt;
>  	u64 map_req_cnt;
>  	u64 pre_req_cnt;
> +	u64 umap_req_cnt;
>  };
> 
>  struct ufshpb_lu {
