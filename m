Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25F3C4363D
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 02:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62EB22087D
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 02:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgJACwU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 22:52:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37847 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJACwU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2020 22:52:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id e18so2802416pgd.4
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2020 19:52:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LHkV585ufBqt86BSJcpAVk3Z2UHR6MbpfaK5XaFxfFo=;
        b=I5ucgU7mvyHJIadwClfFfPvnbv2srlRPYgiVpPq3jfcXEGwnA26bnaSdCVajJ63xxq
         qgHRTkrliHoj+ZfLj69aTrUIMuwDYgATxRKZJ7j3yEMls4fSKdVPalBOB2i02xtBe0t9
         u4fG0JWdLaQP74iiIljajDqb98KTU/2WTGoB0pmXeO+VdUD5dQH7mi4jdt+QmW7Jf7yN
         hQdRF8NTaffrUKc03KCrWyw0YGFqrwPFcZsK4akfXlnBNcU/E6047PQXaWIuKcy4Bu+Z
         ufrUgQ0grpsrMvz25WuXc+MpI9QCVw0CqOJOfYKX6vJuQdQFF2nO7ikHAbxNNDL17U1X
         1Aew==
X-Gm-Message-State: AOAM5329KG4X4uJRk8EeVo52uTg+VSZcPcJVo17UOVqJF2Wt17fwZAt0
        yEnrKWdY8dAOz3rP9xalpbCMSimBa5w=
X-Google-Smtp-Source: ABdhPJyidJmiipgkQb6KqBPI1dMXH30xEg7yzY/w9cO1qVfEM/7Ope+eVliaL4XEllKH8aQlOnZkBg==
X-Received: by 2002:a17:902:b203:b029:d2:1ebe:b4e4 with SMTP id t3-20020a170902b203b02900d21ebeb4e4mr671760plr.12.1601520739530;
        Wed, 30 Sep 2020 19:52:19 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:74c0:38d3:8092:91f1? ([2601:647:4000:d7:74c0:38d3:8092:91f1])
        by smtp.gmail.com with ESMTPSA id c3sm4058247pfo.120.2020.09.30.19.52.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 19:52:18 -0700 (PDT)
Subject: Re: [PATCH 1/2] scsi: Add limitless cmd retry support
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <1601398908-28443-1-git-send-email-michael.christie@oracle.com>
 <1601398908-28443-2-git-send-email-michael.christie@oracle.com>
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
Message-ID: <919c092a-ecf9-bf11-3422-9c4443e9918d@acm.org>
Date:   Wed, 30 Sep 2020 19:52:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1601398908-28443-2-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-29 10:01, Mike Christie wrote:
> +static bool scsi_cmd_retry_allowed(struct scsi_cmnd *cmd)
> +{
> +	if (cmd->allowed == SCSI_CMD_RETRIES_NO_LIMIT)
> +		return true;
> +
> +	return (++cmd->retries <= cmd->allowed);
> +}

Did checkpatch complain about the parentheses in the above return statement?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
