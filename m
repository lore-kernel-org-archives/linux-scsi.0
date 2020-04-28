Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30A6C83000
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 16:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9941206E2
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 16:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgD1QZp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 12:25:45 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:36661 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbgD1QZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 12:25:45 -0400
Received: by mail-pj1-f50.google.com with SMTP id a31so1357961pje.1;
        Tue, 28 Apr 2020 09:25:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fsswDv/JFtXWKeRWiDxY7o4Nm4O8gO+2f5zJAXK621M=;
        b=hYZHSil8cz89bt0Gm8IavRfXECzgpAAYNwwNisZ8AVKfbEAf0TV9iFu33U72Rr6n60
         uytiJS5XQBOTREBllrUpJ2Opv2BXEW0blqMIc0SC5hwy8S6bp9EKnLb3pUhT4WytpOVy
         qXjyOKSPDF5dwDSYnzNt+gb8baIOTeIHGqH3N5cR/Hl54PDtu9DlPLpGwT7bqsyhdZVV
         fiHgt1Mt3ZiQndlZVyda8vi1F+H/tOzqyeSD3NFkWbGalBNJD5ieD/MtAivNUYqOvNjw
         eIH31a/UAPgK3SG3wuJI3pcjKbImccW2eVsxYzf5dJ6wkN2iVIHI1DevQV6DkLLocUZg
         hvQg==
X-Gm-Message-State: AGi0PubaPDK10HE1UWQvaD4EK7LukLJSOOC8RbySgcNT/lZb36I2INXn
        A4FCi81akjp5g3XGnfdP5WJEq7MwFLj9nA==
X-Google-Smtp-Source: APiQypJPSALHl30raI6FBk/moxbXMo/Zuu1Ogx5d4Xj2cnqhiCF9ubK3Sp8+pc7lJ2eEG9ocZA8EEw==
X-Received: by 2002:a17:90a:498a:: with SMTP id d10mr6381030pjh.194.1588091143641;
        Tue, 28 Apr 2020 09:25:43 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:1473:9ec8:73db:e572? ([2601:647:4000:d7:1473:9ec8:73db:e572])
        by smtp.gmail.com with ESMTPSA id z28sm15899725pfr.3.2020.04.28.09.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 09:25:42 -0700 (PDT)
Subject: Re: [PATCH 06/11] target: drop sess_get_initiator_sid
To:     Mike Christie <mchristi@redhat.com>, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20200428061109.3042-1-mchristi@redhat.com>
 <20200428061109.3042-7-mchristi@redhat.com>
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
Message-ID: <2d072c3d-140f-fd47-72bc-099e3555490b@acm.org>
Date:   Tue, 28 Apr 2020 09:25:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428061109.3042-7-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-27 23:11, Mike Christie wrote:
> sess_get_initiator_sid is no longer used. Drop it.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
