Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A6FC33CB1
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 04:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA7D92077B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 04:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgAPEsP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 23:48:15 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:37636 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729138AbgAPEsP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 23:48:15 -0500
Received: by mail-pg1-f173.google.com with SMTP id q127so9261527pga.4;
        Wed, 15 Jan 2020 20:48:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0S2+3hSKtOJ2JYJcki1xzbAcKnDvkCEIcUnVNQdS+OA=;
        b=mgfUblGwQAMybJ2y0xJei9EQkXtzNPT5KHMTu6Tesw+vgti21Z1Ih/aAgIh8zp5Jp0
         lTH204YqziKHOUWJ8TNZxHTKzB+ZCOit+xWs8G6FMJDaGWSZ9WFfsN+USdrZyMqej3gk
         aLNsJgNpqqLvWRrBYdmtBL/TePirqsgYVwliK7D7c6LhXg66GOq/LTFmEzOrpZNf7NjM
         zbMUh4vC0ynX0bD4I8Ey77aFznxi8S0ReW9rtJjp0CGPjET5R8nQr6Pd0UJXrNHH2ktN
         WfTW9FVCGLTx1I9hEIoFq7k9ZizezunaIkJxm2p//OXAvUSeoyHQubIhUpTcVsQLcDoH
         ng2w==
X-Gm-Message-State: APjAAAXvQyWUuXrp31+Zhcn1tIgR7UgWebDIITJqj9KfGvsLMI6dU5hp
        0eI/KQelckZ3AY7xEYeX6to=
X-Google-Smtp-Source: APXvYqx7bBCwV7+brXVYjNoMySI8WfZCVZQyQhmv9WIyZn8RyaDM+SItw/1VaqGYKUOlbuchiciR5Q==
X-Received: by 2002:a63:a350:: with SMTP id v16mr35428345pgn.87.1579150094362;
        Wed, 15 Jan 2020 20:48:14 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:e955:e36b:c3d8:ecb2? ([2601:647:4000:d7:e955:e36b:c3d8:ecb2])
        by smtp.gmail.com with ESMTPSA id t187sm23991267pfd.21.2020.01.15.20.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 20:48:13 -0800 (PST)
Subject: Re: Trace seen on target during iSER login
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Rahul Kundu <rahul.kundu@chelsio.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>
References: <BYAPR12MB3080466CC0D6B968D3525F5BEF270@BYAPR12MB3080.namprd12.prod.outlook.com>
 <53ca2c5e-25e1-9762-9a8e-0036c02fdb3b@acm.org>
 <BYAPR12MB3080FE52C175C69092D8428EEF3F0@BYAPR12MB3080.namprd12.prod.outlook.com>
 <yq1blr4p0fy.fsf@oracle.com>
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
Message-ID: <ecdfc240-e0d7-789c-ff81-3ce88c1a9d12@acm.org>
Date:   Wed, 15 Jan 2020 20:48:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <yq1blr4p0fy.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-15 19:03, Martin K. Petersen wrote:
> Are you going to submit this?

Yes, I just did that. Thanks for the reminder.

Bart.


