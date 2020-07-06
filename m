Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB669C433E2
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 02:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B27620747
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 02:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgGFClL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jul 2020 22:41:11 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39582 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgGFClL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2020 22:41:11 -0400
Received: by mail-pj1-f66.google.com with SMTP id b92so16352837pjc.4;
        Sun, 05 Jul 2020 19:41:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=81NTEqDyZvRshxK436Y1/22euKYv5lsQgXKxLCuXD2E=;
        b=GEDxe16suR7P+4rnKI/uZq6yII1eninz7Y6UXphu2HMcowaUlnAvBJ4w3Jkv0YK0ms
         8W5PwADgB1A30Oh5R9RDEZE1LCXytpZw9DIpFra/hDi3+pgZUAf/TFu5sai/6WDnmpUC
         LPfdYDVrPN4xHAVDtgki7DnCAzfi7pzcZa+OkpqrTmytLtIAyMVcSvMKFsh3KG0+Nuyu
         Jyap0WKvcnupm4yChb4yUmmNJpigqmYBrrDwU2DhLjTNoXJBEa095OnwdXvMlVQhJT8L
         NiT/VFG38/Cm2//NKPbCUW9bjIjIIarmsFdLr/ZmsVZ5PepKBbcpzs9auk+ov8zw2y3z
         z2fw==
X-Gm-Message-State: AOAM533zFqHeIeImBt+fStic3dgmHy1U++LKiN3ym7na0JyxWAs0dfU8
        Oc570VDfKPJUkwxCkHVcC1DUHDWG
X-Google-Smtp-Source: ABdhPJyo99JpoklWM+tc9dEeSPA6GAkADROtb/hL1h8tP63d31sWgyKW00TNP5b/4zcd/cQDTtEs6Q==
X-Received: by 2002:a17:90a:f2c3:: with SMTP id gt3mr33462329pjb.92.1594003269735;
        Sun, 05 Jul 2020 19:41:09 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 199sm17815077pgc.79.2020.07.05.19.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 19:41:08 -0700 (PDT)
Subject: Re: [PATCH v2] SCSI and block: Simplify resume handling
To:     Alan Stern <stern@rowland.harvard.edu>, martin.petersen@oracle.com
Cc:     Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20200701183718.GA507293@rowland.harvard.edu>
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
Message-ID: <9e824700-dfd1-5d71-5e91-833c35ea55eb@acm.org>
Date:   Sun, 5 Jul 2020 19:41:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701183718.GA507293@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-01 11:37, Alan Stern wrote:
>  void blk_post_runtime_resume(struct request_queue *q, int err)
>  {
> -	if (!q->dev)
> -		return;
> -
> -	spin_lock_irq(&q->queue_lock);
>  	if (!err) {
> -		q->rpm_status = RPM_ACTIVE;
> -		pm_runtime_mark_last_busy(q->dev);
> -		pm_request_autosuspend(q->dev);
> -	} else {
> +		blk_set_runtime_active(q);
> +	} else if (q->dev) {
> +		spin_lock_irq(&q->queue_lock);
>  		q->rpm_status = RPM_SUSPENDED;
> +		spin_unlock_irq(&q->queue_lock);
>  	}
> -	spin_unlock_irq(&q->queue_lock);
> -
> -	if (!err)
> -		blk_clear_pm_only(q);
>  }
>  EXPORT_SYMBOL(blk_post_runtime_resume);

I'd like to keep the if (!q->dev) check at the start of the function instead
of moving it to the middle of the function to keep the symmetry with the
existing runtime power management functions in the same source file.

>  void blk_set_runtime_active(struct request_queue *q)
>  {
>  	if (q->dev) {
> +		int old_status;
> +
>  		spin_lock_irq(&q->queue_lock);
> +		old_status = q->rpm_status;
>  		q->rpm_status = RPM_ACTIVE;
>  		pm_runtime_mark_last_busy(q->dev);
>  		pm_request_autosuspend(q->dev);
>  		spin_unlock_irq(&q->queue_lock);
> +
> +		if (old_status != RPM_ACTIVE)
> +			blk_clear_pm_only(q);
>  	}
>  }

Since this function is being modified, please change the if (q->dev) into
if (!q->dev) return since returning early is the recommended kernel coding
style.

Thanks,

Bart.
