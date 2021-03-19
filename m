Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611F3C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 19:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D615961977
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 19:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhCSTs6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 15:48:58 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:44619 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhCSTsy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 15:48:54 -0400
Received: by mail-pf1-f175.google.com with SMTP id b184so6626645pfa.11
        for <linux-scsi@vger.kernel.org>; Fri, 19 Mar 2021 12:48:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cswbEhHHO5JTsfmsgN+ByV0GrBegM7x8SKwEBff3xCE=;
        b=dNtr7c0kPIHgQMEXzyPqQdr5fOINJrMDT1CCbgZowyU45k66BSw+qKRDuHwvkfTz4w
         K2+c++kP7uqKV1hxAjinrLP6TGi5lfBhi5x1aomVPwUe78U9zhX6PHTOfMinWwxlevq+
         TSGTyLjTB43Ixyj7sJK3QjNej/QdZSRaaK9NUphHKW8HZr1uwY7pY/XQIC7LAwqCohbw
         ctfR+cNv/bBlZffiFyt/Tyh7Qtrw1d9V5uNDTd09ii7M8J5/5Z31GIOYyvdk/SgeWaAI
         BXRJcO81EE86fgmR/YH+/g3IYg3VRAy31RM1x8A9urHJfTfq6YteTqUOo44Vjs/YSCQZ
         cmhA==
X-Gm-Message-State: AOAM530N0jCAXRHVCJNWSovV9YcxgABjsNYwxK5xWHb/4OzC4iherpTJ
        onPkKhNq4Y+AWUvg1BuWR2gLNkXIsImesA==
X-Google-Smtp-Source: ABdhPJzhSDqYQiAgNxTGRlXbfA12ldlmu+EtTOeBg/ibzEUwL3kPHwmPT2exxaCuDJUu4XRUvZEegg==
X-Received: by 2002:a62:7b83:0:b029:1f1:5ef3:b4d9 with SMTP id w125-20020a627b830000b02901f15ef3b4d9mr10688945pfc.65.1616183322987;
        Fri, 19 Mar 2021 12:48:42 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id t125sm2792024pgt.71.2021.03.19.12.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 12:48:42 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 9019F40317; Fri, 19 Mar 2021 19:48:41 +0000 (UTC)
Date:   Fri, 19 Mar 2021 19:48:41 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        hare@suse.de
Subject: Re: [RFC] scsi_debug: add hosts initialization --> worker
Message-ID: <20210319194841.GL4332@42.do-not-panic.com>
References: <20210319150514.17083-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319150514.17083-1-dgilbert@interlog.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 19, 2021 at 11:05:14AM -0400, Douglas Gilbert wrote:
> Adding (pseudo) SCSI hosts has been done in the scsi_debug_init()
> function. Each added SCSI host triggers an (async) scan and for
> every LUN found, the host environment can trigger a lot of work.
> On a recent Ubuntu/Debian distribution a lot of this "work" seems
> to involve udev and its scripts. The result of this work can be
> seconds elapsed before scsi_debug_init() returns.
> 
> This experimental code places the function to add those SCSI hosts
> in its own thread. This allows scsi_debug_init() to complete a lot
> faster. To impede malevolent user space code that might try to send
> a 'rmmod scsi_debug', an extra module_get() reference is taken
> before the worker thread starts and that worker gives back that
> reference when it completes.
> 
> This patch is against MKP's repository and its 5.13/scsi-queue
> branch which is sitting at lk 5.12.0-rc1. It should apply to later
> release candidates in that series.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

This is a good idea in general in terms of module design, however given
current users include fstests and blktests I think as-is it would
introduce a few false positives. So we either decide to not care about
those users and force a check on version moving forward.. or we keep
and the existing behaviour and bite the bullet long term.

Also, in terms of design an alternative is a load/unload sysfs file.
But we'd still punt the same issue of "are we ready to use these devices
after load" to when this file completes writing to.

FWIW, blktets users udevadm settle to try to ensure udev stuff completes
its work, but if folks are using blktests to test things they may also
have multipath installed, and for whatever reason that userspace
application loves to tickle scsi devices upon load, and that is a
random example of another user of of scsi devices which would prevent
unload. Granted, the use of that application of opening the device is
quick, but it still reveals an issue with testing. Perhaps all we can
do is just use scsi_complete_async_scans() in a private module namespace
as suggested in the bug report *and* perhaps setting TEST UNIT READY as
you suggested? If setting TEST UNIT READY for until we're ready, perhaps
that really suffices completely, and that would give parity with what
other userspace applications would use for prepping for a test on a
target scsi device.

I'll soon test what you recommended of

modprobe scsi_debug tur_ms_to_ready=20000

If more devices are used, perhaps the thing to do there is to
multiply per numbef of devices requested?

  Luis
