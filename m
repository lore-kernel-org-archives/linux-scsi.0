Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63EBCC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 17:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F29B20760
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 17:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgGBRXZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:23:25 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33260 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgGBRXY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 13:23:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so10814545pgf.0
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2020 10:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ie850xtyEe/v2GabNmC+LlwHavkLu2bE7v1dtHSoEMY=;
        b=gHEuJfc7tT1XcMoqLBD0g2uzuZR3TmRLWyo0sO1hGjJA2NuflJZc6Xn82OQcF268Jy
         6uxjxpbklibtzSQ0z2urzAJtuUY6Xcyrxxrd7ye8/dTQdii4HYd9fcvPkquvhcu/ao4h
         HmizwCjaF7Qm5lvsrxf0bezf59gfFenrXYo1rSCezJ34kuMq61YIRx7bk0nTJc22u71e
         yWmdtBEUgxE8qRUuqgzUalrq+RtD2hydKTiqFlRm10r9bLddirfobE6ID9+OAPjpnHRL
         kxXZy4vuDuu2DuOci7MFyad++4AWFrnfOWLnNfcb0Qay7qTGT8rFg59ZHA0TDGNvity1
         xpgQ==
X-Gm-Message-State: AOAM530XJUAG5j4j+efCEtol0Kf69CoBUswlMrnK9/L8QohhAuEHTSZb
        edPiI9+2KChX0gUbq9JcSkZvrB6+
X-Google-Smtp-Source: ABdhPJwu96P4sztkHTkLk4ESQeTJwVggqbBH3sL47Jgk+6+3URbo3t1okvOOmx20yBJBM4siwU/5NA==
X-Received: by 2002:a63:5623:: with SMTP id k35mr26770376pgb.325.1593710603318;
        Thu, 02 Jul 2020 10:23:23 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u13sm8203178pjy.40.2020.07.02.10.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 10:23:22 -0700 (PDT)
Subject: Re: [PATCH] scsi: allow state transitions BLOCK -> BLOCK
To:     Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
References: <20200702142436.98336-1-hare@suse.de>
 <1593700443.9652.2.camel@HansenPartnership.com>
 <0c1ce7fc-98ba-0a14-d1a7-889bf1ce794f@suse.de>
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
Message-ID: <2dd291ba-1e59-5e88-de96-5d3965f20317@acm.org>
Date:   Thu, 2 Jul 2020 10:23:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <0c1ce7fc-98ba-0a14-d1a7-889bf1ce794f@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-02 08:14, Hannes Reinecke wrote:
> On 7/2/20 4:34 PM, James Bottomley wrote:
>> On Thu, 2020-07-02 at 16:24 +0200, Hannes Reinecke wrote:
>>> scsi_transport_srp.c will call scsi_target_block() repeatedly
>>> without calling scsi_target_unblock() first.
>>> So allow the idempotent state transition BLOCK -> BLOCK to avoid
>>> a warning here.
>>
>> That really doesn't sound like a good idea.  Block and unblock should
>> be matched pairs and since you don't have a running->running transition
>> allowed this implies that srp calls block many times but unblock only
>> once.  It really sounds like srp needs fixing.
>>
> That was what I was planning first, but then SRP has a weird mix of states, calling scsi_target_block()/scsi_target_unblock() on all sorts of places.

It is not clear to me how the SRP transport code could call
scsi_target_block() twice without calling scsi_target_unblock() in
between? All these calls are serialized by the rport mutex.
scsi_target_block() is called when the port state is changed to
SRP_RPORT_BLOCKED. scsi_target_unblock() is called when the port
state is changed into another state than SRP_RPORT_BLOCKED.

Bart.
