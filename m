Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2481C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 01:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D3F5610C9
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 01:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhIJBgz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 21:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbhIJBgy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2021 21:36:54 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E349FC061574
        for <linux-scsi@vger.kernel.org>; Thu,  9 Sep 2021 18:35:43 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id y18so378772ioc.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Sep 2021 18:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ErAyk9D1A5QUQ1SwitqvXGPEBpw4ZKzim5DNF0QGpsA=;
        b=gGCuiNYZvbRrtJf0frhTq+FPIyRz/Fv71IwCiXOMfLgHJlA487EzjzmySacqV3SHRD
         5+zy5CBc12By/BOku214wRNJb18HlBHXmdzojxF2LcQAHWxB3/oVHICQl5yKES0WSZTQ
         wUfcycFjpFP0j/YHu89HgymIwC4z/L0R1BrWbgZJ0jrATk5rBIgHchV3gnGxpql2ptZk
         9dDRqQnV+n8sDlTVy2TO9owyUrKa1ClfAaqfAFfC/UYqOj1K9O6mxSP3zEq1ts7wHpLL
         TMaQdI/bmYu1gnvHRVANvWKY00jX1XwNJ3anSxhUB7AhTvCVrbz28kxlRSObUiyrd1EK
         EPRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ErAyk9D1A5QUQ1SwitqvXGPEBpw4ZKzim5DNF0QGpsA=;
        b=LpwhTZOdJRzW51bWiEISFlWkvnxSXlRf8zIC1Ur83oRrs/bHWkCFeQVfbomqnu3zcY
         1ocCnbHKmpYvii6SOTQSCmpaywZMyRZo+QfUZ7jt1rUcAEvv8Q7pMUnlkITzPsk00oVC
         QClQ5hImjLTL+ds3LmATP4PwyIMPQGYiamxXzKZ88JRhbR3yM3WNMFjnksq/LsypmTw4
         C0oWEjserXD6sTurkhlSQwwuOFjhNZaTC78V1GJ5MebbPqfcrpbBSWnksEq5n3CwvhQ9
         k6rgRWYdOTLJW0ZHTiuQjAth3DKMw+mKs54IxqQkzyJ3JYq5G4BkI45sbZ8IuwQCTA+7
         31+A==
X-Gm-Message-State: AOAM531tqVbwIw6hEnZlm13/qHagr8O+Nlig5szgipO0H4bOuv+2dn87
        +F4oUMZVb0TFQSwZ75a1KWxqi8Hcs6LpnQ==
X-Google-Smtp-Source: ABdhPJybnVvD5h6xZDL78kmKgo+2tS5h9bSOUb5qnBhUEJ37zovqgd2q5U1J0FcKH4m0Y/GXFWHLjw==
X-Received: by 2002:a6b:d915:: with SMTP id r21mr5009169ioc.76.1631237743269;
        Thu, 09 Sep 2021 18:35:43 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r11sm1834057ila.17.2021.09.09.18.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 18:35:42 -0700 (PDT)
Subject: Re: [PATCH] scsi: remove SCSI CDROM MAINTAINERS entry
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <c5e12bd1-10de-634c-d6b3-dac79ed01af5@kernel.dk>
Message-ID: <d086adfb-9cfe-6f3c-aae1-b9106436037d@kernel.dk>
Date:   Thu, 9 Sep 2021 19:35:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c5e12bd1-10de-634c-d6b3-dac79ed01af5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/3/21 8:11 AM, Jens Axboe wrote:
> There's little point in keeping this one separately maintained these
> days, so just remove the entry and it'll fall under the SCSI subsystem
> where it belongs.

Ping...

-- 
Jens Axboe

