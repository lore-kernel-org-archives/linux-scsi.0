Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328C4C33CB7
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 20:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13070206ED
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 20:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgASUg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 15:36:58 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42699 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbgASUg5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 15:36:57 -0500
Received: by mail-pf1-f195.google.com with SMTP id 4so14724511pfz.9;
        Sun, 19 Jan 2020 12:36:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=UUxyKSjpdjU67mcdsyf5zlXgCxjVRM8kRgDC+4ZzLQw=;
        b=gkzyqskDFFRkWz8/q1hR/gmQUOukutEjFRLd+S7oFI5JB4Pdya3IkRC4EHMSpKqN9U
         WZOj2371O7/0GzQk8LZXWFycBueC/lvH/nIquHzgdQmAAFMmwHpmX6oyzyvNRTUH94Rq
         VdhH9YuGTKPUR8Q9labpzxSGR+G74SjEiOT2w9pGAPflBKmrpYDNCq6XtZNjUQwo0N7B
         KiQIHXwB8saPdSFMsCqG/j/EDg4RGWzDOYujcbT1cgJmGqoZXReksWG2SHzf2/1UYSLd
         7xETACvh7Th0AjKd7kJCq/HoquEqM+/7MMK19pONk6cxQkmn/nvwMxgt1/za8AIUSm62
         x0DA==
X-Gm-Message-State: APjAAAXlj0eEPwoH96QTgqif7cOpv+sbBsNCb3e0cLeuAft19rPvdRKa
        fBwUDRp9PoJvWPDHO1MoOuc=
X-Google-Smtp-Source: APXvYqw8W9Bu8BKQV1wIvuESLc9mwFTxMNwtJEPhgxImEJCWmuUmGxqcUZLXYGPoLullNZyjsFqDZA==
X-Received: by 2002:a63:3084:: with SMTP id w126mr7744675pgw.169.1579466217262;
        Sun, 19 Jan 2020 12:36:57 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:781f:ca33:6085:f83a? ([2601:647:4000:d7:781f:ca33:6085:f83a])
        by smtp.gmail.com with ESMTPSA id o2sm14871660pjo.26.2020.01.19.12.36.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 12:36:56 -0800 (PST)
Subject: Re: [PATCH 3/6] scsi: sd: register request queue after
 sd_revalidate_disk is done
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20200119071432.18558-1-ming.lei@redhat.com>
 <20200119071432.18558-4-ming.lei@redhat.com>
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
Message-ID: <e1d192d1-6518-95a5-b284-cdcaac589334@acm.org>
Date:   Sun, 19 Jan 2020 12:36:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200119071432.18558-4-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-18 23:14, Ming Lei wrote:
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 5afb0046b12a..f401ba96dcfd 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3380,11 +3380,12 @@ static int sd_probe(struct device *dev)
>  		pm_runtime_set_autosuspend_delay(dev,
>  			sdp->host->hostt->rpm_autosuspend_delay);
>  	}
> -	device_add_disk(dev, gd, NULL);
> +	device_add_disk_no_queue_reg(dev, gd);
>  	if (sdkp->capacity)
>  		sd_dif_config_host(sdkp);
>  
>  	sd_revalidate_disk(gd);
> +	blk_register_queue(gd);
>  
>  	if (sdkp->security) {
>  		sdkp->opal_dev = init_opal_dev(sdp, &sd_sec_submit);

The effect of changing device_add_disk() into
device_add_disk_no_queue_reg() is as follows:
- __device_add_disk() skips the elevator_init_mq() call.
- __device_add_disk() skips the blk_register_queue() call.

The above patch introduces a blk_register_queue() call but no
elevator_init_mq() call. Is that perhaps an oversight?

Thanks,

Bart.
