Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101E5C38A24
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEB722075E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgEGEcn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 00:32:43 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44682 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgEGEcn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 00:32:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id p25so2331955pfn.11;
        Wed, 06 May 2020 21:32:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=im3ZaNvMLMp9Jj9ynY7CLsk9ZXYPpP2aPz+PzBeFtqY=;
        b=XAbLToOPrtzrsn/hwTmXkvz0esGJTifYxLcoL5ygru8eGYzOt3GKSL1GK5jNZt+zES
         lRcUXV0Ha4JAugCu//OXLRzRynkrJcxLqHSbCZfiohj18yXiWVj/q1LBQeRs8Vnt2a9Q
         UcHV44HNUyg5hgBbGs2ajDjd3sLG7cK2VYmJHbzrFhkMFUa9p1VApwUb6mlM/eAFZV1A
         SC6IjQIghirfQ50+FesvufdVK8/Y0IS8p2zqffER56rcO0ghMovK4GiWmVjpsoa1hYJY
         ebyakgU1IsKV7haHtPvZgVaQYiozoaGA12OT/w3uT8DdzgKutydfOmJ3F7SZHJ4Q7adB
         Wq+A==
X-Gm-Message-State: AGi0PuYgGiaB9hrPa1Kw9P7TEB96zxxvcwBeTJi8Hor7F4RhxvefPq8B
        YDZ3S5I8sG8FnHVYEErKplTJq8vdS/C+Wg==
X-Google-Smtp-Source: APiQypL5YHkQecxnKIVd2PoYpMgS11P0zwyHbJRGGOzM7MqKVqLDVrRo75zM16AL1jNoWkSLrlVe0Q==
X-Received: by 2002:a63:fc5d:: with SMTP id r29mr10009799pgk.131.1588825960776;
        Wed, 06 May 2020 21:32:40 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:246f:3453:e672:e40c? ([2601:647:4000:d7:246f:3453:e672:e40c])
        by smtp.gmail.com with ESMTPSA id m6sm6147350pjo.5.2020.05.06.21.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 21:32:39 -0700 (PDT)
Subject: Re: [PATCH v4 1/1] scsi: pm: Balance pm_only counter of request queue
 during system resume
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, stanley.chu@mediatek.com,
        alim.akhtar@samsung.com, beanhuo@micron.com, Avri.Altman@wdc.com,
        bjorn.andersson@linaro.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1588740936-28846-1-git-send-email-cang@codeaurora.org>
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
Message-ID: <1a08d761-61e1-0f46-0b6b-8e74745d3a7c@acm.org>
Date:   Wed, 6 May 2020 21:32:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588740936-28846-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-05 21:55, Can Guo wrote:
> During system resume, scsi_resume_device() decreases a request queue's
> pm_only counter if the scsi device was quiesced before. But after that,
> if the scsi device's RPM status is RPM_SUSPENDED, the pm_only counter is
> still held (non-zero). Current scsi resume hook only sets the RPM status
> of the scsi device and its request queue to RPM_ACTIVE, but leaves the
> pm_only counter unchanged. This may make the request queue's pm_only
> counter remain non-zero after resume hook returns, hence those who are
> waiting on the mq_freeze_wq would never be woken up. Fix this by calling
> blk_post_runtime_resume() if a sdev's RPM status was RPM_SUSPENDED.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Thank you for having root-caused and fixed this!

Bart.
