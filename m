Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E4CC77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 20:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbjEWUGP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 16:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238394AbjEWUGN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 16:06:13 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164C113E;
        Tue, 23 May 2023 13:06:10 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1ae4baa77b2so571335ad.2;
        Tue, 23 May 2023 13:06:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684872369; x=1687464369;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RkN9kpEtQR9KLesG9+ZLsH9wS2KwchcjOktmEbimT/8=;
        b=PISnTMpaqlTwVJZriFwK4MuXhITijttmmZCirGt8pFR3tBW78nMb2gJ8GvLKz4sUMv
         oT0AQowChv01yXM2xASyUp33Q+cm+5NxziIAXkBHz7dA1yZVe8cHZ1L5Qorxp8q+WlxP
         iuFqv36n7qOXN8fl7e1c1UBzRpa4/j1MhNWc5e2RovGoAETznCSQnjS087EakfY+JYK7
         35OJffcFC860gowEjyTqul5cBXv5jpI1+ke0Zwo5S10S47jQsjj9Lr7lVjx6VpJSvKUO
         /65pxcTYekuyOHVsvqy9oJ2JonYYPyn57sxZdESPcfzgHJAUMKdRaKH9ALv/0mYDLMFz
         pOYw==
X-Gm-Message-State: AC+VfDyeOt+xT0iMOCOdcBGC80ysSt/IdETb5rtgza13olUXbt3PRrpj
        bDrDoReUeb0SpKpObyWtSW0=
X-Google-Smtp-Source: ACHHUZ72kBflqtVXUQyGT8mv00bm4mQqV2cVRP+m6o7/tJtnWDDut+PXWDKvBtmaKcsrT06wO1bDWA==
X-Received: by 2002:a17:903:2444:b0:1aa:f203:781c with SMTP id l4-20020a170903244400b001aaf203781cmr19193931pls.44.1684872369293;
        Tue, 23 May 2023 13:06:09 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:24d2:69cd:ef9a:8f83? ([2620:15c:211:201:24d2:69cd:ef9a:8f83])
        by smtp.gmail.com with ESMTPSA id m10-20020a170902bb8a00b001aaeeeebaf1sm7134844pls.201.2023.05.23.13.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 13:06:08 -0700 (PDT)
Message-ID: <9fa519ab-a470-9e32-d3dc-f342ddad1026@acm.org>
Date:   Tue, 23 May 2023 13:06:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: spinlock recursion in aio_complete()
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Cc:     Linux SCSI List <linux-scsi@vger.kernel.org>, linux-aio@kvack.org,
        linux-parisc <linux-parisc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <5057d550-c3f4-be34-d3e6-390790051232@gmx.de>
 <89053bf1-6bc3-3778-7662-14d15bd778a3@acm.org>
 <8bd7faad-abf4-f7b3-03c9-e06f9b5d2148@gmx.de>
 <077b00a6-9587-2e28-3f8a-44871f9428ca@acm.org>
 <5e684a22-dcc1-095f-ac18-fd1b3bf81cd6@gmx.de>
 <4d786f73-8c6f-4fd1-cdd6-42f2d59d6120@gmx.de>
 <ZGyawdtBhNnvvTv3@shell.armlinux.org.uk> <ZG0bkNJ5jQC1a3pY@p100>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZG0bkNJ5jQC1a3pY@p100>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/23 13:01, Helge Deller wrote:
> Subject: [PATCH] Fix flush_dcache_page() for usage in irq context
> 
> flush_dcache_page() can be called with IRQs disabled, e.g. from
> aio_complete().
> 
> Fix flush_dcache_page() on the arm, parisc and nios2 architectures
> to not unintentionally re-enable IRQs by using xa_lock_irqsave() instead
> of xa_lock_irq() for the flush_dcache_mmap_*lock() functions.

Please consider adding a Fixes: tag such that this patch is picked up 
automatically by the stable tree maintainers.

Thanks,

Bart.

