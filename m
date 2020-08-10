Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465E0C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 23:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AFA9206C3
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 23:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgHJXWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 19:22:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45001 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbgHJXWI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 19:22:08 -0400
Received: by mail-pl1-f194.google.com with SMTP id x15so1150823plr.11;
        Mon, 10 Aug 2020 16:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PvDZ3uG5mmpgE4z3jSnn80rUANwYIPbz+dNGCCdVe9w=;
        b=lRSM9AYfx0aOvP6Y/SjDCNMcRq0qhvikSoomlrLCBZbIaeI10ygpWoicCBsu3oOzPi
         WV+FGkw0Dy7+MAtJyItCVdfnc3ymCLrX66t6oRqkYNhSnbjQJE6636G91WCDDqYLl+j4
         oseQe1OuChhsLcoxtubm9jPPZmwcmfd2bYkxzOiJhF4kxddv6c1biXhn3AKpnGzZpVnI
         8dFrX5kFHaGoZcVygBsaEB8cpBGqsQ86Si2UaUdnkRjYEbHVbCoVNWz/4iaoilewtwBt
         BXBWar+s9aRXOZ1DcZLRDZHsXauzab5Gd38muygdtBIzUTTaPVzM0u15nuujQhppvOja
         OSgw==
X-Gm-Message-State: AOAM530s472x/l1fEaBTaFEhKvAr5cwB3lm1AA6Py7xcFTjiToTAJ4Ko
        2n4n0gyVP7T3vZ0nXeqhx3+wYYJO
X-Google-Smtp-Source: ABdhPJx5E0gJo0PCq0RzWibTbggEvNUKAQSRWkAQgTxVBgrx7N2CJ0j/MVZIT2dzgcbKfgELgrRnrw==
X-Received: by 2002:a17:902:4b:: with SMTP id 69mr26983473pla.18.1597101727744;
        Mon, 10 Aug 2020 16:22:07 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id h15sm589063pjf.54.2020.08.10.16.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 16:22:06 -0700 (PDT)
Subject: Re: [PATCH] scsi_debugfs: dump allocted field in more convenient
 format
To:     Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, jejb@linux.ibm.com
References: <20200809095501.23166-1-dmtrmonakhov@yandex-team.ru>
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
Message-ID: <fb7fa6c3-40e4-ba17-f16a-307fa1a1b68a@acm.org>
Date:   Mon, 10 Aug 2020 16:22:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200809095501.23166-1-dmtrmonakhov@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-09 02:55, Dmitry Monakhov wrote:
> All request's data fields are formatted as key=val, the only exception is
> allocated field, which complicates parsing.
> 
> With that patch request looks like follows:
> 0000000012a51451 {.op=WRITE, .cmd_flags=SYNC|IDLE, .rq_flags=STARTED|DONTPREP|ELVPRIV|IO_STAT, .state=in_flight, .tag=137, .internal_tag=188, .cmd=opcode=0x2a 2a 00 00 00 45 18 00 00 08 00, .retries=0, .result = 0x0, .flags=TAGGED|INITIALIZED|3, .timeout=30.000, .alloc_age=0.004}
> 
> Signed-off-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
> ---
>  drivers/scsi/scsi_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
> index c19ea7a..6ce22b1 100644
> --- a/drivers/scsi/scsi_debugfs.c
> +++ b/drivers/scsi/scsi_debugfs.c
> @@ -45,7 +45,7 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
>  		   cmd->retries, cmd->result);
>  	scsi_flags_show(m, cmd->flags, scsi_cmd_flags,
>  			ARRAY_SIZE(scsi_cmd_flags));
> -	seq_printf(m, ", .timeout=%d.%03d, allocated %d.%03d s ago",
> +	seq_printf(m, ", .timeout=%d.%03d, .alloc_age=%d.%03d",
>  		   timeout_ms / 1000, timeout_ms % 1000,
>  		   alloc_ms / 1000, alloc_ms % 1000);
>  }

Hi Dmitry,

These messages are intended for humans and are not intended for processing
by any kind of software. I think the current message is easier to understand
by a human than the new message introduced by the above patch.

Thanks,

Bart.


