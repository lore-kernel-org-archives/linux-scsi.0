Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B7BC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 15:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 961A2206F1
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 15:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgF1PIR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 11:08:17 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35497 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgF1PIO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 11:08:14 -0400
Received: by mail-pl1-f196.google.com with SMTP id k1so6121378pls.2
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jun 2020 08:08:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0LvO3BRijGyYc58uugpk7/1HNM1xopprDiOqCriUBE4=;
        b=SmJU5NzoJMq9nCHMsfPhIzLMgbWPgbbsaUiqdri92gXa9N7Ju9fA5E/FxHCR7rw6LL
         OG1hmOEAEvzMqJVOQtww+NeKKgfpMs0sr0oqVAA7nzhntoJVaKKwmmOBWLK3HHRojHZ7
         CTHahx5UPfHzo1geFUxbx08IDgbnaWGwIj3fIbiNkrADgppCR5FeHi1u7sMD0YZm8k9+
         mv7q6DtuUPtUPdbHO/A7ahZF1DVorJJlbQ5b/bpbU359CxVqjBmCUBV0qolDKfWrA2wY
         vvie5gPvqAlnvnZWX4ZkcbPSUt1GG1Ac+4rcttezSB0r3dt3/Rh9I/bMAy1FBJW+wF0u
         qzXQ==
X-Gm-Message-State: AOAM530TxO/wzkY3NuYKLe667ZVSxd34liBkBhPPxa864xuFgC96IAxS
        VGjiFUlFd/ppeQle8ZV++hDcUkBk
X-Google-Smtp-Source: ABdhPJyK6q10Z0Mh0IwZNDqJjC0rN6muZ+n7301a8ocLL2Sn8mB64aVRT/dtJZGFjx0Mj5Kdm5tz0Q==
X-Received: by 2002:a17:90a:930c:: with SMTP id p12mr14038266pjo.2.1593356893672;
        Sun, 28 Jun 2020 08:08:13 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g13sm2536172pje.29.2020.06.28.08.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 08:08:12 -0700 (PDT)
Subject: Re: [PATCH 03/22] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microchip.de>, linux-scsi@vger.kernel.org
References: <20200625140124.17201-1-hare@suse.de>
 <20200625140124.17201-4-hare@suse.de>
 <863b7da2-bbfc-a32f-87ab-648f8561314c@acm.org>
 <7a52763c-eb51-7c63-8d06-b0cc2eab6630@suse.de>
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
Message-ID: <e5964b6d-43c1-a14d-c791-4b5826eb2ee8@acm.org>
Date:   Sun, 28 Jun 2020 08:08:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <7a52763c-eb51-7c63-8d06-b0cc2eab6630@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-28 02:02, Hannes Reinecke wrote:
> On 6/28/20 5:48 AM, Bart Van Assche wrote:
>> On 2020-06-25 07:01, Hannes Reinecke wrote:
>>> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>>> +                    int data_direction, int op_flags)
>>
>> How about using enum dma_data_direction for data_direction and unsigned
>> int, or even better, a new __bitwise type for op_flags?
>>
> Okay for data direction, but converting op_flags into __bitwise (or even
> a new type) should be relegated to a different patchset.

OK.

>>> +/**
>>> + * scsi_put_internal_cmd - free an internal SCSI command
>>> + * @scmd: SCSI command to be freed
>>> + */
>>> +void scsi_put_internal_cmd(struct scsi_cmnd *scmd)
>>> +{
>>> +    struct request *rq = blk_mq_rq_from_pdu(scmd);
>>> +
>>> +    if (blk_rq_is_internal(rq))
>>> +        blk_mq_free_request(rq);
>>> +}
>>> +EXPORT_SYMBOL_GPL(scsi_put_internal_cmd);
>>
>> How about triggering a warning for the !blk_rq_is_internal(rq) case
>> instead of silently ignoring regular SCSI commands?
>>
> That's by design.
> Some drivers have a common routine for freeing up commands, so it'd be
> quite tricky to separate these two cases out at the driver level.
> So it's far easier to call the common routine for all commands, and
> let this function do the right thing for all commands.

That sounds fair to me, but is an example available in this patch series
of a call to scsi_put_internal_cmd() from such a common routine? It
seems to me that all calls to scsi_put_internal_cmd() introduced in this
patch series happen from code paths that handle internal commands only?

Thanks,

Bart.
