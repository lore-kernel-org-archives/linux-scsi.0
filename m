Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFA2C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 19:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA4802068D
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 19:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgFHTg4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 15:36:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41466 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgFHTg4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 15:36:56 -0400
Received: by mail-pg1-f193.google.com with SMTP id r10so9182791pgv.8
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2020 12:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tS+NAUv3oymLebzVE6+rGHdxl7jZAoujAnHprvM8CIE=;
        b=YTppWR9fcGnIu1BnxdV5mDYbNqFgaszQa9/3z5WwAilkpS8ir0tITXcGhmvlshAY1Q
         ZxY5qhjaPtd22XgoNsbeULLKtDy5oHzWKSozGfI2ZrUb8+ya1CVLMMXAecgdNhEW6H0x
         Dd8tURF2P/c3RuSRqAJEa3Sj35Rl/VKB2OTF3Fr8wWPzp2ooHyL5va7T4VNuVFZME7Zk
         dAU09+NC9THwqU+l1yp3yskxgPlbBfuJZRXzZPUGtuqY2IQt+OHT1WTXQg4hf8VWZA9i
         DVyZXnXbXExTyvZSRNPYBaRUzhqkwxeosp4DICH12HCljiHGeQB2XKyrQ1ZtmHJHiQu2
         1WvQ==
X-Gm-Message-State: AOAM530lETjZZ107Q+qWF1XPJCdBThTOYAAGjx4dKtk/lRGxWyHC4yc2
        RhYG15KtBqRxxfKctUeoN5g=
X-Google-Smtp-Source: ABdhPJx+OAdsrFpZd59L3EPR4KuS4/f4xbXqZbzmyuHeGZoHEw1qTrBuncZfZb4cJ2dSa1sbw2lX9g==
X-Received: by 2002:a65:46c9:: with SMTP id n9mr595940pgr.89.1591645015244;
        Mon, 08 Jun 2020 12:36:55 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p11sm8224801pfq.10.2020.06.08.12.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 12:36:54 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] qla2xxx: Change in PUREX to handle FPIN ELS
 requests.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200608184630.31574-1-njavali@marvell.com>
 <20200608184630.31574-2-njavali@marvell.com>
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
Message-ID: <1e2939f1-d117-d548-722c-730e9f21e2de@acm.org>
Date:   Mon, 8 Jun 2020 12:36:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200608184630.31574-2-njavali@marvell.com>
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
> SAN Congestion Management generates ELS pkts whose size
> can vary, and be > 64 bytes. Change the purex
> handling code to support non standard ELS pkt size.
> 
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Reviewed-by: Arun Easi <aeasi@marvell.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Reviewed-by: James Smart <james.smart@broadcom.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>

Has anyone other than Himanshu ever posted a positive review for this
patch? I can't find the other review tags here:
https://lore.kernel.org/linux-scsi/20200514101026.10040-1-njavali@marvell.com/

Bart.
