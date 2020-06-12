Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B58C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 04:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD07C20836
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 04:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgFLE2i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 00:28:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40545 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgFLE2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 00:28:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id s23so3713707pfh.7;
        Thu, 11 Jun 2020 21:28:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7FHd7ZEofWmIKV3Vjvxv3qh2Z1UvkaKjplL+2txj47M=;
        b=WkaYAghFoDyfthQ27QZVpctLKNZw6ENkEPdDNodUUx4ccvX4gBX1scuAn8rRClYcWb
         srNhjWzFhAAByFSnZm8o+LVX4npJ2iK0GPYl6ogVtHAlfgQCqBcCYjTZMpMADH/7bX+P
         9c+JGeHAKFXWEwC5GUCPlKpnPAXGFP6/Hn20pAXnAcjjDNVIkIlf0YkcM/PDUVo1JIER
         KuwgFn9gtSfhmFzAnzPEcUT8s296THbZNXpxRJ4KX2aHBBF+mNZvWfx4Y9ZG85YqeTzj
         Gdan8Ej8mnj/TGF9DrStNZUa4cJadFiZKMAS/B2jzzOf4JJN9HoSZEECSyJ7FvP6ndf+
         +7YA==
X-Gm-Message-State: AOAM531oCD4KRGvA3TM2R3WF6L8CzIprmFA72TsV3rECZ5aHfk54JOxy
        Y3Hg7cNrYzycPW/R/F7eYXM2WCmc
X-Google-Smtp-Source: ABdhPJwNRN31QbwBE/HjFTZmaD6FLUvogfMml2ZjqNVAfCWe6impYXKcDxVSiAWonUVNVcVnXJ0HNA==
X-Received: by 2002:a62:3785:: with SMTP id e127mr10235922pfa.210.1591936117373;
        Thu, 11 Jun 2020 21:28:37 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i5sm4549593pfd.5.2020.06.11.21.28.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 21:28:36 -0700 (PDT)
Subject: Re: [RFC PATCH 2/5] scsi: ufs: Add UFS-feature layer
To:     daejun7.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <1319810e-a323-c022-5e27-902f88cefe8f@acm.org>
 <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
 <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
 <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
 <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p4>
 <20200612022759epcms2p47929b76eb2e809240f415c19f9383f92@epcms2p4>
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
Message-ID: <cf01e1d2-50e9-7fa8-b2ee-88a900231304@acm.org>
Date:   Thu, 11 Jun 2020 21:28:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200612022759epcms2p47929b76eb2e809240f415c19f9383f92@epcms2p4>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-11 19:27, Daejun Park wrote:
>>> @@ -2525,6 +2525,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>>>  
>>>    ufshcd_comp_scsi_upiu(hba, lrbp);
>>>  
>>> +  ufsf_ops_prep_fn(hba, lrbp);
>>> +
>>>    err = ufshcd_map_sg(hba, lrbp);
>>>    if (err) {
>>>      lrbp->cmd = NULL;
> 
>> What happens if a SCSI command is retried and hence ufsf_ops_prep_fn()
>> is called multiple times for the same SCSI command?
>
> Developers of UFS features should implement it so that prep_fn does not have
> any problems even if it processes the same SCSI command multiple times.
> In HPB feature, prep_fn modifies only upiu  structure. So it is ok to call
> it multiple times because the upiu is rebuilt from ufshcd_comp_scsi_upiu().

Please make sure that this expectation is documented somewhere.

Thanks,

Bart.
