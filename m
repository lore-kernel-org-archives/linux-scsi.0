Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936CEC6FD19
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 18:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCPSlh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 14:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCPSl1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 14:41:27 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6956BBD4C8;
        Thu, 16 Mar 2023 11:41:26 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id y2so2564690pjg.3;
        Thu, 16 Mar 2023 11:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678992086;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aAO8ipnGlaW7Dsdpbu2ZfEHDL1dEpEJ1pzRe9Xj45k0=;
        b=ln0XI09uQYWjrapTiNHLCbUGmeDNZ5cs7gnwYyDufiUfXiYP1OOXpbnRlw09f5G+gG
         Z2AV9WEQYshpp2i9TGXPdatlCbuJtwM/oE2uBFsNswByIKG1qDVHsQtaUqWDqBqGmBMK
         3q6JiBoOGbAROLAt1Qr8tX1+mTluchJwWfL7BV5KsT6E+pb6GWmmW6Jlr69SVLsuOrZt
         XdaHt6XiLi7BSeIfeZ5ALzNFd9zDNVJlS8EC/WMAKh/JJMy1eIvKmb15/RKZ+1+jR3+W
         x7LYriC5rgYCwTolv1+9DWc526LlR8pVHnRWrsKKE0vGQ5x9u3Wz/dwVUJDPBmpNEOmE
         7dmQ==
X-Gm-Message-State: AO0yUKUbpmeWpeQ69Lp5dIPxE/UBeQNgR9u5J+7ddxaqjM+DG5jHjfLT
        rxBzx84S8we8WeDOEHSP5D4=
X-Google-Smtp-Source: AK7set8CHdRUEDH1kXpv7Ln9kRiMK77wVthfB0Yo62w5ZO6f2T4CZZigqQzLsymhio37ow9nEn+X2Q==
X-Received: by 2002:a05:6a20:65a2:b0:d6:a2f9:ca9a with SMTP id p34-20020a056a2065a200b000d6a2f9ca9amr3901085pzh.42.1678992085744;
        Thu, 16 Mar 2023 11:41:25 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ad26:bef0:6406:d659? ([2620:15c:211:201:ad26:bef0:6406:d659])
        by smtp.gmail.com with ESMTPSA id c25-20020aa78c19000000b00623f72df4e2sm9088pfd.203.2023.03.16.11.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 11:41:24 -0700 (PDT)
Message-ID: <70b757f9-cc0c-ebd9-a597-f6ea14acbedb@acm.org>
Date:   Thu, 16 Mar 2023 11:41:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 02/19] block: introduce ioprio hints
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
 <20230309215516.3800571-3-niklas.cassel@wdc.com>
 <c91be70e-14a9-7ad6-ba7c-975a640a34d3@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c91be70e-14a9-7ad6-ba7c-975a640a34d3@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/15/23 19:00, Damien Le Moal wrote:
> Bart,
> 
> I would like to hear your opinion as well.

Isn't sending a ping after only three days a bit soon for such a large 
patch?

Regarding your question: I like the block/ioprio.c changes in this 
version of this patch series much better than the changes in the 
previous version of this patch series.

No objections from my side about the changes in this patch (02/19).

Thanks,

Bart.

