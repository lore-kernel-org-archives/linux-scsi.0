Return-Path: <SRS0=7Ct3=AQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B6EC433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 15:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27EDF2075D
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 15:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgGEPH2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jul 2020 11:07:28 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36599 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgGEPH1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2020 11:07:27 -0400
Received: by mail-pf1-f195.google.com with SMTP id 207so15746947pfu.3
        for <linux-scsi@vger.kernel.org>; Sun, 05 Jul 2020 08:07:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/9sirdQltpWdD4aqPzzmpNAM9800ABy+/+kMX6dJtuA=;
        b=R7Oyicr52qoLQ8TX3DBw+wJYGe0la+2VDO01cGbQtl2K5d2gPv9TXimxfm9ig/RfYL
         2oxL0T3lt53ypzoeOCwo8VvFy+tzF7rAM1dSIz5Vy/zfoI45hGx8+ux4vu0jVIZo/Cvn
         H8mSF8Gy5dx82E+7sdD15tIyQUk5HixhbInXivYRoYosFfe1OS0trWEjWWmcVWnGFHvv
         JQ1OwiFdYSpu+X5dDWthEJXeqPsHNmuFsCx0GJwoEGNO+YHDur1aUEfNEHWK9QFdsqre
         OitB4/uLYwAIADEM4dclr8OJ2u0csmGnDKsa9p2WP9SJ2GftXgkzqnh3UqJSyQDMvTmT
         ufYg==
X-Gm-Message-State: AOAM531etnnNZAMjvp+6iyd1N3h0wjCIkVIREyyNCD88ZFKbngdkAeif
        OjydeciemlVFZf24xv+m0hc=
X-Google-Smtp-Source: ABdhPJx6ybv/HhN0JDu7R2ht9Nm4nGx56y3bn1CrDsjUihoaaZfGbNErM8FVWUQmo47QzYbymrWrig==
X-Received: by 2002:a63:e60b:: with SMTP id g11mr37878746pgh.188.1593961646804;
        Sun, 05 Jul 2020 08:07:26 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k98sm7406520pjb.42.2020.07.05.08.07.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 08:07:26 -0700 (PDT)
Subject: Re: [RFC PATCH v3 1/2] ufs: support various values per device
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
References: <cover.1593753896.git.kwmad.kim@samsung.com>
 <CGME20200703053756epcas2p1f32da04da87c8f56a6052caada95fb9a@epcas2p1.samsung.com>
 <dc21b368f44c8a9a257d1b00549e3b5aeec00755.1593753896.git.kwmad.kim@samsung.com>
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
Message-ID: <b2a0f977-8155-a947-d883-626c1c7762bb@acm.org>
Date:   Sun, 5 Jul 2020 08:07:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <dc21b368f44c8a9a257d1b00549e3b5aeec00755.1593753896.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-02 22:30, Kiwoong Kim wrote:
> +static const struct ufs_dev_value ufs_dev_values[] = {
> +	{0, 0, 0, 0, false},
> +};

A minor stylistic request: please change "{0, 0, 0, 0, false}" into "{
}". The C language requires that structure members that have not been
specified are zero-initialized.

Thanks,

Bart.

