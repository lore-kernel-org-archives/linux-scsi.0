Return-Path: <SRS0=iDBg=2U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192E3C2D0DA
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE0822253D
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 05:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfL3FAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Dec 2019 00:00:49 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41960 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfL3FAt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Dec 2019 00:00:49 -0500
Received: by mail-pl1-f194.google.com with SMTP id bd4so14178240plb.8
        for <linux-scsi@vger.kernel.org>; Sun, 29 Dec 2019 21:00:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yEVXYFblq6ONNZPlEyiuDi5GqqoTLbtw1cJlYaQHRps=;
        b=d8habFK2+DPHz1F2UR9oL/xdvnKoO7oRf5c1BDlCAmBm1+9XxJhypsTDpyvNldAuhn
         euMxrDPP2S48LEzX2jO5jECrrTDK50Ej6Ep0fuSgLg9o0EiVsbnvXFS90UkQjKxZCS2w
         UhusYIVXDzUKu57Hrdx+CDqsKM2vDirzUfSGQ6yoDCnpJovEz7ZcNokxqAScrOoMm5Sm
         NlJwxbGD/cd/gSn/yP7dclqXssxz4MbdhAA5am7wBuMY/OYUh3Ai39KqINhaTn/OqOeO
         JB2GvOkBSK5W8wkbKqD9HUVcqUx2bG9XZ6dqtD6aFehWWi8w4jnOZRZh2ridHl8QvcRE
         iIBw==
X-Gm-Message-State: APjAAAXOtJs5OeQc3oFvEv8p+Cfig6W45D4aYpax++h4Bjgc+RE1/kjT
        Gjygvg/B97Syliw+YcRlFXG1qd7C
X-Google-Smtp-Source: APXvYqy0GT97SdU7Xh0jjzqty+iPRrD7uofA50mk6z6faMgbceLnY5YDOQBfEPArx6CuFMQHHlBozw==
X-Received: by 2002:a17:90a:e990:: with SMTP id v16mr43894266pjy.67.1577682048522;
        Sun, 29 Dec 2019 21:00:48 -0800 (PST)
Received: from ?IPv6:2601:647:4000:10b0:8d02:1c2d:1354:1880? ([2601:647:4000:10b0:8d02:1c2d:1354:1880])
        by smtp.gmail.com with ESMTPSA id g2sm36455515pgn.59.2019.12.29.21.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Dec 2019 21:00:47 -0800 (PST)
Subject: Re: [Bug 205595] New: Memory leak in scsi_init_io
To:     bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org,
        tristmd@gmail.com
References: <bug-205595-11613@https.bugzilla.kernel.org/>
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
Message-ID: <fa730093-36c5-4c88-4d9d-301f77fa7464@acm.org>
Date:   Sun, 29 Dec 2019 21:00:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <bug-205595-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-20 06:27, bugzilla-daemon@bugzilla.kernel.org wrote:
> Syzkaller hit 'memory leak in scsi_init_io' bug.
> BUG: memory leak
> unreferenced object 0xffff888029b78500 (size 256):

Was the "unreferenced object" text perhaps generated by kmemleak?

What software genereated the "BUG: memory leak" output? A quick search
through the kernel tree did not reveal any code that produces that text.

I'm wondering how to reproduce this issue and the leak reports. Is
running the provided syzkaller reproducer sufficient?

Thanks,

Bart.
