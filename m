Return-Path: <SRS0=90Tc=3O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E27CC35241
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jan 2020 05:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 119D12071E
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jan 2020 05:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgAYFyB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jan 2020 00:54:01 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:41346 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgAYFyB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jan 2020 00:54:01 -0500
Received: by mail-pl1-f182.google.com with SMTP id t14so1653142plr.8
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2020 21:54:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CqeU61Sk6t4e6d2VLrRQcQR/NiWdMDDVRHpayiEBdYY=;
        b=hu2vRfNY8mQKiEflTTCyAPM/B5DxFeC8erBbnOI+LC1rywSM9UVV6AstHfUhbZtRws
         Y+xju0tAvxjxGFNmNbo+NaJ/t/4ACPYivTGyUXHQL/LQT6yr+No+/umOIONrdUtE7yjR
         61hwUS4zN/ZIZniYdCHqlIivU2xU2fyHtSFVBsgumsDGE57m9zJxUeRCWxE7+FdAODXF
         oUSROT5BqZJ25ucPi8M3BMwa83Nb4wFjkbA1S5duSbFeoaNyMkejq8ZxfN1oJOtx+iU4
         u3gScgxpl9kS2tsK/RQVVK54o6cETaLt4fMJn0/H6QlCV/7TXpL37EhwrfLC5m+1aVVk
         KoIw==
X-Gm-Message-State: APjAAAWyFmSmfFiiVn9lPTUSkoCbycS70JnDGTuYynPM3RnXkJlqJ6dw
        HOMyToW5QLGuQxqqthF6SbIUhM2C
X-Google-Smtp-Source: APXvYqy+MJMU93FXCLq9r+izaHM5LgSWjZlwDDjKr8ifZy9JXznDWzWDSTNeVYJvw34Hopu8kUPkgA==
X-Received: by 2002:a17:90a:c983:: with SMTP id w3mr3180648pjt.121.1579931640214;
        Fri, 24 Jan 2020 21:54:00 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:1596:afb1:10e:95ae? ([2601:647:4000:d7:1596:afb1:10e:95ae])
        by smtp.gmail.com with ESMTPSA id 2sm8326897pgo.79.2020.01.24.21.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 21:53:59 -0800 (PST)
Subject: Re: [PATCH v3 2/3] scsi: add shost helper to set max queue depth on
 all of its devices
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
References: <20200124230115.14562-1-jsmart2021@gmail.com>
 <20200124230115.14562-3-jsmart2021@gmail.com>
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
Message-ID: <b3ce0a08-8a0c-4154-ab3d-a78a28de5487@acm.org>
Date:   Fri, 24 Jan 2020 21:53:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200124230115.14562-3-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-24 15:01, James Smart wrote:
> Create a helper routine to loop through all devices on an shost and
> change their current and maximum queue depth. The helper is created
> such that is lldd callable.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
