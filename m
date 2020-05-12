Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4AFC2D0F7
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 15:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B49DF206DD
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 15:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbgELPzx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 11:55:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32921 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgELPzx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2020 11:55:53 -0400
Received: by mail-pg1-f193.google.com with SMTP id a4so6346989pgc.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2020 08:55:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=c3AMi9O8i0koAOCaFR7+ZuizpJ/BszYesVv3aSshufI=;
        b=TIXjcUd8rvOGziQeysn0ln3urLO5QEBg7Wj3UhCsC5+IXJyfpGXqjYJhdgU5IO6xHn
         RkVEvIrqW10qNdNzZ3wcZz3eRl4e5ZnqJVaNQcvwANkyftu9WDWB6BKL4NbAk2W9YZCu
         0MTYkGZmu7f474VBMuPB/t8F3oEIlWRbGSIRZXklHznl5nM6xF3IVm+Q4SOXYeKpPAHA
         br+LyKwZmNhp/6+7GEC3sfWO6IumDXSKbhMyDlYaFQk2vhiPR8CNfJCtIoHCQocQe5I7
         AzEndkRElvIcuGPOfY+iowt/k8y448f30p4WAviDSM7Rf6qQWC9dkVr5iUrzGkFB2qJd
         I9gg==
X-Gm-Message-State: AGi0PubOxW3gXSgXwiOZJMm0E2cp8YQR3+aLhntd2+4d/427RIcxsUor
        2EUszbVzwuVcEXyQaco2/K0=
X-Google-Smtp-Source: APiQypKJYr+syJhGP4/mC5j8jPHamlvq4PbzU9GmEnMjqRKZ98JKyrq2eTMfZA2pGEHtcSnecXPYrw==
X-Received: by 2002:a63:c308:: with SMTP id c8mr14338954pgd.398.1589298952198;
        Tue, 12 May 2020 08:55:52 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f45b:a40:89f7:8812? ([2601:647:4000:d7:f45b:a40:89f7:8812])
        by smtp.gmail.com with ESMTPSA id j23sm13011098pjz.13.2020.05.12.08.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 08:55:51 -0700 (PDT)
Subject: Re: [PATCH v5 10/15] qla2xxx: Fix the code that reads from mailbox
 registers
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200511200946.7675-1-bvanassche@acm.org>
 <20200511200946.7675-11-bvanassche@acm.org>
 <3def1366-2e63-173e-2664-44229b6f79ec@suse.de>
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
Message-ID: <a4c7cd79-d816-737e-2005-9f936d45150f@acm.org>
Date:   Tue, 12 May 2020 08:55:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <3def1366-2e63-173e-2664-44229b6f79ec@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-11 23:17, Hannes Reinecke wrote:
> On 5/11/20 10:09 PM, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
>> index 182bd68c79ac..4d8039fc02e7 100644
>> --- a/drivers/scsi/qla2xxx/qla_iocb.c
>> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
>> @@ -2268,7 +2268,7 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
>>               IS_QLA28XX(ha))
>>               cnt = RD_REG_DWORD(&reg->isp25mq.req_q_out);
>>           else if (IS_P3P_TYPE(ha))
>> -            cnt = RD_REG_DWORD(&reg->isp82.req_q_out);
>> +            cnt = RD_REG_DWORD(reg->isp82.req_q_out);
>>           else if (IS_FWI2_CAPABLE(ha))
>>               cnt = RD_REG_DWORD(&reg->isp24.req_q_out);
>>           else if (IS_QLAFX00(ha))
> 
> WTF?
> Is 'isp82.req_q_out' a pointer, but the others are not?
> This really looks dodgy...

Hi Hannes,

This is what I found in the qla2xxx source code:

/* Request queue data structure */
struct req_que {
	[ ... ]
	uint32_t __iomem *req_q_in;	/* FWI2-capable only. */
	uint32_t __iomem *req_q_out;
	[ ... ]
};

$ git grep -nHEw 'req_q_(out|in) = '
drivers/scsi/qla2xxx/qla_mid.c:770:	req->req_q_in = &reg->isp25mq.req_q_in;
drivers/scsi/qla2xxx/qla_mid.c:771:	req->req_q_out = &reg->isp25mq.req_q_out;
drivers/scsi/qla2xxx/qla_os.c:3217:	req->req_q_in = &ha->iobase->isp24.req_q_in;
drivers/scsi/qla2xxx/qla_os.c:3218:	req->req_q_out = &ha->iobase->isp24.req_q_out;
drivers/scsi/qla2xxx/qla_os.c:3223:		req->req_q_in = &ha->mqiobase->isp25mq.req_q_in;
drivers/scsi/qla2xxx/qla_os.c:3224:		req->req_q_out = &ha->mqiobase->isp25mq.req_q_out;
drivers/scsi/qla2xxx/qla_os.c:3230:		req->req_q_in = &ha->iobase->ispfx00.req_q_in;
drivers/scsi/qla2xxx/qla_os.c:3231:		req->req_q_out = &ha->iobase->ispfx00.req_q_out;
drivers/scsi/qla2xxx/qla_os.c:3237:		req->req_q_out = &ha->iobase->isp82.req_q_out[0];

Bart.
