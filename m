Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C1AC4CECC
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 17:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6C50206D9
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 17:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgD0Rjt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:39:49 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:55620 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgD0Rjs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 13:39:48 -0400
Received: by mail-pj1-f67.google.com with SMTP id a32so7805175pje.5
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2020 10:39:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4aDgljY6ATZLQYZ11tc2dYkqWQ8Ycz9rI3nFmiRCbuc=;
        b=HyYoIJcOopTFoEbbWONb3e8BdpWJ2mDOR+dUoRoj/5Yb9OXJd/y4unFtj9UL3dGeKD
         385G8cDF6UAnIIoxQajQY5Q4fplEsb7XvL4nvnRbiWa6kL9mBN103ikdnufQJpy2Kfik
         iJq3Gnl/rSu1NEVAEXuhSaIVrFs5vJdHmp1y9zaY0A7++aw3BFSiQnLZwaTIXDOtEVUE
         68YbY0sO2WSS69wcDMInjiIAAbEBizJo0JN2bH0BykqZ2ExXgIlIcYD8JqFzj91ikYMi
         CcVti06tyvwzJ5CMPXNkM0iQupkmwcmn+6BWNkzR8qxjUmkESxtP8Xi3k/RYoubg3PUT
         ZmhA==
X-Gm-Message-State: AGi0PuazCW10CBbTfKyH5k4FAd2kEmg710sMNQPeuuN2FBesEXfrTirC
        ca1nHyVzGg+aK8x8yauPenU=
X-Google-Smtp-Source: APiQypKk5+P3F6S39pbl6oJdNW5mtpNP8HdguGs1fqbABriTj0HF8Aw3/e3artOohm0hlG9lTIK1og==
X-Received: by 2002:a17:902:9a8a:: with SMTP id w10mr25231444plp.259.1588009186797;
        Mon, 27 Apr 2020 10:39:46 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:a598:4365:d06:a875? ([2601:647:4000:d7:a598:4365:d06:a875])
        by smtp.gmail.com with ESMTPSA id j14sm11995576pjm.27.2020.04.27.10.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 10:39:45 -0700 (PDT)
Subject: Re: [PATCH v4 05/11] qla2xxx: Make a gap in struct
 qla2xxx_offld_chain explicit
To:     himanshu.madhani@oracle.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-6-bvanassche@acm.org>
 <d63f4b0b-9eea-9ae7-5c77-4b37a2040193@oracle.com>
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
Message-ID: <a2cc0d95-f20e-42ec-1e78-a25bbc8e567d@acm.org>
Date:   Mon, 27 Apr 2020 10:39:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d63f4b0b-9eea-9ae7-5c77-4b37a2040193@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-27 07:27, himanshu.madhani@oracle.com wrote:
> On 4/26/20 10:03 PM, Bart Van Assche wrote:
>> This patch makes struct qla2xxx_offld_chain compatible with ARCH=i386.
>>
>> Cc: Nilesh Javali <njavali@marvell.com>
>> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
>> Cc: Quinn Tran <qutran@marvell.com>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Daniel Wagner <dwagner@suse.de>
>> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/qla2xxx/qla_dbg.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h
>> b/drivers/scsi/qla2xxx/qla_dbg.h
>> index 433e95502808..b106b6808d34 100644
>> --- a/drivers/scsi/qla2xxx/qla_dbg.h
>> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
>> @@ -238,6 +238,7 @@ struct qla2xxx_offld_chain {
>>       uint32_t chain_size;
>>         uint32_t size;
>> +    uint32_t reserved;
>>       u64     addr;
>>   };
>>  
> 
> I think this should to be verified with Marvell Firmware folks. (I don't
> have API document handy with me anymore)

Please note that this patch does not change the layout of this structure
for x86_64. All this patch does is to make a hole in this structure
explicit.

Bart.
