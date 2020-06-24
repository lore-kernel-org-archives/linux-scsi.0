Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B64BC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 13:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71BF720823
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 13:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390189AbgFXNdW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 09:33:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43725 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388896AbgFXNdV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 09:33:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id w2so628977pgg.10;
        Wed, 24 Jun 2020 06:33:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=M9l6txOTKX6NW4WDDCYiUemnZ4OCGm3jGi3nT3lueA8=;
        b=cNJmu1KWcUatEyL0b5OdGr4/eAUq9pZTFa4h2Joi0ATIT6jPCKOAe7lsYt76cU7eaN
         agymxF2lwl11j5JFGHm+IwyRIX5xRtbAdI2u9Qb1TuoWzTxT+Ii50h8JqsmPWQ37C2X+
         3GG16Lev3az0OEY5/l6sQIU+5B4wsfXwWLVLMli1JvwCYvrB+E5yu+Wls/1dQFCzLnKA
         Cyc4zXS/CVXos//EP2OCdq00sbRY+0onrcRQBEtZqI2Ph0WJGcT4gG6poSqn6DZNBAU6
         D0vzBLXFhvz7VA/ijZoW5oeMAmGzPWa0D09Bw4TKMGQ/8+ahb8A9ekwbvfdeNWSoKC4i
         WZJA==
X-Gm-Message-State: AOAM5307jLnf3VI06zgm8NQWdRfabptKIRb+lrbMq6NAj4KXtAyov1VG
        VgcAat9o+nxusg1XfM88U4I=
X-Google-Smtp-Source: ABdhPJy84ZYwI8uYwYLoAXr770aOJpQHyK6PLjP0ow9VARewgz8PHOTpgz8nyMy49jOSJZ8muGQyNg==
X-Received: by 2002:a65:63d4:: with SMTP id n20mr718566pgv.213.1593005600062;
        Wed, 24 Jun 2020 06:33:20 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 199sm11480185pgc.79.2020.06.24.06.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 06:33:19 -0700 (PDT)
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
To:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
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
Message-ID: <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
Date:   Wed, 24 Jun 2020 06:33:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200623111018.31954-1-martin.kepplinger@puri.sm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-23 04:10, Martin Kepplinger wrote:
> This add a very conservative but simple implementation for runtime PM
> to the sd scsi driver:
> Resume when opened (mounted) and suspend when released (unmounted).
> 
> Improvements that allow suspending while a device is "open" can
> be added later, but now we save power when no filesystem is mounted
> and runtime PM is enabled.
> 
> Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
> ---
>  drivers/scsi/sd.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d90fefffe31b..fe4cb7c50ec1 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1372,6 +1372,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
>  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"));
>  
>  	sdev = sdkp->device;
> +	scsi_autopm_get_device(sdev);
>  
>  	/*
>  	 * If the device is in error recovery, wait until it is done.
> @@ -1418,6 +1419,9 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
>  
>  error_out:
>  	scsi_disk_put(sdkp);
> +
> +	scsi_autopm_put_device(sdev);
> +
>  	return retval;	
>  }
>  
> @@ -1441,6 +1445,8 @@ static void sd_release(struct gendisk *disk, fmode_t mode)
>  
>  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
>  
> +	scsi_autopm_put_device(sdev);
> +
>  	if (atomic_dec_return(&sdkp->openers) == 0 && sdev->removable) {
>  		if (scsi_block_when_processing_errors(sdev))
>  			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);

My understanding of the above patch is that it introduces a regression,
namely by disabling runtime suspend as long as an sd device is held open.

Bart.


