Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B74DC35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 01:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86AB6207DD
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 01:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgEHA75 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 20:59:57 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43356 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgEHA74 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 20:59:56 -0400
Received: by mail-pf1-f194.google.com with SMTP id v63so25521pfb.10;
        Thu, 07 May 2020 17:59:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=WB6WTJjgZ3Lt500KY4uUkwBVNYsShOidG0IimHCe/II=;
        b=lV/rB+EHlZVDb1IcqsDUzeO4HR7+kOMXX+HR/b3nZaBhlaY6ww7vCI2eM/p4+3Eo4h
         xSo7jqZpkB1IUzNpzOINWeBQjdQxEE0KahPWtoUeq5qwVN6AAsjymOGTnzZH0p/IVK20
         hum7vnqpqOnFQq9b++7Rc6yCFFa4Gi0BXB6CGN7LnZZtZIakqjeEakhuf+0biqEGgyRp
         5slLPMjhfr13N18nL272bvcLVO8loGIe6IDiaVOtQ+rXnh8sNHt7Mw6BQMnTqMbkXTkE
         C+NNF3PU+6Va35uGIKxO0xKjUKAfh4L1TwC3LP3u1pQxogfj31RKPZiODiKvOlKOLsMK
         aFJQ==
X-Gm-Message-State: AGi0PuazBPuK7kyOwUuioGpV8fiNypXPZjLNWPByl64hs0Z33k78BMmq
        m4flY+zzCz1lgMP+HxG/RCw=
X-Google-Smtp-Source: APiQypJQ1fMSrWsMJmYIC6pDl9HTNDYZkvAtxL3K43w/qUsc9YsbU8dN7P13X+YWImUhYkt71mWXoA==
X-Received: by 2002:a62:7547:: with SMTP id q68mr71602pfc.55.1588899594341;
        Thu, 07 May 2020 17:59:54 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8ce8:d4c:1f4f:21e0? ([2601:647:4000:d7:8ce8:d4c:1f4f:21e0])
        by smtp.gmail.com with ESMTPSA id w2sm914559pja.53.2020.05.07.17.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 17:59:53 -0700 (PDT)
Subject: Re: [RESENT PATCH RFC v3 1/5] scsi; ufs: add device descriptor for
 Host Performance Booster
To:     huobean@gmail.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org,
        rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
References: <20200504142032.16619-1-beanhuo@micron.com>
 <20200504142032.16619-2-beanhuo@micron.com>
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
Message-ID: <6d06ec34-04d2-93ff-1ff5-dc1317c3d060@acm.org>
Date:   Thu, 7 May 2020 17:59:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504142032.16619-2-beanhuo@micron.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-04 07:20, huobean@gmail.com wrote:
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 698e8d20b4ba..de13d2333f1f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6627,6 +6627,17 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>  		goto out;
>  	}
>  
> +	if (desc_buf[DEVICE_DESC_PARAM_UFS_FEAT] & 0x80) {
> +		hba->dev_info.hpb_control_mode =
> +			desc_buf[DEVICE_DESC_PARAM_HPB_CTRL_MODE];
> +		hba->dev_info.hpb_ver =
> +			(u16) (desc_buf[DEVICE_DESC_PARAM_HPB_VER] << 8) |
> +			desc_buf[DEVICE_DESC_PARAM_HPB_VER + 1];
> +		dev_info(hba->dev, "HPB Version: 0x%2x\n",
> +			 hba->dev_info.hpb_ver);
> +		dev_info(hba->dev, "HPB control mode: %d\n",
> +			 hba->dev_info.hpb_control_mode);
> +	}
>  	/*
>  	 * getting vendor (manufacturerID) and Bank Index in big endian
>  	 * format

Please introduce a symbolic name for the constant 0x80, e.g.
UFS_FEATURE_HPB.

Please use get_unaligned_be16() instead of open-coding it.

Thanks,

Bart.


