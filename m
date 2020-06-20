Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CC5C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 16:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8651622BF5
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 16:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgFTQ0e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Jun 2020 12:26:34 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:54452 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgFTQ0c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2020 12:26:32 -0400
Received: by mail-pj1-f65.google.com with SMTP id u8so5669032pje.4
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jun 2020 09:26:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W4I/Pc3M/R+/gWIhDs7HtPt3MCuJjvSb08bA4KBQxzg=;
        b=SKunirdI7DYAv9vjHW0QPXJZ+7n7IbCbzQ8Fmf9B102Fynjwm/OhoufoWfEyT3buwd
         ZzS3/d2nCqfdg+ywEiRG5TzM3fl+kKLgqJ/MC/IJK8YM6iDMISe8lnRDkpD3vPeSXI8L
         rJugjLiF+oFQGJf613I6PlZrcKU2oFbZVUzpnjBg1GVLQd/3uzyGhqt7gzmG4wo+XGKB
         GfskY0vySpAsnBMgBTJgjH04Cpia2l+Gtsh3byrPH6suhOjKbzKBBsslCfVVaxfm4Z+w
         QvzgR9QRug5P4dA4bmFskVnsZnRjtvfmZe4iVBDFqViSvycB0Sg2WnyHlSgN1O6IWKhS
         P5Yg==
X-Gm-Message-State: AOAM5307vBlwSJJqfV6xuqiSg+vYkS3wJakcF0huJFcyM03NyLSSXBcN
        ZRQzXbCRSa+p3mgb/qWMq+Q=
X-Google-Smtp-Source: ABdhPJythhZuMCMdBAZ37wAyi4OQMHClDx6Li/cBllICtiOBzLV6HalDzMUOqpH5FCBzeVbHLlHLrQ==
X-Received: by 2002:a17:902:c082:: with SMTP id j2mr12669883pld.70.1592670391423;
        Sat, 20 Jun 2020 09:26:31 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i19sm8856345pjz.4.2020.06.20.09.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 09:26:30 -0700 (PDT)
Subject: Re: [RFC PATCH v1 1/2] ufs: support various values per device
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org
References: <1592638297-36155-1-git-send-email-kwmad.kim@samsung.com>
 <CGME20200620073914epcas2p2c788e787f4fff602de61e5f8e5fb79ae@epcas2p2.samsung.com>
 <1592638297-36155-2-git-send-email-kwmad.kim@samsung.com>
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
Message-ID: <5ed422cb-ad63-e085-cfe4-ac7d78b1ac87@acm.org>
Date:   Sat, 20 Jun 2020 09:26:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1592638297-36155-2-git-send-email-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-20 00:31, Kiwoong Kim wrote:
>  #define END_FIX { }

The name of this macro is longer than its value. Additionally, this
macro makes code harder to read instead of easier. Please include a
patch to remove this macro from the UFS driver.

> +#define UFS_DEV_VAL(_vendor, _model, _key, _val) { \
> +	.wmanufacturerid = (_vendor),\
> +	.model = (_model),		\
> +	.key = (_key),			\
> +	.val = (_val),			\
> +}

A macro like the above also makes code harder to read instead of easier.
Please remove this macro definition and use the designated
initialization style directly.

Thanks,

Bart.
