Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64D5C35240
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 02:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 998602064C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 02:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbgAXCzp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 21:55:45 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55946 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730487AbgAXCzp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2020 21:55:45 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so377102pjz.5
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2020 18:55:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3NcvFQJ4rlIeUKxhaXQZHNHPekZIQMWtDFSEmvBiDPk=;
        b=NcSWXtnbty/O/Y6rIeVO13cY15EkcxASUwWcMs5kN9nz+GgDgENeMY3wsp8rQwEH0h
         d3mFd2vj4Ur8gGru4SiIGQ18rRffXF3tZ7S7Gw9+E5rsMHhVGKvaNzJEBlmaloncv9ND
         uGtaBUwCYKmQ7d4fDjNWXJD+QKyO2gnnE8DuJAQCPgmydKuuNGHmgI5y+fS1MoI8dAOm
         Z6d/bkjteShofcxkHDfhxTmSZLb90hVTOIqcqY/VyrdyVJbFf88+3pnFGsg0tZnBzNnj
         y6y38Z93/8pTbhK6SNAN7yWYQgzSSdMEUsWUDPYCYtYoyUIt0Qvq8gc05OOPPMhZDAmL
         H7ZQ==
X-Gm-Message-State: APjAAAUlN0G6OFR2DE7h25roe3ExnvYPACpSnIxbzp1XVf2Ueazv8JPG
        o8PuojRQGCJN250H/r5pc7ucY73A
X-Google-Smtp-Source: APXvYqyuV3+c/7BvA8MUolDlIlcA6MK37dOwnU+Qnycyk1b2TVtRKIaaS+WTOyp5rk9Gggl9Um+0Wg==
X-Received: by 2002:a17:90a:b008:: with SMTP id x8mr897086pjq.106.1579834544084;
        Thu, 23 Jan 2020 18:55:44 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:3d7d:713:61bd:ca2a? ([2601:647:4000:d7:3d7d:713:61bd:ca2a])
        by smtp.gmail.com with ESMTPSA id a26sm4132263pfo.27.2020.01.23.18.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 18:55:43 -0800 (PST)
Subject: Re: [PATCH v2 3/3] scsi: add shost attribute to set max queue depth
 on all devices on the shost
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
References: <20200123222102.23383-1-jsmart2021@gmail.com>
 <20200123222102.23383-4-jsmart2021@gmail.com>
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
Message-ID: <5f870a98-65d4-c4c6-8034-4c7dd8612b94@acm.org>
Date:   Thu, 23 Jan 2020 18:55:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200123222102.23383-4-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-23 14:21, James Smart wrote:
> +	depth = simple_strtoul(buf, NULL, 0);

From Documentation/process/deprecated.rst:

The :c:func:`simple_strtol`, :c:func:`simple_strtoll`,
:c:func:`simple_strtoul`, and :c:func:`simple_strtoull` functions
explicitly ignore overflows, which may lead to unexpected results
in callers. The respective :c:func:`kstrtol`, :c:func:`kstrtoll`,
:c:func:`kstrtoul`, and :c:func:`kstrtoull` functions tend to be the
correct replacements, though note that those require the string to be
NUL or newline terminated.

Did checkpatch recommend to use kstrtoul() instead?

> +	return (retval < 0) ? retval : count;

Are the parentheses necessary in this expression?

Thanks,

Bart.
