Return-Path: <SRS0=xzXz=2F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8813C43603
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 00:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBA1C206C3
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 00:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfLOAJp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Dec 2019 19:09:45 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46378 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfLOAJp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Dec 2019 19:09:45 -0500
Received: by mail-pg1-f193.google.com with SMTP id z124so1472840pgb.13
        for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2019 16:09:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=gipykIAZvNSsqGv7v1rGYVkCL0d15iEwqHgMrZZNLAI=;
        b=G3D/soEbiDDKfLC2owXpI9w+S5t5xk0XJGb4N8r3aGmwj6sTA49QORYcpoOaZD3MHM
         fdD9M2NUYwfNJngxPg7dv/KCCwnMDXA019yRtNZsy2pVzw94TNmfz9X4WTgad1eu8zIx
         yQ1/gYigp5UrqZGu6s0NEEa0Tqn5Yfs21kwLrjO1h5tWOxMBfhMRUy9sVpjDFsnmO1xy
         dML+bVxzyNR+oDRzSdjXAzhpQZvn+vrQFGuoG4lopbdtA7xsyL8HR8ASGgcysClefRgB
         adgoIi+ZrZGWa/yPzOJMIFo+aWCFemhHbiboqrkEX+lHoZ100DuvRfKJsFajodx1YEay
         j4Og==
X-Gm-Message-State: APjAAAV1/lhMvDKUXIGGgucBDv4LAfS44bVddX/NURVP+dwcVNcjFK3E
        qtxHdtVaaUa5Z5Jm2q2Wjos=
X-Google-Smtp-Source: APXvYqysP0oOte5T7LEgjGz2JH0cplIVigJA2gtEKE4pPuyghawQRzXMRZIiWOa7/Rkr0oAOVUtLJw==
X-Received: by 2002:a63:8eca:: with SMTP id k193mr8625882pge.293.1576368584303;
        Sat, 14 Dec 2019 16:09:44 -0800 (PST)
Received: from ?IPv6:2601:647:4000:110a:ccaa:fdec:8bf4:a5a? ([2601:647:4000:110a:ccaa:fdec:8bf4:a5a])
        by smtp.gmail.com with ESMTPSA id d22sm15911018pgg.52.2019.12.14.16.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2019 16:09:43 -0800 (PST)
Subject: Re: [PATCH 3/4] qla2xxx: Fix point-to-point mode for qla25xx and
 older
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Martin Wilck <mwilck@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>, linux@yadro.com
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-4-bvanassche@acm.org>
 <fdff60ffaacad1b3a850942f61bdd92ab5bc6d12.camel@suse.de>
 <20191212200720.wbq2en3pnnpegrij@SPB-NB-133.local>
 <20191214010400.r6ord53kwbh2lmlm@SPB-NB-133.local>
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
Message-ID: <86234568-0ab4-4efa-5f4f-05b0d604be3a@acm.org>
Date:   Sat, 14 Dec 2019 16:09:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191214010400.r6ord53kwbh2lmlm@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-13 17:04, Roman Bolshakov wrote:
> Bart, what kernel do you use on initiator? Should we bring in
> workarounds for initiators into mainline?

Hi Roman,

The setup I use to test point-to-point mode is as follows:
* A single server equipped with a QLE2562 adapter.
* The two ports of the QLE2562 adapter directly connected to each other.
* Both FC ports are assigned to a VM such that if a kernel crash occurs
  only the VM has to be rebooted (PCIe-passthrough).
* The following in /etc/modprobe.d/qla2xxx.conf of the VM used for
  testing:

options qla2xxx qlini_mode=dual ql2xextended_error_logging=0x5200b000

With this setup it is guaranteed that initiator and target are running
the same kernel version.

I run all my tests with mainline kernels. Typically I run my tests on
top of a merge of Martin's scsi-fixes and scsi-queue branches. Since the
regression that I reported is a regression in the upstream kernel I
think the fix should go into the upstream kernel.

Bart.
