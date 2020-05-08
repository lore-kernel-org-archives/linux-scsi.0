Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7ECC47247
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 01:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C89EE207DD
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 01:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgEHBCi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 21:02:38 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41798 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgEHBCi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 21:02:38 -0400
Received: by mail-pl1-f194.google.com with SMTP id u10so2822430pls.8;
        Thu, 07 May 2020 18:02:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QfiPaS5tEiLl/kQo57rb3xlvnudHi9Euse23Tg6CV1Q=;
        b=tZZdyyFzkijFOlSD1bMvwHJqlZdHt9rUWs/QLtyAwaC4ww0WAM05P1LXcpb15S0P/s
         tYQPtpY2MGDpUbn32XOts+C83zq0YwUD0kEtg6IaDl7Fe6VznkL+PoQooZ9MP0UxNMoq
         KlaZ2rBvPQlpnRLwiXZM3rMN7PtQkyx9bXHKVaFSPCjLfhpIoo2hjZFyGqadaPkq1ARm
         vr+haT1u3xhp1dMwYfRmoN0wyAHzrYj8XOdxxDnMIVZqyFcXhSZPJAs78rBeWP88in7m
         fOM8WAcr4soRf1Y7BHVbX2r9x1FzU1xxgEpLj3OseVW3JjxtWr2OqZZxyDCHiCxFeuYC
         GChw==
X-Gm-Message-State: AGi0PuZbNQZ25hKFdbopWX3W2foFCBPYiED1IV+nGjrf4yGZV0XP36lg
        Ydi2Eowu8C0MHRLxJYdLZ2g=
X-Google-Smtp-Source: APiQypLTbjWZgM3Hgs05j/+2LLRCNLJN7nSA7lSV4gIwuRDuGmIz83STSP8j88VT8l86H3ETsB/1Kg==
X-Received: by 2002:a17:90a:3450:: with SMTP id o74mr3248459pjb.159.1588899757487;
        Thu, 07 May 2020 18:02:37 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8ce8:d4c:1f4f:21e0? ([2601:647:4000:d7:8ce8:d4c:1f4f:21e0])
        by smtp.gmail.com with ESMTPSA id g10sm292pfk.103.2020.05.07.18.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 18:02:36 -0700 (PDT)
Subject: Re: [RESENT PATCH RFC v3 3/5] scsi: ufs: add ufs_features parameter
 in structure ufs_dev_info
To:     huobean@gmail.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org,
        rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
References: <20200504142032.16619-1-beanhuo@micron.com>
 <20200504142032.16619-4-beanhuo@micron.com>
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
Message-ID: <f3485a4d-dadd-423a-e186-7736c3bfe5f1@acm.org>
Date:   Thu, 7 May 2020 18:02:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504142032.16619-4-beanhuo@micron.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-04 07:20, huobean@gmail.com wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Make a copy of bUFSFeaturesSupport, name it ufs_features, add it
> to structure ufs_dev_info.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs.h    | 2 ++
>  drivers/scsi/ufs/ufshcd.c | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 53a5e263f7c8..1f2d4b4950b8 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -543,6 +543,8 @@ struct ufs_dev_info {
>  	u16 hpb_ver;
>  	/* bHPBControl */
>  	u8 hpb_control_mode;
> +	/* bUFSFeaturesSupport */
> +	u8 ufs_features;
>  };
>  
>  /**
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 83ed2879d930..1fe7ffc1a75a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6625,6 +6625,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>  		goto out;
>  	}
>  
> +	dev_info->ufs_features = desc_buf[DEVICE_DESC_PARAM_UFS_FEAT];
> +
>  	if (desc_buf[DEVICE_DESC_PARAM_UFS_FEAT] & 0x80) {
>  		hba->dev_info.hpb_control_mode =
>  			desc_buf[DEVICE_DESC_PARAM_HPB_CTRL_MODE];

Since this patch touches the same code as patch 1/5, please merge
patches 1/5 and 3/5 into a single patch.

Thanks,

Bart.


