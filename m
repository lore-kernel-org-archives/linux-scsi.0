Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AAB1C63797
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 18:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7598F60EB2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 18:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhGVSEH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:04:07 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:46066 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhGVSEG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 14:04:06 -0400
Received: by mail-pl1-f178.google.com with SMTP id k1so32089plt.12;
        Thu, 22 Jul 2021 11:44:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FvXZTA6mugHk4R1/Z05yoSgeTtcYooYPzjkabIbtOnI=;
        b=i4amZnP91PLN7LJqITteD8PbLjwhVJ3BTmGgMXhUguHPTtfvuh3wEfXyPZAbmUWteJ
         ZbNPMAyKs+6dWM6cdIw9+MOc7ulG/ptV/mIL/Mgm1P2da7xVHXOEByEe2URWYzoRrbMq
         785hC8deTVPDSRalbvy1m8/xB5jb+6pDDypSfBvzaccm3XMrInVhvL+BiyN8fZ1dQlDb
         FOdgW5xCZ9b5t+iSOOGH6bLco8nI33wQ1Uz2w4DyrXg93xpacFCfzw1Mt5OOQUPC6mz3
         EP2LWGJ0w6Ir5CFMrNa/kAcHJ6F2M5LR6ThVnz2pjfBvzBkZhrUjxS+SVKWRr2U9iNiG
         hgoQ==
X-Gm-Message-State: AOAM533getFOUoNuNHDTCkF+pp0SHIg5hrXmhCuzBL0DEqNp0lRMeUSP
        lc6zRHoamyaZ10/oOxwd3ARtXzkeGYwCS2yHmsQ=
X-Google-Smtp-Source: ABdhPJxcOzpXl23Bj1vM0xld2b/z9D2P5CkYIMpJkrAvOluHH1pql9bEA8eL+/F+WxEoIwjZ+qHXJw==
X-Received: by 2002:a17:90a:e611:: with SMTP id j17mr10179878pjy.48.1626979479252;
        Thu, 22 Jul 2021 11:44:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:6539:4b6a:66a5:486f])
        by smtp.gmail.com with ESMTPSA id g27sm34309804pgl.19.2021.07.22.11.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 11:44:34 -0700 (PDT)
Subject: Re: [PATCH 21/24] scsi: consolidate the START STOP UNIT handling
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210712054816.4147559-1-hch@lst.de>
 <20210712054816.4147559-22-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <75da1d81-4a0f-ae5e-d511-6a036d0d2472@acm.org>
Date:   Thu, 22 Jul 2021 11:44:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712054816.4147559-22-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/11/21 10:48 PM, Christoph Hellwig wrote:
> +	char cdb[MAX_COMMAND_SIZE] = { };

How about using 'u8' instead of 'char'?

Additionally, MAX_COMMAND_SIZE equals 16. According to SBC-4 6 bytes is 
enough for the START STOP UNIT command.

> +	cdb[0] = START_STOP;
> +	cdb[4] = data;

Please combine the above two statements with the cdb[] declaration into 
a single line.

Additionally, please split data into two arguments to make calls of this 
function easier to read. This is what I found in SBC-4:
* bit 1 of byte 4 has the name LOEJ (load eject).
* bit 0 of byte 4 has the name START (start unit).

Thanks,

Bart.
