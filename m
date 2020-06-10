Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB039C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B55192074B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgFJCn2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 22:43:28 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34706 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgFJCn2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 22:43:28 -0400
Received: by mail-pg1-f196.google.com with SMTP id m1so322488pgk.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2020 19:43:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=F8U8OjsCZOQ1pAFxMxM8B/CmNVGX0Ub1YAlXFx7x+M8=;
        b=ANljlOTP8tpPKkKCBhTpNiprpYpfN1S/qFlL3OyfbFAIlfzHeWTMz2OK3d5M3PCIRQ
         YlpbiWy7Os/+cDoRr6cK1tRoDfv6W3TXKFFyljrB1q3loHERZjARb23CH/FHr2DHoUK2
         KE6f2N4Yxn/VmlCFfq6IfQKVAp4RIvh3xspjhK39qhu/0ACsAZE0/3CBtsZyUbLLiuUe
         sZNAT31wHAFTXNhwRi7Y12HkAlbXhb7XIOI3ZixmLYar6jzuAvO67Isdfw3Ed9dD8hgU
         wSOsxB8hrO3p8CshQBS+xBAklgudsnw7xaIIOsi1vW/EUdRi72KlmRSPIK0YC14JPqil
         ddiA==
X-Gm-Message-State: AOAM5329v306M1lA1x6m4lH2eaAuNlE+/6sX9gkJguEYqH2T0ldl+ehX
        Cw0Ssuys+nSdWXxdR1Jrxv8=
X-Google-Smtp-Source: ABdhPJy7ToFbbvbjJbFdO2fiYUUnEUCTn9OrSR1tEOv5ynPvBF8QhfJa3c1sDATDfht5xI2MfN8dvg==
X-Received: by 2002:a05:6a00:14d4:: with SMTP id w20mr741607pfu.279.1591757006103;
        Tue, 09 Jun 2020 19:43:26 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id x14sm11162478pfq.80.2020.06.09.19.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 19:43:25 -0700 (PDT)
Subject: Re: [PATCH] qla2xxx: Fix the ARM build
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200609041403.20306-1-bvanassche@acm.org>
 <20200609073040.wjxzdtv5lcot2ziw@beryllium.lan>
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
Message-ID: <eb192096-653f-41cf-4698-198fac26fcb3@acm.org>
Date:   Tue, 9 Jun 2020 19:43:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200609073040.wjxzdtv5lcot2ziw@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-09 00:30, Daniel Wagner wrote:
> Hi Bart,
> 
> On Mon, Jun 08, 2020 at 09:14:03PM -0700, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
>> index 42dbf90d4651..edc9c082dc6e 100644
>> --- a/drivers/scsi/qla2xxx/qla_def.h
>> +++ b/drivers/scsi/qla2xxx/qla_def.h
>> @@ -46,7 +46,7 @@ typedef struct {
>>  	uint8_t al_pa;
>>  	uint8_t area;
>>  	uint8_t domain;
>> -} le_id_t;
>> +} __packed le_id_t;
>>  
>>  #include "qla_bsg.h"
>>  #include "qla_dsd.h"
>> @@ -1841,8 +1841,8 @@ typedef union {
>>  	struct {
>>  		uint8_t reserved;
>>  		uint8_t standard;
>> -	} id;
>> -} target_id_t;
>> +	} __packed id;
>> +} __packed target_id_t;
> 
> This is a bit strange. Why is that only these two definitions need this
> treatment? With gcc 6.3.0 on Debian stretch, the compiler did the
> right thing for x86_64, ARMv7 and ARMv8. In all cases target_id_t is 2 bytes
> long.

Hi Daniel,

That's a good catch. I checked again and the __packed annotations for
target_id_t are not necessary. I will send a v2 of this patch.

Thanks,

Bart.
