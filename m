Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02DDC4727E
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 02:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5188A207F7
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 02:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387491AbgJBCiJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 22:38:09 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:39720 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgJBCiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 22:38:08 -0400
Received: by mail-pg1-f170.google.com with SMTP id d13so504759pgl.6
        for <linux-scsi@vger.kernel.org>; Thu, 01 Oct 2020 19:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o7GWjMRxTB+qJNx7gxY1RNqIKbfci1vbhTXX6v+ER2A=;
        b=Y0zS+LynzJ1eh3SFzzeP9WDVaZMKDmwYUuGr9KUqGv7Bu6833SC81uAWZBWABKj3Zj
         RpUUbY57jcnPNE/nB2C2fDad30MMWu5FnByk4bYvsNmiFi1PPE6sIp5aBO9BYRRX9Y0k
         OLbrrUHP8HZ/6JRSFDPEp/VQr/7ekJdfW4noodPICWnLRudASC/BN7+lTgNloM2sscm+
         QnF+GgxYMSHHS2c2lQ3+cb8+DJQTKepYLL92KYNjBSruxXvrd0kVDF7faURUqo7q6/3E
         qidgDGld8+v0G78uieRmvvK3MXIonkp/I3XY9LhCPov42tzxPPhsh+Z1ywfPqkgvD++/
         DpOw==
X-Gm-Message-State: AOAM532ruxuGw1Cpor0l8lFlAICsc6hSCOCz8eYIl43bmL5plL5BIQDq
        ToG8NBtL7UrIKCpxUq/bWOw6YefagDw=
X-Google-Smtp-Source: ABdhPJyyW8IC6V8tcpYqD9QwGSJadur44Iz1j7jN5H3ItWnFQzUdT3jQ7K99EbvO1QEFiGrha9rXcw==
X-Received: by 2002:aa7:8084:0:b029:13f:b82a:1725 with SMTP id v4-20020aa780840000b029013fb82a1725mr163876pff.9.1601606287959;
        Thu, 01 Oct 2020 19:38:07 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:70da:e8be:ff7e:1f9? ([2601:647:4000:d7:70da:e8be:ff7e:1f9])
        by smtp.gmail.com with ESMTPSA id j12sm155914pjs.21.2020.10.01.19.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 19:38:06 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi: Add limitless cmd retry support
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <1601566554-26752-1-git-send-email-michael.christie@oracle.com>
 <1601566554-26752-2-git-send-email-michael.christie@oracle.com>
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
Message-ID: <408febe8-2f66-cadb-2104-3821793f87fe@acm.org>
Date:   Thu, 1 Oct 2020 19:38:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1601566554-26752-2-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-01 08:35, Mike Christie wrote:
> The next patch allows users to configure disk scsi cmd retries from
> -1 up to a ULD specific value where -1 means infinite retries.
> 
> This patch adds infinite retry support to scsi-ml by just combining
> common checks for retries into some helper functions, and then
> checking for the -1/SCSI_CMD_RETRIES_NO_LIMIT.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
