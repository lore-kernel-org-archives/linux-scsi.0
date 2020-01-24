Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C5DC35240
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 03:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CBA620704
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 03:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbgAXDN3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 22:13:29 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:39596 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730664AbgAXDN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2020 22:13:29 -0500
Received: by mail-pf1-f169.google.com with SMTP id q10so400694pfs.6
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2020 19:13:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nmaQKSIkZfjQx4a5bCTAkinQ0w+y5qAslUd9NEqe5+Y=;
        b=ULIXDdaIOehn3H7OWBP9cxDd8GgbvQU8OUJgDfLhN16RbH3/wgOagoW9pz/pmgv3cX
         SAhsQSuVsciugjfIm4Gj1MSz9QyCf3si/5BmM3KURkBEsN6R6T/kifbE57p316GkNJHX
         7BO/hnDNJgxq/WHt08S8bvtqg/QVOlE871rUr7elY0QpS4/nWfco9lfrcn0Ec7HudiE6
         LLPYvh3rRPgeOWjnLYchSvsBHM7uL7+BlOKjwste141V2tVoa0gBCDzHcgycchitfWO8
         ZnupwcZBbyQ9j0GGVDMAs4rojjeeFOgdJ61Tg1cCMoaKPN0JpC827qGpoPGq3TwjEYB6
         4IJQ==
X-Gm-Message-State: APjAAAVKO5/6MfdnrvpaODZOHsxgyhT9Tsfx0SqxRzmf5WxZrh9W2W0s
        oxUTf1TsCwJw8N/Td11gZY0=
X-Google-Smtp-Source: APXvYqzRYCLvSYIu4u1FmKn/ay/BKAl7v6RMkIope+HquJWCne3N878eKq8PTdUPecb5DPHnm1OG4w==
X-Received: by 2002:aa7:9d9c:: with SMTP id f28mr1355997pfq.20.1579835608890;
        Thu, 23 Jan 2020 19:13:28 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:3d7d:713:61bd:ca2a? ([2601:647:4000:d7:3d7d:713:61bd:ca2a])
        by smtp.gmail.com with ESMTPSA id c19sm4390081pfc.144.2020.01.23.19.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 19:13:28 -0800 (PST)
Subject: Re: [PATCH v2 5/6] qla2xxx: Convert MAKE_HANDLE() from a define into
 an inline function
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200123042345.23886-1-bvanassche@acm.org>
 <20200123042345.23886-6-bvanassche@acm.org>
 <20200123103900.lgfr23w7p7fgcshr@beryllium.lan>
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
Message-ID: <5931014b-0170-8e82-174f-31b93ec14229@acm.org>
Date:   Thu, 23 Jan 2020 19:13:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200123103900.lgfr23w7p7fgcshr@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-23 02:39, Daniel Wagner wrote:
> s/MAKE_HANDLE/make_handle/ ?

That will make the function name conformant with the coding style. I
will look into this.

Bart.

