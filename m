Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2CFC433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 03:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7D15206F6
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 03:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgGID3q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 23:29:46 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46712 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgGID3q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 23:29:46 -0400
Received: by mail-pl1-f194.google.com with SMTP id k5so239061plk.13;
        Wed, 08 Jul 2020 20:29:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=q3IZnISxIPPDDwiALWI0ioJvtr5nXFi3N6ROOCyQZVo=;
        b=VJIbfRQvxtQX0pN1FFR4yBL0oki01MAVHJsWfoHLw1mwtpPbh7NtyEcQ0jtyajXlpp
         fONGflndInwAnZngT4IWla09hLt1aNFTPELF+oOp3fVGQbxxqq0Zb4boBcGppgz41dun
         zfWVl73HmeO/V9Cnu6KcinCsLbUk6e6+ajoFIMyn3qHjpSQ9Yi1yGhZhXzorFV5EjfQa
         3dLMgmhASBRaArfRf2PUGRsUP/cVH05WOkBMAXTkJx6xkMSdbHYJE5/51+52DoasqJun
         k3tkIPdJ3qkn3p8eM4ALGi33cJku6HEA35DyuP2E7nCMLjqDTa+0ilnFwm5/mUKniQEH
         g6Rg==
X-Gm-Message-State: AOAM530xiuwy22ydncvN1Ro41ZAXOw72G+RsHzKH24KtEuzGV51qn3Ls
        7k6j/sRvh8T5Z6yiEpCFn30KADop
X-Google-Smtp-Source: ABdhPJzE2GAiIlP0/TAp118wClGJghip5lBkzBi3AP+o6TZ1uuBpKiOQMDT31dEmCjVeJ47WRHEhcg==
X-Received: by 2002:a17:90a:ff91:: with SMTP id hf17mr12659856pjb.137.1594265385253;
        Wed, 08 Jul 2020 20:29:45 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id e8sm959013pff.185.2020.07.08.20.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 20:29:44 -0700 (PDT)
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
Message-ID: <269bdaab-797e-f54c-11af-46561220b448@acm.org>
Date:   Wed, 8 Jul 2020 20:29:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
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
> 
> No functional changes are intended.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Can Guo <cang@codeaurora.org>
> CC: Bart Van Assche <bvanassche@acm.org>

This patch looks good to me. Can, since this patch modifies code in
which you recently fixed a bug, would it be possible to test this patch?

Thanks,

Bart.
