Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDAFC433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 02:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 183F5207BB
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 02:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgEPCCY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 22:02:24 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46560 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgEPCCY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 22:02:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id b12so1633187plz.13;
        Fri, 15 May 2020 19:02:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=K1jBxoTJP+YdUrDFZ8IbGwG/Jq+eNynlSQ5I6FZVKB0=;
        b=cW6xWYOg8jNjaczCliIR2TyXGP9zY7AtpH0RuZomdzQSf996LQbkQVctpNCLQJhQjB
         6ioqwjDIcTjwH9vDe9YL+kZihbUsWmj6N/EU42CSKOAjm814QE1ZmpE3Icudno7Zv1Tp
         ySa/j4IDmKJJwBGlfvq0ugUccvTl5HVF5Hwh/bWXcfflnBp0N5CAEeeD7hOSfyYOPFT/
         eAiLxR0AtOgJMyR5r3otOGWa4OwWdYex9f4hk8zSHCHvyqPOSxGNNCD1KgG/WycScmqI
         TyYQkBKQH3F06rH87j3HntFdGaU+b0Bva617cquaMfQL+MSCH6dxOXpV9C3WD8D6njMC
         XjzA==
X-Gm-Message-State: AOAM531YMS1JfbSqpq5E+8MaS+2Xrmy8rxo8kRgAcFDJMYGfJ58oM5Kx
        gUVKNbSKmDkSyEqyTukemvs=
X-Google-Smtp-Source: ABdhPJwQ0/OX281bWOGzd10Lv1NSoG2Xkp4caALn42swqoreE/4dsZjmFw75U5kMwPziLSdUx6krcA==
X-Received: by 2002:a17:90a:17a6:: with SMTP id q35mr6319764pja.96.1589594542969;
        Fri, 15 May 2020 19:02:22 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f99a:ee92:9332:42a? ([2601:647:4000:d7:f99a:ee92:9332:42a])
        by smtp.gmail.com with ESMTPSA id v189sm2872596pfv.176.2020.05.15.19.02.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 19:02:21 -0700 (PDT)
Subject: Re: [RFC PATCH 05/13] scsi: ufs: ufshpb: Disable HPB if no
 HPB-enabled luns
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <1589538614-24048-6-git-send-email-avri.altman@wdc.com>
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
Message-ID: <abb03999-353a-77b3-b938-e4991f0ff920@acm.org>
Date:   Fri, 15 May 2020 19:02:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589538614-24048-6-git-send-email-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-15 03:30, Avri Altman wrote:
> @@ -368,6 +390,8 @@ int ufshpb_probe(struct ufs_hba *hba)
>  	if (ret)
>  		goto out;
>  
> +	INIT_DELAYED_WORK(&hba->hpb_disable_work, ufshpb_disable_work);
> +	schedule_delayed_work(&hba->hpb_disable_work, 60 * HZ);
>  out:
>  	kfree(dev_desc);
>  	if (ret) {

Calling INIT_DELAYED_WORK() just before schedule_delayed_work() is a bad
practice. If cancel_delayed_work() gets called before
INIT_DELAYED_WORK() then it will encounter something that it not
expects. If cancel_delayed_work() and INIT_DELAYED_WORK() get called
concurrently than that will trigger a race condition. It is better to
call INIT_DELAYED_WORK() from the context that allocates the data
structure in which the work structure is embedded.

Thanks,

Bart.


