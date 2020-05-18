Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB6AC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 14:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74279206D4
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 14:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgEROhh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 10:37:37 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:37942 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgEROhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2020 10:37:37 -0400
Received: by mail-pg1-f169.google.com with SMTP id u5so4910940pgn.5;
        Mon, 18 May 2020 07:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=c5ASnkpAYuYegZeLgskgvXdAMRcmpa8mnNPpPlDj1nc=;
        b=oyWFmzvcUW9CD5SH7TLNhIDu+gI4ZRmovmRVNZjKhiULpN2d3UhNJPUWiT683/yuXT
         DEbET2Enh6SgPdR6fCWW+NedXxDukKha19BlRbe0uXc3HqtDz2Y55094MdkjdspHtw/H
         kP1rqy/fA8jtSSrBICZUrMqw1a9slf6Ee3k5HoMVnIzcI1ci4UiXTdp/EfU5/l4NZuts
         loSDdkIHrI3lbK62Fp0/25waFohV5uZu+Z+8IL+hJjzlCQEIMT1wv0Ej0X+Ek1+R+ncE
         UQ1IhiWvIFCWtbC5slZ1npQjsC3oPs5TKPeUp+pIXHfWCpbrYGZth2r2r/g5ydsSuw2I
         s1FA==
X-Gm-Message-State: AOAM531Z32ZsUtbWwzf2WtwzsUamZKaqFc4i8naRadgUqtbpFZm2gGsq
        /WpHySwnWUYO1dr5aVGmJE+zq9h+
X-Google-Smtp-Source: ABdhPJzi3kaeXyU0Uepkf8SGi6lTTwqlzqPdyEtGT0JblDb80oPxz+Gu+zW26EdeYgpHSh9PHwmBYQ==
X-Received: by 2002:aa7:9ad9:: with SMTP id x25mr10399533pfp.179.1589812655923;
        Mon, 18 May 2020 07:37:35 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:dc5d:b628:d57b:164? ([2601:647:4000:d7:dc5d:b628:d57b:164])
        by smtp.gmail.com with ESMTPSA id a16sm8026321pfl.167.2020.05.18.07.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 07:37:35 -0700 (PDT)
Subject: Re: [PATCH] scsi: Refactor scsi_mq_setup_tags function
To:     Ye Bin <yebin10@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200518074732.39679-1-yebin10@huawei.com>
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
Message-ID: <0eb97dd3-b4ca-fff4-87cc-774ae8911203@acm.org>
Date:   Mon, 18 May 2020 07:37:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200518074732.39679-1-yebin10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-18 00:47, Ye Bin wrote:
>   "shost->tag_set" is used too many times, introduce temporary parameter
> "tag_set" instead of "&shost->tag_set".

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
