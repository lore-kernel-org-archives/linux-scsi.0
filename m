Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E74C432C0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 02:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4A16206DC
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 02:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfLCChA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 21:37:00 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:33903 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfLCChA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 21:37:00 -0500
Received: by mail-pj1-f65.google.com with SMTP id t21so841587pjq.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Dec 2019 18:36:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+2FlEDTILozPJjxn5b8IV9h9F+kHoEKXnmIrvHaSCwg=;
        b=IOfz/Dmwl0/8f/Lttvkor8pbb4BMrE6bWa/9F/YRlugvwfCRE8vBCV9krqusqxeR29
         cVCoLX5YUU0Lt7lUhdQfm/CaC+coTv2dr//2e1fGfF3tuucK5UOYhxGiKbaxgolwdTib
         355OV2CZVrZZbi6oWYYtjsVW+mA/5i1RptfXWrWAGS+kZMNZfI/tmIEIU3SOCtrb0Nal
         uJl7P9moYNVx+cuE0JRhiI+UEsRvF4S5Xv8AR9NXnWelsbrIEbOVJCq1SM03tJB9ejNZ
         XqZHV0mqUTbjeWlNn0D63+TM99G8tPfw7aucQ/BtuDfnv5sB2IlO2mOrTJ8sDR7wiJS0
         m68w==
X-Gm-Message-State: APjAAAUrrmxizNSTzJvfAORVUYcqRkTjYWbGItrBPiBpmwd0j3blobFn
        52rOnc6zWU1lYO6B6W75mbg=
X-Google-Smtp-Source: APXvYqyGd7BxfcHW9RAV/9HvADAlH2gdCycojPg6IwbxN8AYB2/25xBGK/Ou7uTX6QQBhZNgRzMT+g==
X-Received: by 2002:a17:902:9309:: with SMTP id bc9mr2567988plb.273.1575340619094;
        Mon, 02 Dec 2019 18:36:59 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id s15sm674628pjp.3.2019.12.02.18.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 18:36:58 -0800 (PST)
Subject: Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
References: <20191109042135.12125-1-bvanassche@acm.org>
 <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
 <af903206-ce02-ef50-567f-d647efe0476a@acm.org>
 <20191202205554.5p77fyot6bc2ij6t@SPB-NB-133.local>
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
Message-ID: <10e0c0c1-f3ad-7233-995d-59f1b748e39f@acm.org>
Date:   Mon, 2 Dec 2019 18:34:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191202205554.5p77fyot6bc2ij6t@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-02 12:55, Roman Bolshakov wrote:
> On Mon, Dec 02, 2019 at 08:40:17AM -0800, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
>> index b25f87ff8cde..e2e91b3f2e65 100644
>> --- a/drivers/scsi/qla2xxx/qla_iocb.c
>> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
>> @@ -2656,10 +2656,16 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
>>  	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
>>  	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
>>  	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
>> -	/* For SID the byte order is different than DID */
>> -	els_iocb->s_id[1] = vha->d_id.b.al_pa;
>> -	els_iocb->s_id[2] = vha->d_id.b.area;
>> -	els_iocb->s_id[0] = vha->d_id.b.domain;
>> +	if (IS_QLA23XX(vha->hw) || IS_QLA24XX(vha->hw) || IS_QLA25XX(vha->hw)) {
>> +		els_iocb->s_id[0] = vha->d_id.b.al_pa;
>> +		els_iocb->s_id[1] = vha->d_id.b.area;
>> +		els_iocb->s_id[2] = vha->d_id.b.domain;
>> +	} else {
>> +		/* For SID the byte order is different than DID */
>> +		els_iocb->s_id[1] = vha->d_id.b.al_pa;
>> +		els_iocb->s_id[2] = vha->d_id.b.area;
>> +		els_iocb->s_id[0] = vha->d_id.b.domain;
>> +	}
>>
>>  	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
>>  		els_iocb->control_flags = 0;
> 
> Hi Bart,
> 
> I'm fine as long as it works for old and new HBAs. I don't have docs to
> 2300/2400 series and the HBAs. Are you sure it follows the same S_ID
> order as 2500?
> 
> Regardless of that, it should work for the last 4 series of the HBAs,
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Hi Roman,

Thanks for the review. In my copy of the 25xx firmware manual the s_id[]
field has been marked as RESERVED. I have tried not to write into s_id[]
but that was not sufficient to restore point-to-point mode.

Older versions of the qla2xxx driver did not initialize s_id[]. I think
that commit edd05de19759 ("scsi: qla2xxx: Changes to support N2N
logins") is the commit that introduced initialization of s_id[]. Is that
value passed to the target port? Did that commit perhaps introduce code
that checks the value received by the target?

Bart.
