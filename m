Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFF0C43461
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 15:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA5920772
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 15:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgIDPg1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 11:36:27 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36298 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgIDPg0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 11:36:26 -0400
Received: by mail-pj1-f67.google.com with SMTP id b17so1068436pji.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2020 08:36:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=b1s52rt6DCZCHqYuxKnfS5Fc/NwgB4Pig50R6j593/o=;
        b=CXZ0K50QNzcNrMYrgdfGIgoXOKp0HpW01faEi9u5UlNSd6vs9Cf35k6XB1HkShP3WS
         MuBy7PL51xPxsNNYHQ8fWdaY6QwGSfQ04eDfZQg+t34BgbDeBn4Jbob08LWhg8Z9s6HA
         EjZB1bGsb+H7XWygM0JVu5pcvnCeg53K+V9qZE4L01d445o7xPOTQnm0C25cR0flRwBE
         fmekrurLKXrbq4qXtSyjcxKENN9f+m26puqh7rV9Q3jKDKOQMrHetI4GXKJiUDIwHk/d
         YM1LJ/DQ0+u6rXScrTtuYNgezowvRNzkVE5YJ6MNfkg1JVNJGvp1C1C2Oy1mREXBvFW5
         QnbQ==
X-Gm-Message-State: AOAM530GD9dcr1lwTbRJsC1ngcBi6tllAfx1B2d9sWX7z97yJ/wt47aY
        21+8qWuHx8ntkbLIn+mdO5c=
X-Google-Smtp-Source: ABdhPJw5yjdqGR//Lh3zDmaI4vWLalps1E2ZMOWZS5bIlzZYMIvkduczCzriP49O1//FO8JMeGcS1A==
X-Received: by 2002:a17:902:9e08:b029:d0:8a6a:d5e8 with SMTP id d8-20020a1709029e08b02900d08a6ad5e8mr7645329plq.0.1599233785525;
        Fri, 04 Sep 2020 08:36:25 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:69e7:97a3:b129:6db? ([2601:647:4000:d7:69e7:97a3:b129:6db])
        by smtp.gmail.com with ESMTPSA id u14sm6892964pfm.103.2020.09.04.08.36.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 08:36:24 -0700 (PDT)
Subject: Re: [PATCH v3 11/13] qla2xxx: Add IOCB resource tracking
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200904045128.23631-1-njavali@marvell.com>
 <20200904045128.23631-12-njavali@marvell.com>
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
Message-ID: <bd547541-5a29-5ec5-305a-8614d5a8792c@acm.org>
Date:   Fri, 4 Sep 2020 08:36:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200904045128.23631-12-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-03 21:51, Nilesh Javali wrote:
> This patch tracks number of IOCB resources used in the IO
> fast path. If the number of used IOCBs reach a high water
> limit, driver would return the IO as busy and let upper layer
> retry. This prevents over subscription of IOCB resources where
> any future error recovery command is unable to cut through.
> Enable IOCB throttling by default.

Please use the block layer reserved tag mechanism instead of adding
a mechanism that is (a) racy and (b) triggers cache line ping-pong.

Thanks,

Bart.
