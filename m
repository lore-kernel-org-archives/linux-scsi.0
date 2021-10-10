Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEBBC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Oct 2021 03:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75D5160F57
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Oct 2021 03:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhJJDyP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 23:54:15 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:42985 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhJJDyO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2021 23:54:14 -0400
Received: by mail-pl1-f176.google.com with SMTP id l6so8818449plh.9
        for <linux-scsi@vger.kernel.org>; Sat, 09 Oct 2021 20:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=X45UpzojP88khyasRhOPEt9alEdUka5qxt8IKIhsbL0=;
        b=yWxJTsUpNDdJ6RQsKBdJeY/+E+k6P1/ft6vPdTaqsR0qdQr/28WDmUTflnRAABXS0N
         s2ABJRn8hVG/9EoBURKuLfkdEhyR3jH6um6yI+8PFgIvK/GhoI+Ngnh83fj1/dakhMKD
         c3uie8zzJ1QxNNz8WR4utUTjzONB5DH+OLN4pxtkcmvvUnn4ccESDg/wiE/UQasMfW5S
         scYBLJcwXlQCv6xXY3OIGfoUvWpGnYXs10uvteuB4hOFUDbA9glycq7QU5hL+R4viAFL
         pLjVtfRzbsQvb2FmnDnPVTHIwaRjToUnE+MOcuIBynKLSaG/M9ZnrT+laaD1R4VhNXde
         tDIQ==
X-Gm-Message-State: AOAM533PMiynCS68TkEpbi7N48y25/vtBppzoEogU1UC9QZuudiGZKgn
        b7n+J5Tnb/fj6vzJJVPZM4h+ez+S1zk=
X-Google-Smtp-Source: ABdhPJwqIIlW9qlAXwfE6WdkqxrhlcDb405xxf+cLFz1pag3EoQOrpwcsACQujAqdsrXBNEArwkBwA==
X-Received: by 2002:a17:90b:3809:: with SMTP id mq9mr21827829pjb.7.1633837936702;
        Sat, 09 Oct 2021 20:52:16 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:2e9:472e:972e:e872? ([2601:647:4000:d7:2e9:472e:972e:e872])
        by smtp.gmail.com with ESMTPSA id pj12sm2314587pjb.19.2021.10.09.20.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 20:52:15 -0700 (PDT)
Message-ID: <52ee4617-93ba-919f-b990-f04f64a13d4b@acm.org>
Date:   Sat, 9 Oct 2021 20:52:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Content-Language: en-US
To:     Yanling Song <songyl@ramaxel.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20210930034752.248781-1-songyl@ramaxel.com>
 <526271c5-a745-7666-6b18-9eb61898f1db@acm.org>
 <20211009133207.789ad116@songyl>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211009133207.789ad116@songyl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/9/21 06:32, Yanling Song wrote:
> op_is_write() does not meet our requirement: Both read and write
> commands have to be checked, not just write command.

Right, I should have proposed to compare the operation type with 
REQ_OP_READ / REQ_OP_WRITE. However, that approach only works for SCSI 
commands that come from the block layer and not for SG_IO 
(REQ_OP_DRV_IN/OUT).

>> Please remove all of the above code and use blk_rq_pos(),
>> blk_rq_sectors() and rq->cmd_flags & REQ_FUA instead.
> 
> I did not quite get your point. The above is commonly used in many
> similar use cases. For example: megasas_build_ldio() in
> megaraid_sas_base.c.
> What's the benefit to switch to another way: use
> blk_rq_pos(),blk_rq_sectors()?

I expect that using blk_rq_pos() and blk_rq_sectors() will result in 
faster code. However, these functions only work for SCSI commands that 
come from the block layer and not for SG_IO. If you want a common code 
path for SG_IO and block layer requests, please take a look at how 
get_unaligned_be*() is used in drivers/scsi/scsi_trace.c.

Thanks,

Bart.
