Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969B1C433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 02:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E55C206F0
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 02:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIBCk7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 22:40:59 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44144 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgIBCk6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 22:40:58 -0400
Received: by mail-pl1-f196.google.com with SMTP id q3so1557433pls.11;
        Tue, 01 Sep 2020 19:40:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ounAEZKLrPxII/574jxn/BpCWEoVC1+u8Hfh4HMDkRE=;
        b=U2tgQky3cCdTh7uxG/p+FNS1NwJ6MKxgHkmQ+VNMvGrEDueTKSjwAfcAA3vHhLIY/S
         OHKowwQ9HtWgIf1qU3DRwRli/7BacLNN5gVHEVEoOfIIkra+CIbWankW20gVrEbo9kXV
         ttZZZI9Tn7Gvn1sGTnO/CxoI6u0qFLr7LXRf+84j4swp4osQDVSNGFDwJqtyIqXCEE9x
         N7w3ADnFtoJU6KJ6ejdo2ewhtAVdjr54qsAvkj2+0RQ6vb44lZpLai/NdOmEQMFwiRKI
         l2j4WSMI1uCv+gB2m8Ty6N4iAn7ny0r7y/gVkLpF3twjXop+OpSi634I/dbB+CuZ0hRA
         6lNA==
X-Gm-Message-State: AOAM531a/paY+Y+ELBJH0xmuptwGT1flmvObKvAxIvma7GoYBuCT8Cw2
        sJQaIEUfcEX6yf4PTiifbqThku/dLik=
X-Google-Smtp-Source: ABdhPJyWelvFiQ8fs90BNWZdJ6WYrT3P/mFYMpi9NgUTsnu3QlkRKgVC9oIZIw9hYJ0Y7ASLKByNvQ==
X-Received: by 2002:a17:90b:33ca:: with SMTP id lk10mr170120pjb.233.1599014456762;
        Tue, 01 Sep 2020 19:40:56 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id j9sm3428077pfe.170.2020.09.01.19.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 19:40:55 -0700 (PDT)
Subject: Re: [PATCH V4] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>, linux-block@vger.kernel.org
References: <20200817100840.2496976-1-ming.lei@redhat.com>
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
Message-ID: <93faff01-daf7-4805-edc6-9101495686ce@acm.org>
Date:   Tue, 1 Sep 2020 19:40:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200817100840.2496976-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-17 03:08, Ming Lei wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7c6dd6f75190..a62c29058d26 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -551,8 +551,27 @@ static void scsi_run_queue_async(struct scsi_device *sdev)
>  	if (scsi_target(sdev)->single_lun ||
>  	    !list_empty(&sdev->host->starved_list))
>  		kblockd_schedule_work(&sdev->requeue_work);
> -	else
> -		blk_mq_run_hw_queues(sdev->request_queue, true);
> +	else {

Has this patch been verified with checkpatch? Checkpatch should have warned
about the unbalanced braces.

> +		/*
> +		 * smp_mb() implied in either rq->end_io or blk_mq_free_request
> +		 * is for ordering writing .device_busy in scsi_device_unbusy()
> +		 * and reading sdev->restarts.
> +		 */

Hmm ... I don't see what orders the atomic_dec(&sdev->device_busy) from
scsi_device_unbusy() and the atomic_read() below? I don't think that the block
layer guarantees ordering of these two memory accesses since both accesses
happen in the request completion path.

> +		int old = atomic_read(&sdev->restarts);
> +
> +		if (old) {
> +			/*
> +			 * ->restarts has to be kept as non-zero if there is
> +			 *  new budget contention comes.

There are two verbs in the above sentence ("is" and "comes"). Please remove
"comes" such that the sentence becomes grammatically correct.

> +			 *
> +			 *  No need to run queue when either another re-run
> +			 *  queue wins in updating ->restarts or one new budget
> +			 *  contention comes.
> +			 */
> +			if (atomic_cmpxchg(&sdev->restarts, old, 0) == old)
> +				blk_mq_run_hw_queues(sdev->request_queue, true);
> +		}
> +	}

Please combine the two if-statements into a single if-statement using "&&"
to keep the indentation level low.

> @@ -1611,8 +1630,34 @@ static void scsi_mq_put_budget(struct request_queue *q)
>  static bool scsi_mq_get_budget(struct request_queue *q)
>  {
>  	struct scsi_device *sdev = q->queuedata;
> +	int ret = scsi_dev_queue_ready(q, sdev);
> +
> +	if (ret)
> +		return true;
> +
> +	atomic_inc(&sdev->restarts);
>  
> -	return scsi_dev_queue_ready(q, sdev);
> +	/*
> +	 * Order writing .restarts and reading .device_busy, and make sure
> +	 * .restarts is visible to scsi_end_request(). Its pair is implied by
> +	 * __blk_mq_end_request() in scsi_end_request() for ordering
> +	 * writing .device_busy in scsi_device_unbusy() and reading .restarts.
> +	 *
> +	 */
> +	smp_mb__after_atomic();

Barriers do not guarantee "is visible to". Barriers enforce ordering of memory
accesses performed by a certain CPU core. Did you perhaps mean that
sdev->restarts must be incremented before the code below reads sdev->device busy?

> +	/*
> +	 * If all in-flight requests originated from this LUN are completed
> +	 * before setting .restarts, sdev->device_busy will be observed as
> +	 * zero, then blk_mq_delay_run_hw_queues() will dispatch this request
> +	 * soon. Otherwise, completion of one of these request will observe
> +	 * the .restarts flag, and the request queue will be run for handling
> +	 * this request, see scsi_end_request().
> +	 */
> +	if (unlikely(atomic_read(&sdev->device_busy) == 0 &&
> +				!scsi_device_blocked(sdev)))
> +		blk_mq_delay_run_hw_queues(sdev->request_queue, SCSI_QUEUE_DELAY);
> +	return false;
>  }

Thanks,

Bart.
