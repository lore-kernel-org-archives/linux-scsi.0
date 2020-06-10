Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AA6C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 14:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25B28207C3
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 14:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgFJO6A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 10:58:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42016 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgFJO6A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 10:58:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id e9so1092585pgo.9
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2020 07:57:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=JkZEtJr2Dy0DAFADFxeEWObS6mpbpZzeaBmMebfJvQE=;
        b=dxdmjaMuAWWBSDg8DZokEDqXxva0abVRNKdB7OLiOmYHV2dnITtKoHMC/qA5YH7cHp
         b2RiJ3WoS/MMM84dkgbNe0z+Sn/ad8YPhXD40slFAZO2mDqS43jyDHCuHeuvnrU2FWr4
         ULJn0XZilxkQsFT4AyjKY/Qo8GKf8uHxkzD3OKGh2+bG9467BLCDYc89uBq4MzqoKNLk
         QpOpv0vffZxPlv5ql90UWkkYmY8rm6AHbHDRnYxgxlqp24YGxHdlujbht+KlTdVhqYYj
         qt4BXMHgeIn/3X/1pu1JKgBAa3DRhYSjUyXkI0mdvtvrRbYCBNxIQEe8wF7QFCP6TQh1
         aizg==
X-Gm-Message-State: AOAM533vExZv7zJOQeYwC092IHXmHyY92bV/S/jnugWFdFhxHmp33wd9
        N4BzMrto8N4qEvsjUsfkHNk=
X-Google-Smtp-Source: ABdhPJw0wBxR9z5rnx24VgQf8DOLmpegzpR6tBIE7PPcVQYNVkVLpa7++vOdD1mlrF6MUWqOrd67vg==
X-Received: by 2002:a63:2216:: with SMTP id i22mr825818pgi.31.1591801079358;
        Wed, 10 Jun 2020 07:57:59 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id l2sm168032pga.44.2020.06.10.07.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 07:57:58 -0700 (PDT)
Subject: Re: [PATCH v2] qla2xxx: Fix the ARM build
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>
References: <20200610024215.27997-1-bvanassche@acm.org>
 <20200610112745.qh7ahl7nff2xwzhm@beryllium.lan>
 <20200610121151.GA15652@SPB-NB-133.local>
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
Message-ID: <1cd27f37-1456-04a1-28b3-19ea9b44ef19@acm.org>
Date:   Wed, 10 Jun 2020 07:57:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200610121151.GA15652@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-10 05:11, Roman Bolshakov wrote:
> On Wed, Jun 10, 2020 at 01:27:45PM +0200, Daniel Wagner wrote:
>>> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
>>> index 42dbf90d4651..de9c1604c575 100644
>>> --- a/drivers/scsi/qla2xxx/qla_def.h
>>> +++ b/drivers/scsi/qla2xxx/qla_def.h
>>> @@ -46,7 +46,7 @@ typedef struct {
>>>  	uint8_t al_pa;
>>>  	uint8_t area;
>>>  	uint8_t domain;
>>> -} le_id_t;
>>> +} __packed le_id_t;
>>
>> Now I am totally confused. le_id_t (and why does be_id_t not need it?) are
>> not used inside either of the reported data structure (cmd_entry_t,
>> ms_iocb_entry_t, request_t, struct ctio_crc2_to_fw, struct ctio7_to_24xx,
>> struct ctio_to_2xxx) which the bot reports. I must oversee something.
> 
> I also had the thought that both fields should be packed for sake of
> consistency because there is fcp_hdr with be_id_t sid/did and
> fcp_hdr_le with le_id_t sid/did. You also seem to be correct, about your
> concerns. I overlooked that only ctio_crc2_to_fw and ctio7_to_24xx have
> le_id_t initiator_id field.

It's only now that I noticed that the build failures are reported by
sparse (C=1). So the build failures may indicate a bug in sparse.

Bart.

