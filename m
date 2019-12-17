Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A3BC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 15:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 996AF218AC
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 15:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfLQPFv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 10:05:51 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:46823 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbfLQPFu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2019 10:05:50 -0500
Received: by mail-pj1-f68.google.com with SMTP id z21so4705584pjq.13;
        Tue, 17 Dec 2019 07:05:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=lwDHFMooL9fOlM9zyGVa3WovEZDDyFpSkh2Rh2NW+qA=;
        b=ad+x5rbvfEGAzfE7lEA9IgEfJmpRNYvqkVHAifBOI5TWYplVoLV6EKiDtXHTyco6sX
         90d9HPIpVSeEGZi9j8eZIVw3auPdMkoFcfsNWWsD6obMJTR/Vloxtu+sHo7XvE20dykd
         BdRonBq2nVhGIf1GFiMoihMYYmDf1/ic11ZrZqA44Isbdy+WC8SYdqXN6qT8fKRQugCs
         4BmVeswCTqVaIa6V66OyiOhjq8TY6Dez+XlwG8kwrVkmhrOm+Qhi7JeGtYiRPwLYb/la
         tXet3MkbjOZ05AlbOgViLO3uQSluGnzJNt3R0BdBf+egf/TfojxP+PxVAXAoVaHKqCdG
         66sg==
X-Gm-Message-State: APjAAAX8wCMB46s+9G7OhJmMgQzvTL5vEc8dNIJkIKLK18xvIK6zCsz6
        UiiMmG7J1KND39f5POmcwLU=
X-Google-Smtp-Source: APXvYqwHJPjdu2AoUsOFl80E08yD2tKyqMk2aTI1hq9D+fsSGBE65MMENSz5+4bZiI8mHS5le87ksw==
X-Received: by 2002:a17:90a:2569:: with SMTP id j96mr6456477pje.79.1576595149826;
        Tue, 17 Dec 2019 07:05:49 -0800 (PST)
Received: from ?IPv6:2601:647:4000:110a:a9aa:d433:235e:1129? ([2601:647:4000:110a:a9aa:d433:235e:1129])
        by smtp.gmail.com with ESMTPSA id k1sm5593624pgk.90.2019.12.17.07.05.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 07:05:48 -0800 (PST)
Subject: Re: [PATCH] scsi:remove unreachable code on scsi_decide_disposition
 func
To:     "wubo (T)" <wubo40@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Mingfangsen <mingfangsen@huawei.com>
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915E9A7FD@dggeml505-mbx.china.huawei.com>
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
Message-ID: <613e2596-07cc-aca9-2c7b-b0a0563353a1@acm.org>
Date:   Tue, 17 Dec 2019 07:05:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915E9A7FD@dggeml505-mbx.china.huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-17 03:53, wubo (T) wrote:
> From: Wu Bo <wubo40@huawei.com>
> 
> Remove unreachable code on scsi_decide_disposition func.
> 
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>  drivers/scsi/scsi_error.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index ae2fa17..c5e05c4 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1934,7 +1934,6 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
>         default:
>                 return FAILED;
>         }
> -       return FAILED;
> 
>  maybe_retry:

I'm not sure it's worth to address this issue. If
scsi_decide_disposition() is changed I prefer to remove the "default:
return FAILED;" code because compilers can provide more useful
diagnostics about switch/case statements that do not have a default
statement, especially if the "switch" applies to a value with
enumeration type.

Bart.
