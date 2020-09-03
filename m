Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 055D5C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7E9F2078E
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgICDxi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:53:38 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:38965 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgICDxf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 23:53:35 -0400
Received: by mail-pf1-f175.google.com with SMTP id u128so1138734pfb.6
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2020 20:53:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oNfqXN4IU/Vo5beBoek1G40MI59V9D07UClAULI0G+Y=;
        b=FNgUWp2FTsWMK65vVfDF16qGN86wdQDGWASGTUPYmoXwvXpmj64f0K3xOUDMDJPNx0
         HMZxhlUwJzAoFlIEdkA0zUyeiHM4PKqt65kfWAX36xk0xfItt5OberFsnSIOHizYPXwU
         k739DqwVNEr7qyFm1sTp7imW3Wjvy4U0XVCEE1krho7EPGm8h8KxBUo1UyRfdfCxrOjD
         UmgrZDfZtt+IJcdQWC+ukqi+ks58tR0PHxjn3QQLg2MIB/nBAgMZlnsVMPKHJVwm2JxM
         yb+ddIS9qs5YitMHL+Uj0EUE1sDylZVqMKcAXfeBBM/l2OQAzDkdTbMhNm+wEOcl4TzA
         HeRQ==
X-Gm-Message-State: AOAM530Qf+/5MBrCMiamNwPb6FAsd+p6D9i8DMOKAevETAqEK/uDieDW
        r/KQWT54nLNguhK8+YGNQ7cBGnAOzR8=
X-Google-Smtp-Source: ABdhPJy10Sq8ripSsduJUhTfZ2G0OIICEwfJhFcWQ9YmLkiXpkGZC/gZl3WQ7qM1OElxcYEUGVVM3g==
X-Received: by 2002:a17:902:7896:b029:d0:89f1:9e33 with SMTP id q22-20020a1709027896b02900d089f19e33mr159285pll.15.1599105212611;
        Wed, 02 Sep 2020 20:53:32 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:56b7:d2c3:23c8:7358? ([2601:647:4000:d7:56b7:d2c3:23c8:7358])
        by smtp.gmail.com with ESMTPSA id gt13sm785477pjb.43.2020.09.02.20.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 20:53:31 -0700 (PDT)
Subject: Re: SCSI staging branch
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <yq1o8mnd0k5.fsf@ca-mkp.ca.oracle.com>
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
Message-ID: <53465bce-bb91-cd26-7d5d-e9c1dee07a4e@acm.org>
Date:   Wed, 2 Sep 2020 20:53:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <yq1o8mnd0k5.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-02 20:25, Martin K. Petersen wrote:
> I have had a few pokes about why patches are slow to show up in
> 5.10/scsi-queue. The reason is that there have been an awful lot of
> rebases and fixups in the last couple of releases. When I have to go
> back and fix things that breaks the commit hash previously sent in the
> thank you notes from b4. Which again breaks the lore archive mail thread
> links to the git commits, etc.
> 
> As a result I am experimenting with having a staging branch that is
> separate from and slightly ahead of scsi-queue. I merge patches and let
> them soak in there for a few days to let zeroday and the various code
> analyzers do their thing. And once I am reasonably comfortable that I
> don't have to go back and fix anything, I'll shuffle the commits over to
> 5.10/scsi-queue.
> 
> This also means that there is now a delay between me merging something
> and the thank you notes being sent out. I was contemplating hacking b4
> so I could send notes for both staging and queue but it would generate a
> lot of potentially duplicate email.
> 
> Another option is that I send a personal note to the submitter once
> stuff is staged. And then the public b4 thank you notes once the commits
> end up in scsi-queue proper. I'm open to suggestions.
> 
> Patchwork should still accurately reflect the status of posted
> patches. Plus my for-next branch shows what is currently staged, of
> course.

How about one branch per driver and doing an octopus merge before sending
a pull request to Linus? Would that be sufficient to prevent that commit
hashes break when dropping one patch series? Please note that I'm not sure
that this is the best approach.

Thanks,

Bart.


