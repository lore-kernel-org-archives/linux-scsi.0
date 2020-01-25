Return-Path: <SRS0=90Tc=3O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AA7C35241
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jan 2020 05:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 471D220716
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jan 2020 05:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgAYFvR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jan 2020 00:51:17 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:42850 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgAYFvR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jan 2020 00:51:17 -0500
Received: by mail-pf1-f180.google.com with SMTP id 4so2149281pfz.9
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2020 21:51:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hiBb6/idb/ik/Yd/BqGt+ldDvR1cu3usQxiXs+CGCew=;
        b=k0seKVjqXXt/kr0SzpNWbhQ/ShD5W5SUvoCzjxjiwBjfY69uVF7mTDx4vdCjFQUrUl
         dxQOB3ri42i/cNW3YMhnXcRU286kOQEB+kPp4CVCTSzupG1ckx6YaE3Jgh4WtiHs4HSQ
         tYXV3o1tWBE6RiQwN+8AgtF6TQIaehir2m1rxXXJYAOvsBPjKVvvSTfq+CEOaEnI/QPf
         4gcfVjDe/tJ0eRr+25KELZVG4t67DPSy+4SZV7mC36IANhjENSAidfPhKgbMsI9zfcF6
         fEr0DwrrjAW4NEt9lkMv/AkjkooNYKqQMse87fm9XrCd6JwACERnrqpey7/h+pb+O4UX
         6Lzg==
X-Gm-Message-State: APjAAAVyl1cy7WeVtDPCCr8CNS1ldKtVBEqCxz5yGT+IYXXioXiQsuzb
        Z3qxH0EmG/qPRCoOo5Ra2g8raHH/
X-Google-Smtp-Source: APXvYqyznxSzN4rHBHkpRN8byIQreWb0NcMODHRnpjRPeoPVBFnnXbs24B7l+nDo5sQwhEIXEc6R6g==
X-Received: by 2002:a65:64c6:: with SMTP id t6mr7827708pgv.392.1579931476242;
        Fri, 24 Jan 2020 21:51:16 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:1596:afb1:10e:95ae? ([2601:647:4000:d7:1596:afb1:10e:95ae])
        by smtp.gmail.com with ESMTPSA id b15sm8387697pgh.40.2020.01.24.21.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 21:51:15 -0800 (PST)
Subject: Re: [PATCH v3 3/3] scsi: add shost attribute to set max queue depth
 on all devices on the shost
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
References: <20200124230115.14562-1-jsmart2021@gmail.com>
 <20200124230115.14562-4-jsmart2021@gmail.com>
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
Message-ID: <45cc1ca7-0724-223f-0f48-ad8749de174f@acm.org>
Date:   Fri, 24 Jan 2020 21:51:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200124230115.14562-4-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-24 15:01, James Smart wrote:
> This patch adds an shost attribute, max_device_queue_depth, that will
> cycle through all devices on the shost and change their current and max
> queue depth to the new value.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
