Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1BDC433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 03:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0692621D40
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 03:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgIJDdr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 23:33:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42299 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbgIJDdi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 23:33:38 -0400
Received: by mail-pg1-f194.google.com with SMTP id m5so3478782pgj.9
        for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2020 20:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Sh+0hF7GJUryLj5SWDBTxSuWCr9OQ0AeJv2Z8BEEEiM=;
        b=VFUAhWSfqguw9Hms9o3BoqHpjy7Z6HAgdk4kusBeLVKGBADGier++oFd0Vpn+Hf2T9
         tB0BUey1rnhtbs5VAH+dp/6i7RtCB/JrNKSCSGyNTmpCInxRkaalXDvMtc+/oVxGEZGK
         BnLkFfuCgVGo4G7pI4IlB+kZN+7hH7+1gCtLolekWwfDjCVFyIH9E1wVtvC95SupIkNt
         atwkgTB3l6SM6SRbRfjK2b8cvLw76F8lBn/OS3+di3Mq8D7gJ2LA9FoVRVvrVYxbyyUs
         u0ApVkAYDxKFt65jLwWnJJmqcC29S4+nlPsXvopZ0K8MDK39wIBUGAR933dRB4kjqCOg
         AAJw==
X-Gm-Message-State: AOAM5337WoahsgfMSNWLxbSIuLqoUQpK5DI/turyfN7N8dcfSskw3Vzc
        UzYpbXEnt3K2oHLoKOTqigm7CyBAGa0=
X-Google-Smtp-Source: ABdhPJwGQ2npCbliX+gRNEKIswMG5lw5D/jkxyzGErPIuhHbZqybGGLsfznyxHXsMNwEu41Q9kUzXQ==
X-Received: by 2002:a62:3641:: with SMTP id d62mr3462258pfa.82.1599708816990;
        Wed, 09 Sep 2020 20:33:36 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:bb4f:1304:7d44:a266? ([2601:647:4000:d7:bb4f:1304:7d44:a266])
        by smtp.gmail.com with ESMTPSA id u14sm4219220pfc.203.2020.09.09.20.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 20:33:36 -0700 (PDT)
Subject: Re: [PATCH V6] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Long Li <longli@microsoft.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
References: <20200909072952.1583148-1-ming.lei@redhat.com>
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
Message-ID: <994b691c-dbfa-424d-d4da-ef535455e3e2@acm.org>
Date:   Wed, 9 Sep 2020 20:33:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200909072952.1583148-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-09 00:29, Ming Lei wrote:
> +		if (old) {
> +			/*
> +			 * ->restarts has to be kept as non-zero if there is
> +			 *  new budget contention comes.
> +			 *
> +			 *  No need to run queue when either another re-run
> +			 *  queue wins in updating ->restarts or one new budget
> +			 *  contention comes.
> +			 */
> +			if (atomic_cmpxchg(&sdev->restarts, old, 0) == old)
> +				blk_mq_run_hw_queues(sdev->request_queue, true);

How about combining the above two if-statements into a single if-statement to
keep the indentation level low?

>  /* Returns false when no more bytes to process, true if there are more */
> @@ -1611,8 +1630,32 @@ static void scsi_mq_put_budget(struct request_queue *q)
>  static bool scsi_mq_get_budget(struct request_queue *q)
>  {
>  	struct scsi_device *sdev = q->queuedata;
> +	int ret = scsi_dev_queue_ready(q, sdev);
>  
> -	return scsi_dev_queue_ready(q, sdev);
> +	if (ret)
> +		return true;

I like Ewan's comment about the above code:

"I think this should just be:

	if (scsi_dev_queue_ready(q, sdev))
		return true;

There's no particular reason to call the function in a local variable
initializer, this just makes the code less clear to me.  And "ret"
isn't needed for any other reason."

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

The above comment doesn't explain what happens if the all pending SCSI
commands complete after .restarts has been incremented and before .device_busy
is read. Since I think that case is handled, consider changing "before setting
.restarts" into "before reading .device_busy".

Anyway, since I think the code is fine, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
