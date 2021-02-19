Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C214C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E05364EB4
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 19:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhBSTKu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 14:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBSTKr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2021 14:10:47 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C456C061756;
        Fri, 19 Feb 2021 11:10:07 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id do6so15528620ejc.3;
        Fri, 19 Feb 2021 11:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XLkoPoIFUYSG0CnG6IeXuqS8bVpwDZfgCMeGfArQxjc=;
        b=JlNWvlFA9KjjsglUQfCjxWMMidI6wVm/8reK+dV5XzRc3NYt3gjgyNZps1mkFuQtOf
         TqYdNbBFkJ1rIhf+B9ErVa0Tqy5FtH5HwZBEhk0tdxEh4Y8eBpcERnT2zpxJGFavxDP0
         6kx774esN00S+skIL/9dPitZWDJgO0iF8qEmXZvxkZz38UoUWr5hGViiAyvY2QhqpVtq
         M98Wz8fxEVi1mPKSIP/e2ko1nmXDgBDAeM8D3vawXR0ZdNcPskUblTqPCvPhA+6/LFyt
         e/yg8JrxSXCBy7CxnLW2wrJ4fFYy8kEeDyLVVskfAydqVjsW5OIBh0Txl5Oc9QR2PVTb
         JYnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XLkoPoIFUYSG0CnG6IeXuqS8bVpwDZfgCMeGfArQxjc=;
        b=jlucej5oVdMmBKpfUTTl4MqB9+tF9Y758q8lZ1ek4ppyt9ldy2VaVHpHNcWwiv2UoQ
         ngP6VbTGeq9+iqQlg91Ag52hpDZ69mpuWPw6Z9KAGS2CFfReQ5g2R/ulTprhMoPHNp94
         MbqQObR2t+VcCIe0QkMdKSjkgUHslzxM9VMqAePXQOIozqQA14rZhaocgZAZOVi3RYZC
         cnGEUJst9pRUTvEVORcndyBMQxEPI7plc7ssOD1zXTxi6OCoHvEDabSgDVN1Nq9zxj44
         z7bGfh/bfDhphTXBMyVq4IImpWqtgQZPXNKZIz+XcftAigvKTxRUYmBtGGnxYtVAW6i+
         UWbg==
X-Gm-Message-State: AOAM533A1g8fnBPI2VJdJ25CEpLH8wiMCYBtd9cuLYO6gjZS0UHZnAzF
        vUDWCEmfU2z2anLIklvA9GwN0yUhc7E=
X-Google-Smtp-Source: ABdhPJwKmJxUfl7nKoRU7JScQW/AvbUlzE4Tcpf37syJ4FEEqKWdPGfShgKx54eKSGYfWNBgQU3VoA==
X-Received: by 2002:a17:906:3556:: with SMTP id s22mr9154916eja.85.1613761806017;
        Fri, 19 Feb 2021 11:10:06 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id u23sm5766625edt.87.2021.02.19.11.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 11:10:05 -0800 (PST)
Subject: Re: [PATCH 16/25] target: add workqueue based cmd submission
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210217202811.5575-1-michael.christie@oracle.com>
 <20210217202811.5575-17-michael.christie@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <ed2a377c-8142-75a4-69aa-050a0fd18cbb@gmail.com>
Date:   Fri, 19 Feb 2021 20:10:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210217202811.5575-17-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17.02.21 21:28, Mike Christie wrote:
> loop and vhost-scsi do their target cmd submission from driver
> workqueues. This allows them to avoid an issue where the backend may
> block waiting for resources like tags/requests, mem/locks, etc
> and that ends up blocking their entire submission path and for the
> case of vhost-scsi both the submission and completion path.
> 
> This patch adds a helper drivers can use to submit from a lio
> workqueue. This code will then be extended in the next patches to
> fix the plugging of backend devices.
> 
> Note: I'm only converting vhost/loop initially, but the workqueue
> based submission will work for other drivers and have similar
> benefits where the main target loops will not end up blocking one
> some backend resource. I'll port others when I have more time to
> test as I think we might want to make it configurable for some
> drivers.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
>   drivers/target/target_core_device.c    | 10 ++++--
>   drivers/target/target_core_internal.h  |  1 +
>   drivers/target/target_core_transport.c | 42 +++++++++++++++++++++++++-
>   include/target/target_core_base.h      |  8 ++++-
>   include/target/target_core_fabric.h    |  2 ++
>   5 files changed, 59 insertions(+), 4 deletions(-)
> 


Looks good.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
