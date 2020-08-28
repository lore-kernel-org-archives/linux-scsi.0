Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15419C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 03:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD2F82080C
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 03:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgH1Daf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 23:30:35 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36937 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgH1Dae (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2020 23:30:34 -0400
Received: by mail-pl1-f193.google.com with SMTP id c15so1273337plq.4
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2020 20:30:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=afU71p7jziIn9rvabTseGtzF6RL0jfE1OBUpeJhUueM=;
        b=m9B49QkJf7+zX4+pNya0VsqOSgEfcj0NArGqibPd9Keu//jhocqCdPb+S441+Dd/Xv
         bRNGmcCDCcuT+5ioV+cU0E3H0INf5x8xrIgssGjLjSpX1wafskZC6Gf87kOUcU6ozCjU
         dBTDPIWCshGe0VmkaLYfpcd0X2r01D/EWftFiMDqWEi7Bi/tSehHDbUPue27M+oZ3y5i
         Xl2Woyw3+neXdliXPvoCzfN1mBs/hl+VOaHjczxGfYR3sD7QC4zGEQkr49ChDMWE7olu
         /ap4RoLjP1xAz6KNaWfrkGMFtjXkUGdjs8EJrcom17xp0HVE7wetutNkur/vaWp2Zl3A
         35qw==
X-Gm-Message-State: AOAM530HIs608x3Laufw7X1cRIQODkKVcYteTz4/KvOglmtqlLMQHu4v
        3GIj3gVu/P4dVRY9LPPErHA=
X-Google-Smtp-Source: ABdhPJzPgtRXjHqs9r3mpeSVnXc0rjfPQiyD021nF5auYPhhXbvugwDg/2iLSBdvHbxXMiRe5yqLqQ==
X-Received: by 2002:a17:90b:4c4d:: with SMTP id np13mr672465pjb.209.1598585433236;
        Thu, 27 Aug 2020 20:30:33 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d4sm3485746pju.56.2020.08.27.20.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 20:30:32 -0700 (PDT)
Subject: Re: [PATCH v3] fix qla2xxx regression on sparc64
To:     Rene Rebe <rene@exactcode.com>, linux-scsi@vger.kernel.org
Cc:     Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20200827.222729.1875148247374704975.rene@exactcode.com>
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
Message-ID: <c6ce5754-e0bb-e86f-51f6-333aafc7d2a2@acm.org>
Date:   Thu, 27 Aug 2020 20:30:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200827.222729.1875148247374704975.rene@exactcode.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-27 13:27, Rene Rebe wrote:
> Commit 98aee70d19a7e3203649fa2078464e4f402a0ad8 in 2014 broke qla2xxx
> on sparc64, e.g. as in the Sun Blade 1000 / 2000. Unbreak by partial
> revert to fix endianess in nvram firmware default initialization. Also
> mark the second frame_payload_size in nvram_t __le16 to avoid new
> sparse warnings.

Thank you for having fixed the endianness warnings.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
