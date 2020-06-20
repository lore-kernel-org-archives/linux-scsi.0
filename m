Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F6FC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 16:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE3A23EF1
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 16:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgFTQdL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Jun 2020 12:33:11 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37838 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgFTQdJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2020 12:33:09 -0400
Received: by mail-pj1-f65.google.com with SMTP id m2so6011285pjv.2
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jun 2020 09:33:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bRgn0RswBtYYq7jVzj6HGL/cOgYyaiY0DipgJjCvfqc=;
        b=dDzKJygu89q9B753STq/avwmiiqxyfAStMvjND6kRRDH8ObmsM4krwHG6hlof4kT7P
         luDewAzSdQRugs44M88SWCqMQRYtHuiFnePrhcO3vlqw1ipUBPOikQGlAYrXEC6mBXq4
         5zoVbcsjQzIfGvE8I7UK7/49Sjj+8hkbeyk38nTj799NqXd7/f3Eb/+ZhLGqdw3OU24f
         vPTXk6ZdCX/UzjFhnLaxf2aJuErkQTQcpn+KpwO25lumDqDzgI0+1iuqVj51CRIT66hA
         eVGyRvwfv7x2FaNpq8Kp6jnXKo18NlxTBlqSFLKs1dk+ARRF/jCeKkPMwkL0MI3C9VID
         BqIA==
X-Gm-Message-State: AOAM532PF5/MW6FoEfOIWi7e9p8NdkEfz0K5t2yJgvsvYkJVv9z/e8cb
        ZFq5da3BYTFYB5Vbs4yQzniLJa/j
X-Google-Smtp-Source: ABdhPJyZFuql98jsMa7mi2Ss8/+bym2Vl5MTj//1Pi6qwA2nk3uGmwdF/9LYueK+ivsxViJZUncVFA==
X-Received: by 2002:a17:90a:d3d6:: with SMTP id d22mr9233860pjw.184.1592670788997;
        Sat, 20 Jun 2020 09:33:08 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i3sm8403986pjv.1.2020.06.20.09.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 09:33:08 -0700 (PDT)
Subject: Re: [RFC PATCH v1 1/2] ufs: introduce callbacks to get command
 information
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org,
        Christoph Hellwig <hch@lst.de>
References: <CGME20200620070044epcas2p269e3c266c86c65dd0e894d8188036a30@epcas2p2.samsung.com>
 <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com>
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
Message-ID: <992d1812-98b9-99b5-acc0-69c7aba3d074@acm.org>
Date:   Sat, 20 Jun 2020 09:33:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-19 23:53, Kiwoong Kim wrote:
> Some SoC specific might need command history for
> various reasons, such as stacking command contexts
> in system memory to check for debugging in the future
> or scaling some DVFS knobs to boost IO throughput.
> 
> What you would do with the information could be
> variant per SoC vendor.

Isn't this something that should be done in an I/O scheduler instead of
in a SCSI LLD? I don't like the idea behind this patch series at all.

Bart.
