Return-Path: <SRS0=hRFu=4U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF7EC3F2CD
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 06:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27910215A4
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 06:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgCCGhD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Mar 2020 01:37:03 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40219 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgCCGhD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2020 01:37:03 -0500
Received: by mail-pg1-f193.google.com with SMTP id t24so1048995pgj.7
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2020 22:37:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=yldANRrwbeVYxdAy1piiUadONm4JOidQwpjwgeul7GU=;
        b=BMegFLYlGgoUjhnIzKKT+pbp2RFlet2wsOsJ1vdBhakb07UZZF4uz9EpAnKStxsMZs
         LKdC/X+7Mvd5hT6EiCglN5/Q+naKSsFRj8M+TMalimx2FVCZpSH5KR1RCvQiS3ASpDYB
         VDiJnws3Oevuzhg+EY3mftCqT0umP2m8kxC9H+VQra3aWvJtzEoEthLTxFPx9M3NwA/c
         P5ORoocIwgpM4XP9677wyxLT778fP2v4xzPuGSpQY2UxtI1sW57a5glz9Bz0TjpIZQex
         NO04mVz1HvPSUTwI12aC6o3nVP2COe+i8qho2cUg+ZPaJ23eipO61oz9GUKtnE4/agRt
         chWA==
X-Gm-Message-State: ANhLgQ1bTSe+Hjg2mjzrwFg7qBZTjR7czMZhCG5UPmslJSIn+dKOLjkA
        rMUVmDUVOl9qN7cMcohb6Do=
X-Google-Smtp-Source: ADFU+vtx7crHHd9lp8lKZyfvuNc1cKwLd38FdLAjQfyxgayqFSEH8Q4Ee26i2THvsRO0AwQoVgURiw==
X-Received: by 2002:a63:354d:: with SMTP id c74mr2641547pga.234.1583217422154;
        Mon, 02 Mar 2020 22:37:02 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:5909:8e52:fd69:e98d? ([2601:647:4000:d7:5909:8e52:fd69:e98d])
        by smtp.gmail.com with ESMTPSA id c3sm23202945pfb.85.2020.03.02.22.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 22:37:01 -0800 (PST)
Subject: Re: [PATCH 4/4] qla2xxx: Fix the code that reads from mailbox
 registers
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200302033023.27718-1-bvanassche@acm.org>
 <20200302033023.27718-5-bvanassche@acm.org>
 <20200302184312.6uunsrgpxqjznsdz@beryllium.lan>
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
Message-ID: <7c8959b8-5b4a-d65c-ae21-b8fe2c7d0680@acm.org>
Date:   Mon, 2 Mar 2020 22:37:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302184312.6uunsrgpxqjznsdz@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-02 10:43, Daniel Wagner wrote:
> On Sun, Mar 01, 2020 at 07:30:23PM -0800, Bart Van Assche wrote:
>> -#define RD_REG_BYTE(addr)		readb(addr)
>> -#define RD_REG_WORD(addr)		readw(addr)
>> -#define RD_REG_DWORD(addr)		readl(addr)
>> -#define RD_REG_BYTE_RELAXED(addr)	readb_relaxed(addr)
>> -#define RD_REG_WORD_RELAXED(addr)	readw_relaxed(addr)
>> -#define RD_REG_DWORD_RELAXED(addr)	readl_relaxed(addr)
>> -#define WRT_REG_BYTE(addr, data)	writeb(data, addr)
>> -#define WRT_REG_WORD(addr, data)	writew(data, addr)
>> -#define WRT_REG_DWORD(addr, data)	writel(data, addr)
>> +static inline u8 RD_REG_BYTE(const volatile u8 __iomem *addr)
>> +{
>> +	return readb(addr);
>> +}
> 
> I would prefer lower case for the inline function names.

How about doing that as a separate patch such that this patch can remain
small and readable?

Thanks,

Bart.
