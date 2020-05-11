Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42AFC54E8E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 16:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B717A20708
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 16:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbgEKQEn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 12:04:43 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35091 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbgEKQEn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 12:04:43 -0400
Received: by mail-pl1-f193.google.com with SMTP id u15so172774plm.2
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 09:04:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=T5xcAXIZptqfVtHOOwZBGueAYoYGNzHOM7YnKp5BD9A=;
        b=nq3CO7nlHmj2xmPVp4nsiUmebwFAfLYTQSQu2Skij+N6J6HeuO7GkO9kt+6KH7FA2K
         JBkqkxvmgWPM5GNqobFP/EJhMgxSxpM8+gM/obmSb/l1nnrI8mC8NDBkt3Mgt9uASOct
         TtVUk6btKIGdRONtPii7jYnAuBvOMyKAqz8gR/zu8pbXC/vTKEvg+BT30FLRiuRQFmwm
         4XJWNgah4G5LSrbkWWytm74FYThqjwh18A6TgKqnxu9qtyXdlfjV5nf38ItfGpP/gGoy
         UnCBrC0ByX5Vbkop2yQRbZpqFgIABfeYSEpEej2s5HIdA1yzDlINforUAlE9RLjHGETs
         tnQg==
X-Gm-Message-State: AGi0PuZYTqo5KRcctz02f7IGPTDowWCIIsyWV6yho9c4VI4jbbmV3YGn
        77ZEP3DW2sNRzIc/SMw+ucc=
X-Google-Smtp-Source: APiQypJY84AxQKOM3ufnVPYDCSYk0Y4plgr91ddZZMOzYnA2Z0ljhHw1oCf+hkM1v8JlQpVyL/W8/g==
X-Received: by 2002:a17:902:9a06:: with SMTP id v6mr16101511plp.343.1589213081917;
        Mon, 11 May 2020 09:04:41 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:c4e5:b27b:830d:5d6e? ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id x4sm9593816pff.67.2020.05.11.09.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 09:04:41 -0700 (PDT)
Subject: Re: [PATCH v4 06/11] qla2xxx: Increase the size of struct
 qla_fcp_prio_cfg to FCP_PRIO_CFG_SIZE
To:     Arun Easi <aeasi@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-7-bvanassche@acm.org>
 <alpine.LRH.2.21.9999.2005110035150.23618@irv1user01.caveonetworks.com>
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
Message-ID: <88a29e9b-409f-695f-a793-7968f4565314@acm.org>
Date:   Mon, 11 May 2020 09:04:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.9999.2005110035150.23618@irv1user01.caveonetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-11 00:36, Arun Easi wrote:
> On Sun, 26 Apr 2020, 8:03pm, Bart Van Assche wrote:
> 
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
>> Cc: Nilesh Javali <njavali@marvell.com>
>> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
>> Cc: Quinn Tran <qutran@marvell.com>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Daniel Wagner <dwagner@suse.de>
>> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>  drivers/scsi/qla2xxx/qla_fw.h | 3 ++-
>>  drivers/scsi/qla2xxx/qla_os.c | 1 +
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
>> index b364a497e33d..4fa34374f34f 100644
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
>> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
>> index 2dd9c2a39cd5..30c2750c5745 100644
>> --- a/drivers/scsi/qla2xxx/qla_os.c
>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>> @@ -7877,6 +7877,7 @@ qla2x00_module_init(void)
>>  	BUILD_BUG_ON(sizeof(struct qla82xx_uri_data_desc) != 28);
>>  	BUILD_BUG_ON(sizeof(struct qla82xx_uri_table_desc) != 32);
>>  	BUILD_BUG_ON(sizeof(struct qla83xx_fw_dump) != 51196);
>> +	BUILD_BUG_ON(sizeof(struct qla_fcp_prio_cfg) != FCP_PRIO_CFG_SIZE);
>>  	BUILD_BUG_ON(sizeof(struct qla_fdt_layout) != 128);
>>  	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
>>  	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
>>
> 
> The changes themselves look ok, but..
> 
> Could the warning be avoided by memset of FCP_PRIO_CFG_HDR_SIZE
> before first read_optrom(), and another memset of
> "FCP_PRIO_CFG_SIZE - FCP_PRIO_CFG_HDR_SIZE" before second
> read_optrom() call?
> 
> The reason I ask is that, the kind of "1" element array
> declaration in a struct is a common way of mapping a header
> followed by N records of some nature. It is a bit sad if we are
> moving away from that style and hard computing the structure by hand.

Coverity would definitely complain about calling memset() to clear
multiple array elements while the array declaration only specifies a
single element.

BTW, the style that is currently preferred in the Linux kernel for
declaring flexible arrays is to use [] instead of [1]. See e.g. the
following commit:

commit 1a91a36aba9c232c73e4a5fce038147f5d29e566
Author: Gustavo A. R. Silva <gustavo@embeddedor.com>
Date:   Wed Feb 26 16:31:25 2020 -0600

  mmc: Replace zero-length array with flexible-array member

  The current codebase makes use of the zero-length array language
  extension to the C90 standard, but the preferred mechanism to declare
  variable-length types such as these ones is a flexible array
  member[1][2], introduced in C99:

    struct foo {
            int stuff;
            struct boo array[];
    };

  By making use of the mechanism above, we will get a compiler warning
  in case the flexible array does not occur last in the structure, which
  will help us prevent some kind of undefined behavior bugs from being
  inadvertently introduced[3] to the codebase from now on.

  Also, notice that, dynamic memory allocations won't be affected by
  this change:

  "Flexible array members have incomplete type, and so the sizeof
  operator may not be applied. As a quirk of the original implementation
  of zero-length arrays, sizeof evaluates to zero."[1]

  This issue was found with the help of Coccinelle.

  [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
  [2] https://github.com/KSPP/linux/issues/21
  [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

  Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
  Acked-by: Adrian Hunter <adrian.hunter@intel.com>
  Link: https://lore.kernel.org/r/20200226223125.GA20630@embeddedor
  Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

[ ... ]

Bart.
