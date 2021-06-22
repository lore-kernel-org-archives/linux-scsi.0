Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02512C4743C
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 02:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D93D160FEB
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 02:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhFVCuJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 22:50:09 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:36667 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhFVCuI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 22:50:08 -0400
Received: by mail-pg1-f177.google.com with SMTP id e33so15876400pgm.3;
        Mon, 21 Jun 2021 19:47:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9mlO06SX0LdTT0ocPEd5q7QIXv28FNBq2MCnTk+7XSA=;
        b=aUoyXf5tRwH1g2IgWfAzgrqm13lMbJu69YHZ2KxNBaKBY5jDQrDx2HO2ZZLpzlnnOG
         5AcwR/Xso6fcVwmFVITHyg5lwoqaDfWGAjeUBRO+W7oDWkqbQ9J2i8qRfJXnYJqI1nEF
         Kn3hYT+LOH/wOUjvUCI6b3ZKxdzj3DzNJI3A8bVlBWkMoF+TkYML8JxmDBYhEWjT8IB6
         9gON57pO3Kztc+luM8sIs/fPnGpoyC+9poEy7fv6H961a93igYWD2zPUkq6d6HLFF6d7
         bZg3lR/4BWu0TrUftCIyU+8D8Oxzn+PuyR5tHhx1L/GhYQ18StPo4X+EpQvAyJ8a+Gjm
         x0NQ==
X-Gm-Message-State: AOAM53056JTlcTqx93GYuDkKlvzKVzhKIwZs+RH/TkBWwv7djzTETD0u
        kmJbx1q2gZyE7OWDx4Ca4BGD+jPLJSE=
X-Google-Smtp-Source: ABdhPJz7tQPMrQZzkjN2n8UhQFhnsD8RFLnss6532vV8dL6da/ZwaKUUgp7EjpfM0qtIv8wNB4+YGQ==
X-Received: by 2002:a05:6a00:1515:b029:2f1:d29:2a44 with SMTP id q21-20020a056a001515b02902f10d292a44mr1329834pfu.51.1624330072083;
        Mon, 21 Jun 2021 19:47:52 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u21sm16655525pfh.163.2021.06.21.19.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 19:47:51 -0700 (PDT)
Subject: Re: [PATCH] scsi: remove reduntant assignment when alloc sdev
To:     Ed Tsai <ed.tsai@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210621034555.4039-1-ed.tsai@mediatek.com>
 <9e1d5f1f-b51e-8f1a-d052-d6debed116e6@acm.org>
 <9bbe52d3f21b91eadf7ba30be5054cf64ba47739.camel@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6a9e7b80-ace3-2af3-785e-5fc306fc2521@acm.org>
Date:   Mon, 21 Jun 2021 19:47:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9bbe52d3f21b91eadf7ba30be5054cf64ba47739.camel@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/21/21 6:27 PM, Ed Tsai wrote:
> have planned to re-submit it?

That patch has just been resubmitted. I have Cc-ed you.

Thanks,

Bart.


