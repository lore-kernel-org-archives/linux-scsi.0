Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766BBC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 16:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A3AC2071A
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 16:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404985AbgE1Q2U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 12:28:20 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46358 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404861AbgE1Q2S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 12:28:18 -0400
Received: by mail-pg1-f196.google.com with SMTP id p21so13687368pgm.13
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 09:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vFCr42NLNE/hXbA1L62MUTGPjX7xHaEbe3FQ2pkdUfo=;
        b=QhAY1/JVGIW9i36SCH8JPfhdVoG+t40P79u7ZR/40n5iJP7OFjwqJthlfOxecTYNWb
         2doADhfSLWnYLjkyy5gP2wjNwjec88bGRCQU8J26LnK5zslzmtTz12hhsZmD8qqUQ49x
         ZiId7eq0yXTh9t3ySxm4GUrIWfHDDM58N3cFZ7aP94+Yazj77sEqoU0HrUlCjC3MO2y9
         VcKLDtSEslEQP/HkHPJLsy0MonzeGyL76K3Ce5/CKyNRckeL5WG095bZgEFYDkHMyEH6
         Z4dip0f/EL9M0IPnJ2PXZOTONWutB73WNXDUmKSWNZndGGWnFqMO8sEFYpFJmWIjiZvx
         vSzw==
X-Gm-Message-State: AOAM531DNWjLJNx/PpwBUwnWGjFxNhA/34/ux+WFahprZnZ/Davdz61v
        l4pSIdN4xlPZmdQNqhHDR2RNaLQOFQY=
X-Google-Smtp-Source: ABdhPJyWDiv8HNZBgPxh54pfVw2RNMPaSzkyLnbRSaejLWaDSAJyk+xHO5iQbIkL06OQNYw4INZZdw==
X-Received: by 2002:a65:6795:: with SMTP id e21mr3810001pgr.282.1590683297109;
        Thu, 28 May 2020 09:28:17 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:40e6:aa88:9c03:e0b4? ([2601:647:4000:d7:40e6:aa88:9c03:e0b4])
        by smtp.gmail.com with ESMTPSA id s23sm2674793pfs.56.2020.05.28.09.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 09:28:15 -0700 (PDT)
Subject: Re: [PATCH 1/4] scsi: convert target lookup to xarray
To:     Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200527141400.58087-1-hare@suse.de>
 <20200527141400.58087-2-hare@suse.de>
 <20200528072409.s6jqoaty2zvks7ei@beryllium.lan>
 <efd9850d-936a-f7fa-3dbf-cc27a56c8108@suse.de>
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
Message-ID: <e024750d-fb34-edc1-b47d-b65c150f321f@acm.org>
Date:   Thu, 28 May 2020 09:28:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <efd9850d-936a-f7fa-3dbf-cc27a56c8108@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-28 00:52, Hannes Reinecke wrote:
> On 5/28/20 9:24 AM, Daniel Wagner wrote:
>> Is there a special reason why don't use xa_for_each to iterate through
>> all
>> entries?
>>
> This entire function is completely daft.
> It says 'scsi_remove_target()', but for some weird reason fails to pass
> in the target it want to delete, so it has to go round in circles trying
> to figure out which target to delete.
> There probably had been an obscure reason for this, but with the current
> code it's just pointless.
> So that's the next thing to fix (after all of this): use a struct
> scsi_target as argument for this function, then this entire loop can go.

Please be careful when modifying this code. I remember that it took
multiple iterations to get this code right. See e.g. commit 81b6c9998979
("scsi: core: check for device state in __scsi_remove_target()"). See
also commit fbce4d97fd43 ("scsi: fixup kernel warning during rmmod()").
See also commit f9279c968c25 ("scsi: Add STARGET_CREATED_REMOVE state to
scsi_target_state").

The only reason I can think of why that loop exists is that @dev may be
associated with multiple targets (struct scsi_target) at the same time.
Is that something that can happen?

Thanks,

Bart.
