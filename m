Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C478C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 02:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EEF220768
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 02:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgF1CbP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 22:31:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39282 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgF1CbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 22:31:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id d66so6378903pfd.6;
        Sat, 27 Jun 2020 19:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+ArFVrwoLVX1sf7as+tt+PKXqjPeIcvA4ZqO6UJpCKM=;
        b=WykcS9RsKybmIcgmlZSBaVCgoon5aWdwObOY3FOnaw/M49i4FVIaJkmtUYPfqcavau
         40ZeetodBSNID6TdCIxPwC/x2b0AV6xyYiVELFdqWNr4jN1IPidh/PBuouhlSwMZf60B
         LrZc0f8CHux+pWkzD7H/9FgaGrYOQ0EOn0ijG/BTj06yzLYRhcj+R6XHZqbRK4nfpWed
         N1YWPphQ5WprW/0pVKA5aqKV7e5VbT/+2icBtNJ+u+7cHiRe/Pq0ff6OPRjvrIuqPLBz
         z9vlAHasx7Mkozd2mqfMOuFg6oF+DXntq3fPyfDiFWsxQuSSC6e+10yjqwUgFPA2F2cZ
         4c6w==
X-Gm-Message-State: AOAM530rZFf3cgVttm5jr6sVp+EgyE57ZSSlH6bxjei08BG57mtITluY
        5MPs4udsPM5rA1zu+9cMlVA=
X-Google-Smtp-Source: ABdhPJw9df3wG4o39fLzfIY1v03+ViAkD6XsDMRZ6xmYNHbvJVT3R/25nNd4m4Zw2An84yGoWTE/gg==
X-Received: by 2002:a65:428d:: with SMTP id j13mr5374741pgp.211.1593311473479;
        Sat, 27 Jun 2020 19:31:13 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id jz23sm15074445pjb.2.2020.06.27.19.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jun 2020 19:31:12 -0700 (PDT)
Subject: Re: [PATCH] scsi: target: tcmu: Fix crash on ARM during cmd
 completion
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>,
        Henry Willard <henry.willard@oracle.com>
References: <20200624085320.31117-1-bstroesser@ts.fujitsu.com>
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
Message-ID: <93e7f9ef-566e-6949-b2c7-2e822ee49f39@acm.org>
Date:   Sat, 27 Jun 2020 19:31:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200624085320.31117-1-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-24 01:53, Bodo Stroesser wrote:
> The fix is to use the maximum of remaining ring space and
> sizeof(struct tcmu_cmd_entry) as the length param.
> 

[ ... ]

> +		/*
> +		 * Flush max. up to end of cmd ring, since current entry might
> +		 * be a padding that is shorter than sizeof(*entry)
> +		 */
> +		size_t ring_left = head_to_end(udev->cmdr_last_cleaned,
> +					       udev->cmdr_size);
> +		tcmu_flush_dcache_range(entry, ring_left < sizeof(*entry) ?
> +					ring_left : sizeof(*entry));
>  
>  		if (tcmu_hdr_get_op(entry->hdr.len_op) == TCMU_OP_PAD) {
>  			UPDATE_HEAD(udev->cmdr_last_cleaned,

The patch description says "maximum" but the above formula calculates the
minimum of "ring_left" and sizeof(*entry). Did I perhaps misread this patch?

Thanks,

Bart.


