Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646C2C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 01:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 488FF207BB
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 01:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgEPBqS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 21:46:18 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37719 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgEPBqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 21:46:17 -0400
Received: by mail-pg1-f196.google.com with SMTP id f23so1849791pgj.4;
        Fri, 15 May 2020 18:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ozaQPfbwUuNVUGa/T9+ig8Jwi6csJDZ7UY/cyZqf/Zk=;
        b=ZoRZEvRuqExrNalOGEy/C7u7/CWDs8/fKqudD2SiEQK0uQoeQJUenSkF2upp+dyJXY
         vSAAj/s2xpIyXmNj0di0RX2wkiQNCfKpd4g+8BcRNRMIxHXNtQifvvNwQqfv2dVZSwbV
         jTnsjOQc6OaeU5YkzM5FqkpL8WWgs4cm7jt9qIocqriDWTG4X7tARTJ4WGSVOIHQVtcg
         ClQV/JViDKhGat5ykR40isz40xKtefI6tpoTxcOPbmvjTtwX5u37gyIhpYhEC9JPJE++
         PeXnoU84Xo3ekB2EAdN04EkOUaGH+Dt3AOfrYIGrrVwYqG/GG/RUXFNR278UXXoX0rdO
         /wkA==
X-Gm-Message-State: AOAM5323OntGFKhjoufxusA1ydsh+v1cT7FZqC2nJOg7T6CSguBVpW0u
        iX2rH9JTRJCP44k0qL8jdm0=
X-Google-Smtp-Source: ABdhPJxjiqpibobSqV5W7xM1pKavxEjCXdRAST5Y1tkkF8km7GRnO8/rMGGyVxOtjJ3WrDqt0Xy0bA==
X-Received: by 2002:a65:6703:: with SMTP id u3mr5635547pgf.179.1589593575577;
        Fri, 15 May 2020 18:46:15 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f99a:ee92:9332:42a? ([2601:647:4000:d7:f99a:ee92:9332:42a])
        by smtp.gmail.com with ESMTPSA id r21sm2431204pjo.2.2020.05.15.18.46.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 18:46:14 -0700 (PDT)
Subject: Re: [RFC PATCH 02/13] scsi: ufshpb: Init part I - Read HPB config
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
 <1589538614-24048-3-git-send-email-avri.altman@wdc.com>
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
Message-ID: <6aaf9bd5-44f5-f523-5aaf-23e3fe784055@acm.org>
Date:   Fri, 15 May 2020 18:46:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589538614-24048-3-git-send-email-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-15 03:30, Avri Altman wrote:
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 426073a..bffe699 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -50,6 +50,7 @@
>  #include "ufs_bsg.h"
>  #include <asm/unaligned.h>
>  #include <linux/blkdev.h>
> +#include "ufshpb.h"
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/ufs.h>
> @@ -7341,6 +7342,9 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>  		hba->clk_scaling.is_allowed = true;
>  	}
>  
> +	if (ufshcd_is_hpb_supported(hba))
> +		ufshpb_probe(hba);
> +
>  	ufs_bsg_probe(hba);
>  	scsi_scan_host(hba->host);
>  	pm_runtime_put_sync(hba->dev);

This looks weird to me because of the following reasons:
- If there are direct calls from the ufshcd module into the ufshpb
  module and if there are direct calls from the ufshpb module into the
  ufshcd module, why has ufshpb been implemented as a kernel module? Or
  in other words, will it ever be possible to load the ufshcd module
  without loading the ufshpb module?
- Patch 3/13 makes ufshpb a device handler. There are no direct calls
  from any upstream SCSI LLD to any upstream device handler. However,
  this patch adds a direct call from the ufshcd module to the ufshpb
  module which is a device handler.

Bart.
