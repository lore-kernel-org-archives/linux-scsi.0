Return-Path: <SRS0=uhQV=4K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB23C35669
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 02:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD292072C
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 02:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgBVCpk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 21:45:40 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45607 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgBVCpk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2020 21:45:40 -0500
Received: by mail-pg1-f195.google.com with SMTP id b9so1915638pgk.12
        for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2020 18:45:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HE7sH2ZRXmWzWVLBJHBdZ14L20XJIe9q/E4kuKDwjU4=;
        b=mRq75tcTXAbNIzgJtL5siP1hZt+gt1nn2JLkJr9aD/udAO94V/ArcrNSr9nb/+w99z
         1E9v/GZX6DhCatSaoEsDyOJyGQ+KaoeMvw3Bl7lZJSYsZILprs9daOTUkg2xuDjAiDFR
         Pj+V7pSwIlM/wxCenxxNy240dqOGVVJfsJ2FiU3YLRfgCjrfMONOQY5KfNDsOQEH1Lud
         F9zslNbdxrNHZTnwxU07omRzi7+p4BC38KbaSA39CsYzUim30QmzCaBBVKJVsJEUm9fN
         THHbEe9hJ00cFpnMGqVLS9wvTrllcviGy95ql+mmxQcSMfHnyHfSlRO4Ydp687s3XnVT
         Emow==
X-Gm-Message-State: APjAAAXcJGujUBb/rRHjm2szb3ccwEuo+nAcOaeu72A2piuABnXLd5n4
        E0IGdAxp2deE/I7VE26pmMdDWky7n5o=
X-Google-Smtp-Source: APXvYqzWs5Cwc9Gw6SGmemF4Gxw1DEKMcOcBzdi6hvMjMNXjEVF7UMked63C4B4O+B31HwHnm43JpA==
X-Received: by 2002:a63:8f59:: with SMTP id r25mr42861772pgn.280.1582339539924;
        Fri, 21 Feb 2020 18:45:39 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:89d3:733:bb73:c1a4? ([2601:647:4000:d7:89d3:733:bb73:c1a4])
        by smtp.gmail.com with ESMTPSA id w25sm4136378pfi.106.2020.02.21.18.45.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 18:45:39 -0800 (PST)
Subject: Re: [PATCH 2/2] ufshcd: use an enum for quirks
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
References: <20200221140812.476338-1-hch@lst.de>
 <20200221140812.476338-3-hch@lst.de>
 <7f2394fb-d1fc-830b-eab7-30650c92e87f@codeaurora.org>
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
Message-ID: <530c2c48-7bc7-1a8e-07b9-997854188f9c@acm.org>
Date:   Fri, 21 Feb 2020 18:45:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <7f2394fb-d1fc-830b-eab7-30650c92e87f@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-21 10:18, Asutosh Das (asd) wrote:
> On 2/21/2020 6:08 AM, Christoph Hellwig wrote:
>> +    /* Interrupt aggregation support is broken */
>> +    UFSHCD_QUIRK_BROKEN_INTR_AGGR            = 1 << 0,
>> +
> 
> How about using BIT() here?

Not everyone is convinced that using BIT() improves code readability.

Bart.
