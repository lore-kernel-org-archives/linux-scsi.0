Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57DBC2BB1D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 03:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB37D2072D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 03:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404957AbgDND40 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 23:56:26 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33904 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbgDND4X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 23:56:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id v23so5515627pfm.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2020 20:56:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=hnwQGkgMtwcmw7H8Dnu4FuNZA6n1L21AcLJyL5Qb0jE=;
        b=MKxFRcn2jj9P1d7PrWooiVnxTKxfy62nsdCCn88EsaC3s7IMRy8pWRbU1zCt5UUXqH
         NfjHGK4EFj2ZtyhNGqdnizCEq+ICkgQRp8VA9altbikvN0mFXztZDMpFKr2yOPVD0PME
         L1WUFbpQKL5JviPE1M8weMBWMvy7cJfrWOEFuNj3X5TSId/QuuI2Ix5ocS4YGWGFxX9N
         ijv0kF3nra2ceKPzHnV6czEw7OGHj2sLRaW/18DpLb8YmYn1t5gl1OSmQqrxf5Y3k1JT
         RXh3qCAaRRZB3GG1+C5jnpkpw2Qg+nY0IeKVCPMQEl26ZwhgrbSDax1c8JUezz+2CzSb
         dqig==
X-Gm-Message-State: AGi0PuaC08hAaYTlQsPw5nQGG9jGFiH8kZ9m+ka3iwqa7n5QYyUNcJl2
        2lyqlyN8uApzF4qgggEh9tg=
X-Google-Smtp-Source: APiQypIPB1bbJklN59kHvj5qlJg3noEv4nMSZHgeHryxRmpg/p07Nw2z3hh3PH9/ZPhEZ1IY8zonfg==
X-Received: by 2002:a63:545:: with SMTP id 66mr12295494pgf.66.1586836581462;
        Mon, 13 Apr 2020 20:56:21 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:14af:1801:111a:3d47? ([2601:647:4000:d7:14af:1801:111a:3d47])
        by smtp.gmail.com with ESMTPSA id h6sm7852519pje.37.2020.04.13.20.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 20:56:20 -0700 (PDT)
Subject: Re: [PATCH] qla2xxx: Increase the size of struct qla_fcp_prio_cfg to
 FCP_PRIO_CFG_SIZE
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
References: <20200405231339.29612-1-bvanassche@acm.org>
 <20200413153049.GA8042@SPB-NB-133.local>
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
Message-ID: <6672ed7a-e6d5-b7f4-0ed1-b74e43542ba2@acm.org>
Date:   Mon, 13 Apr 2020 20:56:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200413153049.GA8042@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-13 08:30, Roman Bolshakov wrote:
> On Sun, Apr 05, 2020 at 04:13:39PM -0700, Bart Van Assche wrote:
>> This patch fixes the following Coverity complaint without changing any
>> functionality:
>>
>> CID 337793 (#1 of 1): Wrong size argument (SIZEOF_MISMATCH)
>> suspicious_sizeof: Passing argument ha->fcp_prio_cfg of type
>> struct qla_fcp_prio_cfg * and argument 32768UL to function memset is
>> suspicious because a multiple of sizeof (struct qla_fcp_prio_cfg) /*48*/
>> is expected.
>>
>> memset(ha->fcp_prio_cfg, 0, FCP_PRIO_CFG_SIZE);
>>
>> ---
>>  drivers/scsi/qla2xxx/qla_fw.h | 3 ++-
>>  drivers/scsi/qla2xxx/qla_os.c | 1 +
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
>> index f9bad5bd7198..647e67c6ba5e 100644
>> --- a/drivers/scsi/qla2xxx/qla_fw.h
>> +++ b/drivers/scsi/qla2xxx/qla_fw.h
>> @@ -2217,8 +2217,9 @@ struct qla_fcp_prio_cfg {
>>  #define FCP_PRIO_ATTR_PERSIST   0x2
>>  	uint8_t  reserved;      /* Reserved for future use          */
>>  #define FCP_PRIO_CFG_HDR_SIZE   0x10
>> -	struct qla_fcp_prio_entry entry[1];     /* fcp priority entries  */
>> +	struct qla_fcp_prio_entry entry[1023]; /* fcp priority entries  */
>>  #define FCP_PRIO_CFG_ENTRY_SIZE 0x20
>> +	uint8_t  reserved2[16];
>>  };
>>  
>>  #define FCP_PRIO_CFG_SIZE       (32*1024) /* fcp prio data per port*/
> 
> Hi Bart,
> 
> A new constant may be introduced to define size of qla_fcp_prio_entry.
> That would let to drop the magic 32 number here and allow to add one
> more BUILD_BUG_ON for sizeof(struct qla_fcp_prio_entry).

Hi Roman,

The constant FCP_PRIO_CFG_ENTRY_SIZE is only used once, namely in the
following code:

	len = ha->fcp_prio_cfg->num_entries * FCP_PRIO_CFG_ENTRY_SIZE;

How about removing the definition of FCP_PRIO_CFG_ENTRY_SIZE and
changing FCP_PRIO_CFG_ENTRY_SIZE in the above calculation into
sizeof(struct qla_fcp_prio_entry)?

Thanks,

Bart.

