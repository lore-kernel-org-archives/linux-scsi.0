Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC47FC33C9E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 04:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DE12206D7
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 04:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbgAQEAO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 23:00:14 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36387 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgAQEAN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 23:00:13 -0500
Received: by mail-pg1-f193.google.com with SMTP id k3so11000187pgc.3;
        Thu, 16 Jan 2020 20:00:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=j/gmt+S+U5biY49eR+qUY302EUGG1032iY8t1Ue0P1s=;
        b=SjDjmIptcOzs3J32TQ2+idVc5baQvUVKjWwx/vINIdyY+ETBRl9/yyElOuiPGzwMME
         JLJ9QG0vQu0+4tgUAoBmlu+JZXKyB0taGZJuf2HWcjNUH8JAnvK1true3bwuRZsHBym7
         OM3fxA9YleS0FoSQJdq6RCnUKTtlkEtns884vsZZ1lOeZQI5vGakkKjIo2Trv3av0oTg
         qUiOicfmquxA1z7ITO27HYChrBppf6+BtisMKK0jFoYjX5cXs+cMDs6kPb3M3C2TH5XG
         oKe1dRks/dVN9Kpz2wRTYXwKCpQjT8UwGXkKosHKum6b1ixm630tpYuuBTDncKiZ5tCg
         09uw==
X-Gm-Message-State: APjAAAVcFnnf8P6sld5eezfeJ2S15vR45ItdQwFOawDAznuO3Sf34z9e
        nogBdJlzeKpGr0S2LrQqASLV4a6Wl50=
X-Google-Smtp-Source: APXvYqzojzQMzN/4c4rIhB+N1ix9vQkiluNoIBRoleUyxoTu7MgidTGKioWDjBx1jvV8QJgO04VrqA==
X-Received: by 2002:a63:ce4b:: with SMTP id r11mr44165950pgi.419.1579233612897;
        Thu, 16 Jan 2020 20:00:12 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:8dfb:7edd:e01b:b201? ([2601:647:4000:d7:8dfb:7edd:e01b:b201])
        by smtp.gmail.com with ESMTPSA id u26sm26061663pfn.46.2020.01.16.20.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 20:00:12 -0800 (PST)
Subject: Re: [PATCH v2 6/9] scsi: ufs: Delete is_init_prefetch from struct
 ufs_hba
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200116215914.16015-1-huobean@gmail.com>
 <20200116215914.16015-7-huobean@gmail.com>
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
Message-ID: <125ff67c-bcd5-69e7-2ec8-203b805c246b@acm.org>
Date:   Thu, 16 Jan 2020 20:00:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200116215914.16015-7-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-16 13:59, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Without variable is_init_prefetch, the current logic can guarantee
> ufshcd_init_icc_levels() will execute only once, delete it now.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 5 +----
>  drivers/scsi/ufs/ufshcd.h | 2 --
>  2 files changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 44b7c0a44b8d..31b6e2a7c166 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6967,8 +6967,7 @@ static int ufs_lu_add(struct ufs_hba *hba)
>  {
>  	int ret;
>  
> -	if (!hba->is_init_prefetch)
> -		ufshcd_init_icc_levels(hba);
> +	ufshcd_init_icc_levels(hba);
>  
>  	/* Add required well known logical units to scsi mid layer */
>  	ret = ufshcd_scsi_add_wlus(hba);
> @@ -6994,8 +6993,6 @@ static int ufs_lu_add(struct ufs_hba *hba)
>  	scsi_scan_host(hba->host);
>  	pm_runtime_put_sync(hba->dev);
>  
> -	if (!hba->is_init_prefetch)
> -		hba->is_init_prefetch = true;
>  out:
>  	return ret;
>  }

The current code calls ufshcd_init_icc_levels() once per HBA. This patch
changes that into one call per LUN. It seems like the patch description
contradicts the code I see above.

Thanks,

Bart.
