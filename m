Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D8E1C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 19:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E9BF2070A
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 19:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgEOT2o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 15:28:44 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37578 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgEOT2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 15:28:43 -0400
Received: by mail-pj1-f65.google.com with SMTP id q9so1414263pjm.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2020 12:28:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nZImNymGoYEuV34AxMub5tbECUkkjxtOy1Xv1S4hHgk=;
        b=R5hWv8erdhc6bjCXyxBsb3tiiJ/JxTzqRXusmEz+vMpsj1/YShm9hENz/gZD/XGPqm
         cSfXUBL2walAJokOBM6fPjDX2tYTB0yVIH4h1YTHlBZ7RxqJ+0EL5IymtlbOAr5q5fVb
         yU4fB04Pwci+Vc25IrDIpjSumxaMkLNRKz50k2kmSx9KeAPtRmUQCKeZRlEPYZ7PUcss
         C/tSt9yMydQZ+0HANCSLZiuBxykkCCJBoFz1cp4wdMmPqW4PG4Wg9Z86YWNPQbwr4aXn
         XJUQutQv48/X43FQm8byE87SiBErzLk072+QUg2dEwL8QGO/4iH7S78zorQcTmEPLGPi
         unOA==
X-Gm-Message-State: AOAM533HT1MBpbQK8eAEa9rVjcupXE/MJp5RwUJJmp5YIV1cQQv18Ebw
        BoXq+N353Tti1z0dq2uhso1NRrBl
X-Google-Smtp-Source: ABdhPJx63B9aR2blL2MVt2apDb/1DmWG5IwXJZfEZoI9WUJcuqqd48zEfMKlpojViM3FI2aNfrIuZQ==
X-Received: by 2002:a17:902:70c2:: with SMTP id l2mr5088540plt.112.1589570921543;
        Fri, 15 May 2020 12:28:41 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f99a:ee92:9332:42a? ([2601:647:4000:d7:f99a:ee92:9332:42a])
        by smtp.gmail.com with ESMTPSA id gv24sm2109345pjb.6.2020.05.15.12.28.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 12:28:40 -0700 (PDT)
Subject: Re: [PATCH RFC] ufs: Make ufshcd_wait_for_register() sleep instead of
 busy-waiting
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
References: <20200507222750.19113-1-bvanassche@acm.org>
 <198a1467-09db-f846-e153-a9681ff15b71@codeaurora.org>
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
Message-ID: <16bb7e00-abbd-060c-c775-ae49a024d7de@acm.org>
Date:   Fri, 15 May 2020 12:28:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <198a1467-09db-f846-e153-a9681ff15b71@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-08 09:27, Asutosh Das (asd) wrote:
> On 5/7/2020 3:27 PM, Bart Van Assche wrote:
>> The ufshcd_wait_for_register() function either sleeps or spins until the
>> specified register has reached the desired value. Busy-waiting is not
>> only considered a bad practice but also has a bad impact on energy
>> consumption. Always sleep instead of spinning by making sure that all
>> ufshcd_wait_for_register() calls happen from a context where it is
>> allowed to sleep. The only function call that has to be moved is the
>> ufshcd_hba_stop() call in ufshcd_host_reset_and_restore().
>>
>> Cc: Can Guo <cang@codeaurora.org>
>> Cc: Avri Altman <avri.altman@wdc.com>
>> Cc: Bean Huo <beanhuo@micron.com>
>> Cc: Alim Akhtar <alim.akhtar@samsung.com>
>> Cc: Asutosh Das <asutoshd@codeaurora.org>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

Thanks for the review Asutosh. Does anyone else want to review and/or test this patch?

Thanks,

Bart.
