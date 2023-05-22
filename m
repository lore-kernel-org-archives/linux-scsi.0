Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CB9C77B73
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 20:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbjEVU7K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 16:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbjEVU6y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 16:58:54 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4221A6;
        Mon, 22 May 2023 13:58:47 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-64d30ab1f89so2770560b3a.3;
        Mon, 22 May 2023 13:58:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684789127; x=1687381127;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2MFmEunz7XB8mdTYQaL515OHE+e6+GxqvAEqkfTAdhU=;
        b=DfZSpgTwLVisa2SDfbgg1MoB4tY2vx8GST7urcIezpD7aoGKX3CqMqi0zsAeriY/yK
         YHBvAXlwgmpoXpx2I5SFsOMQekR4cVvirvkHW6zlY194/w2OOLw1qk/fn6Nosvcvu1xB
         Vaovu/QWjuq/Afm2AB8E5HoA6p/G1hfieqLnVG9En0ORe2F5+O+HAxertvUe98SzB93H
         QtMfV7onOxZsf3J6jvNBNRqH07amztn7jQnqC5QqlJNMUD4a+wYhRivvht4N3cZX0XGw
         KmWWLdxSNW8sKjkSvIwafGEkTy7x2ax37N073AmXXFQpjTJh4waoO8BsKfBlVFaPK1S/
         T0Ag==
X-Gm-Message-State: AC+VfDw9IYHHuGGup4StOlgpFxy/mM4RDRgybCu2+s5+xfMbw6ftZGjF
        UpbF4E2ZTW5qd3eTDrJjjR51SvtHKAY=
X-Google-Smtp-Source: ACHHUZ5J7UC/nrn8zwx6ZpRHATcXDWf3HvvBs6ysazZR7zn9EoKEkGFcd0kHcMVG8Ou8afFGf9vcvQ==
X-Received: by 2002:aa7:888f:0:b0:64d:b0d8:a396 with SMTP id z15-20020aa7888f000000b0064db0d8a396mr4693470pfe.7.1684789126866;
        Mon, 22 May 2023 13:58:46 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:642f:e57f:85fb:3794? ([2620:15c:211:201:642f:e57f:85fb:3794])
        by smtp.gmail.com with ESMTPSA id q24-20020a62e118000000b005d22639b577sm3281185pfh.165.2023.05.22.13.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 13:58:46 -0700 (PDT)
Message-ID: <077b00a6-9587-2e28-3f8a-44871f9428ca@acm.org>
Date:   Mon, 22 May 2023 13:58:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: spinlock recursion in aio_complete()
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-aio@kvack.org, linux-parisc <linux-parisc@vger.kernel.org>
References: <5057d550-c3f4-be34-d3e6-390790051232@gmx.de>
 <89053bf1-6bc3-3778-7662-14d15bd778a3@acm.org>
 <8bd7faad-abf4-f7b3-03c9-e06f9b5d2148@gmx.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8bd7faad-abf4-f7b3-03c9-e06f9b5d2148@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/22/23 13:51, Helge Deller wrote:
> On 5/22/23 21:28, Bart Van Assche wrote:
>> On 5/20/23 22:43, Helge Deller wrote:
>>> On a single-CPU parisc64 machine I face the spinlock recursion below.
>>> Happens reproduceably directly at bootup since kernel 6.2 (and ~ 6.1.5).
>>> Kernel is built for SMP. Same kernel binary works nicely on machines with more than
>>> one CPU, but stops on UP machines.
>>> Any idea or patch I could try?
>>
>> How about performing one or more of the following actions?
>> * Translating aio_complete+0x68 into a line number.
> 
> It hangs in fs/aio.c:1128, function aio_complete(), in this call:
>      spin_lock_irqsave(&ctx->completion_lock, flags);

All code that I found and that obtains ctx->completion_lock disables IRQs.
It is not clear to me how this spinlock can be locked recursively? Is it
sure that the "spinlock recursion" report is correct?

Thanks,

Bart.

