Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86622C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 17:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3985C23A79
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 17:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbhAVR0t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 12:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728718AbhAVQzn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 11:55:43 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC45C06178B
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2021 08:54:35 -0800 (PST)
Date:   Fri, 22 Jan 2021 17:51:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611334293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=duF826oNjVqHJH4TCpsijGzt7xMkMBsSQhoM/BiX/rk=;
        b=Bs2Vt+SwuiX5kT2alBKmXtdI9+TdBzTQld5+fMdiPh6fE5MNkd70XHTrHtSKwal/MNkZIi
        lGq7thshhf4hdaC5HKlYbIhfjtC/HSkXVvU+K+XyIrZrEkuWoq6HSVMWXOyyMx20VUiluw
        Pp+f7Z758ZUD9KEBCyrdfK7BA6uwP7023Wt4Vle1leTJSI963ke1nkKHqxDyMpcK9nOmsN
        3yp72asrF9J2NUiGquOhzIms/Ed1Mlc0QxBJBhHWvlKThDSlG8AzONbNqWyGHJYy8dVcMY
        8bKoImIg30Rx3V6FesfvshJL8p97EyADvvpYatlj3vCfntQMkQG0q000yh8+ww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611334293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=duF826oNjVqHJH4TCpsijGzt7xMkMBsSQhoM/BiX/rk=;
        b=KaLTi/c9uenRo/ZUU8if2WMwfxRSb7itk3NLJdEKMCynf29TO5qwbstv4EIOy0FudLPXZ1
        h41f2ivxgPUyUNDQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH 0/6] scsi: target: Remove in_interrupt() usage.
Message-ID: <20210122165133.3ejgs4d5tewnuvps@linutronix.de>
References: <20201220203638.43615-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201220203638.43615-1-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-20 21:36:32 [+0100], To target-devel@vger.kernel.org wrote:
> Folks,
> 
> in the discussion about preempt count consistency across kernel
> configurations:
> 
>  https://lore.kernel.org/r/20200914204209.256266093@linutronix.de/
> 
> it was concluded that the usage of in_interrupt() and related context
> checks should be removed from non-core code.
> 
> In the long run, usage of 'preemptible, in_*irq etc.' should be banned from
> driver code completely.
> 
> This series addresses the target subsystem.
> Most of in_interrupt() usage is debugging. There is one function which
> either invokes wait_for_completion() or schedules a timer based on
> in_interrupt().

A gentle ping case it got buried somewhere in the merge window / xmas.
My understanding is that nab is out-of-town and target gets routed via
scsi.

Sebastian
