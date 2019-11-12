Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E058DC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 02:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB6442084F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 02:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfKLCsW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 21:48:22 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41044 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfKLCsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 21:48:22 -0500
Received: by mail-pg1-f193.google.com with SMTP id h4so10815532pgv.8
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 18:48:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xyWl+dNLYg02rcSQSloGtEo3sUSex1SFzzzw99Va370=;
        b=G9G0oFsvD6eLhhS0fwfO23hNY5a9x9PChbrg0MBTDkpxNzp527kLXNOexPtwbW7m/x
         pLk1cNgCo15zshG6jWrIeGIYic5L2CsM1b/g7wrcUBO+STvIBsVp4hQOgPT7Z6gRhkMa
         JxL3ryfh23P1yT+95MnQrkHnV76fTHQgSGuDuxfc/bJs7IAA0vvp9VxG4HEGpWzql2x/
         9TdaQmYwkggRtwaIGUuik3gKos8xZQkLiBetwSiw7Rc19d2ea9Rtr02gaiduigOfFtNr
         TKI0DGf6H7qXU9GUxkNQcwmxocbakZbko0n/K+4A7UcLZTlZ4UwwWIGj9Bs3jH60qXeH
         tgLw==
X-Gm-Message-State: APjAAAUxXs1iK+CB6eavAMRoytz47y1211cS1h3yOPYVLI0/sRhPeXvr
        0UmKoiVg0oH9lJLCcZPD8wBobVe4
X-Google-Smtp-Source: APXvYqzUOPssWqyq+rNxgS6filcOGThDz6EzK+KARgO2GTSRNkg+5dm7M8lD2ouYTyjx8j8dQGl17A==
X-Received: by 2002:a63:25c7:: with SMTP id l190mr32879879pgl.429.1573526901034;
        Mon, 11 Nov 2019 18:48:21 -0800 (PST)
Received: from ?IPv6:2601:647:4000:a8:97:b734:6b8f:663c? ([2601:647:4000:a8:97:b734:6b8f:663c])
        by smtp.gmail.com with ESMTPSA id c12sm19011256pfp.67.2019.11.11.18.48.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 18:48:19 -0800 (PST)
Subject: Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
References: <20191109042135.12125-1-bvanassche@acm.org>
 <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
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
Message-ID: <32187dd9-f222-fbed-cc93-1c6abca6e06c@acm.org>
Date:   Mon, 11 Nov 2019 18:48:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-11 03:28, Roman Bolshakov wrote:
> On Fri, Nov 08, 2019 at 08:21:35PM -0800, Bart Van Assche wrote:
>> The commit mentioned in the subject breaks point-to-point mode for at least
>> the QLE2562 HBA. Restore point-to-point support by reverting that commit.
>>
>> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
>> Cc: Quinn Tran <qutran@marvell.com>
>> Cc: Himanshu Madhani <hmadhani@marvell.com>
>> Fixes: 0aabb6b699f7 ("scsi: qla2xxx: Fix Nport ID display value") > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>  drivers/scsi/qla2xxx/qla_iocb.c | 7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
>> index b25f87ff8cde..cfd686fab1b1 100644
>> --- a/drivers/scsi/qla2xxx/qla_iocb.c
>> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
>> @@ -2656,10 +2656,9 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
>>  	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
>>  	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
>>  	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
>> -	/* For SID the byte order is different than DID */
>> -	els_iocb->s_id[1] = vha->d_id.b.al_pa;
>> -	els_iocb->s_id[2] = vha->d_id.b.area;
>> -	els_iocb->s_id[0] = vha->d_id.b.domain;
>> +	els_iocb->s_id[0] = vha->d_id.b.al_pa;
>> +	els_iocb->s_id[1] = vha->d_id.b.area;
>> +	els_iocb->s_id[2] = vha->d_id.b.domain;
>>  
>>  	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
>>  		els_iocb->control_flags = 0;
> 
> The original commit definitely fixes P2P mode for QLE2700, the lowest
> byte is domain, followed by AL_PA, followed by area. However the
> fields are reserved in ELS IOCB for QLE2500, according to FW spec.
> 
> Perhaps we should have a switch here for 2500 and the other one for
> 2600/2700? Or, we should only set the fields only for QLE2700, to comply
> with both specs.

Himanshu, can you tell us which adapters and/or firmware versions need
which version of the above code?

Thank you,

Bart.
