Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5504DC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 22:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E05764E6B
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 22:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhB1WID (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 17:08:03 -0500
Received: from mail-pg1-f175.google.com ([209.85.215.175]:41962 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbhB1WIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 17:08:01 -0500
Received: by mail-pg1-f175.google.com with SMTP id a23so476125pga.8;
        Sun, 28 Feb 2021 14:07:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oSlig3oiA1Pbrd3+p5gB30XBkYWsSFMJuETdec9IS14=;
        b=gDlXP3baooujnDy5m7ykeMWpEfDsdoIztseub8xHyay2tqlo6qG8KfrRLmueqYP/t3
         4beXO9qYiLyIP+K6AxFT60h5CKJurfEvdSDVQML2esCxeaw05XvysyiqxjYeJhgzbb+d
         0O7oN7+rjovUdMM981DEY4WmO2LLjm1g/uDMMZGYdXtAI4tanjy1/5LaoYw4AEwhv72Y
         Fca2n3w6qR0/+yh1WoWX5Mt80bWzWTtO4Q8A/DugajXYdodnL6ZytwxlO7AYbXa5QoWz
         DEiaSxCnWf+eT2UNquVIpob42C4idfgE9QSCYh3F8pEGiyklTJxN2/pNi/5I2QSpkBhd
         ZOrg==
X-Gm-Message-State: AOAM531QkcM61o+dqPE2q14kGVwGLgrUhfgg1bhzXtr+TyLws0cZG/jW
        bQK/EegQbHjjZikUbKwxMIF9DIDkAu0=
X-Google-Smtp-Source: ABdhPJyH3EK/0JqQC9+JlzV8fjaTa0JejLt+368w9D35qsRi7P1Msm5V6tbZnxVTIWam+GiBVSvZGg==
X-Received: by 2002:a63:c80c:: with SMTP id z12mr3460693pgg.376.1614550039895;
        Sun, 28 Feb 2021 14:07:19 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:33b2:579f:d8cd:be8a? ([2601:647:4000:d7:33b2:579f:d8cd:be8a])
        by smtp.gmail.com with ESMTPSA id x11sm1169761pjh.0.2021.02.28.14.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Feb 2021 14:07:19 -0800 (PST)
Subject: Re: [PATCH 05/11] pragma once: convert
 drivers/scsi/qla2xxx/qla_target.h
To:     Alexey Dobriyan <adobriyan@gmail.com>,
        torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org
References: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
 <YDvMYoYcHN5wVDpo@localhost.localdomain>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e617be2f-04cf-2ffb-50b8-9b7be31fb77a@acm.org>
Date:   Sun, 28 Feb 2021 14:07:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YDvMYoYcHN5wVDpo@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/28/21 9:01 AM, Alexey Dobriyan wrote:
> This file has broken include guard which is not obvious just by looking
> at the code. Convert it manually. I think I got #endif right.

Why do you think that the include guard is broken? Please mention this
in the patch description.

> -
> -#ifndef __QLA_TARGET_H
> -#define __QLA_TARGET_H
> -
> +#pragma once
>  #include "qla_def.h"
>  #include "qla_dsd.h"

Please insert a blank line between #pragma once and the #include directives.

Thanks,

Bart.
