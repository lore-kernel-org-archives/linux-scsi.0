Return-Path: <SRS0=xzXz=2F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC48C43603
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 00:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C571A206C3
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 00:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfLOAMh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Dec 2019 19:12:37 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44807 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfLOAMh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Dec 2019 19:12:37 -0500
Received: by mail-pl1-f195.google.com with SMTP id az3so2834513plb.11
        for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2019 16:12:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=SR5gnJBISfe3EqTXjChlTu9WmCc/AM2UME1gipJTLI4=;
        b=rDl2X3FRrqm3hp/gq+Xn4UnSObwVVCQT7v7rUhNKDp2bJvoawCIkEk5S4Jk6+wWiBt
         8ZIXKWdWuj0C6O26/tTVVyqLnjAUU26IhVgYnwuTLzRHOw7fBXpAQOcFLYSz7kS1f9JB
         z5+s+g31oZBEjyQzSJel6Lv2nsfRrF4p72tjHlMLc/aKiB3owBffIfuDbmAKNpgRDX3F
         eEV1OL5xru5J2YxW4ocLUxj5d10p1DbEv1jUF/ZCxTGsQdmpmRsW/CCfjr7cz+NlrVNA
         fcxqXiOtBIRI2eOl1v0W3c20tsKB/BS82P5wiCZxjSpukqINYcrDAIVJhfuj/oLmURZt
         IeKw==
X-Gm-Message-State: APjAAAVU0uajOx5zrzxaAroT88tSbo6do2lwQcvIaCyRZmqzD0r2+L69
        hTE7ouMVycQAC5xF6axG3sE=
X-Google-Smtp-Source: APXvYqyaPyxguN+mq0gPubovgKTfvnsnzTBbQ5FfBzW8YO7YgdotVl2aa9OKaVmRTDLHd4qKQXmTkg==
X-Received: by 2002:a17:902:ac97:: with SMTP id h23mr8100751plr.237.1576368756208;
        Sat, 14 Dec 2019 16:12:36 -0800 (PST)
Received: from ?IPv6:2601:647:4000:110a:ccaa:fdec:8bf4:a5a? ([2601:647:4000:110a:ccaa:fdec:8bf4:a5a])
        by smtp.gmail.com with ESMTPSA id n2sm7014709pgn.71.2019.12.14.16.12.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2019 16:12:35 -0800 (PST)
Subject: Re: [PATCH 4/4] qla2xxx: Micro-optimize
 qla2x00_configure_local_loop()
To:     Martin Wilck <mwilck@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Cc:     linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-5-bvanassche@acm.org>
 <5ff7962a50719d79a3262bcb290bc93b3a8e3058.camel@suse.de>
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
Message-ID: <ee7fe321-956f-fe75-6a69-5cb1a0673046@acm.org>
Date:   Sat, 14 Dec 2019 16:12:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5ff7962a50719d79a3262bcb290bc93b3a8e3058.camel@suse.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-10 02:46, Martin Wilck wrote:
> On Mon, 2019-12-09 at 10:02 -0800, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
>> index 6c28f38f8021..ddd8bf7997a8 100644
>> --- a/drivers/scsi/qla2xxx/qla_init.c
>> +++ b/drivers/scsi/qla2xxx/qla_init.c
>> @@ -5047,13 +5047,12 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>>  			rval = qla24xx_get_port_login_templ(vha,
>>  			    ha->init_cb_dma, (void *)ha->init_cb, sz);
>>  			if (rval == QLA_SUCCESS) {
>> +				__be32 *q = &ha->plogi_els_payld.data[0];
>> +
>>  				bp = (uint32_t *)ha->init_cb;
>> -				for (i = 0; i < sz/4 ; i++, bp++)
>> -					*bp = cpu_to_be32(*bp);
>> +				for (i = 0; i < sz/4 ; i++, bp++, q++)
>> +					*q = cpu_to_be32(*bp);
>>  
>> -				memcpy(&ha->plogi_els_payld.data,
>> -				    (void *)ha->init_cb,
>> -				    sizeof(ha->plogi_els_payld.data));
>>  				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
>>  			} else {
>>  				ql_dbg(ql_dbg_init, vha, 0x00d1,
> 
> A side effect of this patch would be that after return from
> qla2x00_configure_local_loop(), the byte ordering in ha->init_cb
> remains in CPU byte ordering, whereas before your patch, it would have
> been converted to be32. I'm uncertain if that would matter later on.
> 
> The following is not a problems with your patch, but what's really
> weird is that in qla24xx_get_port_login_templ() (which is only called
> from here), the buffer is converted from le32 to CPU endianness, and
> then here, in a second step, from CPU to be32. I'm wondering which byte
> order this buffer is supposed to have, and whether that's different
> depending on which mode the controller is operating in (the be32
> conversion seems to be applied in N2N mode only). Moreover, looking at
> the definition of init_cb_t in qla_def.h, this data structure actually
> has mixed endianness, making me doubt that changing the endianness of
> the whole buffer makes sense at all. Or is ha->init_cb simply being
> abused in this part of the code?
> 
> I guess only Himanshu or Quinn can tell.

Hi Martin,

I will rework this patch such that this function again changes the
ha->init_cb buffer into big endian byte order.

Bart.
