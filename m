Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF9CC433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 21:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EEA161976
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 21:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhC2VGh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 17:06:37 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:41980 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhC2VGO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 17:06:14 -0400
Received: by mail-pj1-f50.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so6576169pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2021 14:06:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=30YEakpoiX3+z5LoMONbVWqAgr9MOlNDwoLxBpCCEWs=;
        b=duyEPx4yo9cxpJ3cioYl5YbNWmPcF50bCRO1/qVhHM/I5qtfD4bxaVzm+v88jLrtG7
         hVT9LhOEARRr0MrSVEExVaDC2AgBY1kooAHk+aX4CS7s1EfQ08+6rkM67Fkt5qvFpLs7
         rzyO49yxoZsaTYFBUoqpR5vUCYbwWBGCQcmsMgkojrP1dugNg5hdzWOZLOYSj/BKQeo4
         5NqifPgkg5rGl3XkIDiwA4dzgN58w+qCcNfhKW/RQ7BWOrwIzusCeSVLUtkBmVCjmZwD
         zLu+qw8Vqrgza++DG/CDnNcjx4KnNBiyn1FfFUKofrb870S2ieJB6a5YkBHrXc9QRyD7
         9LlA==
X-Gm-Message-State: AOAM5316sDWRNxgI25xe2yuC9SekIazU8Ki3Mad/WkDMnUgs0MJN9NH3
        SIg3t99gmXws0noRE2A7Jc8J2uW+a04=
X-Google-Smtp-Source: ABdhPJxyFLhQlQbI5Wb4QQXHGTCz2ynaLExfLEPPl9XoITuhDw+mH8boDSdsms7ICrnCQPLWD4UopQ==
X-Received: by 2002:a17:90b:120f:: with SMTP id gl15mr961149pjb.77.1617051973739;
        Mon, 29 Mar 2021 14:06:13 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 144sm17912730pfy.75.2021.03.29.14.06.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 14:06:12 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufshcd-pltfrm: fix deferred probing
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <420364ca-614a-45e3-4e35-0e0653c7bc53@omprussia.ru>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <52c081b2-2f66-ee7b-4dcd-d106106dfd3d@acm.org>
Date:   Mon, 29 Mar 2021 14:06:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <420364ca-614a-45e3-4e35-0e0653c7bc53@omprussia.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/21 1:50 PM, Sergey Shtylyov wrote:
> The driver overrides the error codes returned by platform_get_irq() to
> -ENODEV, so if it returns -EPROBE_DEFER, the driver would fail the probe
> permanently instead of the deferred probing.  Propagate the error code
> upstream, as it should have been done from the start...
> 
> Fixes: 2953f850c3b8 ("[SCSI] ufs: use devres functions for ufshcd")
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

Hi Sergey,

How has this patch been tested?

Thanks,

Bart.
