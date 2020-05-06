Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB38C4724C
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 15:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6865206DB
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 15:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgEFPmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 11:42:18 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46896 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729148AbgEFPmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2020 11:42:18 -0400
Received: by mail-pg1-f194.google.com with SMTP id q124so933677pgq.13;
        Wed, 06 May 2020 08:42:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=p8vqcBfi44I5OkhEhqufSEM+gjE4sBS2tKiTaMtMmIg=;
        b=l6dtqCaxNPJ3b85Fwb9MsTUMECg8FOZ9nmMFDey2UjSPnXAg3cmSbG+21DxUN8LX/J
         Pzcdt+X4CBtSIcnDBHhxmwowzPO2iRbqOzEdODtp/LO0YUjRlJvw64pX/O1K2ws20AmC
         bJdIrAZlXLOnW7r3pWllTU/Sn1eFCjAgeZSzNO+n/ZDof953JorRXL4Kz7L2hbBDKZRD
         ZEj65/Gy1ZjC8Bk9qL2IbSvtwm9MnXRtzuzC1uS2s0XDsb1ynb9xvy5MfJLWUIs0YyTt
         aSjzje1rrhybcLRrot4pRa8+4GrMQjUwYAOzE6Wi+H2jwWHvS8I+B2ZB87tmeTnN+5F7
         U8Cg==
X-Gm-Message-State: AGi0PuYbYopkUFsuLLjQrjfQlPKiE07jObXf6Nf9SDhqCFEhqn8tawLe
        LIm293VeICmv1ejClpC73xuKXEJ5uqA=
X-Google-Smtp-Source: APiQypIioMtLWPemCQ+EgNryu+/+fz+7elzisVRIO8OFNX+4uBRFu5FRxuWq3TM9Bc8jdLL5n6rjeQ==
X-Received: by 2002:aa7:8d93:: with SMTP id i19mr8940039pfr.112.1588779736000;
        Wed, 06 May 2020 08:42:16 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:901f:c4d7:864c:c3a5? ([2601:647:4000:d7:901f:c4d7:864c:c3a5])
        by smtp.gmail.com with ESMTPSA id gd17sm5157195pjb.21.2020.05.06.08.42.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 08:42:14 -0700 (PDT)
Subject: Re: [PATCH -next] scsi: qla2xxx: Use PTR_ERR_OR_ZERO() to simplify
 code
To:     Samuel Zou <zou_wei@huawei.com>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1588751650-37186-1-git-send-email-zou_wei@huawei.com>
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
Message-ID: <5693adb3-8f5c-efcc-8e63-38a8311c90b9@acm.org>
Date:   Wed, 6 May 2020 08:42:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588751650-37186-1-git-send-email-zou_wei@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-06 00:54, Samuel Zou wrote:
> Fixes coccicheck warning:
> 
> drivers/scsi/qla2xxx/tcm_qla2xxx.c:1488:1-3: WARNING: PTR_ERR_OR_ZERO can be used
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Samuel Zou <zou_wei@huawei.com>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 1f0a185..7c4157e 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1485,10 +1485,8 @@ static int tcm_qla2xxx_check_initiator_node_acl(
>  				       sizeof(struct qla_tgt_cmd),
>  				       TARGET_PROT_ALL, port_name,
>  				       qlat_sess, tcm_qla2xxx_session_cb);
> -	if (IS_ERR(se_sess))
> -		return PTR_ERR(se_sess);
>  
> -	return 0;
> +	return PTR_ERR_OR_ZERO(se_sess);
>  }

Can the Hulk check that verifies where PTR_ERR_OR_ZERO() can be
introduced be deactivated? I think this patch makes the code less
readable instead of making it more readable.

Thanks,

Bart.
