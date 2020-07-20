Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D714EC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF12C22C9C
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgGTCeX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 22:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgGTCeW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2020 22:34:22 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69A0C0619D2;
        Sun, 19 Jul 2020 19:26:46 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id 72so7985522ple.0;
        Sun, 19 Jul 2020 19:26:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mRInm97ThyXWZaerbiKXgP4Kpz4u0q1Z2GFefeCRJKM=;
        b=i0pv65+JvBwRkEdQGw72oVSSqrLfTt1otcVdbe79WeAIW9Xsjx8IAjKg2YjZq+X8hs
         6DecQVP54iJS/iqfWTNOJPBSJlvSIrx3yQgwMEC9JKBRu8KnxzG18RJ8O0gfj07HQQNi
         83V6fjbnYKoTD7K+38GDRtdEElDYCuWBhLgT6ESdyTyQ3NXHuNhjgRkm/bLQS05lb+wb
         E/WPl39HBnpVph1lbYfSiRB+bRApD7+5pG0gQKycUJ8OpB2PEWtNd/5YzjuLu3i7tNE0
         wJyhXqIFPXXrCQyWlllRN4S1cVPu/G5iWekVASqGqXQIjzX3gRA1DOmp+QXve9sUEJ01
         F2lA==
X-Gm-Message-State: AOAM533lhtQmCAGp/YI97W5Q5KDfhdy/7avOZd9lTDFq5azDJQI4FwSr
        HKRvLMvClxCAeQGssLHfWWk=
X-Google-Smtp-Source: ABdhPJyUROynzXgjzcvWnMZpvrWHklgi3CGyipijlWgrGs3rrdR3/zHJgWTHyMQROldxJu5cD2kJHQ==
X-Received: by 2002:a17:902:7484:: with SMTP id h4mr15868188pll.243.1595212005881;
        Sun, 19 Jul 2020 19:26:45 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id m20sm12526487pgn.62.2020.07.19.19.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2020 19:26:44 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: run queue in case of IO queueing failure
To:     Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20200708131405.3346107-1-ming.lei@redhat.com>
 <bd3039d4-0c24-ad67-bdfe-85096ad60721@acm.org> <20200720013213.GA791101@T590>
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
Message-ID: <e3fdd46a-4d33-cb57-7b2d-68f2cf5d22cc@acm.org>
Date:   Sun, 19 Jul 2020 19:26:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200720013213.GA791101@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-19 18:32, Ming Lei wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b9adee0a9266..9798fbffe307 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -564,6 +564,15 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
>  	scsi_uninit_cmd(cmd);
>  }
>  
> +static void scsi_run_queue_async(struct scsi_device *sdev)
> +{
> +	if (scsi_target(sdev)->single_lun ||
> +	    !list_empty(&sdev->host->starved_list))
> +		kblockd_schedule_work(&sdev->requeue_work);
> +	else
> +		blk_mq_run_hw_queues(sdev->request_queue, true);
> +}
> +
>  /* Returns false when no more bytes to process, true if there are more */
>  static bool scsi_end_request(struct request *req, blk_status_t error,
>  		unsigned int bytes)
> @@ -608,11 +617,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>  
>  	__blk_mq_end_request(req, error);
>  
> -	if (scsi_target(sdev)->single_lun ||
> -	    !list_empty(&sdev->host->starved_list))
> -		kblockd_schedule_work(&sdev->requeue_work);
> -	else
> -		blk_mq_run_hw_queues(q, true);
> +	scsi_run_queue_async(sdev);
>  
>  	percpu_ref_put(&q->q_usage_counter);
>  	return false;
> @@ -1721,6 +1726,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		 */
>  		if (req->rq_flags & RQF_DONTPREP)
>  			scsi_mq_uninit_cmd(cmd);
> +		scsi_run_queue_async(sdev);
>  		break;
>  	}
>  	return ret;

Looks good to me. Feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
