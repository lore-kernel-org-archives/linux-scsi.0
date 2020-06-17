Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0686C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 19:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6C3921532
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 19:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgFQTTi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 15:19:38 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44847 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQTTi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 15:19:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id r18so1739563pgk.11;
        Wed, 17 Jun 2020 12:19:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f3h8SA2NdNGnsgYyCV0RnrSZYYK839TG5VEFdmTv5UM=;
        b=hUuN26eeAa1SRLYljtECfeoOYJsgxLmz2n1ktIp/9xTFA7DAeMTABGLOdZ1JqUrauX
         F4Y4PYGJ6XhBpxCtYAiOOJ86QSZTjz/xNadBhuWhwxQZ4J46PjMPKndgM7gEt56WVFh9
         vGXlX+Q7Xgcwu0VFAejz8UaSCUzpmOevdj/wNFcva7svkHMnAe3f3pxBzcPXsMB1pEpX
         mGtLPPU3YtE5c2er5CsItTByTS3k48niXQNPmODaSmWdqRjVpylFA8uNJhDebXoVNFHs
         AcPlSvnorsrs9n4X8yQNL01DNbd6Cqq6aYsDrS+7f962tPfNzwCsCrz2wo2pTLbAev5Q
         OYcQ==
X-Gm-Message-State: AOAM533BFPwyCdQqL3Nv/KFk98glgwVxUMQ3BBXzf3pjLGiYshawBdpM
        CCp3ism2N3AiBDtIjddKiJjT1lVq
X-Google-Smtp-Source: ABdhPJxUlIxL7BpcInfnVnxOEqROyTf0gLUF7n32Pevzzh4bj1Hdeo5AXR5iX263YifWTVZ2BIiy0A==
X-Received: by 2002:a63:931b:: with SMTP id b27mr269564pge.135.1592421577475;
        Wed, 17 Jun 2020 12:19:37 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id fv7sm310887pjb.41.2020.06.17.12.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 12:19:36 -0700 (PDT)
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
To:     Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
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
Message-ID: <b92ce48a-55d8-9377-f6c5-510d7e3beb1b@acm.org>
Date:   Wed, 17 Jun 2020 12:19:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-17 11:49, Simon Arlott wrote:
> @@ -3576,9 +3582,19 @@ static void sd_shutdown(struct device *dev)
>  		sd_sync_cache(sdkp, NULL);
>  	}
>  
> -	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
> -		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
> -		sd_start_stop_device(sdkp, 0);
> +	if (sdkp->device->manage_start_stop) {
> +		bool stop_disk = (system_state != SYSTEM_RESTART);
> +
> +		if (stop_before_reboot > 1) { /* stop all disks */
> +			stop_disk = true;
> +		} else if (stop_before_reboot) { /* non-rotational only */
> +			stop_disk |= blk_queue_nonrot(sdkp->disk->queue);
> +		}
> +
> +		if (stop_disk) {
> +			sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
> +			sd_start_stop_device(sdkp, 0);
> +		}
>  	}
>  }

Is introduction of a new kernel module parameter essential? Or in other
words, has it been considered to apply the new behavior to all SSDs?

Thanks,

Bart.
