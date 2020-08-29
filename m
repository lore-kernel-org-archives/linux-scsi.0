Return-Path: <SRS0=Q1Hz=CH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B28EC433E6
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Aug 2020 23:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2845920EDD
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Aug 2020 23:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgH2XsY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Aug 2020 19:48:24 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38132 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgH2XsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2020 19:48:23 -0400
Received: by mail-pg1-f196.google.com with SMTP id l191so2270829pgd.5;
        Sat, 29 Aug 2020 16:48:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=L0MMWeBMS7jUdX5jKMbThFkK48FEuT2Nn6hRNrfb6d0=;
        b=c1BZ5n0dwcLALcqNQezN35b9OTLPvdlghQzFcLqQM7sjKtxtkbujs3famfz04PGjUD
         D8FkpuoITPnkknpXov9sslYri6jXpSl1XB2jg+4HOLHX8AkgBj9CdAs9xUpqv2OKf5xu
         toxzdZpfnIK0NcfuCq2qgYjYOau6h2pJkp8B53bJq8r5BbXMHmoernTjVjBhL3RPkSEz
         vFqI8lwiYJXaN/YLeSHpQtOaj5+lIjbRWO4ycRAOqVq41Sv+mvHoL039mo0wEmJZ02tV
         6Fv0MiITII17sNhKszH/c5Ti8TchKGI+uYkFU5VrufYdczt2HiKNomWomKBiBZEBbzuA
         l20A==
X-Gm-Message-State: AOAM530+W+eMKvo50sm5FcyyqWRJ0/vFexcbFBmVgxj3xZnlwDvSG866
        lPdyc9gUPvdq1IA49DAtGek=
X-Google-Smtp-Source: ABdhPJwuOLqnUxmWkDooq1sGN7PGUdLjuiTg5JfvJLzbbQvGiEEJueSLGOAPpEwYDoy0bD8T2FZZBQ==
X-Received: by 2002:aa7:982e:: with SMTP id q14mr4458988pfl.299.1598744902007;
        Sat, 29 Aug 2020 16:48:22 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id e66sm3471172pfa.130.2020.08.29.16.48.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2020 16:48:21 -0700 (PDT)
Subject: Re: [PATCH v9 3/4] scsi: ufs: L2P map management for HPB read
To:     daejun7.park@samsung.com,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <963815509.21598598782155.JavaMail.epsvc@epcpadp2>
 <CGME20200828070950epcms2p5470bd43374be18d184dd802da09e73c8@epcms2p6>
 <1210830415.21598601302480.JavaMail.epsvc@epcpadp1>
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
Message-ID: <5587cf86-eeec-2c70-a47c-57149f00eb95@acm.org>
Date:   Sat, 29 Aug 2020 16:48:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1210830415.21598601302480.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-28 00:19, Daejun Park wrote:
> +static unsigned int ufshpb_host_map_kbytes = 1024;

A comment that explains where this value comes from would be welcome.

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

Why BLK_MQ_REQ_PREEMPT? Since this code is only executed while medium access
commands are processed and since none of these commands have the PREEMPT flag
set I think that the PREEMPT flag should be left out. Otherwise there probably
will be weird interactions with runtime suspended devices.

Is it acceptable that the above blk_get_request() call blocks if a UFS device
has been runtime suspended? If not, consider using the flag BLK_MQ_REQ_NOWAIT
instead.

> +	bio = bio_alloc(GFP_KERNEL, hpb->pages_per_srgn);
> +	if (!bio) {
> +		blk_put_request(req);
> +		goto free_map_req;
> +	}

If the blk_get_request() would be modified such that it doesn't wait, this
call may have to be modified too (GFP_NOWAIT?).

> +	if (rgn->rgn_state == HPB_RGN_INACTIVE) {
> +		if (atomic_read(&lru_info->active_cnt)
> +		    == lru_info->max_lru_active_cnt) {

When splitting a line, please put comparison operators at the end of the line
instead of at the start, e.g. as follows:

		if (atomic_read(&lru_info->active_cnt) ==
		    lru_info->max_lru_active_cnt) {

> +	pool_size = DIV_ROUND_UP(ufshpb_host_map_kbytes * 1024, PAGE_SIZE);

Please use PAGE_ALIGN() to align to the next page boundary.

Thanks,

Bart.
