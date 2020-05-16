Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8411DC433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 02:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C9FF207C3
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 02:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgEPCNf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 22:13:35 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53888 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgEPCNe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 22:13:34 -0400
Received: by mail-pj1-f66.google.com with SMTP id hi11so1725625pjb.3;
        Fri, 15 May 2020 19:13:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4A1yJQWH0zlW7qYrgn5UB7I/2Jue1bZ9pkew6X207TM=;
        b=AvZ7Q4j4h+cKqMg+rSeD3GB8n2Ftt42VFvpOq6YBCOZPshJTNYk0ZbBPgprRmGr7jD
         lqm0e+rsf5jLA9jYAkR7Zu68y+bYbay4e6PSgD7r9cRBBFH8w91O+pk8wAIcmVm6TXpQ
         yAuTNCWB3M1LIRliSb5NZYjxrOtNQaTGpT+ncQA7Fjzr4YxKENf0OH36qLlxRxS/hfIM
         mTl+TiVx0E1qZT5QkUSiVF2cyEQb3c4h0TpgX8T7Fv6bezovooea0QukLBmDl3BG1H5m
         Gs+M569pufPPs/SjxWFqr+V5r/dQmwNqqN1l0aTcgJ3EGRP+CcjItcwfN7/dIcqu4SqV
         tHHA==
X-Gm-Message-State: AOAM5334i2j2PTtnLXsnaIPpcZegr39K3c6ToskCC/zDGSKzhoSlPIRV
        DISjzShpAToY0ActbYRHDSI=
X-Google-Smtp-Source: ABdhPJyYPlqyuINHfKCvbHNeyyGJJpZhkPWeb9Y7RWy4Fh1Pew4OKmCYnY1iZT2Aeye1QahSPuX+Xg==
X-Received: by 2002:a17:90a:71c3:: with SMTP id m3mr2825793pjs.17.1589595212441;
        Fri, 15 May 2020 19:13:32 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f99a:ee92:9332:42a? ([2601:647:4000:d7:f99a:ee92:9332:42a])
        by smtp.gmail.com with ESMTPSA id v1sm2721182pgl.11.2020.05.15.19.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 19:13:31 -0700 (PDT)
Subject: Re: [RFC PATCH 06/13] scsi: scsi_dh: ufshpb: Prepare for L2P cache
 management
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <1589538614-24048-7-git-send-email-avri.altman@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <953f883a-1911-7de9-3b72-477a03a01222@acm.org>
Date:   Fri, 15 May 2020 19:13:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589538614-24048-7-git-send-email-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-15 03:30, Avri Altman wrote:
> +static int ufshpb_mempool_init(struct ufshpb_dh_lun *hpb)
> +{
> +	unsigned int max_active_subregions = hpb->max_active_regions *
> +		subregions_per_region;
> +	int i;
> +
> +	INIT_LIST_HEAD(&hpb->lh_map_ctx);
> +	spin_lock_init(&hpb->map_list_lock);
> +
> +	for (i = 0 ; i < max_active_subregions; i++) {
> +		struct ufshpb_map_ctx *mctx =
> +			kzalloc(sizeof(struct ufshpb_map_ctx), GFP_KERNEL);
> +
> +		if (!mctx) {
> +			/*
> +			 * mctxs already added in lh_map_ctx will be removed in
> +			 * detach
> +			 */
> +			return -ENOMEM;
> +		}
> +
> +		/* actual page allocation is done upon subregion activation */
> +
> +		INIT_LIST_HEAD(&mctx->list);
> +		list_add(&mctx->list, &hpb->lh_map_ctx);
> +	}
> +
> +	return 0;
> +
> +}

Could kmem_cache_create() have been used instead of implementing yet
another memory pool implementation?

> +static int ufshpb_region_tbl_init(struct ufshpb_dh_lun *hpb)
> +{
> +	struct ufshpb_region *regions;
> +	int i, j;
> +
> +	regions = kcalloc(hpb->regions_per_lun, sizeof(*regions), GFP_KERNEL);
> +	if (!regions)
> +		return -ENOMEM;
> +
> +	atomic_set(&hpb->active_regions, 0);
> +
> +	for (i = 0 ; i < hpb->regions_per_lun; i++) {
> +		struct ufshpb_region *r = regions + i;
> +		struct ufshpb_subregion *subregions;
> +
> +		subregions = kcalloc(subregions_per_region, sizeof(*subregions),
> +				     GFP_KERNEL);
> +		if (!subregions)
> +			goto release_mem;
> +
> +		for (j = 0; j < subregions_per_region; j++) {
> +			struct ufshpb_subregion *s = subregions + j;
> +
> +			s->hpb = hpb;
> +			s->r = r;
> +			s->region = i;
> +			s->subregion = j;
> +		}
> +
> +		r->subregion_tbl = subregions;
> +		r->hpb = hpb;
> +		r->region = i;
> +	}
> +
> +	hpb->region_tbl = regions;
> +
> +	return 0;

Could kvmalloc() have been used to allocate multiple subregion data
structures instead of calling kcalloc() multiple times?

> +	spin_lock(&hpb->map_list_lock);
> +
> +	list_for_each_entry_safe(mctx, next, &hpb->lh_map_ctx, list) {
> +		list_del(&mctx->list);
> +		kfree(mctx);
> +	}
> +
> +	spin_unlock(&hpb->map_list_lock);

Spinlocks should be held during a short time. I'm not sure that's the
case for the above loop.

Thanks,

Bart.
