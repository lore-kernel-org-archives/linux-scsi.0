Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93765C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 811B3206F1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732462AbgF2T04 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:26:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41301 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732388AbgF2T0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:26:54 -0400
Received: by mail-pl1-f194.google.com with SMTP id f2so7473405plr.8
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 12:26:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AXtl2nxmEkz7cjQdmD1ArGk35lrhZK2hWx0Qu+var4M=;
        b=JKNjyY73uWFyxWyTj463hA1ue21KaW4AbUtdoHFyQ05EgwxjElJgZonFRExeMA+hiJ
         clS1Dndt1cZoAa+p+m52XQY2dgAH5tepwIBuBjj++lhotV1rlvv+Nl1kxaZSa/5aK3u1
         jxDWGZretGpcm4NcGwhsHvJrtX5IQyEMfXbqeqt17MQ2nErRuNnxCDgXQ+rZzD9z7h67
         fZNj1CuHbKtcnGntVxuHC3VmvnCSxochwEKCNqBAm1aX+T7ku3n2o0H2w+sBiHCDlRsS
         aJdFupgytOvC3v1SKBfVD6ub1qF56VIfqMsH8fJGIg1AEGRyp6g/m/Ix9m1SC3KGug0a
         SF/A==
X-Gm-Message-State: AOAM530fvIAGz/0pPbno7h+nKqspzmynXLA5KLXtirrVUVo/TTMvpmLB
        Oq7W2qddy+Xf9ODyk2/r8U3d1RAl
X-Google-Smtp-Source: ABdhPJyhBYTDemlgmALSAioH6By1uI1sW/m/tJsq6ukupdfwl+eGXMBXMTwdGzdt65AZhuZRCqVKvw==
X-Received: by 2002:a17:90a:cb0e:: with SMTP id z14mr16689129pjt.140.1593458813685;
        Mon, 29 Jun 2020 12:26:53 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id r203sm439229pfr.30.2020.06.29.12.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 12:26:53 -0700 (PDT)
Subject: Re: [PATCH] ch: Do not read past the end of vendor_labels[]
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
References: <20200629161051.14943-1-bvanassche@acm.org>
 <CAK8P3a1H0H82fp_kLDnE4=SihDO4PgB+jDiLjfmUsPfdFYXoCQ@mail.gmail.com>
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
Message-ID: <6504926f-3cca-3fe8-464c-9a1c4d8943d3@acm.org>
Date:   Mon, 29 Jun 2020 12:26:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1H0H82fp_kLDnE4=SihDO4PgB+jDiLjfmUsPfdFYXoCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-29 11:33, Arnd Bergmann wrote:
> On Mon, Jun 29, 2020 at 6:11 PM Bart Van Assche <bvanassche@acm.org> wrote:
>> diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
>> index b81b397366db..b675a01380eb 100644
>> --- a/drivers/scsi/ch.c
>> +++ b/drivers/scsi/ch.c
>> @@ -651,19 +651,23 @@ static long ch_ioctl(struct file *file,
>>                 memset(&vparams,0,sizeof(vparams));
>>                 if (ch->counts[CHET_V1]) {
>>                         vparams.cvp_n1  = ch->counts[CHET_V1];
>> -                       memcpy(vparams.cvp_label1,vendor_labels[0],16);
>> +                       strncpy(vparams.cvp_label1, vendor_labels[0],
>> +                               ARRAY_SIZE(vparams.cvp_label1));
>>                 }
> 
> Against which tree is this? I see in mainline the correct
> 
>       strncpy(vparams.cvp_label1,vendor_labels[0],16);
> 
> rather than the broken memcpy. If this was changed recently to the
> broken version, maybe send a revert, or add a "Fixes" tag?

Hi Arnd,

Thanks for having taken a look. This patch applies to Martin's for-next
branch. The most recent ch patch I found in Linus' master branch is "ch:
remove ch_mutex()" from February 2020. I haven't found any more recent
ch patches in the linux-next/master branch either. Have I perhaps been
looking at the wrong repository or the wrong branch?

Thanks,

Bart.
