Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECB0C4BA0A
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 05:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0907222C2
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 05:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgBZFbp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 00:31:45 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45718 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgBZFbp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Feb 2020 00:31:45 -0500
Received: by mail-pl1-f194.google.com with SMTP id b22so805880pls.12;
        Tue, 25 Feb 2020 21:31:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=MH43w2ivxADrawY5wWEkcJfzZm+RFQcGzQ8+FfYQAPg=;
        b=rKjpuOY+vAI+O2CmSjggJyRldZoitR3weK62xn64dJNwfFo6f9pfmNw8XeY0PTm3pe
         fZF2Wrpok7lR5Azhn/hSlQw1rUFYIKclX2vJbOyzR/+I7mPT1arBl5ACiYhKYHhoMVPp
         ahTYprTKRP0rsmX0cNYFd/khrhFCk5XZVinkaHTyUz5cxhQij5GHbH7xQHt31G9/I+4h
         1ktXZ6/7U9bgesEqV5MMJGIRYqWufd2a8QbXtE1c1Vzkkf8UNsNau+oMd21WdTikjx5B
         EeakFR7gqitE+lpujrS8CQLW/VzAAqdMEz022pq3WE8fdu1W+e47vjE13G7Ddvy4EiiV
         Hf9Q==
X-Gm-Message-State: APjAAAUNQz7rlthe5dhneYM5IiioaqWuBOi6qvEdwTNWbVBd0g+jUbh5
        poKLmdgQp0604N31rRsrZ1ItALVjaJ8=
X-Google-Smtp-Source: APXvYqzk/ilEnPzCnnwMIxBkcm4eFKv2uQoaS7ya7g0teP5oNRGqEtnvg93eOOx2jVhiowuUbrvDAg==
X-Received: by 2002:a17:90a:cf11:: with SMTP id h17mr3181708pju.103.1582695104226;
        Tue, 25 Feb 2020 21:31:44 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:1421:d554:52c5:9706? ([2601:647:4000:d7:1421:d554:52c5:9706])
        by smtp.gmail.com with ESMTPSA id k63sm895901pjb.10.2020.02.25.21.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 21:31:43 -0800 (PST)
Subject: Re: [PATCH] SCSI: use kobj_to_dev
To:     guosongsu@gmail.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guosong Su <suguosong@xiaomi.com>
References: <20200225100411.10250-1-guosongsu@gmail.com>
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
Message-ID: <9abc13e0-3f5b-93e0-fc88-d37b7269d965@acm.org>
Date:   Tue, 25 Feb 2020 21:31:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225100411.10250-1-guosongsu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-25 02:04, guosongsu@gmail.com wrote:
> From: Guosong Su <suguosong@xiaomi.com>
> 
> Use kobj_to_dev to instead of open-coding it.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
