Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF5FC4363D
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 02:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8074B21531
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 02:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgJACoF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 22:44:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35855 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJACoF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2020 22:44:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id d9so3021351pfd.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2020 19:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Ke0TKP8lQfI5Dj3EHGvZ26tLHgEa3R4DcSNMY/KkU18=;
        b=AV0HF5IKd18TOYrLUkWqfVD5Q4DCjcBCam3d9mFbe6zOROjZOkbmr5zmIX/rCiFUSr
         TjbySZ2h8WUi8LJc3ZsLXZOmZjyt8bBDUUGoXgK86r6La/HxMCsl1VKkuWhtz/W0XbVa
         ZnXBfbjOdlBgWPDgFsXiQUy54NK63ZGEZaFSZ7tmX8djaauyonD1fABcUxHNaDj0RvpS
         sl7uMiWlFaFMGVy2kRjIgFpKVQsuz87i/ydUnlCQ1ZLv9Qy7zqAiEFR7kcDdZnanVmSl
         0HSfjdIcCAKacUysNaI8UHxMMOCM2B6tZw64Z3Ls1BIpEx83CbqU50CdRkT1MVF4W971
         tYRQ==
X-Gm-Message-State: AOAM532lLYn3ochXDeN3dQA4TuhZYvcdfECJoIUiIgvZ8MFEL4hu0Clk
        wqIKfYdaAy54qznMno8Pvf3pQNls7G4=
X-Google-Smtp-Source: ABdhPJxdY0wQ96sw5VKR2JbB+8qLanEuZcq6XLAxzCUJrLdhfXEBGFl56/9M8NE6v/Ardg8rP+FnFw==
X-Received: by 2002:a62:fc51:0:b029:142:4506:9a7b with SMTP id e78-20020a62fc510000b029014245069a7bmr5026969pfh.28.1601520243498;
        Wed, 30 Sep 2020 19:44:03 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:74c0:38d3:8092:91f1? ([2601:647:4000:d7:74c0:38d3:8092:91f1])
        by smtp.gmail.com with ESMTPSA id q24sm3926190pfs.206.2020.09.30.19.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 19:44:02 -0700 (PDT)
Subject: Re: [PATCH 2/4] scsi_dh_alua: return BLK_STS_AGAIN for ALUA
 transitioning state
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200930080256.90964-1-hare@suse.de>
 <20200930080256.90964-3-hare@suse.de>
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
Message-ID: <10c29e0a-688c-9cc0-3329-8f97300b8827@acm.org>
Date:   Wed, 30 Sep 2020 19:44:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200930080256.90964-3-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-30 01:02, Hannes Reinecke wrote:
> When the ALUA state indicates transitioning we should not retry
> the command immediately, but rather complete the command with
> BLK_STS_AGAIN to signal the completion handler that it might
> be retried.
> This allows multipathing to redirect the command to another path
> if possible, and avoid stalls during lengthy transitioning times.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
>  drivers/scsi/scsi_lib.c                    | 5 +++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 308bda2e9c00..a68222e324e9 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -1092,7 +1092,7 @@ static blk_status_t alua_prep_fn(struct scsi_device *sdev, struct request *req)
>  	case SCSI_ACCESS_STATE_LBA:
>  		return BLK_STS_OK;
>  	case SCSI_ACCESS_STATE_TRANSITIONING:
> -		return BLK_STS_RESOURCE;
> +		return BLK_STS_AGAIN;
>  	default:
>  		req->rq_flags |= RQF_QUIET;
>  		return BLK_STS_IOERR;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f0ee11dc07e4..b628aa0d824c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1726,6 +1726,11 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		    scsi_device_blocked(sdev))
>  			ret = BLK_STS_DEV_RESOURCE;
>  		break;
> +	case BLK_STS_AGAIN:
> +		scsi_req(req)->result = DID_BUS_BUSY << 16;
> +		if (req->rq_flags & RQF_DONTPREP)
> +			scsi_mq_uninit_cmd(cmd);
> +		break;
>  	default:
>  		if (unlikely(!scsi_device_online(sdev)))
>  			scsi_req(req)->result = DID_NO_CONNECT << 16;

Hi Hannes,

What will happen if all remote ports have the state "transitioning"?
Does the above code resubmit a request immediately in that case? Can
this cause spinning with 100% CPU usage if the ALUA device handler
notices the transitioning state before multipathd does?

Thanks,

Bart.


