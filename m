Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE8DC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Feb 2022 20:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347295AbiBBUtT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Feb 2022 15:49:19 -0500
Received: from mail-pj1-f45.google.com ([209.85.216.45]:46991 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiBBUtS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2022 15:49:18 -0500
Received: by mail-pj1-f45.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so723476pjb.5;
        Wed, 02 Feb 2022 12:49:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ySgLiv/89N7mZb1C2sJVu/EoRPqGfXaA+CdN6XIMoeM=;
        b=ysUV3+AQSp7alZyZmbvmwxEzqpDolTUTd3RamaOkY53csWYuK6U53+iaAPG40t9S5w
         XI36ChJ0o2eZXbPeoNKiRBnudcnFwS+Rk/G95ezncA4DY3JhcK+/8fhraeeShsiUhAuO
         8XH5Kcg9LGRo/MgNyFD+1MDghpg07xwqImVXiluKC/ebALoz55RhX1yxJFkkeNcz0SqQ
         eoUaVPhzf27st5I4Y+2gAAJgDd+sOzE6J4fJMwg14OJewYUq3H8OB/yzdnwgA9uep2AV
         gSc4ELn0lB1aNkz3IlJNmOZvmvxEuEhhhJ8eWrUcJtDtrsyeVVfGIGvcigPyf40ParDQ
         jVCg==
X-Gm-Message-State: AOAM531WCxDyo1AmjILqG6DIm2hYmPDbkEwnjMxuszIkxxYD3VlSksCb
        ux0gaTg1Lj6HuXtfeo6/fkc=
X-Google-Smtp-Source: ABdhPJwPgnITJtTST9fAxQEGMJGSaFt6NzzvRocKvr0EBV7POi+dS5F32GWpFQwuHzFWiqF4KZ30hQ==
X-Received: by 2002:a17:90a:eac9:: with SMTP id ev9mr9971160pjb.166.1643834958107;
        Wed, 02 Feb 2022 12:49:18 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id lp17sm7857231pjb.25.2022.02.02.12.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 12:49:17 -0800 (PST)
Message-ID: <c8402f76-7397-77c3-232c-c825c52ea826@acm.org>
Date:   Wed, 2 Feb 2022 12:49:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] scsi: Add scsi_done_direct() for immediate
 completion.
Content-Language: en-US
To:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220201210954.570896-1-sebastian@breakpoint.cc>
 <20220201210954.570896-2-sebastian@breakpoint.cc>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220201210954.570896-2-sebastian@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/1/22 13:09, Sebastian Andrzej Siewior wrote:
> -void scsi_done(struct scsi_cmnd *cmd)
> +static bool scsi_done_need_blk_compl(struct scsi_cmnd *cmd)

I'm not happy about the name of this function. The word "need" in the 
function name suggests that this function does not modify any state. 
However, the body of the function shows that it may complete a SCSI 
command. How about renaming the existing scsi_done() function into 
scsi_done_internal() or so and adding a "bool complete_directly" 
argument to that function?

BTW, I only received patch 1/2 but not patch 2/2. Please Cc the 
linux-scsi mailing list for the entire patch series when reposting the 
patch series.

Thanks,

Bart.
