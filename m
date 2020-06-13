Return-Path: <SRS0=9DJi=72=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F156EC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 15:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D72842078A
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 15:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgFMPYJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Jun 2020 11:24:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35132 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgFMPYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Jun 2020 11:24:08 -0400
Received: by mail-pl1-f194.google.com with SMTP id k1so4844837pls.2;
        Sat, 13 Jun 2020 08:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=UfcBK4H6+ohdNeuGMt6p8le19zTz2XSkp3/CaqQe5O8=;
        b=b7OGMAztATiBMhCEgX89EHKHAhB0BhPFp0ruXbyycH95HZ2cgz5AR7VOxBhlLeRy4e
         tot4TZJu0PaQgW6rEQuwPEo8K37fIVtbkpRmQP/0UYBAC65yTJCt+LRPxdt8NWauCRF4
         KpzlGDdHvfoTTxsY6EPVRwm3QvydJW9F+MITi7i3I1qdycMvuB52ssAgmEKg/mi41cls
         Wt35aFGle9QG4tBDmN3zSeGeDNWa7/s7vgrsjHw5vcWQrAK2PjmuNSaZp37A+jmb4GIW
         YlSwf2tVubKYgWblVyPmtYCVG+gmGeMwm7MmKOYxloKV2xehzVdCZ8AidpbeP4DVPbGC
         BCTw==
X-Gm-Message-State: AOAM532yFGb6NnJPdgZaxe8kcaJ6bnOx1QFJFSu7Ge49GbuBCcvji0Xb
        LSJApl1XctrCRsSuulQh5P4=
X-Google-Smtp-Source: ABdhPJymdjHm3iCGCIjhJV+CctFN8xPeZhVKyskO8vOoKFu3NUorZSrNpR7TMJevj+fQGTqZ/x3Wpw==
X-Received: by 2002:a17:90b:283:: with SMTP id az3mr3982512pjb.232.1592061847390;
        Sat, 13 Jun 2020 08:24:07 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id z186sm7963645pgb.93.2020.06.13.08.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2020 08:24:06 -0700 (PDT)
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
References: <0389f9cf-fea8-9990-7699-0e4322728e4a@acm.org>
 <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
 <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
 <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
 <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
 <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
 <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p5>
 <963815509.21591934102518.JavaMail.epsvc@epcpadp1>
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
Message-ID: <6d570594-96f8-764e-e252-97a714731650@acm.org>
Date:   Sat, 13 Jun 2020 08:24:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <963815509.21591934102518.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-11 20:37, Daejun Park wrote:
>>> +static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
>>> +				  struct ufshpb_req *map_req)
>>> +{
>>> +	struct request_queue *q;
>>> +	struct request *req;
>>> +	struct scsi_request *rq;
>>> +	int ret = 0;
>>> +
>>> +	q = hpb->sdev_ufs_lu->request_queue;
>>> +	ret = ufshpb_map_req_add_bio_page(hpb, q, map_req->bio,
>>> +					  map_req->mctx);
>>> +	if (ret) {
>>> +		dev_notice(&hpb->hpb_lu_dev,
>>> +			   "map_req_add_bio_page fail %d - %d\n",
>>> +			   map_req->rgn_idx, map_req->srgn_idx);
>>> +		return ret;
>>> +	}
>>> +
>>> +	req = map_req->req;
>>> +
>>> +	blk_rq_append_bio(req, &map_req->bio);
>>> +	req->rq_flags |= RQF_QUIET;
>>> +	req->timeout = MAP_REQ_TIMEOUT;
>>> +	req->end_io_data = (void *)map_req;
>>> +
>>> +	rq = scsi_req(req);
>>> +	ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
>>> +				map_req->srgn_idx, hpb->srgn_mem_size);
>>> +	rq->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
>>> +
>>> +	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_map_req_compl_fn);
>>> +
>>> +	atomic_inc(&hpb->stats.map_req_cnt);
>>> +	return 0;
>>> +}
>> 
>> Why a custom timeout instead of the SCSI LUN timeout?
>
> There was no suitable timeout value to use. I've included sd.h, so I'll
> use sd_timeout.

Wouldn't that be a layering violation? The UFS driver is a SCSI LLD
driver and the sd driver is a SCSI ULD. A SCSI LLD must not make any
assumptions about which ULD driver has been attached.

How about leaving req->timeout zero such that blk_add_timer() sets it?
blk_add_timer() is called by blk_mq_start_request(). From blk_add_timer():

	if (!req->timeout)
		req->timeout = q->rq_timeout;

Thanks,

Bart.
