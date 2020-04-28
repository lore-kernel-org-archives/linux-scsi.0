Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DE9C83001
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 16:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0146820656
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 16:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgD1QaD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 12:30:03 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40503 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbgD1QaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 12:30:03 -0400
Received: by mail-pf1-f196.google.com with SMTP id x2so7202429pfx.7;
        Tue, 28 Apr 2020 09:30:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MIDJ0r0z4CNqSVp8mS4Nr/flVoiVA++YaK6HT3QzFCc=;
        b=kfk9Q0IUUN5aXEtthGR9DA9Wv0DXmbLB7vmKZS32vGDXDFoLv9zMOzYQ5M1lt+3885
         xvJfzbkyTnds02uCzCEYouvjncDG70hU1m89aa6oUcdE3/IRsm1sAI9isc2IrX50EkMK
         x0XCUWZjMxMcJJtWSAJ6nMxg97MMYYnI2s1T8Pa+sdQ/2hwSY+wigwTY5vtL05iSFgav
         m39D40TcMIJA/weRuMpUlGPUIwP39+OVRxqmn0peCUhoMJLtPCTkMIDOHR/sPTD0cd9r
         tn7v6Qe2e8fqaGDUbzzd3yi8tRlhVgNSzZ0SkXfn/IoFUG54DiI1Gvc9PkHu8gQ6JfsX
         z21Q==
X-Gm-Message-State: AGi0PubntOZ053Po7EcRXX6C/1alWZdVMKxIvuI7ouTQ2XxVaJiIo3ZO
        dHhm5qgZqMgxmOVOrAsvYH9ZCZwDkQjllQ==
X-Google-Smtp-Source: APiQypKs4VKrU7xVDEQmmhT4D7K1j6c+obiRv1IUQbYWkKN1sFAAk3OZbsRntpen75++23+sUWmONA==
X-Received: by 2002:a63:a351:: with SMTP id v17mr2598458pgn.343.1588091401828;
        Tue, 28 Apr 2020 09:30:01 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:1473:9ec8:73db:e572? ([2601:647:4000:d7:1473:9ec8:73db:e572])
        by smtp.gmail.com with ESMTPSA id n69sm2640986pjc.8.2020.04.28.09.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 09:30:01 -0700 (PDT)
Subject: Re: [PATCH 07/11] target: add sysfs support
To:     Mike Christie <mchristi@redhat.com>, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20200428061109.3042-1-mchristi@redhat.com>
 <20200428061109.3042-8-mchristi@redhat.com>
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
Message-ID: <a79c2243-f4ee-4138-abd5-d9df70761bf0@acm.org>
Date:   Tue, 28 Apr 2020 09:29:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428061109.3042-8-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-27 23:11, Mike Christie wrote:
> @@ -3536,6 +3551,15 @@ static int __init target_core_init_configfs(void)
>  
>  	target_init_dbroot();
>  
> +	tcm_core_kobj = kobject_create_and_add("scsi_target", NULL);
> +	if (!tcm_core_kobj)
> +		goto out;

Is an ack from Greg KH required when adding a new directory under
/sys/kernel?

Should a file be added under Documentation/ABI/stable that documents the
new sysfs attributes?

Otherwise this patch looks fine to me.

Thanks,

Bart.
