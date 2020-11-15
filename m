Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4465DC5519F
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 03:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E41EB20DD4
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 03:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgKODR5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Nov 2020 22:17:57 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38730 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgKODR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Nov 2020 22:17:57 -0500
Received: by mail-pl1-f194.google.com with SMTP id d17so4925745plr.5;
        Sat, 14 Nov 2020 19:17:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K4XQTrFFgS4uWnCwvVsRlx27hTvPlp91RdZDml2p1Dk=;
        b=pf2tZ/7PDoLjVDClycDuoN/ErSr8/Zrv1MCla3EHbusFppCzborEqn+t2oVfds+4sF
         l95I9Cma1vyy4N4ASJRQtTzQ3ZVg6wfa/L2lgfUFBHsU+imi/tYMn10/nbhi4qSXJBIg
         xnVVjOR/8bNW4mxydJLNuJmHTgXmMB2VcIw6t4qpLEFCFQyYX/ThAmWh4NjARvuetK67
         C+Ytm0+D2cXSW9j9rdE2YwiqLPFvWB00iemh94GOEmNCUcBojNEy/zkYw+HAEHsk1L6g
         jm/Zyy9Tkkw+6fgjzoF5CHinrv5jRJ73XSK6vS/8Yx2/CDElIdvg14CgvIFFrvGEllZK
         XDBw==
X-Gm-Message-State: AOAM5326S6s4S4s0BfuhbQUGi1CTlUmngSOW/72gnitGfbEzFQH7TXnz
        +X2IXc5Xnn05il9fQDxRkbR9IilD2GY=
X-Google-Smtp-Source: ABdhPJzmsGzZXe4lQR5L1tHX7eWznXyXHuHdzcv8ghefC6y8E4qaxYFMB2/baJ5fiitM3R492FGHyA==
X-Received: by 2002:a17:902:402:b029:d5:ac47:c33f with SMTP id 2-20020a1709020402b02900d5ac47c33fmr7892401ple.60.1605410276042;
        Sat, 14 Nov 2020 19:17:56 -0800 (PST)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id z22sm15382024pje.16.2020.11.14.19.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 19:17:54 -0800 (PST)
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Bodo Stroesser <bostroesser@gmail.com>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
 <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
 <20201026131226.GA88490@SPB-NB-133.local>
 <270e2edf-49c9-942f-ac3d-b6dfa0aca8f7@acm.org>
 <20201027234639.GB88490@SPB-NB-133.local>
 <c3dac124-301e-df94-9d64-b3c46d4eafb9@acm.org>
 <45E2175E-EE3A-473C-93DD-8ED3168198CA@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <359169eb-f904-24ff-f899-d383df070822@acm.org>
Date:   Sat, 14 Nov 2020 19:17:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <45E2175E-EE3A-473C-93DD-8ED3168198CA@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/20 8:57 AM, Anastasia Kovaleva wrote:
> Is this patch series good enough to be accepted in this form, without
> the kernel switch? As far as i can see, no one has shared their opinion
> about this changes. 

Hi Anastasia,

I will leave it to others to review this patch series.

Thanks,

Bart.
