Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1848C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 03:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A86C420825
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 03:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgGWDxL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 23:53:11 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:34269 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGWDxL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 23:53:11 -0400
Received: by mail-pj1-f68.google.com with SMTP id cv18so3736755pjb.1;
        Wed, 22 Jul 2020 20:53:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xjAKpHFHzgoSZ1buN8IrXmLnuePQtpjKoqBhopDmhts=;
        b=sgHfIsz2dMUsrXM5oU60kBdwx4nSt33jV06SlXbKMZKXaSsHMk44u0pSYj/V/6UMdw
         1qnB/8Br5688h6a9yLe3PZ16KihrE0pjjpXxqaPZ4PDd9Jkf8fJ/Y9KgdeZdKPLHWzko
         W+IxemjXGR/a/Na7sCAoImmqh3dWNn22jHDV5wYosn/+HBF0fwKUUnhAfX6NnVp5+SPN
         GGL2kwXTj8TlJFItmzjRr1Dbwut21Eh3PI6aSEdHMfdVZRpxjMHoFWpSNmlWV/QL/Y9J
         rj3XR84FjUGvmxtqO5aJzO11IsAIMf4eGIw+nf115MwwQH4so3uAZikpGeFFKu3/mVer
         OlBw==
X-Gm-Message-State: AOAM5300z0qPM9YmOfvo5wD4xL3WC8rEew6jdBwZiGDqRr1PkAMG8v1E
        9ORxzTQEAVgEVN0LoqhTIp+5jMXm
X-Google-Smtp-Source: ABdhPJyd+5A8LXHNsdrqFWC+C3NGi5AFfEX0ynFb5N6BORH6hriMhKWLNk3qLQbWcM+bOyjDM0UJfg==
X-Received: by 2002:a17:90a:9287:: with SMTP id n7mr2110685pjo.223.1595476390247;
        Wed, 22 Jul 2020 20:53:10 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id q14sm1170753pgk.86.2020.07.22.20.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 20:53:09 -0700 (PDT)
Subject: Re: [PATCH v3] SCSI and block: Simplify resume handling
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     martin.petersen@oracle.com, Can Guo <cang@codeaurora.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20200701183718.GA507293@rowland.harvard.edu>
 <9e824700-dfd1-5d71-5e91-833c35ea55eb@acm.org>
 <20200706151436.GA702867@rowland.harvard.edu>
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
Message-ID: <b1dcfb82-e6d4-cb34-c4b3-6557f776e0df@acm.org>
Date:   Wed, 22 Jul 2020 20:53:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706151436.GA702867@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-06 08:14, Alan Stern wrote:
> Commit 05d18ae1cc8a ("scsi: pm: Balance pm_only counter of request
> queue during system resume") fixed a problem in the block layer's
> runtime-PM code: blk_set_runtime_active() failed to call
> blk_clear_pm_only().  However, the commit's implementation was
> awkward; it forced the SCSI system-resume handler to choose whether to
> call blk_post_runtime_resume() or blk_set_runtime_active(), depending
> on whether or not the SCSI device had previously been runtime
> suspended.
> 
> This patch simplifies the situation considerably by adding the missing
> function call directly into blk_set_runtime_active() (under the
> condition that the queue is not already in the RPM_ACTIVE state).
> This allows the SCSI routine to revert back to its original form.
> Furthermore, making this change reveals that blk_post_runtime_resume()
> (in its success pathway) does exactly the same thing as
> blk_set_runtime_active().  The duplicate code is easily removed by
> making one routine call the other.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
