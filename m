Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5614EC10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 15:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 314D12074A
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 15:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgCMPDs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 11:03:48 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45175 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgCMPDs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 11:03:48 -0400
Received: by mail-pg1-f194.google.com with SMTP id m15so5117733pgv.12
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2020 08:03:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ox0YxvwtRiAGj7FM+e+yGzl1IJV63C+AKgXV9Fj1d38=;
        b=cZkT6FCLKwbC+UjvZt9fG75UqjfMqcsEjQoaKuz6hje/2NMUuFyvDFm3SJ2nbgVliC
         FX0D3ph5WXLxbcIG6+3e4BRyCKLjOC20/sn/e3bvt7KJU6aDgAEQFaau+Zz81HCZK3se
         nyHafknQviZW5G4sZqQxaKRtMo2A6kTeB4xZXAzysgGKzxKYa4EyC7mG/fR+QIhVhIYy
         1C7+zWgY7kvNDqVcOQ6p0KCC8TVZC0tIUxJqi+6bsFnMOg8gHd9aqdda2uJfc7ioz+Iv
         zVSg+MZZcKlA9C8l3FMJI4u9VKCGqBP9fOPe3ECV5EpL8bYnfQlpXkvkU4YlUn79brfi
         8tfg==
X-Gm-Message-State: ANhLgQ2uR0jjEsPQazSkyHhDl/R07bECbsXm87zbGEb+FjcCA11bJ664
        J1tfVezhxGyktHWK/e6F78M=
X-Google-Smtp-Source: ADFU+vusbXoDS7XYE9INGZr8cl05KotVpMO5MgKmpFkk956L6rX4UDDw+bxWb+cTqqZYTuq2KTMzDA==
X-Received: by 2002:a65:68d0:: with SMTP id k16mr2507412pgt.414.1584111826976;
        Fri, 13 Mar 2020 08:03:46 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:4927:51b8:6d1e:6c02? ([2601:647:4000:d7:4927:51b8:6d1e:6c02])
        by smtp.gmail.com with ESMTPSA id p7sm47616135pfb.135.2020.03.13.08.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 08:03:46 -0700 (PDT)
Subject: Re: [PATCH v2 4/5] scsi/st: Use get_unaligned_be24() and
 sign_extend32()
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kai Makisara <Kai.Makisara@kolumbus.fi>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
References: <20200313023718.21830-1-bvanassche@acm.org>
 <20200313023718.21830-5-bvanassche@acm.org> <20200313110804.GC8132@lst.de>
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
Message-ID: <e78f338d-7760-99db-b7ad-2fd698a76d29@acm.org>
Date:   Fri, 13 Mar 2020 08:03:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200313110804.GC8132@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-13 04:08, Christoph Hellwig wrote:
> On Thu, Mar 12, 2020 at 07:37:17PM -0700, Bart Van Assche wrote:
>> @@ -2680,8 +2681,7 @@ static void deb_space_print(struct scsi_tape *STp, int direction, char *units, u
>>  	if (!debugging)
>>  		return;
>>  
>> -	sc = cmd[2] & 0x80 ? 0xff000000 : 0;
>> -	sc |= (cmd[2] << 16) | (cmd[3] << 8) | cmd[4];
>> +	sc = sign_extend32(get_unaligned_be24(&cmd[2]), 23);
> 
> Btw, didn't the old code here have undefined behavior if cmd[] is
> a u8 and we shift by a larger amount?

That's a great question. According to my interpretation of the C
standard the above code is fine:

<quote>
6.5.7 Bitwise shift operators
Syntax
  shift-expression:
    additive-expression
    shift-expression << additive-expression
    shift-expression >> additive-expression
Constraints
Each of the operands shall have integer type.
Semantics
The integer promotions are performed on each of the operands. The type
of the result is that of the promoted left operand. If the value of the
right operand is negative or is greater than or equal to the width of
the promoted left operand, the behavior is undefined. [ ... ]
</quote>

Since the RHS has integer type, I think the above means that cmd[2] and
cmd[3] are promoted to a signed integer before being shifted left. As
far as I know the Linux kernel only supports compilers for which
sizeof(int) >= 4 so I think that the old code did not trigger undefined
behavior.

Bart.


