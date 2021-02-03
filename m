Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A58DC433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DF1064F68
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhBCIi0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 03:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbhBCIiY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 03:38:24 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B79C06174A;
        Wed,  3 Feb 2021 00:37:43 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id df22so9903261edb.1;
        Wed, 03 Feb 2021 00:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MMxPbV24wCw9jdZMUSEGJzIoBXjIAwvU0J/rkzD1YXk=;
        b=mdTL9ngKvMZ5GG+EMXrBODJVm4SBszty6TdsiP+ai5uH1bFzhI8nuSUCGr1d1LBs/O
         pefP2tbYa9JZ1bazFLg0eK88CUPfrGEl9pPkOumpUr3coa/qEoCmBDykAlswhzqrE3Kl
         xYlLVMo98lcVCSn/mgZ19AkWYQwlRd+AabKeM/vWFzXxnxRgpO4nmQbcHv75K+Y+KKhq
         GFAokYetjmMj7d/ZQ+2FlJC6JbEM44dO7/Rj5R8g5utfRtrf0OHCGvbFytKsbSvEWW9i
         MTluoIGy+df6XFUirRQPPNbQldwbDA1E0RwVNp1Z6x7vRQT/nW4GN9PqWPUfL4f6pEC3
         KONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MMxPbV24wCw9jdZMUSEGJzIoBXjIAwvU0J/rkzD1YXk=;
        b=pWkNaMi0PCu0NMUtmTrquacee5wW4sF3by6Z/1l9MFGkaHwbHIRHPwRWAUSjT6+dOE
         DxC+6ERDGyZCvItoJu2HvfoSQo0u8u8v9Rb3Im/EfiggvJHR5h7S3ZKAhgQ87UYh/aSk
         l8Cir5+Dx/x4dnyjAWxV0eyHdvq2ASOSdflofut2KTFlVZorfR1ioTZ7nRyyhljJWhN4
         JSdVmlb9NGYwv7XS1iu05M40knk6tK7GoJiDeyIiYFRNNBj6AZgUHHQmVMZMyzy0Zbrb
         GylYtJd2GXySBXw9CtYnBJmlr8cUUA0tIDx/xhLtNTfu57KGVWusu74/CoGYBJEZJsqp
         waCA==
X-Gm-Message-State: AOAM532PsmVkeQc9rej3/gNbX6ntWXR2rY9Vmzrq9PxL4RNL19Y6q3I9
        2hrZnruWu+CSS67/BzRU5rs=
X-Google-Smtp-Source: ABdhPJzwxJz1SQDPvH0URh51M609uESH6v2AtCbD8psOe+k3tF5VuW0E7A3ksDaffUOX4iQPQmXZzQ==
X-Received: by 2002:a50:e0c1:: with SMTP id j1mr1819774edl.253.1612341462512;
        Wed, 03 Feb 2021 00:37:42 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id e8sm503690edy.91.2021.02.03.00.37.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Feb 2021 00:37:42 -0800 (PST)
Message-ID: <5a87ffd05533868f9290d894c90d6b7ff2661082.camel@gmail.com>
Subject: Re: [PATCH 1/4] scsi: ufs: Add exception event tracepoint
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Wed, 03 Feb 2021 09:37:40 +0100
In-Reply-To: <20210119141542.3808-2-adrian.hunter@intel.com>
References: <20210119141542.3808-1-adrian.hunter@intel.com>
         <20210119141542.3808-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-19 at 16:15 +0200, Adrian Hunter wrote:
> Currently, exception event status can be read from
> wExceptionEventStatus
> attribute (sysfs file attributes/exception_event_status under the UFS
> host
> controller device directory). Polling that attribute to track UFS
> exception
> events is impractical, so add a tracepoint to track exception events
> for
> testing and debugging purposes.
> 
> Note, by the time the exception event status is read, the exception
> event
> may have cleared, so the value can be zero - see example below.
> 
> Note also, only enabled exception events can be reported. A
> subsequent
> patch adds the ability for users to enable selected exception events
> via
> debugfs.
> 
> Example with driver instrumented to enable all exception events:
> 
>   # echo 1 >
> /sys/kernel/debug/tracing/events/ufs/ufshcd_exception_event/enable
> 
>   ... do some I/O ...
> 
>   # cat /sys/kernel/debug/tracing/trace
>   # tracer: nop
>   #
>   # entries-in-buffer/entries-written: 3/3   #P:5
>   #
>   #                                _-----=> irqs-off
>   #                               / _----=> need-resched
>   #                              | / _---=> hardirq/softirq
>   #                              || / _--=> preempt-depth
>   #                              ||| /     delay
>   #           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
>   #              | |         |   ||||      |         |
>        kworker/2:2-173     [002] ....   731.486419:
> ufshcd_exception_event: 0000:00:12.5: exception event status 0x0
>        kworker/2:2-173     [002] ....   732.608918:
> ufshcd_exception_event: 0000:00:12.5: exception event status 0x4
>        kworker/2:2-173     [002] ....   732.609312:
> ufshcd_exception_event: 0000:00:12.5: exception event status 0x4

Hi Adrian

aAbove print has two trace strings "exception event" in each event
print, it is somehow redundant to me, why not replace the second one
with the event string name?


ufshcd_exception_event: 0000:00:12.5: LOW_TEMP 0x4

or just status:

ufshcd_exception_event: 0000:00:12.5: status 0x4


Bean

> 

> 





