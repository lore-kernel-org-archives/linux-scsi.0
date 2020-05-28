Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1546DC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 14:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F15732084C
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 14:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391367AbgE1Oxk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 10:53:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44109 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391244AbgE1Oxi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 10:53:38 -0400
Received: by mail-pg1-f195.google.com with SMTP id p30so13561852pgl.11;
        Thu, 28 May 2020 07:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=cfzDVeenpvj+BZqV0/UhApIa8t7msOrP7Mg4fGDJbms=;
        b=aFu4DGMAKjLdV5kkQZKqVi9PDjp8s1ze+gdYXwwyva8l6MlIrnQ8kWtkrE4qW8jb3G
         NkD5d6Y+TR/Igxv3Ysb7xcLy30lSkALRDZRx2aCVcxWM2GBXpWd/mu4PUBFOFKIQzDnc
         tm2EbVUyZpBcT8Agpler1bsVaPgObiaM7wfixvlEkVuXEHJdiOz84HP5TqwmLfFmPq3e
         PXKCL1fQtmjZ4tH8YQ5GjvuLmMKYKYS4tjHax+6n1EB/Rzc56KyzC7iqim8VPDga67FB
         KE+0PQYloLcbyVT7x+6vmo9rkrUOGmT/2fzZVU3j/pbQ6jt6yRVb71cpnMXDABWXU/sh
         sY0w==
X-Gm-Message-State: AOAM5300UDoUA1zGlnvTwIAMwoeQD8Qt5q0ZFvasL2HTDZPKAg+0AksQ
        doa8vfebl3vnvZWOwz/nhrYnaHSoU/8=
X-Google-Smtp-Source: ABdhPJyww5SkYlCpB6JqMj2ap2uap5OXF3S8N+mAl26zik/nUI7r5eyXEVIv/1IC8TYkgg7xy4bQBg==
X-Received: by 2002:a63:40a:: with SMTP id 10mr3383814pge.310.1590677616663;
        Thu, 28 May 2020 07:53:36 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:40e6:aa88:9c03:e0b4? ([2601:647:4000:d7:40e6:aa88:9c03:e0b4])
        by smtp.gmail.com with ESMTPSA id k92sm5799676pjh.2.2020.05.28.07.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 07:53:35 -0700 (PDT)
Subject: Re: [PATCH] sbp-target: add the missed kfree() in an error path
To:     Chris Boot <bootc@bootc.net>
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20200528102056.911825-1-hslester96@gmail.com>
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
Message-ID: <475e4f50-6d20-d653-8288-0676bc708bcc@acm.org>
Date:   Thu, 28 May 2020 07:53:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528102056.911825-1-hslester96@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-28 03:20, Chuhong Yuan wrote:
> sbp_fetch_command() forgets to call kfree() in an error path.
> Add the missed call to fix it.

Hi Chris,

The changelog of the code under drivers/target/sbp makes we wonder
whether this driver has ever had any other users than its original
author. Do you agree with this? If so, do you want to keep this driver
in the kernel tree?

Thanks,

Bart.
