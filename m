Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A0E4C4332B
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 04:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62AC22071C
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 04:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgCSE3h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 00:29:37 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:36339 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgCSE3h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2020 00:29:37 -0400
Received: by mail-pl1-f182.google.com with SMTP id g2so499474plo.3;
        Wed, 18 Mar 2020 21:29:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rFmth4wVLXPIQ4vkrsLqpNTYU2zcLktLeNqddkrmIRw=;
        b=t3H2o/TfdyX84ESADYxtRYMaWScrUSbcPF+COGJt/yTYB3JTnGRYPpmWLHRSfrgDeC
         vbjdlwDPpGUyeRUn3yml21VCElOCXagxFA5Y/Zo97yg8Q/rCffQ0u6kZbASe4okP0sxo
         edVXqgSKOKkNBdaVCjWUh1uV0tHEFWwoW+c1DNP9ID4Yncb7cisOnA/u7mdfV6P5rW81
         gItwz0qRxlIPDv/dUYaQBxnv9BXidR9CQqJyZ/vbp94vgA/b9CQ3Bpse9RG6+AmrLI5S
         3Gx8iNUuxPIOJlZctmOHYJaB8TnwneD3GBxrLcNtCj8xIZLi2Ru16kq1C8giDKDFwaka
         lcmQ==
X-Gm-Message-State: ANhLgQ2mOIgsjaBgErUj/7jR4LZLndbhMFzoVJilc01PaQXC6f+1+E+k
        Vqzu0zNDA8VkMZokc2AmDjjJJu9Gpls=
X-Google-Smtp-Source: ADFU+vtZBHclJF8Ci1JCtaMOJVJbfE3BByT3WHDZ2kfUSg37S24K2Daw+575AO4BaaoS6IixYntEow==
X-Received: by 2002:a17:902:207:: with SMTP id 7mr1740171plc.216.1584592175785;
        Wed, 18 Mar 2020 21:29:35 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:84b7:c685:175f:6f9b? ([2601:647:4000:d7:84b7:c685:175f:6f9b])
        by smtp.gmail.com with ESMTPSA id u18sm561455pfl.40.2020.03.18.21.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 21:29:34 -0700 (PDT)
Subject: Re: [PATCH] scsi: target: core: add task tag to trace events
To:     Viacheslav Dubeyko <slava@dubeyko.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com, v.dubeiko@yadro.com,
        rostedt@goodmis.org, mingo@redhat.com, r.bolshakov@yadro.com,
        k.shelekhin@yadro.com
References: <226e01deaa9baf46d6ff3b8698bc9fe881f7dfc1.camel@dubeyko.com>
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
Message-ID: <42e02192-4c5a-e19e-a02d-ede3974c18ed@acm.org>
Date:   Wed, 18 Mar 2020 21:29:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <226e01deaa9baf46d6ff3b8698bc9fe881f7dfc1.camel@dubeyko.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-16 06:07, Viacheslav Dubeyko wrote:
> Trace events target_sequencer_start and target_cmd_complete
> (include/trace/events/target.h) are ready to show NAA identifier,
> LUN ID, and many other important command details in the system log:

Reviewed-by: Bart van Assche <bvanassche@acm.org>
