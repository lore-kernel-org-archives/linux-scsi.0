Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC260C3404C
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A880424656
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgBTEt3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:49:29 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34924 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727637AbgBTEt3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2020 23:49:29 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so1050624plt.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2020 20:49:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6fbp7IfaIesFfYaHSMdlQNMpltNPLhuMUgtJ+6D/hv8=;
        b=AHrxWPE8vlqdZxZeBltWWf8Bvukqxv4yeZPDIG5KqdRoem/j+V8nDoL3XQgd+IDYs1
         LSJT/0LKSxz87Ga7WETikqSOIGnSP2A2rQcnpI+x7XagG+oaL09Dug4zj2nY4JPwy6JM
         2XeCowsGeMyjnhz4AwZ2mFZGuLnLqvrs2rufm3RqwlFs/Q35q/awuTOP4nYdkGsC2KbZ
         us8YgLXh25WppFL7IjSNpjaj1vqkZ94+WtMS7LVVoonUSnBY04fv7EQwSDhXv33Ep9e5
         G6c48+XxXUAhODDMLiCP03ksxCS4O27Ydef4/MzLFfECxufX3V/LAXZHmtVZRnSbDzt3
         /0yg==
X-Gm-Message-State: APjAAAXAkicPb6iz9bNs+CF6wDuQO/+Azf17GRphX1tb/EQHgI76wT+v
        cif8rYM48y0oGoU1L+alktOB+rbB1g0=
X-Google-Smtp-Source: APXvYqwTOtAqkaKfIWY6frFFgB3JhLrDm4X58hX3eVh+7xTGgx5OoCFpRO5EC5Il7CGlAZUzJIJkbg==
X-Received: by 2002:a17:902:ba8a:: with SMTP id k10mr30264995pls.333.1582174167973;
        Wed, 19 Feb 2020 20:49:27 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:29a7:b1bb:5b40:3d61? ([2601:647:4000:d7:29a7:b1bb:5b40:3d61])
        by smtp.gmail.com with ESMTPSA id d69sm1373596pfd.72.2020.02.19.20.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 20:49:27 -0800 (PST)
Subject: Re: [PATCH 1/3] ch: fixup refcounting imbalance for SCSI devices
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200213153207.123357-1-hare@suse.de>
 <20200213153207.123357-2-hare@suse.de>
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
Message-ID: <03c4146b-59f7-18d9-2283-d5499e4280f4@acm.org>
Date:   Wed, 19 Feb 2020 20:49:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200213153207.123357-2-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-13 07:32, Hannes Reinecke wrote:
> The SCSI device is required to be present during ch_probe()
> and ch_open(). But the SCSI device itself is only checked during
> ch_open(), so it's anyones guess if it had been present during
> ch_probe(). And consequently we can't reliably detach it during
> ch_release(), as ch_remove() might have been called first.
> So initialize the changer device during ch_probe(), and
> take a reference to the SCSI device during both ch_probe()
> and ch_open().

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
