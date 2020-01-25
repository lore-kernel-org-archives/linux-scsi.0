Return-Path: <SRS0=90Tc=3O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC23C35241
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jan 2020 05:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38B742071E
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jan 2020 05:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgAYFy6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jan 2020 00:54:58 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33885 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgAYFy5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jan 2020 00:54:57 -0500
Received: by mail-pf1-f193.google.com with SMTP id i6so2175574pfc.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2020 21:54:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yY/7x8bXW6P4n45s2vq/+aHauXUZ/ontaRxvRjgaFgI=;
        b=ODRz0UWNHcXjcx9EeXzgAhFSz4MFqG+z1vwqIzMYqinfbBtVUVVXdE3eEIbte46mim
         n1GfEOX6znt7/K560eJr3oLoJtViT2EtNC+XZzGyi1wQVIxte1u86WENd2ZUPtw7yq8o
         awTEgOJM/8ekPGdaZjOWHvF92h15zEDzQe2386bYlNVRbVvuUUFjCKEtRLh9wHBH3PMu
         oakkKFJ5ZfjOwxxix6Ll2N+BMS6+uM7JRCbiLtVVsN+s+09DPLe0d193qF1o1fNIwPAV
         oqjOMu34rZO78xctEuYXHUW/+q89IdHjH9Vq2BpARf1atfgptlNp2wIJ8trsMSMCOBYJ
         fAww==
X-Gm-Message-State: APjAAAUrKYjjqlfpRZP0m2W9emeL7Gig7NMJP9L4fnbRDwTur8PCslO2
        WP3kKpDT+9cnr0U5O/TwuCy+xvYz
X-Google-Smtp-Source: APXvYqxh8Zzr67QMFESlpOM6/GiKJ6mXPQSJjHx8C+75xL67W9PpmtwAPYlmajtLXr0NUySX8HaONw==
X-Received: by 2002:a63:c508:: with SMTP id f8mr7854604pgd.17.1579931696715;
        Fri, 24 Jan 2020 21:54:56 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:1596:afb1:10e:95ae? ([2601:647:4000:d7:1596:afb1:10e:95ae])
        by smtp.gmail.com with ESMTPSA id e15sm8509415pja.13.2020.01.24.21.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 21:54:56 -0800 (PST)
Subject: Re: [PATCH v3 1/3] scsi: refactor sdev lun queue depth setting via
 sysfs
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
References: <20200124230115.14562-1-jsmart2021@gmail.com>
 <20200124230115.14562-2-jsmart2021@gmail.com>
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
Message-ID: <0502d67b-202e-a11c-a2d5-113838deded0@acm.org>
Date:   Fri, 24 Jan 2020 21:54:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200124230115.14562-2-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-24 15:01, James Smart wrote:
> In preparation for allowing other attributes and routines to change
> the current and max lun queue depth on an sdev, refactor the sysfs
> sdev attribute change routine. The refactoring creates a new scsi-internal
> routine, scsi_change_max_queue_depth(), which changes a devices current
> and max queue value.
> 
> The new routine is placed next to the routine, scsi_change_queue_depth(),
> which is used by most lldds to implement a queue depth change.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
