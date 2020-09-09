Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EC5C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 03:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8528621941
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 03:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIIDva (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 23:51:30 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35222 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgIIDv3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 23:51:29 -0400
Received: by mail-pf1-f194.google.com with SMTP id o68so1086980pfg.2;
        Tue, 08 Sep 2020 20:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6RJh4Ys7PG8ADSyzHkjgnqLsHhH/WalnSSvnG+Euy0g=;
        b=YUIwIk00Gt8l3FuYstma4c/LkvUT4IwGGP5F74AYEgLdT8DOO6C+Y/BLX5RjeID+mE
         e811ksQMoqcjDHaJLMQEhrowPkNrnis91o1S8OjjmA9wUfotH+czd26AfQQQvecVsoMd
         VlD/1gYkUEZhYIklbLf3ycbjzFAh2YMqg83E0uaK2WmR4I5OZ5Pre7t2Q+VF2NRMRFFj
         AN49bQarmrk00LNBl0oZp62K0gPMbcfIAdMXIYgPJxwUtrW4L78qt1Tu1wqLHE5Hc++p
         CyHx/CxHm19GH4O5hBd7Buon4RZtVQXdzGgDfCOIAqqgN9lW9mGhcgIcL7H9r1I+aPds
         QDvQ==
X-Gm-Message-State: AOAM533KEwGcsh0KmZR8knTHpSpEyFvrNT6Ibz5HGFbTpUrEl2nstHYM
        KB9BAOTIaIX3uktHRe9UFXA=
X-Google-Smtp-Source: ABdhPJy7QhqzDwoJ6ExM6DoiqdfYjBINr+ReTRT2cMVi9oi+tXNMXVOeYnHj+LARwX4q7VKnIwkq0Q==
X-Received: by 2002:a17:902:bd48:: with SMTP id b8mr1744601plx.139.1599623488694;
        Tue, 08 Sep 2020 20:51:28 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:fb09:e536:da63:a7cd? ([2601:647:4000:d7:fb09:e536:da63:a7cd])
        by smtp.gmail.com with ESMTPSA id n11sm631036pgd.2.2020.09.08.20.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 20:51:27 -0700 (PDT)
Subject: Re: [PATCH 7/9] scsi_transport_spi: Freeze request queues instead of
 quiescing
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
References: <20200906012219.17893-1-bvanassche@acm.org>
 <20200906012219.17893-8-bvanassche@acm.org>
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
Message-ID: <c3278367-1719-81d6-b3e9-2c60278d711d@acm.org>
Date:   Tue, 8 Sep 2020 20:51:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200906012219.17893-8-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-05 18:22, Bart Van Assche wrote:
> Instead of quiescing the request queues involved in domain validation,
> freeze these. As a result, the struct request_queue pm_only member is no
> longer set during domain validation. That will allow to modify
> scsi_execute() such that it stops setting the BLK_MQ_REQ_PREEMPT flag.
> Three additional changes in this patch are that scsi_mq_alloc_queue() is
> exported, that scsi_device_quiesce() is no longer exported and that
> scsi_target_{quiesce,resume}() have been changed into
> scsi_target_{freeze,unfreeze}().

Hi Woody,

Do you still own a setup on which SPI DV can be tested?

Thanks,

Bart.
