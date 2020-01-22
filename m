Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA43C32771
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 05:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E9AF2465A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 05:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgAVFNS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 00:13:18 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38806 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgAVFNS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 00:13:18 -0500
Received: by mail-pf1-f196.google.com with SMTP id x185so2741991pfc.5;
        Tue, 21 Jan 2020 21:13:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=G4zWcG38QbfOgSj2GyrGGnsjW0vqGvdhkVYZ4/Opd0A=;
        b=h3AI7ZF8s0P+PUkPIrdGfcWBiWdNrt06mkJ/vWASCjfSLCFH+rEMPeEUEIuF0kvI0i
         JI8771n0FEZQF9cecE5014UUEAUsVeaj0iUaCOqVZpCyJN8E0e3hCMxNKS5i3RevZZ3Q
         DDGMW7KRGv6GPpXNsfvPBfrkAQ0dOCXztpAISmoVERAiiZfYX6v+0AOmFWXvN8GHOyNH
         dO0rM37RtRzWaohOZjDjP/TDurfCY/2uR/vpjN4WZWm4qYO1ErMSIxdZ8mtZp/m3Guxl
         vD09z/dZcIqc/SAulxpkREzUUwhwsVb3q7/r/2ZREaLM5xX3fNK5Ydw3LDy2/Xr5Y7nB
         nirw==
X-Gm-Message-State: APjAAAURQ7LjSkP1X7xtdAOieyH9PAstVNMCcekky5LZ5USXGjlPQ8GS
        W3l3Ijip7wnJi+n59RWaDyA0fYnP
X-Google-Smtp-Source: APXvYqxGLSUJHoM41bF+Bf9z+IDOyfFAl9/s5eOA30klYiaibka+mmbEXGrpjQFVDHeIAvQYHXPgWA==
X-Received: by 2002:a63:1a1c:: with SMTP id a28mr9654899pga.374.1579669996726;
        Tue, 21 Jan 2020 21:13:16 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:1483:dec1:1c24:26ea? ([2601:647:4000:d7:1483:dec1:1c24:26ea])
        by smtp.gmail.com with ESMTPSA id z4sm44777776pfn.42.2020.01.21.21.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 21:13:16 -0800 (PST)
Subject: Re: [PATCH v4 6/8] scsi: ufs: Delete is_init_prefetch from struct
 ufs_hba
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200120130820.1737-1-huobean@gmail.com>
 <20200120130820.1737-7-huobean@gmail.com>
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
Message-ID: <6b6a7998-b6e3-6019-8588-18dbf622579a@acm.org>
Date:   Tue, 21 Jan 2020 21:13:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200120130820.1737-7-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-20 05:08, Bean Huo wrote:
> Without variable is_init_prefetch, the current logic can guarantee
> ufshcd_init_icc_levels() will execute only once, delete it now.

How about changing this description into the following:

A previous patch in this series introduced ufshcd_add_lus(). That
function is called once per HBA which makes the is_init_prefetch member
superfluous. Hence remove the is_init_prefetch member.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
