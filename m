Return-Path: <SRS0=uhQV=4K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F59C35669
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 02:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B635E206D7
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 02:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgBVCqK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 21:46:10 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42475 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgBVCqK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2020 21:46:10 -0500
Received: by mail-pf1-f196.google.com with SMTP id 4so2256415pfz.9
        for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2020 18:46:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pQKS9egMPUlLc/tYaFJevI8N7JjrVdDrD283FD5jfv0=;
        b=CtmbAY/+juu1zoWpfCpHvuhPtHbJKP6rqvVJgAH5Id87+4X3ekAkQKb6tHV8e+sevG
         A8A0WONdtStKoQ3LkUW7HEDS09+g3vG6VrGgkqdD8af6DP8NEmG3j9zxc49qFrgQNJUf
         UqwqAQXxM3Ysck0myEuw8T4BtpSTBU77k54wyBVQjiFCXG+CbebBKviFtaAtAGC+VdJI
         MBV4TaKZM2gi/jOVjYjcpwlkhFs/6xZWNulmq/7TgeYWubqyMvPOkOgCcnYcbd278Ar8
         xzuIbrxhLJRBIC7y8kzoLFjMz5yMLW6CGmY8T6pf3MUoUZOczInlmw9j3xXR/uqXYl7y
         srgQ==
X-Gm-Message-State: APjAAAXldW7paoTNnWZ2DmmgQAlRwpT8esUyfifYbGHKGVNMwydi4pk7
        j3GV1qS3UKZDNIB7BP8LFN4=
X-Google-Smtp-Source: APXvYqwpJZQDX+a9nP/W7XgZZzuoxyr/I3CZPPQs6dLVS48Mbxo/yKoHVjX37MK0T6/M0YLkWU8tjw==
X-Received: by 2002:a62:188:: with SMTP id 130mr41187155pfb.249.1582339567963;
        Fri, 21 Feb 2020 18:46:07 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:89d3:733:bb73:c1a4? ([2601:647:4000:d7:89d3:733:bb73:c1a4])
        by smtp.gmail.com with ESMTPSA id r13sm3693088pjp.14.2020.02.21.18.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 18:46:07 -0800 (PST)
Subject: Re: [PATCH 1/2] ufshcd: remove unused quirks
To:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
References: <20200221140812.476338-1-hch@lst.de>
 <20200221140812.476338-2-hch@lst.de>
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
Message-ID: <b8a9f380-a005-6c34-b10c-ab9759d84b4f@acm.org>
Date:   Fri, 21 Feb 2020 18:46:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200221140812.476338-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-21 06:08, Christoph Hellwig wrote:
> Remove various quirks that don't have users, as well as the dead code
> keyed off them.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
