Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F3A0C2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 16:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B35215A4
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 16:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbgIGQxC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 12:53:02 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42344 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730905AbgIGQwq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 12:52:46 -0400
Received: by mail-pf1-f194.google.com with SMTP id d6so1827074pfn.9;
        Mon, 07 Sep 2020 09:52:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VEvhRokwwqmz0U/HN6F5/kaO/COX6wQ1MLILWEgM7qw=;
        b=c1n8UGoIdD8MvK6GVQLe+4YlVet3Yum3u+zGg0HC3xsBt+8AArfBbs54RYiP2vtSY4
         PQ7x3TK6vJpnkIOay1Hi0ZtTb6L/ndcIRmEkSBkG6c9V3RHalgmgYKl2+OpSAeLjHqbp
         4kuZdeilfbtWQeX6URD55BHAEwAzGy6dmmDqL/WR9SjZu1a+EA/n5BWz/IqPm6rKr6PV
         IUK/siCayKwwL2MD0/eHXqZv0paT0mFrtMeEuegywOTZEkLcB938cMKy1vTd/R0Giuop
         AoD6eY7/j2rERAD2xuGXx5j+KTuRo6fiNJGqH3rBQ2KPNMRdI5wStCh1iAKTgjVm0uv1
         +trQ==
X-Gm-Message-State: AOAM532yCXxIBYYBTq7acbzhaBUK+X+4xC+kTWBkjRjjgxxg0Jx0ykkW
        364/09Onpu01v2gStM7IJdlDB4X34fY=
X-Google-Smtp-Source: ABdhPJyBf0pBXopK7X+LDOPgsPVmhGty9Io1yR27QH5eMM2I+fpOFILXWtZgRKU7CjEk6xUL8IgslQ==
X-Received: by 2002:a65:68d6:: with SMTP id k22mr16739358pgt.136.1599497564505;
        Mon, 07 Sep 2020 09:52:44 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:ff58:da99:dd6f:be14? ([2601:647:4000:d7:ff58:da99:dd6f:be14])
        by smtp.gmail.com with ESMTPSA id ih11sm12898562pjb.51.2020.09.07.09.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 09:52:43 -0700 (PDT)
Subject: Re: [PATCH V5] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>, linux-block@vger.kernel.org
References: <20200907071048.1078838-1-ming.lei@redhat.com>
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
Message-ID: <4da219e6-7c2b-b93b-c6d0-2e18aa8ce11f@acm.org>
Date:   Mon, 7 Sep 2020 09:52:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200907071048.1078838-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-07 00:10, Ming Lei wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7affaaf8b98e..a05e431ee62a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -551,8 +551,25 @@ static void scsi_run_queue_async(struct scsi_device *sdev)
>  	if (scsi_target(sdev)->single_lun ||
>  	    !list_empty(&sdev->host->starved_list))
>  		kblockd_schedule_work(&sdev->requeue_work);
> -	else
> -		blk_mq_run_hw_queues(sdev->request_queue, true);
> +	else {

Please follow the Linux kernel coding style and balance braces.

> +		/*
> +		 * smp_mb() implied in either rq->end_io or blk_mq_free_request
> +		 * is for ordering writing .device_busy in scsi_device_unbusy()
> +		 * and reading sdev->restarts.
> +		 */
> +		int old = atomic_read(&sdev->restarts);

scsi_run_queue_async() has two callers: scsi_end_request() and scsi_queue_rq().
I don't see how ordering between scsi_device_unbusy() and the above atomic_read()
could be guaranteed if this function is called from scsi_queue_rq()?

Regarding the I/O completion path, my understanding is that the I/O completion
path is as follows if rq->end_io == NULL:

scsi_mq_done()
  blk_mq_complete_request()
    rq->q->mq_ops->complete(rq) = scsi_softirq_done
      scsi_finish_command()
        scsi_device_unbusy()
        scsi_cmd_to_driver(cmd)->done(cmd)
        scsi_io_completion()
          scsi_end_request()
            blk_update_request()
            scsi_mq_uninit_cmd()
            __blk_mq_end_request()
              blk_mq_free_request()
                __blk_mq_free_request()
                  blk_queue_exit()
            scsi_run_queue_async()

I haven't found any store memory barrier between the .device_busy change in
scsi_device_unbusy() and the scsi_run_queue_async() call? Did I perhaps overlook
something?

> +		/*
> +		 * ->restarts has to be kept as non-zero if there new budget
> +		 *  contention comes.

Please fix the grammar in the above sentence.

> +	/*
> +	 * Order writing .restarts and reading .device_busy. Its pair is
> +	 * implied by __blk_mq_end_request() in scsi_end_request() for
> +	 * ordering writing .device_busy in scsi_device_unbusy() and
> +	 * reading .restarts.
> +	 */
> +	smp_mb__after_atomic();

What does "its pair is implied" mean? Please make the above comment
unambiguous.

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

What will happen if all in-flight requests complete after
scsi_run_queue_async() has read .restarts and before it executes
atomic_cmpxchg()? Will that cause the queue to be run after a delay
although it should be run immediately?

Thanks,

Bart.
