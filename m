Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8FBC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D48220702
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgF2TXc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732285AbgF2TWo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:22:44 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0B7C030F39;
        Mon, 29 Jun 2020 09:56:52 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id z5so8569340pgb.6;
        Mon, 29 Jun 2020 09:56:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/ma/F8azHfAAlX2tIXoGzMQscfg5HcD+VaBkA6I2zHQ=;
        b=pZER90CeOCVTshThob8SMWZGTPpq0Mux+NuRers8/6P2d0f4w05GGRSqD38aYcR8ZZ
         12G9obczqcC1AFF562uQjh3gP+CYReqnp1GfE2ls8ZNYxhGZ8NeOzFlvLYb4fhQVTgw+
         drDHEyhfRZQThZRHWbPqaYsosoDZyprHv0VWmIDHGBLihzGeKEW0eUIgUpLq+zjzfJEV
         X9MSU4N34Sr3VrhXDbKxq8GarIAoqKX/BUhbleGf2EDvUpLtuhQyVdQohOUDokASKovU
         v3hSmeogbUBwwqUUhpG8mhxfAVv22+KxEWOweLvDxOTbSO7NhguMdtjuQ0vGSyPpoGsK
         D5GA==
X-Gm-Message-State: AOAM533Xpd0YJw46l0YjdEqWsLVYGUk6Y0tfaYip9Hybi9VKGvLmjZ6u
        2LYZypdyLwl/pyRziGdgk2w=
X-Google-Smtp-Source: ABdhPJxAvEhIQPLv4qR5l3ldPDQeKRXPQEDzt66dAti3bw4uNmWPcIma5kppyybAmSHb90GeBtGz8A==
X-Received: by 2002:a63:5110:: with SMTP id f16mr10872564pgb.377.1593449812186;
        Mon, 29 Jun 2020 09:56:52 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id a30sm258527pfr.87.2020.06.29.09.56.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 09:56:51 -0700 (PDT)
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
To:     Alan Stern <stern@rowland.harvard.edu>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     jejb@linux.ibm.com, Can Guo <cang@codeaurora.org>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@puri.sm
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
 <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
 <20200626154441.GA296771@rowland.harvard.edu>
 <c19f1938-ae47-2357-669d-5b4021aec154@puri.sm>
 <20200629161536.GA405175@rowland.harvard.edu>
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
Message-ID: <df54c02f-dbe9-08d5-fec8-835788caf164@acm.org>
Date:   Mon, 29 Jun 2020 09:56:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200629161536.GA405175@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-29 09:15, Alan Stern wrote:
> Aha.  Looking at this more closely, it's apparent that the code in 
> blk-core.c contains a logic bug: It assumes that if the BLK_MQ_REQ_PREEMPT 
> flag is set then the request can be issued regardless of the queue's 
> runtime status.  That is not correct when the queue is suspended.

Please clarify why this is not correct.

> Index: usb-devel/block/blk-core.c
> ===================================================================
> --- usb-devel.orig/block/blk-core.c
> +++ usb-devel/block/blk-core.c
> @@ -423,7 +423,8 @@ int blk_queue_enter(struct request_queue
>  			 * responsible for ensuring that that counter is
>  			 * globally visible before the queue is unfrozen.
>  			 */
> -			if (pm || !blk_queue_pm_only(q)) {
> +			if ((pm && q->rpm_status != RPM_SUSPENDED) ||
> +			    !blk_queue_pm_only(q)) {
>  				success = true;
>  			} else {
>  				percpu_ref_put(&q->q_usage_counter);

Does the above change make it impossible to bring a suspended device
back to the RPM_ACTIVE state if the BLK_MQ_REQ_NOWAIT flag is set?

> @@ -448,8 +449,7 @@ int blk_queue_enter(struct request_queue
>  
>  		wait_event(q->mq_freeze_wq,
>  			   (!q->mq_freeze_depth &&
> -			    (pm || (blk_pm_request_resume(q),
> -				    !blk_queue_pm_only(q)))) ||
> +			    blk_pm_resume_queue(pm, q)) ||
>  			   blk_queue_dying(q));
>  		if (blk_queue_dying(q))
>  			return -ENODEV;
> Index: usb-devel/block/blk-pm.h
> ===================================================================
> --- usb-devel.orig/block/blk-pm.h
> +++ usb-devel/block/blk-pm.h
> @@ -6,11 +6,14 @@
>  #include <linux/pm_runtime.h>
>  
>  #ifdef CONFIG_PM
> -static inline void blk_pm_request_resume(struct request_queue *q)
> +static inline int blk_pm_resume_queue(const bool pm, struct request_queue *q)
>  {
> -	if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
> -		       q->rpm_status == RPM_SUSPENDING))
> -		pm_request_resume(q->dev);
> +	if (!q->dev || !blk_queue_pm_only(q))
> +		return 1;	/* Nothing to do */
> +	if (pm && q->rpm_status != RPM_SUSPENDED)
> +		return 1;	/* Request allowed */
> +	pm_request_resume(q->dev);
> +	return 0;
>  }

Does the above change, especially the " && q->rpm_status !=
RPM_SUSPENDED" part, make it impossible to bring a suspended device back
to the RPM_ACTIVE state?

Thanks,

Bart.
