Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592BAC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 08:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04A5864EAE
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 08:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhCKIV1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:21:27 -0500
Received: from z11.mailgun.us ([104.130.96.11]:40336 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231549AbhCKIVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 03:21:17 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615450876; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=FcBNlfOXSoNxm2y83jgoG0XJMJEpboYwvXHkJwO65uM=;
 b=l/wr7ak9QGs/lnoTQST+5+8NTXVwciOPFb7v6hHKNrktre17N6eK6Bgy2bvT+2n7BKQigifD
 P421+DeSKsG3FKtQTE8eV5PiNdOuyOsZj9mdecqWMFCUx4f/Utjt+oUrEzrfBxqZo7ERHZ+H
 we5cZOiMJfqZ0LOlk6Ai6P09fQA=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 6049d2e76e1c22bc8dbd9ea3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 11 Mar 2021 08:20:55
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D2284C43461; Thu, 11 Mar 2021 08:20:55 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1D7A5C43465;
        Thu, 11 Mar 2021 08:20:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 11 Mar 2021 16:20:53 +0800
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
Subject: Re: [PATCH v5 05/10] scsi: ufshpb: Region inactivation in host mode
In-Reply-To: <20210302132503.224670-6-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-6-avri.altman@wdc.com>
Message-ID: <8c2b310299c0ca57bfd445cfca87fb28@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-02 21:24, Avri Altman wrote:
> I host mode, the host is expected to send HPB-WRITE-BUFFER with

In host mode,

> buffer-id = 0x1 when it inactivates a region.
> 
> Use the map-requests pool as there is no point in assigning a
> designated cache for umap-requests.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 14 ++++++++++++++
>  drivers/scsi/ufs/ufshpb.h |  1 +
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 6f4fd22eaf2f..0744feb4d484 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -907,6 +907,7 @@ static int ufshpb_execute_umap_req(struct ufshpb_lu 
> *hpb,
> 
>  	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_umap_req_compl_fn);
> 
> +	hpb->stats.umap_req_cnt++;
>  	return 0;
>  }
> 
> @@ -1103,6 +1104,12 @@ static int ufshpb_issue_umap_req(struct 
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
> @@ -1115,6 +1122,10 @@ static void __ufshpb_evict_region(struct 
> ufshpb_lu *hpb,
>  	struct ufshpb_subregion *srgn;
>  	int srgn_idx;
> 
> +

No need of this blank line.

Regards,
Can Guo.

> +	if (hpb->is_hcm && ufshpb_issue_umap_single_req(hpb, rgn))
> +		return;
> +
>  	lru_info = &hpb->lru_info;
> 
>  	dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n", 
> rgn->rgn_idx);
> @@ -1855,6 +1866,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
>  ufshpb_sysfs_attr_show_func(rb_active_cnt);
>  ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
>  ufshpb_sysfs_attr_show_func(map_req_cnt);
> +ufshpb_sysfs_attr_show_func(umap_req_cnt);
> 
>  static struct attribute *hpb_dev_stat_attrs[] = {
>  	&dev_attr_hit_cnt.attr,
> @@ -1863,6 +1875,7 @@ static struct attribute *hpb_dev_stat_attrs[] = {
>  	&dev_attr_rb_active_cnt.attr,
>  	&dev_attr_rb_inactive_cnt.attr,
>  	&dev_attr_map_req_cnt.attr,
> +	&dev_attr_umap_req_cnt.attr,
>  	NULL,
>  };
> 
> @@ -1978,6 +1991,7 @@ static void ufshpb_stat_init(struct ufshpb_lu 
> *hpb)
>  	hpb->stats.rb_active_cnt = 0;
>  	hpb->stats.rb_inactive_cnt = 0;
>  	hpb->stats.map_req_cnt = 0;
> +	hpb->stats.umap_req_cnt = 0;
>  }
> 
>  static void ufshpb_param_init(struct ufshpb_lu *hpb)
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index bd4308010466..84598a317897 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -186,6 +186,7 @@ struct ufshpb_stats {
>  	u64 rb_inactive_cnt;
>  	u64 map_req_cnt;
>  	u64 pre_req_cnt;
> +	u64 umap_req_cnt;
>  };
> 
>  struct ufshpb_lu {
