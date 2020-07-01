Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2491AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 04:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06A64206CB
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 04:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgGAE2w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 00:28:52 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45392 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgGAE2w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 00:28:52 -0400
Received: by mail-pl1-f193.google.com with SMTP id g17so9385716plq.12
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 21:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Xw6gfv7I3b2IomrbSBMZmB/u2fkKZqYajXzlt9Ie9Jk=;
        b=faZd9DDU/DUfv2QL1br/aWMHXVCDCxzZNvZbszJ7pFz6i3MnfNwW6UuXFKVaTTBX8j
         +OiEIOL3jotAFBBB9Uug5/0PknFw+vKCWnXBb3bp15BbKHVr669ZxX2cJPucz2UHK7QJ
         U47lOwoWbU6fkkzyTIyPX6oDCjRIKY/cs3q/p9ffdOrgxzhgAwBftKuQRe17Lwn3WlAP
         udEEbKvA8OboG6bMI40OJLXRGZfF9Zw6L4WFzw1fDw57MAxrrlbRg8XqMWPpj6EUliLw
         GHlai4I0gkPSVa8TItrF364WkgKa5Qqbk2hmWYZLU6OLgkPywa/aX7GrfabIHYdvB0e/
         91+A==
X-Gm-Message-State: AOAM531fmCyp318Mg49sv1jRNi9z89NoWnJkqSBntl2MCPdl/wJrbspz
        RUUQV0hHCOFY+No86saQ0qgzf73z
X-Google-Smtp-Source: ABdhPJy+4KoSmSsOcUcDvSPaGy/lu/a1sbvQ2T+uhXc8gp+RGmGWKWD8LYKsG4EC3gohG4dbitQi1g==
X-Received: by 2002:a17:90b:f97:: with SMTP id ft23mr22706037pjb.21.1593577728731;
        Tue, 30 Jun 2020 21:28:48 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k100sm3687913pjb.57.2020.06.30.21.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 21:28:47 -0700 (PDT)
Subject: Re: [PATCH v2 0/9] qla2xxx patches for kernel v5.9
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
References: <20200629225454.22863-1-bvanassche@acm.org>
 <02A19F4D-965A-4C3A-B542-6132489D7C94@oracle.com>
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
Message-ID: <11ed4054-635b-2c62-2240-e272dd95dccc@acm.org>
Date:   Tue, 30 Jun 2020 21:28:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <02A19F4D-965A-4C3A-B542-6132489D7C94@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-29 16:26, Himanshu Madhani wrote:
> I had reviewed this series earlier and provided Reviewed-by tag. 
> 
> https://lore.kernel.org/linux-scsi/EAC19A51-7256-4D5D-9DBB-D30CEF8551E9@oracle.com/

Thank you Himanshu for the reviews. I appreciate this. I promise to
check Reviewed-by tags more carefully in the future when reposting a
patch series.

Bart.
