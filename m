Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89D6C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 17:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9044920756
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 17:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgEPROS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 May 2020 13:14:18 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39997 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgEPROR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2020 13:14:17 -0400
Received: by mail-pg1-f193.google.com with SMTP id j21so2557747pgb.7;
        Sat, 16 May 2020 10:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/MV9WcXQv0+4wZLOKsDXnPVuUYGVfdhe+QBIyAhTTT8=;
        b=P0DSRhjcsLF2j9KB5SRmUsPVnNJN9SmCbF3o5lQy2PG3OnxUmqRbIIAYD0lTIRVtVr
         Xl92GYBBHqDwVnmPRfFlbP5Lnzhu1EHjcWc/rACLl1nCLg3q9KVpfzBWZjPH1rYotCRO
         ucfzcPKMm+JZWL5GqOkVXo7hA1u3tjLJb6z770ML130Utv+YRfEKw4upNnlhot4Gaq7h
         Ii9mRvGY0ysakRQV9pEPwhQTX2jXo1gRN1y3f47Gkjod2d/nWQyIPcIAax8y09JZarrh
         2SZtypXut2XFTCeSzBHGvyE5YbtKCtR2HhhNgx4Q5ZdwHCRSW2Xu1fPOP+qbl+nnT01u
         xtTA==
X-Gm-Message-State: AOAM533XHQ5Jsr1GR3zUuD2tEqQuHdAjRs7mQTq8r0xsz+X/8N3bhVJo
        2dswPj5/3R+ZqLN9TRWt4XU=
X-Google-Smtp-Source: ABdhPJw/MzKN74At9Ms8VObjIfKeXq4vKnwZuzlWXZecBeaeph2yHO1uFyAMHS1GoOl86uybifKFqg==
X-Received: by 2002:a62:6485:: with SMTP id y127mr8977880pfb.11.1589649256677;
        Sat, 16 May 2020 10:14:16 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:97a:fd5b:e2c1:c090? ([2601:647:4000:d7:97a:fd5b:e2c1:c090])
        by smtp.gmail.com with ESMTPSA id v17sm4849010pfc.190.2020.05.16.10.14.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2020 10:14:15 -0700 (PDT)
Subject: Re: [RFC PATCH 00/13] scsi: ufs: Add HPB Support
To:     Avri Altman <Avri.Altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
 <SN6PR04MB46408050B71E3A6225D6C495FCBA0@SN6PR04MB4640.namprd04.prod.outlook.com>
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
Message-ID: <835c57b9-f792-2460-c3cc-667031969d63@acm.org>
Date:   Sat, 16 May 2020 10:14:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <SN6PR04MB46408050B71E3A6225D6C495FCBA0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-16 02:14, Avri Altman wrote:
>> Thank you for having taken the time to publish your work. The way this
>> series has been split into individual patches makes reviewing easy.
>> Additionally, the cover letter and patch descriptions are very
>> informative, insightful and well written. However, I'm concerned about a
>> key aspect of the implementation, namely relying on a device handler to
>> alter the meaning of a block layer request. My concern about this
>> approach is that at most one device handler can be associated with a
>> SCSI LLD. If in the future more functionality would be added to the UFS
>> spec and if it would be desirable to implement that functionality as a
>> new kernel module, it won't be possible to implement that functionality
>> as a new device handler. So I think that not relying on the device
>> handler infrastructure is more future proof because that removes the
>> restrictions we have to deal with when using the device handler framework.
>
> So should we keep perusing this direction, or leave it, and concentrate in Bean's RFC?
> Or maybe come up with a 3rd way?

Hi Avri,

I prefer to proceed with reviewing Bean's patch series. If someone
prefers a different approach, I think this is a good time to bring that up.

Thanks,

Bart.
