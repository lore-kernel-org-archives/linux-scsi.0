Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89B9C28CBC
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 15:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF01020A8B
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 15:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgEFPnO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 11:43:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35213 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729148AbgEFPnO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2020 11:43:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id t11so1269185pgg.2;
        Wed, 06 May 2020 08:43:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BJf4wYu0NsxL6tylmAdtEX4s9vSFaIuYVOh5PmM+C7Q=;
        b=rfS/WNAsadvgZYHywiiKzuRBk46hKn1AJ54alxOBavI1X12egJy/CA+QhQF+Z6Y3DZ
         3DxpQ0HGjBCBsXpG/VPNHoFpn6iI6D0zccq8TfdtfHACyPJ6nlUPmjhqI/w+FWLj5vzs
         y+VXqyvae49g3v36WxhHlorgEZMucLpGiGoXxZwWK3ZyXAY6mjoJZVsxFMjW3qzdLQGY
         9i+shXXRidLggMBMSpyxyLIrGe3FD4hyhhj3ZoFfkfr4t7cZqOI2nGWo1JN0w0vEjf1F
         VOg5JkYJGfO+zwhFHR9jZ86WBx6/vVytErb1jaR7A5VSBOI/whxMoW+69j0YX09ev3fm
         OkFQ==
X-Gm-Message-State: AGi0PuYV/iVV/wyD84THRRkWMRjLzlfvubN4XqqdhJ/aKNoXGx414HDF
        G/G+yYy6dfSXgXOw8snVJLjXma20RcY=
X-Google-Smtp-Source: APiQypLNTiOvWmG+Bh8Q3IGgwbzltAxS1IKMuY4odWTD0V93/uoZKcGQskMNNzedsCBNHRPlQ4Scww==
X-Received: by 2002:a63:e210:: with SMTP id q16mr7476154pgh.26.1588779792772;
        Wed, 06 May 2020 08:43:12 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:901f:c4d7:864c:c3a5? ([2601:647:4000:d7:901f:c4d7:864c:c3a5])
        by smtp.gmail.com with ESMTPSA id z1sm5036494pjn.43.2020.05.06.08.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 08:43:12 -0700 (PDT)
Subject: Re: [PATCH] scsi: qla2xxx: make qlafx00_process_aen() return void
To:     Jason Yan <yanaijie@huawei.com>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hmadhani@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200506061757.19536-1-yanaijie@huawei.com>
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
Message-ID: <15498a73-a02d-2568-4d85-9278fbba8ab4@acm.org>
Date:   Wed, 6 May 2020 08:43:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506061757.19536-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-05 23:17, Jason Yan wrote:
> No other functions use the return value of qlafx00_process_aen() and the
> return value is always 0 now. Make it return void. This fixes the
> following coccicheck warning:
> 
> drivers/scsi/qla2xxx/qla_mr.c:1716:5-9: Unneeded variable: "rval".
> Return "0" on line 1768

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

