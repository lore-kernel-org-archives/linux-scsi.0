Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DCAC432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 05:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0714320659
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 05:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfKZFQO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 00:16:14 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37042 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfKZFQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 00:16:14 -0500
Received: by mail-pg1-f193.google.com with SMTP id b10so8366181pgd.4
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2019 21:16:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xtYQbL2zT7uQ89wJejlPftbqYzlrdQZQzlH4tYN1U7U=;
        b=sk8FE5J6ky0hCxA/UBtLTHBnKgBCV8HzIpQS6qkUsxDppj4lJ8RSrvS2bC7D+k1OvY
         kf7Ggcjuw+66pQ8DzjoxH1ZDdoBQ6dCk12oaOsQ47KJUt+U+QNoZ5b2QVDm7KSl8SKEA
         BPVBPNhBtm2MjqtBSA8nqIL1JDEMHrPsv4nuvokuD0MzbsdgHhVoK9Asxrvxc12WgyU9
         H0JE2CzQZRFt1bGCZjxjjS9yyLJMCQQPOSEKUmMLURQ6cZUbWbmUJYackNx67QG/f3LG
         93wM1aV41q+DF5GkCj0cuCCMFRH+P/p6arv6D8o+qwI4/LTcjy8c18XYQ8cbmXtvxcM5
         lx9g==
X-Gm-Message-State: APjAAAUmmHs5iR+g9MtKPnDyNySWAaaH5/Vx6v13PfSL9t6U1cHqfvb2
        Uog6/Jvt/YvkcXMtj2T3jj8=
X-Google-Smtp-Source: APXvYqyUG0FUB+IdZIGPGHb8dIdBkPwaQCpg10BScONZslX9vrl8MEv91P/SFhoAtpf1fAVmt//w/w==
X-Received: by 2002:a63:d20f:: with SMTP id a15mr37927829pgg.268.1574745373081;
        Mon, 25 Nov 2019 21:16:13 -0800 (PST)
Received: from ?IPv6:2601:647:4000:1248:b483:6049:6c3e:9659? ([2601:647:4000:1248:b483:6049:6c3e:9659])
        by smtp.gmail.com with ESMTPSA id 193sm11071648pfv.18.2019.11.25.21.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 21:16:12 -0800 (PST)
Subject: Re: [PATCH v6 4/4] ufs: Simplify the clock scaling mechanism
 implementation
To:     dgilbert@interlog.com, cang@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191121220850.16195-1-bvanassche@acm.org>
 <20191121220850.16195-5-bvanassche@acm.org>
 <0101016ea17f117f-41755175-dc9e-4454-bda6-3653b9aa31ff-000000@us-west-2.amazonses.com>
 <c26ba983-b166-785f-86e8-dd60c802fa77@acm.org>
 <3cadd4df-13ee-fe65-32dc-6a3c583a4988@interlog.com>
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
Message-ID: <4ff965f1-20c9-d561-cd67-c1426466b39f@acm.org>
Date:   Mon, 25 Nov 2019 21:16:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3cadd4df-13ee-fe65-32dc-6a3c583a4988@interlog.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-25 21:00, Douglas Gilbert wrote:
> On 2019-11-26 12:05 p.m., Bart Van Assche wrote:
>> -    start = ktime_get();
> 
> Rather than throw away the high precision clock and resort to jiffies,
> perhaps
> you might try the middle road. For example: ktime_get_coarse().

Hi Doug,

Since HZ >= 100, I think that 1/HZ is more than accurate enough for a
one second timeout.

Bart.
