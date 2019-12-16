Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0164C2D0CE
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 02:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFC382467B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 02:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfLPCkD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Dec 2019 21:40:03 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:45328 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfLPCkC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Dec 2019 21:40:02 -0500
Received: by mail-pj1-f67.google.com with SMTP id r11so2287448pjp.12;
        Sun, 15 Dec 2019 18:40:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=m8jv1ZjcwuWUckxPyANOJEGlpioaHtVIEdToSkgWcBM=;
        b=lUsvZ0CcXGO8tN/htois4hbCAxXEZJlR7I6uZxpGV10IjGAyZIcvBcDxhfFZVYK7mE
         fY7KuRJiB8AkIxhvdYSQzVY53lzAYw6XS4BxKyjGELoXw9xtZm6E66v+rfm7prdE6j4u
         OdbW6xrno8G1QDtMFTxcXcA9FQBFl6JqT1DLT+AujjVA6r8Ew0iMgltx2CJiaEqY6V4x
         HULEiGumWM/DhGCq8f28P8HOdjHJlyvFhTZBt6mck4im7Y2W/oOI2d6qC1pzpaFlEMmk
         Me1/IoH/pZ98Kzdz98Moltr0JxV1mq9b0kVnXug4lToXTvYzypPmnq+A21qBefuJBGhx
         2b+w==
X-Gm-Message-State: APjAAAX8xvAVLukrp2EtE9W5eJGIPpc672l/1UfRqaZILifUEQOO0mXR
        0AXtBrM+bb2DXhuti7qFQ34YjZPchlw=
X-Google-Smtp-Source: APXvYqwJDUhssX/SuN57Ic6JCCHkDENoNeQa++sZpuJpvRW3O9NlveTRQkNwVjKj559BLHCsr0vEdw==
X-Received: by 2002:a17:90a:508:: with SMTP id h8mr15041273pjh.91.1576464001834;
        Sun, 15 Dec 2019 18:40:01 -0800 (PST)
Received: from ?IPv6:2601:647:4000:110a:d014:2a0a:ea98:f50e? ([2601:647:4000:110a:d014:2a0a:ea98:f50e])
        by smtp.gmail.com with ESMTPSA id k16sm20101291pfh.97.2019.12.15.18.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Dec 2019 18:40:00 -0800 (PST)
Subject: Re: [PATCH 1/2] scsi: ufs: Put SCSI host after remove it
To:     cang@codeaurora.org
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1576328616-30404-1-git-send-email-cang@codeaurora.org>
 <1576328616-30404-2-git-send-email-cang@codeaurora.org>
 <85475247-efd5-732e-ae74-6d9a11e1bdf2@acm.org>
 <5aa3a266e3db3403e663b36ddfdc4d60@codeaurora.org>
 <2956b9c7-b019-e2b3-7a1b-7b796b724add@acm.org>
 <3afbe71cc9f0626edf66f7bc13b331f4@codeaurora.org>
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
Message-ID: <5b77c25f-3cc7-f90b-fcd7-dd4c1e2f46d2@acm.org>
Date:   Sun, 15 Dec 2019 18:39:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3afbe71cc9f0626edf66f7bc13b331f4@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-15 17:34, cang@codeaurora.org wrote:
> This is applied to 5.5/scsi-queue. The two changes I patsed from you are
> not merged yet, I am still doing code review to them, so there is no
> blk_cleanup_queue() calls in my code base. I am just saying you may move
> your blk_cleanup_queue() calls below cancel_work_sync(&hba->eh_work) if
> my change applies. How do you think?
> 
> scsi_host_put() was there before but explicitly removed by
> afa3dfd42d205b106787476647735aa1de1a5d02. I agree with you, without this
> change, there is memory leak.

Hi Can,

Since your patch restores a call that was removed earlier, please
consider adding a Fixes: tag to your patch.

Please also have a look at
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=5.6/scsi-queue.
As one can see my patches that introduce blk_cleanup_queue() and
blk_mq_free_tag_set() calls have already been queued on Martin's
5.6/scsi-queue branch.

Bart.
