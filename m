Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5C4C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 02:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D0112465A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 02:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgAWCpq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 21:45:46 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54274 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWCpq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 21:45:46 -0500
Received: by mail-pj1-f66.google.com with SMTP id kx11so483823pjb.4;
        Wed, 22 Jan 2020 18:45:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0bTKL1nEMmiTu3DN8/wNxHjP2cGwCMK4tEMnT3FtOBI=;
        b=s0kMqxltPtbhmFm/nMEveMzjTQTXXwFp9+LnB3QUWDEvFzbWzbZzuR/zujwHd1iGJf
         /f+qJAOwU3neV9/nKKnhKxUJpCboxtrXiMWmo+6V1effVbe7gOj4cXuK1j3LpEgBi+eg
         ik4qeMMPdjeuhmPxXT1zPOKISKKNsEsFwN4PX6tZOVK/iRY5eHm2oauO+drPYv1LcREs
         qiTt7O7/RY1+dtgAL7i8mivf1/q6QglIatTUEIIuUQT/GVMndd2EYAsnZgL2c/PJxiPs
         HK3gSRgwmtgvqxyVzCh5iiWgDkn64uatbAGDoR02NmRHafTut4wF5QiTBYrkerULJdzN
         DOGg==
X-Gm-Message-State: APjAAAV5hg0+zlTExqPqgVzpaNHnPFsQLFb166ydy72IDrVNh1oRPhpp
        z/p+13Uej4r+HS+/9rssJrlI9Pyb
X-Google-Smtp-Source: APXvYqyFjqN4SMdx78XQgp5nv9AZUTULnc9pP0nt+Zco5cy3IfTgnLZJV7ILLKiPHIbGOxLvQAc2vg==
X-Received: by 2002:a17:90a:fa10:: with SMTP id cm16mr1916091pjb.129.1579747545094;
        Wed, 22 Jan 2020 18:45:45 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:d957:4568:237a:bc62? ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id b1sm288408pfp.44.2020.01.22.18.45.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 18:45:44 -0800 (PST)
Subject: Re: [PATCH -next] scsi: qla2xxx: use PTR_ERR_OR_ZERO() to simplify
 code
To:     Chen Zhou <chenzhou10@huawei.com>, hmadhani@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200122101812.94816-1-chenzhou10@huawei.com>
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
Message-ID: <697e27b4-a531-3670-0618-f5dc58a8608b@acm.org>
Date:   Wed, 22 Jan 2020 18:45:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122101812.94816-1-chenzhou10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-22 02:18, Chen Zhou wrote:
> PTR_ERR_OR_ZERO contains if(IS_ERR(...)) + PTR_ERR, just use 
> PTR_ERR_OR_ZERO directly.
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index abe7f79..719d53d 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1462,10 +1462,8 @@ static int tcm_qla2xxx_check_initiator_node_acl(
>  				       sizeof(struct qla_tgt_cmd),
>  				       TARGET_PROT_ALL, port_name,
>  				       qlat_sess, tcm_qla2xxx_session_cb);
> -	if (IS_ERR(se_sess))
> -		return PTR_ERR(se_sess);
>  
> -	return 0;
> +	return PTR_ERR_OR_ZERO(se_sess);
>  }

Is this a useful change? My personal opinion is that the current
implementation (without this patch) is easier to read.

Thanks,

Bart.
