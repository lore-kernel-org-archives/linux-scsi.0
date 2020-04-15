Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7EEC2BB1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 02:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1A40206D5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 02:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392958AbgDOCXM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 22:23:12 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52303 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731321AbgDOCXG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 22:23:06 -0400
Received: by mail-pj1-f66.google.com with SMTP id ng8so6143657pjb.2;
        Tue, 14 Apr 2020 19:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K0/ZtYveb0WSnWgjE0GmECpyrbEo9Oi4rVOpH9N3mVA=;
        b=jzz+01IkP9JxidYMdpLsPj1rr3//hjnIjEJSGjDSbJub/9Y+daqlteBcH4yvwhFU75
         RUDUuNmuovZduys16Z/vMnNlqivERdm9ONCjv5I99b8Q9oszcZ1yyQtcLLDFDFI6YTWv
         YgjiWobv0utDFPfOq6aLxSm4t/QqLVkSFmoYcksWzoBlVxhuuaKTdIJkyKV5/7eHyDa8
         0Xi9cm5tDQtk3O2yMPjOnawZlAFBIaeyMumDRL+n5j73D0hD8F4f/wtHVt45FNLZCfPr
         KNxQTByLh4QMo+iPa6kT326Q6jNE4/InQZ07W104iqDzFS2FsvoUWzaDwjVm9uqaL4SY
         9s2g==
X-Gm-Message-State: AGi0PuaemndXX0haD/05iPsutN5kbZBSYPjdM+2bqb1KyHecweaQT1DO
        VPV7RK9EqGwOwMhkCRQc6kpxxfhVWf0=
X-Google-Smtp-Source: APiQypLs6Wyc7OpCheIVQfNewQIiwgqjHmKh8mY3DRWN4k1duJVybQJo/imlvRj+eEYpru8Y0JTVkQ==
X-Received: by 2002:a17:902:8c88:: with SMTP id t8mr2745910plo.176.1586917385875;
        Tue, 14 Apr 2020 19:23:05 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:3d9e:6f43:1883:92f0? ([2601:647:4000:d7:3d9e:6f43:1883:92f0])
        by smtp.gmail.com with ESMTPSA id v24sm12158318pfm.94.2020.04.14.19.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 19:23:04 -0700 (PDT)
Subject: Re: [RFC PATCH 1/5] target: add sysfs support
To:     Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, nab@linux-iscsi.org
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-2-mchristi@redhat.com>
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
Message-ID: <b6b87cff-c359-b7f6-ffd0-ff5b49dccbb8@acm.org>
Date:   Tue, 14 Apr 2020 19:23:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414051514.7296-2-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-13 22:15, Mike Christie wrote:
> target_core/
> `-- $fabric_driver
>     `-- target_name
>         |-- tpgt_1
>         |   `-- sessions
>         `-- tpgt_2
>             `-- sessions
> 
> iscsi example:
> target_core/
> `-- iscsi
>     `-- iqn.1999-09.com.lio:tgt1
>         |-- tpgt_1
>         |   `-- sessions
>         `-- tpgt_2
>             `-- sessions

After the SCSI target core was added to the kernel tree an NVMe target
core was added. How about using the name "scsi_target" for the top-level
directory instead of "target_core" to prevent confusion with the NVMe
target?

Thanks,

Bart.
