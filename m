Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02D4C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 17:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B98F420814
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 17:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405617AbgE1Rs3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 13:48:29 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40109 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405580AbgE1Rs1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 13:48:27 -0400
Received: by mail-pj1-f68.google.com with SMTP id ci23so3467604pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 10:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=k6TelsimITS7XFMOBoJ1kcXapzCbdc3ECFXprj2epiM=;
        b=mH9F8juv8SvEmkD7tUJ/qIqXPnzH2M+j4Mt+lg1SZ7AYr8MIPmZFOeMSY5yYBsWPxj
         hvLJePHBp5dcCm3iXgPrKsjxI9jM8lP6Wj/Aa5xxd9Nt/q+LqvchzIRPNB3NpLuinWH7
         q+ydjFjKPU21DUdTLrrCp47KDk20r14zq8FUtTsczw5dw423HrX94FnjmlucXzZ3BL1D
         VVMvXctIFIUgz1UHOydoZboTwHBUeaCYvB2ccJq1MRfYYW/WSjSQkIANGRwDUG2G0XVf
         LsQ2tScfPWEB6FTaviUUXWNeGYIKgkVzMkbXc2RLuyajYLGhe1rkn89Xv8KFIi9/HRw2
         GApQ==
X-Gm-Message-State: AOAM533Eg/SCmWtVFsWdKsneS5p528+EdtnoEjba/FVQm0YigO8ETbYh
        UlhmnttoAf0tdPJh9Vpc6WCylxemlbM=
X-Google-Smtp-Source: ABdhPJzHUC32A9njU5G5f7cTrTuMrU8OpOSo7ml/Yc96bRuzlTu6yc97cFdUs4NHWgxHDrDAy00hrw==
X-Received: by 2002:a17:90a:2e87:: with SMTP id r7mr4873335pjd.46.1590688105552;
        Thu, 28 May 2020 10:48:25 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:40e6:aa88:9c03:e0b4? ([2601:647:4000:d7:40e6:aa88:9c03:e0b4])
        by smtp.gmail.com with ESMTPSA id k12sm5084515pfg.177.2020.05.28.10.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 10:48:24 -0700 (PDT)
Subject: Re: [PATCH 1/4] scsi: convert target lookup to xarray
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200528163625.110184-1-hare@suse.de>
 <20200528163625.110184-2-hare@suse.de>
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
Message-ID: <8a9b4a1f-9408-0920-75fc-6df146ea95c2@acm.org>
Date:   Thu, 28 May 2020 10:48:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528163625.110184-2-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-28 09:36, Hannes Reinecke wrote:
> +#define scsi_target_index(s) \
> +	((((unsigned long)(s)->channel) << 16) | (s)->id)

Please define scsi_target_index() as an inline function instead of a macro.

> +	if (xa_insert(&shost->__targets, tid, starget, GFP_KERNEL)) {
> +		dev_printk(KERN_ERR, dev, "target index busy\n");
> +		kfree(starget);
> +		return NULL;
> +	}

So the above code passes GFP_KERNEL to xa_insert() while holding a
spinlock? That doesn't seem correct to me. Since xa_insert() provides
locking itself, can the spin_lock_irqsave(shost->host_lock, flags) /
spin_unlock_irqrestore(shost->host_lock, flags) pair be removed and can
the xa_load() and xa_insert() calls be combined into a single
xa_insert() call? I think xa_insert() returns -EBUSY if an entry already
exists.

> -restart:
>  	spin_lock_irqsave(shost->host_lock, flags);
> -	list_for_each_entry(starget, &shost->__targets, siblings) {
> +	starget = xa_find(&shost->__targets, &tid, ULONG_MAX, XA_PRESENT);
> +	while (starget) {
>  		if (starget->state == STARGET_DEL ||
>  		    starget->state == STARGET_REMOVE ||
> -		    starget->state == STARGET_CREATED_REMOVE)
> +		    starget->state == STARGET_CREATED_REMOVE) {
> +			starget = xa_find_after(&shost->__targets, &tid,
> +						ULONG_MAX, XA_PRESENT);
>  			continue;
> +		}
>  		if (starget->dev.parent == dev || &starget->dev == dev) {
>  			kref_get(&starget->reap_ref);
>  			if (starget->state == STARGET_CREATED)
> @@ -1530,7 +1534,10 @@ void scsi_remove_target(struct device *dev)
>  			spin_unlock_irqrestore(shost->host_lock, flags);
>  			__scsi_remove_target(starget);
>  			scsi_target_reap(starget);
> -			goto restart;
> +			spin_lock_irqsave(shost->host_lock, flags);
> +			starget = xa_find_after(&shost->__targets, &tid,
> +						ULONG_MAX, XA_PRESENT);
> +			continue;
>  		}
>  	}

How about using a for loop instead of a while loop such that the
xa_find_after() statement does not have to be duplicated?

Thanks,

Bart.
