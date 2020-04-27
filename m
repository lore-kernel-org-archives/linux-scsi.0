Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94717C54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 01:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CEBC206A5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 01:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgD0Bzh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 21:55:37 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43776 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgD0Bzg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 21:55:36 -0400
Received: by mail-pf1-f196.google.com with SMTP id v63so8191535pfb.10
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 18:55:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FfkljgAHUiBsMyOwLJc6cB6zpxoEnYGhd955jCWD7qI=;
        b=ocD+uWRZnBC1aSztiu+pXnqH9yvUR6+p/NUGBeavws9CcTI8Jh8rNnu5arkclWGPLZ
         Zg20LVoMhHy6jZPioabps0SzQyre8vBxST+ui5P6kgZokSuXEAXCc9u5BJWF1mwKPta8
         dUotQSV1C3PkTy0YPkZhUKC0cC571FVB+Pq8BLFe6qlxaEcoXMom+JKhJYVObPHSMONb
         2E7p1hU5oRncE4bxs1fePbADMhMz6Z7Orquk83KfV5Gfz5WnJvmK+gndZH8DUc1TlyPS
         LgW2+RZOPWxhLiew7vbYZbNrwk8qI6nT8m9gs6oqtJ5lZz07jIM9jwqneqRlQAdTHvFr
         V9BA==
X-Gm-Message-State: AGi0PubZuJ4w78DIkbdX57f+DL9Qtx29sHDkVHql51v7h+jnuSNkeIxB
        ORpArYf0+xmT2RoZiIUhmiU=
X-Google-Smtp-Source: APiQypLBnEsPFz6WkDfdp79DTP24D0xX9xF005JusK31qQmxdG9vUZGAqUf4Mc1YSBwnjd0SzEKs/w==
X-Received: by 2002:a63:6285:: with SMTP id w127mr12997399pgb.449.1587952535788;
        Sun, 26 Apr 2020 18:55:35 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:612a:373a:aa97:7fa7? ([2601:647:4000:d7:612a:373a:aa97:7fa7])
        by smtp.gmail.com with ESMTPSA id p190sm11275957pfp.207.2020.04.26.18.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 18:55:35 -0700 (PDT)
Subject: Re: [PATCH 1/3] scsi: qla2xxx: Fix warning after FC target reset
To:     Viacheslav Dubeyko <v.dubeiko@yadro.com>,
        linux-scsi@vger.kernel.org
Cc:     hmadhani@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux@yadro.com, r.bolshakov@yadro.com,
        slava@dubeyko.com
References: <1d7b21bf9f7676643239eb3d60eaca7cfa505cf0.camel@yadro.com>
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
Message-ID: <fcbbfdac-1a79-51ac-beae-ea4b38f21798@acm.org>
Date:   Sun, 26 Apr 2020 18:55:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1d7b21bf9f7676643239eb3d60eaca7cfa505cf0.camel@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-24 05:10, Viacheslav Dubeyko wrote:
> From: Viacheslav Dubeyko <v.dubeiko@yadro.com>
> Date: Fri, 10 Apr 2020 11:07:08 +0300
> Subject: [PATCH 1/3] scsi: qla2xxx: Fix warning after FC target reset
> 
> Currently, FC target reset finishes with the warning
> message.

Hi Slava,

For future patch submissions, please include a cover letter with the
patch series and also use threaded mode, e.g. by setting
sendemail.thread = true in ~/.gitconfig.

A summary of what Martin Petersen expects from contributors is available
at https://lore.kernel.org/ksummit-discuss/yq1o8zqeqhb.fsf@oracle.com/.

Thanks,

Bart.
