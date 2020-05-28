Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9D2C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 14:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA1920888
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 14:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403826AbgE1O4U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 10:56:20 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38164 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403836AbgE1O4S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 10:56:18 -0400
Received: by mail-pg1-f194.google.com with SMTP id u5so13594117pgn.5;
        Thu, 28 May 2020 07:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=H+E2Cht00Nd0DyuFWKpXcfzkYTJQqhpE9g+HMMzT2t4=;
        b=AukvJJi+JSoc+LXI2gQFvoLutNSDStYEYeQ329NKyksukuA0J89bfVy6OzxnDyJalL
         xupgiBpxYsb9JwQNg324uYuJ8p4El1er6hriWQX/ufya5h2kV4ioQJ56DOWeDBSk0eWD
         1iaRRpqj0VFkQOe2/DC45VCDBwzwQXkeglMP+oRspYroH3OVAH/ltEEbFZ1CRyDgXKyD
         sZjL0uFEaemxxfPE3ZzZoceTmXRfeHBI6eKhjztpDalF2V1oQvRbwHqSJ9qMqUAo3Snh
         a9V31hKTVmigRU46ZWt0JypulMNfw5NIAcmPWTbgWcSlPDf1xU8e9Un33gyf/aTjiNwl
         JDcQ==
X-Gm-Message-State: AOAM533kCoJim2wOKUPzDBkQnisck14QWHJZEf9+YmNh3aX2JtL9VOgQ
        L6thFIABZPeCcYYbOICE712fka3M85s=
X-Google-Smtp-Source: ABdhPJwzgmR9uvuJLqZGMMf741Tm5oZbzLL+Pv0IXaQ/pTgWbCG4spiyqc1p2fcO179r87QrtZNa0Q==
X-Received: by 2002:a62:d41a:: with SMTP id a26mr3425951pfh.290.1590677776672;
        Thu, 28 May 2020 07:56:16 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:40e6:aa88:9c03:e0b4? ([2601:647:4000:d7:40e6:aa88:9c03:e0b4])
        by smtp.gmail.com with ESMTPSA id u45sm5816165pjb.7.2020.05.28.07.56.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 07:56:15 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] scsi: ufs: remove max_t in ufs_get_device_desc
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200528115616.9949-1-huobean@gmail.com>
 <20200528115616.9949-2-huobean@gmail.com>
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
Message-ID: <85bbc91f-7b91-46fc-acff-3bcc2288c4ae@acm.org>
Date:   Thu, 28 May 2020 07:56:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528115616.9949-2-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-28 04:56, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> For the UFS device, the maximum descriptor size is 255, max_t called in
> ufs_get_device_desc() is useless.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index aca50ed39844..0f8c7e05df29 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6881,8 +6881,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>  	u8 *desc_buf;
>  	struct ufs_dev_info *dev_info = &hba->dev_info;
>  
> -	buff_len = max_t(size_t, hba->desc_size.dev_desc,
> -			 QUERY_DESC_MAX_SIZE + 1);
> +	buff_len = QUERY_DESC_MAX_SIZE + 1;
>  	desc_buf = kmalloc(buff_len, GFP_KERNEL);
>  	if (!desc_buf) {
>  		err = -ENOMEM;

Since the buff_len variable is not changed after its initial assignment,
please remove it entirely.

Thanks,

Bart.


