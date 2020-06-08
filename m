Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9461DC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 19:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71DD92068D
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 19:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgFHThp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 15:37:45 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44048 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgFHTho (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 15:37:44 -0400
Received: by mail-pg1-f194.google.com with SMTP id r18so2931194pgk.11
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2020 12:37:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FEv5iq/cvOgk1raRGockMWQHFXFL9eUWhPYHC54yPk4=;
        b=ZGlYK2WcjFb622338sAU7n4r+apct38H+gutSJPxNg9Ggl0IAUl+4Ixpirt+i9ehJV
         TuKMvm2qsXe6OJnBpW6+EDCCBnKPo9CXlI4XAgWew9lrY/OIkjzK3C5PGWA72fYqbZGk
         ZsbErhtLAY2K2UuJzxqctexJtE41cYErX3Fy4cnlYMtYKp0vts5sq6ygFMx4ER2DIZbb
         keVCTm85KQJn7UJ07UI7UmN01lAVKF9bvgwLC64L6MD97K3NBysbVG0O8gVpJcqTCupT
         +Qu/8+n5t5WukMRULbUEE6XmY9Cpy5UKFJRkQ4vl8OQfa3g5EaMLBvkPkzp0ogyJfAix
         YRtg==
X-Gm-Message-State: AOAM533i66vuUk2n6NTJ0zVdsyOVW6nzc0sMIukLRMWMuuxcaqzTUqGu
        3n5sjtCZ09X71n1Omhmj7S5VC6ny
X-Google-Smtp-Source: ABdhPJy4J31f3FB7TS+/oQIJrO2ZGac4rxvTaWXoi9Pevckw5wVS5yjttesVTtALhowkP13XzPKUag==
X-Received: by 2002:a65:6703:: with SMTP id u3mr21121199pgf.179.1591645063671;
        Mon, 08 Jun 2020 12:37:43 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id j186sm7846900pfb.220.2020.06.08.12.37.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 12:37:42 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] qla2xxx: SAN congestion management(SCM)
 implementation.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200608184630.31574-1-njavali@marvell.com>
 <20200608184630.31574-3-njavali@marvell.com>
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
Message-ID: <ee6065cf-0d11-2475-637f-65b5b4e751ea@acm.org>
Date:   Mon, 8 Jun 2020 12:37:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200608184630.31574-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-08 11:46, Nilesh Javali wrote:
> From: Shyam Sundar <ssundar@marvell.com>
> 
> * Firmware Initialization with SCM enabled based on NVRAM setting and
>   firmware support (About Firmware).
> * Enable PUREX and add support for fabric performance impact
>   notification(FPIN) handling.
> * Allocate a default purex item for each vha, to handle memory
>   allocation failures in ISR.
> 
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Reviewed-by: Arun Easi <aeasi@marvell.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Reviewed-by: James Smart <james.smart@broadcom.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>

Same question for this patch: has anyone ever posted a positive review
for this patch?

Bart.
