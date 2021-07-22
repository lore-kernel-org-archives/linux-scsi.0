Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFD2C63797
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 17:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C4B761407
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 17:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhGVRHF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:07:05 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:56288 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhGVRHE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 13:07:04 -0400
Received: by mail-pj1-f46.google.com with SMTP id gx2so7243930pjb.5;
        Thu, 22 Jul 2021 10:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gm3vqrONHaDFkaV3hytqPZ4vUbr3DdRObV/M6zgfeK8=;
        b=hHhCu3ue6HJH1E+MwOE9JVe91pDfqx9vva3chGRMvcOn7gBqXTe0TVpxFgJwHX5lX7
         O+ftpWSs+GHeqzV4m1Mv03fsp3LbsNJCe+ae4WSTPptHY9w/YD15OJGLOMkXrROd3yC1
         h6iw7QnMPGfvI4BV7HkcB2hiAW28ykRd7cFwJLbWzuLQPXB58/2xWHUpq9oTnVxnIMgt
         RESJcSbj1+K9URYia1MzSrD2i1GU7VekyvpgxHQKIqS86o5pOx0wmv8DMdnTwJSBANFv
         q7L19ED/+WsUZ8pU/dK0/iA8CbzTJO5Ufcvs5D5GFU/i18AqFOL6xtWEpwkAosE2yEjB
         TDnA==
X-Gm-Message-State: AOAM532tRLuJj71ob/TNBJ14pLpcS603xHhI4Pj6larAaubAEHGmdRMe
        GsV//ZURtjKH9rZboup5t7WdzIoBJA5w+0lrTkQ=
X-Google-Smtp-Source: ABdhPJx+ZErZhpMhBPLA+ITcKaUZdyoZczOqOtQBrJnw6CHTXzkyWoomB2PamVkZ1/xMbSULulikRw==
X-Received: by 2002:a17:90a:a105:: with SMTP id s5mr830044pjp.9.1626976058146;
        Thu, 22 Jul 2021 10:47:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:6539:4b6a:66a5:486f])
        by smtp.gmail.com with ESMTPSA id c24sm36760269pgj.11.2021.07.22.10.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:47:37 -0700 (PDT)
Subject: Re: [PATCH 17/24] scsi_ioctl: simplify SCSI passthrough permission
 checking
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210712054816.4147559-1-hch@lst.de>
 <20210712054816.4147559-18-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9f9683ff-10d8-26a2-95de-5084b477e6c0@acm.org>
Date:   Thu, 22 Jul 2021 10:47:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712054816.4147559-18-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/11/21 10:48 PM, Christoph Hellwig wrote:
> +bool scsi_cmd_allowed(unsigned char *cmd, fmode_t mode)
>   {

The first time I encountered this function it was not clear to me what 
the purpose of this function is. I think this is a good time to add a 
comment above this function that explains its purpose, namely to prevent 
that unprivileged SG I/O users can modify storage device firmware.

Thanks,

Bart.
