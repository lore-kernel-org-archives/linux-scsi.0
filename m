Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019B5C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 17:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4539206BE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 17:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIJRt0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 13:49:26 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37044 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgIJRr4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 13:47:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id w7so5062839pfi.4
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2020 10:47:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IRXLoBhPQPRqgb3dsHACvMfVMNKJ3G7UyZKI4LPXzms=;
        b=DcEj8voYMtQqdHtsaq2CGVnNTQwQ+oVbYMixgDTNXXwp0qwIO1krXUkAsY3k/wIqb5
         5MmkRTXA9WH4j+IcxRPU0NTHzfIhkD7uUfkCqj0uqJK8By+Dqtk+zHqGXj9/RKSFCFye
         CPrvv3ZCuuXE6BpkXo/bA5qf0I4VR/xBjtfWhHxXp2VqURzTkXzi5My3PufF7jCHvqfh
         ayV0P+FxBRSjah+5JKBgsEW6scaD0qq0pn57y56c0W50bWcbBsXIEd8PswZcnUeu1yNA
         klDLlm4KMlDGYtddM+6pUw8WesWsf2A8ePRm9BGxi8bYaXiC3pGgejEGD6urnVV1A+7b
         elZQ==
X-Gm-Message-State: AOAM531zaQdRissZjpZOZotumJ0j5/MvnPJixJB1WYIKsNnn41CY7GYg
        mHZj/L49PmQinh6NBRoRfBUi2ApdDvU=
X-Google-Smtp-Source: ABdhPJxrern6qhZFGIRy2FlZVmL+YtEyG6MqtqxN7zCrZU5CiUMYpqLKCUOdpV9DgNtUY2DdmTznYA==
X-Received: by 2002:a62:16d3:: with SMTP id 202mr6397486pfw.44.1599760075505;
        Thu, 10 Sep 2020 10:47:55 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:3d05:213d:6161:c3e5? ([2601:647:4000:d7:3d05:213d:6161:c3e5])
        by smtp.gmail.com with ESMTPSA id bx18sm2514392pjb.6.2020.09.10.10.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 10:47:54 -0700 (PDT)
Subject: Re: [PATCH 1/3] scsi: Cleanup scsi_noretry_cmd()
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20200910073952.212130-1-damien.lemoal@wdc.com>
 <20200910073952.212130-2-damien.lemoal@wdc.com>
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
Message-ID: <34de7f72-3b26-951c-8f09-cb67c3583538@acm.org>
Date:   Thu, 10 Sep 2020 10:47:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200910073952.212130-2-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-10 00:39, Damien Le Moal wrote:
> No need for else after return.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/scsi/scsi_error.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 927b1e641842..5f3726abed78 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1755,8 +1755,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
>  	if (scmd->request->cmd_flags & REQ_FAILFAST_DEV ||
>  	    blk_rq_is_passthrough(scmd->request))
>  		return 1;
> -	else
> -		return 0;
> +
> +	return 0;
>  }

Is this patch useful? Is it necessary? Or is it just code churn?

Thanks,

Bart.
