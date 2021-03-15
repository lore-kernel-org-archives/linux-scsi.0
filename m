Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EAFEC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 08:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7484864E98
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 08:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhCOIb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 04:31:57 -0400
Received: from z11.mailgun.us ([104.130.96.11]:41561 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbhCOIbX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Mar 2021 04:31:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615797083; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=6sAJztk8VeY5vdyxWEOgHKZBVT2GTUCfpMZSijJe5uQ=;
 b=miE17Zfp7mHCCPvqYD+HZevG/JZZtco3uqBvahGl7oAlvYYR2Yq3nD0vRA8zNxSlRNbFzNE/
 Lsqf+IzuzQvnBIcnoOe2A4gYKYOfuEqSW2/z8cBmRdnzboQkGfkSzeYVnJnfgH0RP7Zzt5/c
 FCpxombvV661AXshqTayDWEAYvo=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 604f1b4de2200c0a0d3d3f41 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 15 Mar 2021 08:31:09
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 107D3C43464; Mon, 15 Mar 2021 08:31:08 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1157DC433CA;
        Mon, 15 Mar 2021 08:31:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Mar 2021 16:31:08 +0800
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
Subject: Re: [PATCH v5 08/10] scsi: ufshpb: Limit the number of inflight map
 requests
In-Reply-To: <20210302132503.224670-9-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-9-avri.altman@wdc.com>
Message-ID: <b71279bee1cc9b2ffba5e4f8c90fdce9@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-02 21:25, Avri Altman wrote:
> in host control mode the host is the originator of map requests. To not

in -> In

Thanks,
Can Guo.

> flood the device with map requests, use a simple throttling mechanism
> that limits the number of inflight map requests.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 11 +++++++++++
>  drivers/scsi/ufs/ufshpb.h |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 89a930e72cff..74da69727340 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -21,6 +21,7 @@
>  #define READ_TO_MS 1000
>  #define READ_TO_EXPIRIES 100
>  #define POLLING_INTERVAL_MS 200
> +#define THROTTLE_MAP_REQ_DEFAULT 1
> 
>  /* memory management */
>  static struct kmem_cache *ufshpb_mctx_cache;
> @@ -750,6 +751,14 @@ static struct ufshpb_req
> *ufshpb_get_map_req(struct ufshpb_lu *hpb,
>  	struct ufshpb_req *map_req;
>  	struct bio *bio;
> 
> +	if (hpb->is_hcm &&
> +	    hpb->num_inflight_map_req >= THROTTLE_MAP_REQ_DEFAULT) {
> +		dev_info(&hpb->sdev_ufs_lu->sdev_dev,
> +			 "map_req throttle. inflight %d throttle %d",
> +			 hpb->num_inflight_map_req, THROTTLE_MAP_REQ_DEFAULT);
> +		return NULL;
> +	}
> +
>  	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN);
>  	if (!map_req)
>  		return NULL;
> @@ -764,6 +773,7 @@ static struct ufshpb_req
> *ufshpb_get_map_req(struct ufshpb_lu *hpb,
> 
>  	map_req->rb.srgn_idx = srgn->srgn_idx;
>  	map_req->rb.mctx = srgn->mctx;
> +	hpb->num_inflight_map_req++;
> 
>  	return map_req;
>  }
> @@ -773,6 +783,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu 
> *hpb,
>  {
>  	bio_put(map_req->bio);
>  	ufshpb_put_req(hpb, map_req);
> +	hpb->num_inflight_map_req--;
>  }
> 
>  static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index b49e9a34267f..d83ab488688a 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -212,6 +212,7 @@ struct ufshpb_lu {
>  	struct ufshpb_req *pre_req;
>  	int num_inflight_pre_req;
>  	int throttle_pre_req;
> +	int num_inflight_map_req;
>  	struct list_head lh_pre_req_free;
>  	int cur_read_id;
>  	int pre_req_min_tr_len;
