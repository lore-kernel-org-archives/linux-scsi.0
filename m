Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E6DC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 01:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D5452072F
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 01:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgFKBj0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 21:39:26 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34880 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgFKBj0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 21:39:26 -0400
Received: by mail-pl1-f193.google.com with SMTP id k1so1585663pls.2;
        Wed, 10 Jun 2020 18:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Uzp/cy2ZRT8lQiEe/z+Ee+CLQLGIzNqau5X1CgWABUs=;
        b=c4DJppH2ToJ9tGF2D88Vr0Pwc1BkyB8OHNQb7SqGQ71ek36Il24CeHUFORYm3EP896
         zCGpszYOq62UQwluT5a3mtIQ35/TMMEYKuv1Z/ojghAyoKW7rUh561BPawVL9/uNcxux
         2lBdM7aqQJC7yDsF4mJZjOBBlLvlbb+R3sckz/DiNvD643txXceX34c0azKceX1Jnc7F
         Wrr41kLYcotYakgrmoW1lyTfh+hGG135dfmC4z+01cZ4H4218VpNmynPbmpcW+cLJWrW
         EDNHZ1PUWyQ917AdBh+FNSW/25jWcKC9VqzxkIXyR8PAtea8/bUkRAXNnNot5ftuLJd+
         1ATQ==
X-Gm-Message-State: AOAM530xRMyBhrMY4CJlvtEUYB2PKPz0gA3Dmr+62G8SUU6mdyGKk9uG
        wQX2/IRB1NpMyo+APq+NYag=
X-Google-Smtp-Source: ABdhPJwfWTittCj8Q8nSPBs1x5Lg+YHLnuMdJfZc6bFEeZs2aWVF4PxwZkm9MFflX6vA4JC/7QMcPA==
X-Received: by 2002:a17:90a:6407:: with SMTP id g7mr5742494pjj.9.1591839565528;
        Wed, 10 Jun 2020 18:39:25 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id bv16sm883289pjb.46.2020.06.10.18.39.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 18:39:24 -0700 (PDT)
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
References: <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
 <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
 <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p1>
 <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
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
Message-ID: <ed36e1de-de0a-f7b0-37a2-cbb30c38d48b@acm.org>
Date:   Wed, 10 Jun 2020 18:39:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-04 18:30, Daejun Park wrote:
> This patch is adding UFS feature layer to UFS core driver.
> 
> UFS Driver data structure (struct ufs_hba)
> 	│
> ┌--------------┐
> │ UFS feature  │ <-- HPB module
> │    layer     │ <-- other extended feature module
> └--------------┘
> Each extended UFS-Feature module has a bus of ufs-ext feature type.
> The UFS feature layer manages common APIs used by each extended feature
> module. The APIs are set of UFS Query requests and UFS Vendor commands
> related to each extended feature module.

Personally I'm less than enthusiast that this new feature layer has been
implemented using the driver/bus model. But it seems like nobody else
objects against this model ...

Bart.
