Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91241C433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Feb 2021 10:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B3DB64E56
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Feb 2021 10:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhBNKsm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Feb 2021 05:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhBNKsl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Feb 2021 05:48:41 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5AFC061574;
        Sun, 14 Feb 2021 02:48:01 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o3so2706880edv.4;
        Sun, 14 Feb 2021 02:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pGVhkUzoraAP3NXigL/CCbf2dYxrUtdDHOUnt5rAgug=;
        b=qMEQyrP5mjQRtQdK4v14kOAeyT8xyto8Gelo0LD6eXNwPZDLBPXMZSs8gAojv9HYxC
         yxBwb/TzeN7gjMvDiVtJAeLE4ZG/jRT4gvfyib5zL64gtNHMEajTXfbDAUlPXU5Gn5cz
         LHVEbrSq11NoWn/MQQZAGGtXionSD8ElCqhxinuqyD90VKaB4dr4t7PD48dvvDaNKton
         ML8T7LYPr1aMjLpuDShe8nATG1QRQQAa4DXULAWldcbxxB5hKBnrWiny8mypEbx+zKIA
         DnGw5xAeazDpDbzBp8sdDK3NitOFvBCu55DrRCkdBoDOU43KOWea6jikH59qXTkG2eA5
         WI1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pGVhkUzoraAP3NXigL/CCbf2dYxrUtdDHOUnt5rAgug=;
        b=kCW1aL5etXpKxP43zICK4FM9Nx77si/RTty/flpjQQzs5yMKNakr94qIv/bF1DVqhn
         ysqO8ZIuwZZ3Q8VYf71n9RUd+qqSMAjU9Czg37OeFqqqRhk+sNXHHAKBGXVmzqMTv20V
         jnjbq42o+OBUrlac3GzOLMvvewWKWlXgnohD7e8l8QeR2l4FSS1t1lGUjZSi0XHWmT78
         97DHH01UN9WpVTFZmsj4nafVkJjjp1QsusiS5UPn5il1l+FNEBbUZ5opATdQ3ELeqEnN
         DFu6kF5nncZWI5FJzQrc8eF8o5mNZFA1OTwRPFRTOuMu9hGokCwk+ARfSTxINvcC9uuJ
         aK0w==
X-Gm-Message-State: AOAM532V04NUfUQaecWuFI/jkpggsbcyiBbLszhswqC7N2fjh3E8ERMS
        hZcTTXp1SCV7dC3Dtutc8X4=
X-Google-Smtp-Source: ABdhPJyGwkHN3McjkUbI0OZyCz73W8o4tDadEvqVXsKTJyAxjMjPPID07jMxhTOkpzl6SFXdAr1pFw==
X-Received: by 2002:a50:b2a3:: with SMTP id p32mr11048942edd.358.1613299679767;
        Sun, 14 Feb 2021 02:47:59 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec65.dynamic.kabel-deutschland.de. [95.91.236.101])
        by smtp.googlemail.com with ESMTPSA id u15sm826673edo.86.2021.02.14.02.47.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 14 Feb 2021 02:47:59 -0800 (PST)
Message-ID: <498eb3ad1a93fdebdfbd12f4146f7f59d0f80343.camel@gmail.com>
Subject: Re: [PATCH V2 1/4] scsi: ufs: Add exception event tracepoint
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Sun, 14 Feb 2021 11:47:57 +0100
In-Reply-To: <20210209062437.6954-2-adrian.hunter@intel.com>
References: <20210209062437.6954-1-adrian.hunter@intel.com>
         <20210209062437.6954-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-02-09 at 08:24 +0200, Adrian Hunter wrote:
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
> ufshcd_exception_event: 0000:00:12.5: status 0x0
>        kworker/2:2-173     [002] ....   732.608918:
> ufshcd_exception_event: 0000:00:12.5: status 0x4
>        kworker/2:2-173     [002] ....   732.609312:
> ufshcd_exception_event: 0000:00:12.5: status 0x4
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>

