Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41086C5DF61
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 03:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BCB82187F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 03:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733023AbfKGDJn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:09:43 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42972 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbfKGDJn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Nov 2019 22:09:43 -0500
Received: by mail-pf1-f194.google.com with SMTP id s5so1233938pfh.9;
        Wed, 06 Nov 2019 19:09:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BBtPM3gY1UuxW18zWEymN1u6YIPxJVTbYUr56MDrFLk=;
        b=ZTibWmD7ABSaOUT8yj6GY8014Oxxd8uAs+97411ypIGXa5+ML3x7A1EOd3q0jneB6Y
         h4mqN9Pgx4dUtjXKVfRMmAzgGqmrFjOk2NKwa7ikijomVJsqPQOl3qDU51yc3QoF0XeK
         MnEjscBx90Nwgh0U7iSCXnO205ABxqqPuUDO4yG9oD9XLegddb2qumIrl0tzbi/5sMFB
         cwl3Vx/8sPKzEWvMpLhmb45hS/y7KNhaoTI4H6AiBtN4deJ33pUCbUWyp6/DKJcrf9gC
         2rOY9NgB3unNcjaRhnfOaRXBLgwwvIyvAmHm9x2d2H6BoCQxIHirFvoLcFfdmssMVRR6
         t6CA==
X-Gm-Message-State: APjAAAWIYUNNlyjJJv2KJkwLgioyo1FT/sfyxlL+B7KMfhCWDmo+IYwz
        KjXN11+85lyHgPOm0FjxT3Y=
X-Google-Smtp-Source: APXvYqwdILDeAkwWwKboWax/p1cWrFHQpVYwBfdDSuaQFceigo7Z0sgSVu36vS/VQWgMSyHAWdU3Wg==
X-Received: by 2002:a62:8748:: with SMTP id i69mr1011820pfe.224.1573096182342;
        Wed, 06 Nov 2019 19:09:42 -0800 (PST)
Received: from localhost.localdomain ([2601:647:4000:1075:d11a:9efb:cec9:72e3])
        by smtp.gmail.com with ESMTPSA id p123sm428892pfg.30.2019.11.06.19.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2019 19:09:41 -0800 (PST)
Subject: Re: [PATCH 2/9] c6x: Include <linux/unaligned/generic.h> instead of
 duplicating it
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <jacquiot.aurelien@gmail.com>
References: <20191028200700.213753-1-bvanassche@acm.org>
 <20191028200700.213753-3-bvanassche@acm.org>
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
Message-ID: <5fc0b262-7890-b304-eaa2-f4dd7e42588b@acm.org>
Date:   Wed, 6 Nov 2019 19:09:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191028200700.213753-3-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-28 13:06, Bart Van Assche wrote:
> Use the generic __{get,put}_unaligned_[bl]e() definitions instead of
> duplicating these. Since a later patch will add more definitions into
> <linux/unaligned/generic.h>, this patch ensures that these definitions
> have to be added only once. See also commit a7f626c1948a ("C6X: headers").
> See also commit 6510d41954dc ("kernel: Move arches to use common unaligned
> access").

Mark and Aurelien, are you the c6x maintainers? If so, please let me
know whether you agree with this patch.

Thanks,

Bart.
