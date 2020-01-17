Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D973DC33CB3
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A749B20842
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgAQDxV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 22:53:21 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38771 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbgAQDxV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 22:53:21 -0500
Received: by mail-pj1-f67.google.com with SMTP id l35so2665130pje.3;
        Thu, 16 Jan 2020 19:53:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=k4uCumWD7WfnmJ2v+54Fb302dBBWVzUezBk2U9Nm/Vw=;
        b=Zi5lZQMJ/2L0NJxrbALN3C7fDSIY1ezHOwZt9GI1tpz9qKToxeXuX6h4c4YwtZkyVo
         BBMdhjLpKDBoKBcMzb53NdX2hE7OPLUVXMnP/qmbSq7SHQZSxtUwcZupNqtTolv1YQIX
         mRPumgRQNO1c98rFvefrMMP6REUS8a9yLAyB9FFIvkjG1i+mFQo+frRZeQWctYHvPJ4b
         Kb2a6Br+SSAIG/7yOX126ahGU/+zYsFwmCyRyLhW4ZqRqiTyZi9XdW4zsSMaV6xIO3hk
         C3EJniNniVe9+h+7t/Z/zDcG57jt/JeoOEW/XnQC5SfCWggtjshOIz7kSehKztu1m6ie
         e1pA==
X-Gm-Message-State: APjAAAWvxiXZj41ZixpXiPi5A7rEanmpqaBzReOod7b4gbA9YOtzEnF3
        VViJnS3mSo81nRZKNVCAetJyJ2IRdZs=
X-Google-Smtp-Source: APXvYqzGQ615Av9V/KwICVHz/p/xbNoboDtOhRXUrEe0OZrSNkqdW04KRRkjRnJIzTvUg5vo0SK0MQ==
X-Received: by 2002:a17:90a:1697:: with SMTP id o23mr3332590pja.62.1579233200212;
        Thu, 16 Jan 2020 19:53:20 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:8dfb:7edd:e01b:b201? ([2601:647:4000:d7:8dfb:7edd:e01b:b201])
        by smtp.gmail.com with ESMTPSA id f30sm25431529pga.20.2020.01.16.19.53.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 19:53:19 -0800 (PST)
Subject: Re: [PATCH v2 2/9] scsi: ufs: Delete struct ufs_dev_desc
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200116215914.16015-1-huobean@gmail.com>
 <20200116215914.16015-3-huobean@gmail.com>
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
Message-ID: <afc473b1-6857-4cca-101d-2382f5314f0d@acm.org>
Date:   Thu, 16 Jan 2020 19:53:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200116215914.16015-3-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-16 13:59, Bean Huo wrote:
>  struct ufs_dev_fix {
> -	struct ufs_dev_desc card;
> +	u16 wmanufacturerid;
> +	u8 *model;
>  	unsigned int quirk;
>  };
>  
> -#define END_FIX { { 0 }, 0 }
> +#define END_FIX { 0 }

A minor comment: please use { } instead of { 0 }.

>  /* add specific device quirk */
>  #define UFS_FIX(_vendor, _model, _quirk) { \
> -	.card.wmanufacturerid = (_vendor),\
> -	.card.model = (_model),		   \
> +	.wmanufacturerid = (_vendor),\
> +	.model = (_model),		   \
>  	.quirk = (_quirk),		   \
>  }

Is this macro useful? Does it improve readability of the code? If not,
how about removing it (maybe later)?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
