Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3FFC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 17:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98CA420767
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 17:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgHXRsk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 13:48:40 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42453 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgHXRsg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 13:48:36 -0400
Received: by mail-pf1-f195.google.com with SMTP id 17so5199885pfw.9;
        Mon, 24 Aug 2020 10:48:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rq5TKAgvRU98SjjkveCy6+ZXF39JNnbfx7EG8ZsPrGA=;
        b=JUPgIw++a52Sx5xQ19RxppkLhoE3QJYwwE5bNgLvrXXMoQU7k+hWGk2Gs/SWTSdDOV
         1XTjCjlrVwTbs5lxHTAgdoZUftHCMgz6pZPy7FUWnL7dy4w8rvgMCehBxBb8/To6gn3Q
         uo9r2olbQ1WBAuIOhYWbppEHDEoa4ggsK+ACDqrK1j+D7AqQxdYOf/LTTvKHUOvvnCY5
         0A7fd9u3nO8tBdGH5Z/9lg1mIpI04ecfuLKK4+TB9KeUB1TJUkoyNsnSh2G3MN0+2zYY
         qQIesp9jcTXhL/MFWBeLlfJ6gMPb6iOKRZkd5G778GD/AzWC2B+IudaMoU8tqFYtZgjP
         GpIg==
X-Gm-Message-State: AOAM532kaQxYX7Df31e1ysFISEVsih7ABkMSSgOAcOKnM0Cz3Gi42KFz
        52nK8D3fKBp5eRbMoehkmO+8y/GXww4=
X-Google-Smtp-Source: ABdhPJwYwPUV3R0AMEbdzYtAUCpWFGOwxGYPK3swn5NtUc6J3LUYLFJiDH42C+rSc9l/dLHFn4P76w==
X-Received: by 2002:a63:fe49:: with SMTP id x9mr4003407pgj.446.1598291315134;
        Mon, 24 Aug 2020 10:48:35 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id y196sm12176464pfc.202.2020.08.24.10.48.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 10:48:34 -0700 (PDT)
Subject: Re: [PATCH] block: Fix bug in runtime-resume handling
To:     Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, kernel@puri.sm
References: <9b80ca7c-39f8-e52d-2535-8b0baf93c7d1@puri.sm>
 <425990b3-4b0b-4dcf-24dc-4e7e60d5869d@puri.sm>
 <20200807143002.GE226516@rowland.harvard.edu>
 <b0abab28-880e-4b88-eb3c-9ffd927d1ed9@puri.sm>
 <20200808150542.GB256751@rowland.harvard.edu>
 <d3b6f7b8-5345-1ae1-4f79-5dde226e74f1@puri.sm>
 <20200809152643.GA277165@rowland.harvard.edu>
 <60150284-be13-d373-5448-651b72a7c4c9@puri.sm>
 <20200810141343.GA299045@rowland.harvard.edu>
 <6f0c530f-4309-ab1e-393b-83bf8367f59e@puri.sm>
 <20200823145733.GC303967@rowland.harvard.edu>
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
Message-ID: <3e5a465e-8fe0-b379-a80e-23e2f588c71a@acm.org>
Date:   Mon, 24 Aug 2020 10:48:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200823145733.GC303967@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-23 07:57, Alan Stern wrote:
> The problem is fixed by checking that the queue's runtime-PM status
> isn't RPM_SUSPENDED before allowing a request to be issued, [ ... ]

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Can, can you help with testing this patch?

Thanks,

Bart.
