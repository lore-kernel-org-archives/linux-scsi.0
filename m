Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8B3C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 14:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F165C2074F
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 14:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389150AbgF3Ozx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 10:55:53 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35362 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbgF3Ozw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 10:55:52 -0400
Received: by mail-pj1-f68.google.com with SMTP id i4so9585806pjd.0;
        Tue, 30 Jun 2020 07:55:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uyxc4QXJcSN7l9qnz3IOT4YXnu7cODBB3+hPaz6rN24=;
        b=ZxSMcMusA7XoIQnQ2/1F5glT/pUoe3AAmlPAkB+73cDE+p6L13ZWFwNJjqX5+vjPtr
         s1rkRNUszQZ1yp/CuMVLSLYofyYxLNv4iEUjJ/okmalfKWY3cTe4Nxv4KTw9HJDAhcjW
         YPPJ33qZIEGqLOmPlbDmrPONzxKLdwgYjC29gpTbUcAjtP2H1MAQwsCRHFhJ45HVckvU
         anPfRZNIukDV55bjTPhsev6T8/fSnp/9sb+zOOTcejzXLu0sNr+fF6qGtn6nZsZoRbms
         j49CQp1zBRim/UVMOMZ4vR2lEgk4HLnBRM1HEDk8OX3XH8OmDCLDik8LaQapK31LMatR
         9qzg==
X-Gm-Message-State: AOAM5300v2e2SqWiNLsNOGVKEqHCrAinlIqBCYfSnG9au/LEE7rhZQU8
        nbx6oRezRVxTa81XVXBdYbg=
X-Google-Smtp-Source: ABdhPJxqGwn0YkwFn3wRfqKT8oyGlwNCMH/JmeZBhK+KTeMMSZkRCBcxay3604dW4Qc9NDT/p3e8Rg==
X-Received: by 2002:a17:90a:ad8e:: with SMTP id s14mr23603161pjq.36.1593528951976;
        Tue, 30 Jun 2020 07:55:51 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id z9sm2525690pjr.39.2020.06.30.07.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 07:55:51 -0700 (PDT)
Subject: Re: About sbitmap_bitmap_show() and cleared bits (was Re: [PATCH RFC
 v7 07/12] blk-mq: Add support in hctx_tags_bitmap_show() for a shared
 sbitmap)
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        linux-block@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, don.brace@microsemi.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        ming.lei@redhat.com, hare@suse.com, hch@lst.de,
        shivasharan.srikanteshwara@broadcom.com,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        chenxiang66@hisilicon.com, megaraidlinux.pdl@broadcom.com
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-8-git-send-email-john.garry@huawei.com>
 <9f4741c5-d117-d764-cf3a-a57192a788c3@suse.de>
 <aad6efa3-2d7f-ca68-d239-44ea187c8017@huawei.com>
 <7ed6ccf1-6ad9-1df7-f55d-4ed6cac1e08d@suse.de>
 <8ffd5c22-f644-3436-0a9f-2e08c220525e@huawei.com>
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
Message-ID: <8dfd5434-674a-5df6-114b-59cfed22588d@acm.org>
Date:   Tue, 30 Jun 2020 07:55:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8ffd5c22-f644-3436-0a9f-2e08c220525e@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-29 08:32, John Garry wrote:
> I noticed that sbitmap_bitmap_show() only shows set bits and does not
> consider cleared bits. Is that the proper thing to do?
> 
> I ask, as from trying to support sbitmap_bitmap_show() for hostwide
> shared tags feature, we currently use blk_mq_queue_tag_busy_iter() to
> find active requests (and associated tags/bits) for a particular hctx.
> So, AFAICT, would give a change in behavior for sbitmap_bitmap_show(),
> in that it would effectively show set and not cleared bits.
> 
> Any thoughts on this?

Probably this is something that got overlooked when the cleared bits
were introduced? See e.g. 8c2def893afc ("sbitmap: fix
sbitmap_for_each_set()").

Bart.

