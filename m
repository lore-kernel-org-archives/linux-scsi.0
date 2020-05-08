Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13897C47255
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 20:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F100A20CC7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 20:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgEHULm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 16:11:42 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33444 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbgEHULm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 16:11:42 -0400
Received: by mail-pg1-f195.google.com with SMTP id a4so1363403pgc.0;
        Fri, 08 May 2020 13:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=M0td/tVQrd6JWU+Nqfok36GqNdC8dDzRs4sSNx11odc=;
        b=Oe3ZoViFiDif47K1+IE90XRud+/MAWzK4VsqgMOWRZplrifsNVbS5rCCXBcvrNX1eZ
         j9wK9iYH3Ui0pVA/uHfHN09eZ9raTEESFkkIfO+vh2AHF9xicMBOVKZ6DX56Rg3EO17l
         K49DbEu+xTSJNZSBWpOCpunwm8fR8Bpc1V75Z15CRAJRKlxTx12vlxi0aVdZvPnbAT5P
         HbD/sDWNULxsQ0XwpQ8Y5pxRD/37ykwUmjkrrPbEMGZkiNXlKuiTvo1JQEXb6T/BZV0o
         sBqpwoUG092M8KIjsvFgXL/xAHg18F3TLsgXmwvvtnreQ6afupUzu09N/J2ZdiVA3KvW
         Duxw==
X-Gm-Message-State: AGi0PubkqVNQQaAX0C3nur1uoQyWXkBVqYucX4pB63KcF4b+F3+Fmmf1
        ae9i+fWu3WeCpUT+k/w4i2UJ6Vkd4pk=
X-Google-Smtp-Source: APiQypLbS2OlCtnbNFCZ+k3kV86aeI2BepAWtPhcHgidQvpHFrabaIkHVxwrKM4aPYHHzPtLRQfYwg==
X-Received: by 2002:a63:180a:: with SMTP id y10mr3815182pgl.204.1588968701422;
        Fri, 08 May 2020 13:11:41 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:89ed:1db3:8c60:ba90? ([2601:647:4000:d7:89ed:1db3:8c60:ba90])
        by smtp.gmail.com with ESMTPSA id q14sm1973399pgq.60.2020.05.08.13.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 13:11:40 -0700 (PDT)
Subject: Re: [RESENT PATCH RFC v3 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org,
        rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
References: <20200504142032.16619-1-beanhuo@micron.com>
 <20200504142032.16619-6-beanhuo@micron.com>
 <7b3e127f-a25f-e821-6704-2680ea619c6d@acm.org>
 <1edda80d569a53e0af28fbe30a367d84f099f8fe.camel@gmail.com>
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
Message-ID: <ff9de169-be8e-1595-5df0-0d09b1a1ce8e@acm.org>
Date:   Fri, 8 May 2020 13:11:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1edda80d569a53e0af28fbe30a367d84f099f8fe.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-08 07:44, Bean Huo wrote:
> 1: driver module parameter, while system booting, specify maximum HPB
> cache size in kernel boot Parameters:
> 
>    	static int max_hpb_mem = 128;
>    	module_param(max_hpb_mem,int,0444);
> 
> but this paramter is added in the ufshcd.c since the ufshpb.c is not a 
> independent module. looks not very natural.
> [ ... ]
> If you prefer to convert current HPB driver to be a kernel module
> driver, I prefer first apporach.

Hi Bean,

A kernel module parameter sounds good to me.

Thanks,

Bart.
