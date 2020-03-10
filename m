Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BAFC10F25
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 02:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 631B124655
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 02:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgCJCCK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 22:02:10 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45695 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgCJCCJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 22:02:09 -0400
Received: by mail-pf1-f193.google.com with SMTP id 2so5700339pfg.12
        for <linux-scsi@vger.kernel.org>; Mon, 09 Mar 2020 19:02:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JxsIeFBB4peskT1/UbsT65+a1eaX3W33hLXnDRbuXGg=;
        b=n+kLAIdccfbVdxhBch0uTW9/eo6H6QGzmCFcWHBYNzyY4ah8ph8/FnFhJGsMQLC6dl
         e+01aC3dVHltdXcVsY7Yd4fQG/ePUhjYvwq5PV6xXLzEWyjmQMxR5fVexQuTa3ajgGff
         2visICyBVEIu8/SqA/1UCQGTX7G0HGu4UFP/UHitF5IWuscca2cytEVnFX0VYAVO3JGj
         oUexSSK+qTOOrq0sSXQfJqL6s0BmPQOfQyjJKP3WbYtwKF5oahSvoeu4eE9G+E8RB12T
         9ss1cVUIgKY1GFw/3/MrPVsTJ9Q4/BqCTMznM2gSU9kiMGElq3IGqNZ7nTKgRaHGQHdB
         8z7Q==
X-Gm-Message-State: ANhLgQ3/ZCWNuUHV5RN6ZGJu3Jm5INT6brF1D2CJUwf9RqyS1sZrqvnr
        nhUBt8dnLLzs3WCwqJgtgWAW2ekQ
X-Google-Smtp-Source: ADFU+vs0Eh4W38aI0H5o9izcMtcirFtXi1ZKbBUVl/QCJFP9dzMOAyItueUTmmJ7XS5H+MFNyzedqA==
X-Received: by 2002:a63:e141:: with SMTP id h1mr2805236pgk.129.1583805726958;
        Mon, 09 Mar 2020 19:02:06 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:c0e4:71da:7a83:2357? ([2601:647:4000:d7:c0e4:71da:7a83:2357])
        by smtp.gmail.com with ESMTPSA id e11sm3275370pfj.95.2020.03.09.19.02.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 19:02:05 -0700 (PDT)
Subject: Re: [PATCH] scsi: avoid repetitive logging of device offline messages
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
References: <20200309181416.10665-1-emilne@redhat.com>
 <b7f3c0d1-0f08-83e2-6df5-8b6a02201ba6@acm.org>
 <c9ebe5ecaff898c848402413d9404b23dfe999e6.camel@redhat.com>
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
Message-ID: <ccbaa97a-c946-f235-c7c3-3d9d6bf319c0@acm.org>
Date:   Mon, 9 Mar 2020 19:02:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c9ebe5ecaff898c848402413d9404b23dfe999e6.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-09 13:54, Ewan D. Milne wrote:
> The only purpose of the flag is to try to suppress duplicate messages,
> in the common case it is a single thread submitting the queued I/O which
> is going to get rejected.  If multiple threads submit I/O there might
> be duplicated messages but that is not all that critical.  Hence the
> lack of locking on the flag.

Hi Ewan,

My concern is that scsi_prep_state_check() may be called from more than
one thread at the same time and that bitfield changes are not thread-safe.

Thanks,

Bart.
