Return-Path: <SRS0=Lz4Y=DB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07546C4363D
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 17:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A89DE2311B
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 17:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgIXRw5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Sep 2020 13:52:57 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37189 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgIXRw5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2020 13:52:57 -0400
Received: by mail-pl1-f196.google.com with SMTP id u4so137507plr.4
        for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2020 10:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EwxFnSmLE/oyWMcMpP1cNTvitSg69ecohaw0AUKx6SY=;
        b=LuZHTW7xmgv9gcIhb/pljt3IYiCQ6aJWMZqxFh4j4LnwRdmIUAslj7Pi2xr+NSvmE8
         0Bg7Kqirur+dkdcae/o/taysRmKP3MfFi3GwMa/KY4hflmKkXdFLmHnG3BkEBnheKKJG
         p72rismqu2aktepVy6WhNwt2n7nh1THpF/69NOUoLrgfyOHYNmL845ht2rOy7fZye2j3
         8ulhujSftP2dKUjYPhHw929G7eiQuSkWGbJUo2dNUUVY1ColdfVXRclQNWMDnyHkmpSY
         FNzLP28OCS3kPrdqAloqFGtAePCUvTysuajlZ5C/Jz9fdQn1KlNKMHErbezSrAfrhPp7
         9FqQ==
X-Gm-Message-State: AOAM530dgMKvoZAGCbrz4E5EZHm2R82p79FrVZ4Btl7ePBDttKYwaqLl
        86gzaC12+OWvAXA7yN0bS2/xApexWMA=
X-Google-Smtp-Source: ABdhPJyYjUK1xaSzAcqu6epnStnht0Ac9BeqauwGGmsM8d3uyJ0nOJ5L4Io5oADAzfjHRvAvdA0iLQ==
X-Received: by 2002:a17:902:c213:b029:d2:564d:8352 with SMTP id 19-20020a170902c213b02900d2564d8352mr339882pll.54.1600969976465;
        Thu, 24 Sep 2020 10:52:56 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:755a:78b:43e0:7557? ([2601:647:4000:d7:755a:78b:43e0:7557])
        by smtp.gmail.com with ESMTPSA id q5sm135094pfn.109.2020.09.24.10.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 10:52:55 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi: sg: use queue_logical_block_size() in
 max_sectors_bytes()
To:     Tom Yan <tom.ty89@gmail.com>, linux-scsi@vger.kernel.org
References: <20200923055248.1901-1-tom.ty89@gmail.com>
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
Message-ID: <ca33b6af-6523-821d-5dc9-28ef6d8e7228@acm.org>
Date:   Thu, 24 Sep 2020 10:52:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200923055248.1901-1-tom.ty89@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-22 22:52, Tom Yan wrote:
> Logical block size was never / is no longer necessarily 512.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> ---
>  drivers/scsi/sg.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 20472aaaf630..8a2cca71017f 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -848,10 +848,11 @@ static int srp_done(Sg_fd *sfp, Sg_request *srp)
>  static int max_sectors_bytes(struct request_queue *q)
>  {
>  	unsigned int max_sectors = queue_max_sectors(q);
> +	max_sectors *= queue_logical_block_size(q);
>  
> -	max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
> +	max_sectors = min_t(unsigned int, max_sectors, INT_MAX);
>  
> -	return max_sectors << 9;
> +	return max_sectors;
>  }

I think the above patch is wrong and also that it breaks code that is
correct. In the Linux kernel, "one sector" is by definition 512 bytes.
See also the definition of the SECTOR_SIZE and SECTOR_SHIFT constants.

Bart.
