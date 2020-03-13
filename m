Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C22C2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 20:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63147206EB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 20:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgCMUEm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 16:04:42 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:36406 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMUEm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 16:04:42 -0400
Received: by mail-pj1-f48.google.com with SMTP id nu11so1657688pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2020 13:04:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=A4u9yunZVDXL7PHYJAvDyvOM5ymV2nqIKZTx5TgGEcw=;
        b=Ct9rxn8EGAGYLCexCDsflZspEDzfiCsqPQJhYnmkQEk97Z8Ndw/7oSqtDPhpVf9Cuv
         jnzWdRxFWebR1cYozzHpNdNP7+wi64n1hDLHEv99vhSggGuru+pDuEIBM/AYR0zs74NG
         kqKBuuTi4jWRi2YUNmCBS7PdzTBrpcwKTDHcx19O8NJQUuphTOFhhV4fSkDKztTqGDv1
         ssMaF013k+Pt1SAjvmiK6CJPk8A0Qa2Vf+2pPdP1+B/snJj8JGwdVL7FbMtNohpS0xWw
         2dEnP0tYoXp9AKXUuMk5DPEtakADpWgfhUVwjyLL7rdQrxd2MGvmX0Yjjdmi8uyqUVfU
         EdaA==
X-Gm-Message-State: ANhLgQ1wXYv/bvG0Uy745JfaGoUtSz9LEdYEKjTMhXTsRtaRFufjRsav
        PQC7IdKVkRp0aaChe34sYM8=
X-Google-Smtp-Source: ADFU+vsNTWBL3+451Rj9OPyMcBy6x/06h/xEIu4AVN++y7xIC7ENr202GJEZANQ8JzCKnabDBEWc4Q==
X-Received: by 2002:a17:90a:3589:: with SMTP id r9mr11474598pjb.196.1584129880602;
        Fri, 13 Mar 2020 13:04:40 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:4927:51b8:6d1e:6c02? ([2601:647:4000:d7:4927:51b8:6d1e:6c02])
        by smtp.gmail.com with ESMTPSA id y9sm22089802pgo.80.2020.03.13.13.04.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 13:04:39 -0700 (PDT)
Subject: Re: [PATCH v2 3/5] treewide: Consolidate
 {get,put}_unaligned_[bl]e24() definitions
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>,
        Felipe Balbi <balbi@kernel.org>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200313023718.21830-1-bvanassche@acm.org>
 <20200313023718.21830-4-bvanassche@acm.org>
 <20200313091537.GQ1922688@smile.fi.intel.com>
 <615a0134-26ab-6591-632f-bf85d26ed60b@acm.org>
 <20200313163328.GY1922688@smile.fi.intel.com>
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
Message-ID: <7f70533a-d883-ceda-4bb7-074b01c58181@acm.org>
Date:   Fri, 13 Mar 2020 13:04:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200313163328.GY1922688@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-13 09:33, Andy Shevchenko wrote:
> You have at least two advantages on this:
> a) we really don't modify the content of the input value;
> b) it will be consistent with the rest of consolidated helpers.

(b) is an excellent point. I'm all in favor of consistency so I will add
the 'const' keyword.

Thanks,

Bart.


