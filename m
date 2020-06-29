Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF1AC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56F8120663
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732094AbgF2T2P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732757AbgF2T1t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:27:49 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1EEC02E2FC
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 07:38:40 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i4so8118938pjd.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 07:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=goveQo04BDAbAzqKjsUQj7lmtbK8ykTS8iN7Ty1dPZw=;
        b=q+beXrbbM3Pt85yYMNHlBTciBQUujZOfRZ0jJKASD6+D2MR1RnWggmDs6ldd6NNoAG
         9pga+RHq/AvvW2haICDg1YaVNF5jHXkO1PgZpJsV1bOkSi2e6TG3Rq5JwAu4ZHYfon6j
         LXWBeivXQMHXy1ntQ8exdt6GgbQORh3IL1zhuGuIieR8FnU6ms81P6DJeivycBZV4e92
         WmPMchfnxpBupadrQhV7/5h/JvwjI+IKJnSJztymxAa137zVHaPsciaFkd/fzSnVq1jS
         A1B4tMC/SvuOJdtnqBNQVGEX2zHyJ3EKuHbTHed5UORiNUQqb9/xeTWJ/utEcxaJNG/E
         YqXw==
X-Gm-Message-State: AOAM532Nl7CQkQcRWNgK2KLxF+45fMVh8V5tPTeAKOm0gq8k7BMaK266
        EU6zNa9XwqJbA6rNOfyrjzV4LeXY
X-Google-Smtp-Source: ABdhPJyOwCeqBP3NVSOjXsSAeEFC+Ctc59mp9nQ9mtQEEJWGWtW/WxVxt5aO3NFgWensxFQoS9Sxhg==
X-Received: by 2002:a17:90a:a616:: with SMTP id c22mr16574050pjq.44.1593441519385;
        Mon, 29 Jun 2020 07:38:39 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id b24sm96477pgn.8.2020.06.29.07.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 07:38:38 -0700 (PDT)
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
 <e5964b6d-43c1-a14d-c791-4b5826eb2ee8@acm.org>
 <9793e936-cf51-2d6a-fccd-4a4b9c8cae02@suse.de>
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
Message-ID: <bda9e52e-d087-afb3-f8b2-20427a90ec0a@acm.org>
Date:   Mon, 29 Jun 2020 07:38:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <9793e936-cf51-2d6a-fccd-4a4b9c8cae02@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-28 23:32, Hannes Reinecke wrote:
> On 6/28/20 5:08 PM, Bart Van Assche wrote:
>> On 2020-06-28 02:02, Hannes Reinecke wrote:
>>> On 6/28/20 5:48 AM, Bart Van Assche wrote:
>>>> On 2020-06-25 07:01, Hannes Reinecke wrote:
>>>>> +/**
>>>>> + * scsi_put_internal_cmd - free an internal SCSI command
>>>>> + * @scmd: SCSI command to be freed
>>>>> + */
>>>>> +void scsi_put_internal_cmd(struct scsi_cmnd *scmd)
>>>>> +{
>>>>> +    struct request *rq = blk_mq_rq_from_pdu(scmd);
>>>>> +
>>>>> +    if (blk_rq_is_internal(rq))
>>>>> +        blk_mq_free_request(rq);
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(scsi_put_internal_cmd);
>>>>
>>>> How about triggering a warning for the !blk_rq_is_internal(rq) case
>>>> instead of silently ignoring regular SCSI commands?
>>>>
>>> That's by design.
>>> Some drivers have a common routine for freeing up commands, so it'd be
>>> quite tricky to separate these two cases out at the driver level.
>>> So it's far easier to call the common routine for all commands, and
>>> let this function do the right thing for all commands.
>>
>> That sounds fair to me, but is an example available in this patch series
>> of a call to scsi_put_internal_cmd() from such a common routine? It
>> seems to me that all calls to scsi_put_internal_cmd() introduced in this
>> patch series happen from code paths that handle internal commands only?
>>
> aacraid.
> The function aac_fib_free() is called unconditionally for every fib, and
> doesn't have the means to differentiate between 'normal' and 'internal'
> commands.

Please make scsi_put_internal_cmd() complain if it is invoked for
anything else than an internal command and surround the
scsi_put_internal_cmd() call in aacraid with if (blk_rq_is_internal(rq))
{ ... }.

Thanks,

Bart.
