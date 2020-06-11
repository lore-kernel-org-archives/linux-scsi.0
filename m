Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9429C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 01:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A208F207ED
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 01:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgFKBQN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 21:16:13 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34766 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgFKBQM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 21:16:12 -0400
Received: by mail-pf1-f194.google.com with SMTP id z63so986765pfb.1;
        Wed, 10 Jun 2020 18:16:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=U2xz+clo+p+xAEQa4WAp3fVeKWpdUak8TBQN4ETuhCY=;
        b=JvKKW0jgcD3daBzwyrLY/wguTKjrSQobrDruVHk7dhAdx1K6pt2za5eoZiAoRyEYyD
         /Z4l/EJZ0golsfuboVIj6x19KWmu2+wQgaExBWpMnGYb8gAgxxL1qOzrAIcvTMq65D/O
         90ddGbGdw0+TTyPt/cakGzqMb158Zk9wUpBymWBlX06tcJz5fCsEuEf/ASxRDu61hMh1
         9/adhh8ova8oc2P2FSNlgSHE5WcHNRtrov6yWaoO3s7PjfPdV9tSWVfmYdni1+sMrhm1
         5wcQmA8/W5NdhvCz9MgjRsrz4yahm4mmwba1UAZK5qTI56Rstk0Mc+5VxhCMwWhEpM8d
         juMw==
X-Gm-Message-State: AOAM531Tl6qvxxtBzej61HxHYYookQ2VTb0ymjh/vn5y1K7FYVNrRvpe
        bTJCFNA0zpFGEm0nDlqstbo=
X-Google-Smtp-Source: ABdhPJzqWF2yPbWDLcmy623eeuT+u53nUcxLXq0Ne+zwiWQ3J8arJyeA8fFeq+u2jw1IvmQ5+UcL7w==
X-Received: by 2002:a63:9347:: with SMTP id w7mr4684819pgm.409.1591838171507;
        Wed, 10 Jun 2020 18:16:11 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v129sm1117979pfv.18.2020.06.10.18.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 18:16:10 -0700 (PDT)
Subject: Re: [RFC PATCH 4/5] scsi: ufs: L2P map management for HPB read
To:     daejun7.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
 <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
 <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
 <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
 <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p2>
 <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
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
Message-ID: <0389f9cf-fea8-9990-7699-0e4322728e4a@acm.org>
Date:   Wed, 10 Jun 2020 18:16:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-04 18:56, Daejun Park wrote:
> +static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
> +					     struct ufshpb_subregion *srgn)
> +{
> +	struct ufshpb_req *map_req;
> +	struct request *req;
> +	struct bio *bio;
> +
> +	map_req = kmem_cache_alloc(hpb->map_req_cache, GFP_KERNEL);
> +	if (!map_req)
> +		return NULL;
> +
> +	req = blk_get_request(hpb->sdev_ufs_lu->request_queue,
> +			      REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
> +	if (IS_ERR(req))
> +		goto free_map_req;
> +
> +	bio = bio_alloc(GFP_KERNEL, hpb->pages_per_srgn);
> +	if (!bio) {
> +		blk_put_request(req);
> +		goto free_map_req;
> +	}
> +
> +	map_req->hpb = hpb;
> +	map_req->req = req;
> +	map_req->bio = bio;
> +
> +	map_req->rgn_idx = srgn->rgn_idx;
> +	map_req->srgn_idx = srgn->srgn_idx;
> +	map_req->mctx = srgn->mctx;
> +	map_req->lun = hpb->lun;
> +
> +	return map_req;
> +free_map_req:
> +	kmem_cache_free(hpb->map_req_cache, map_req);
> +	return NULL;
> +}

Will blk_get_request() fail if all tags have been allocated? Can that
cause a deadlock or infinite loop?

> +static inline void ufshpb_set_read_buf_cmd(unsigned char *cdb, int rgn_idx,
> +					   int srgn_idx, int srgn_mem_size)
> +{
> +	cdb[0] = UFSHPB_READ_BUFFER;
> +	cdb[1] = UFSHPB_READ_BUFFER_ID;
> +
> +	put_unaligned_be32(srgn_mem_size, &cdb[5]);
> +	/* cdb[5] = 0x00; */
> +	put_unaligned_be16(rgn_idx, &cdb[2]);
> +	put_unaligned_be16(srgn_idx, &cdb[4]);
> +
> +	cdb[9] = 0x00;
> +}

So the put_unaligned_be32(srgn_mem_size, &cdb[5]) comes first because
the put_unaligned_be16(srgn_idx, &cdb[4]) overwrites byte cdb[5]? That
is really ugly. Please use put_unaligned_be24() instead if that is what
you meant and keep the put_*() calls in increasing cdb offset order.

> +static int ufshpb_map_req_add_bio_page(struct ufshpb_lu *hpb,
> +				       struct request_queue *q, struct bio *bio,
> +				       struct ufshpb_map_ctx *mctx)
> +{
> +	int i, ret = 0;
> +
> +	for (i = 0; i < hpb->pages_per_srgn; i++) {
> +		ret = bio_add_pc_page(q, bio, mctx->m_page[i], PAGE_SIZE, 0);
> +		if (ret != PAGE_SIZE) {
> +			dev_notice(&hpb->hpb_lu_dev,
> +				   "bio_add_pc_page fail %d\n", ret);
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	return 0;
> +}

Why bio_add_pc_page() instead of bio_add_page()?

> +static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
> +				  struct ufshpb_req *map_req)
> +{
> +	struct request_queue *q;
> +	struct request *req;
> +	struct scsi_request *rq;
> +	int ret = 0;
> +
> +	q = hpb->sdev_ufs_lu->request_queue;
> +	ret = ufshpb_map_req_add_bio_page(hpb, q, map_req->bio,
> +					  map_req->mctx);
> +	if (ret) {
> +		dev_notice(&hpb->hpb_lu_dev,
> +			   "map_req_add_bio_page fail %d - %d\n",
> +			   map_req->rgn_idx, map_req->srgn_idx);
> +		return ret;
> +	}
> +
> +	req = map_req->req;
> +
> +	blk_rq_append_bio(req, &map_req->bio);
> +	req->rq_flags |= RQF_QUIET;
> +	req->timeout = MAP_REQ_TIMEOUT;
> +	req->end_io_data = (void *)map_req;
> +
> +	rq = scsi_req(req);
> +	ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
> +				map_req->srgn_idx, hpb->srgn_mem_size);
> +	rq->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
> +
> +	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_map_req_compl_fn);
> +
> +	atomic_inc(&hpb->stats.map_req_cnt);
> +	return 0;
> +}

Why RQF_QUIET?

Why a custom timeout instead of the SCSI LUN timeout?

Can this function be made asynchronous such that it does not have to be
executed on the context of a workqueue?

Thanks,

Bart.
