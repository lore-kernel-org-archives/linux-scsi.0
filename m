Return-Path: <SRS0=yjur=34=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0782C35250
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Feb 2020 03:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F6FA21741
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Feb 2020 03:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgBHDMK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 22:12:10 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33582 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgBHDMK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 22:12:10 -0500
Received: by mail-pg1-f196.google.com with SMTP id 6so802840pgk.0;
        Fri, 07 Feb 2020 19:12:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=LHjE4aw0geMA8WyiTQM05zFr0hQYO2SelPCxCuQgepg=;
        b=e9n/Yzds49DveJbJcMLJxZKsO0CN42S/bR9JhhwEa99nYxXXUyGRgXEt0RzeQ42CP5
         o1uiVMgmrQTKC6+6H7c1LEKwr3sBuTtKN7qlw127S0vlXdbWtO9gnkYYbMPfF7sz/FwT
         4io8P43UYf6b0Eg1SZvqen3fPcamw0xMfO71QGwaDpXAb9UeQWZF9BFCl2EUOab9472X
         nabhDF14O8WUnKpHCRiWF8ufpsc0R+pzPp4yOYEdjqj0eBb596fgwBPKzN7+Q4WMnbzB
         NQXMNjPhoSu7FYX6eIp1mw57etcc0yF60GfXtX9q9UGBCWM+QcipztEz+t0sewvHuPx5
         2ttg==
X-Gm-Message-State: APjAAAX+XsKBa2jtcO1CbhyfaBGfSEgLwK34brB8BX6Sk5866ZhGEPi3
        VhLEa0hZw2Yc30QO7httdz3jXx1gb1Q=
X-Google-Smtp-Source: APXvYqxSQXVjq8PdH9GA01Rd88i5qBTTXRYUs729DU+bD7YELr7saX5utp5rtYa7HODz8u8pLNhKEg==
X-Received: by 2002:a63:ba05:: with SMTP id k5mr2409915pgf.158.1581131528931;
        Fri, 07 Feb 2020 19:12:08 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:81e7:2f8f:8d7f:e4b7? ([2601:647:4000:d7:81e7:2f8f:8d7f:e4b7])
        by smtp.gmail.com with ESMTPSA id v8sm4190556pff.151.2020.02.07.19.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 19:12:08 -0800 (PST)
Subject: Re: [LIO-target] BUG: Deleting a LUN hangs in transport_clear_lun_ref
To:     Pavel Zakharov <pavel.zakharov@delphix.com>,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <9A92D656-A796-4858-85CD-3750BDACFA28@delphix.com>
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
Message-ID: <a1291c13-628f-edf3-3778-56b25f02edaf@acm.org>
Date:   Fri, 7 Feb 2020 19:12:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9A92D656-A796-4858-85CD-3750BDACFA28@delphix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-07 10:48, Pavel Zakharov wrote:
> I haven’t yet tried rebuilding the kernel with the patch reverted,> but that is the next step I’m planning to try once I figure out how
> to do it.

Hi Pavel,

How about verifying as follows whether that patch is the root cause:

git clone
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-kernel &&
cd linux-kernel &&
git revert 83f85b8ec305

and next configure, build and install the kernel, reboot and rerun your
test.

Thanks,

Bart.
