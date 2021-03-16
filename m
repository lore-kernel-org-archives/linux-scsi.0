Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F02CAC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 17:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B12B665127
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 17:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239349AbhCPRrY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 13:47:24 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:56319 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239242AbhCPRqs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 13:46:48 -0400
Received: by mail-pj1-f54.google.com with SMTP id bt4so11028998pjb.5;
        Tue, 16 Mar 2021 10:46:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=cDz1OoD3tDdvu9yZyAWDwJ6QedSgxN+Vxkt9EmQTDzc=;
        b=ZgA11HSZTxPkTPNEIF7Iwm468YzalhPu5PX3ys4YDWcVt0bVN+n8szofus4mJLc6Dz
         hjy4JSLnblDyKMP8NlbrR0LONq7t0yyaNO4hNYiNLZC1/i7T4uVER5PJHoxYPbTGYrqd
         OSDTmVc1ZY+odRiEDf7pN/IfkrobrUR/EVQlHcnt2nf8sFHOks+JpQrjJoXzF06FJVO8
         xdrVDclvwIddxolsereTgxZ52RPTEfc7vSLh2mVKhsuYU97MI3S0rcXYQHmsdjgc5KQE
         rVQtBgWgYZafUGtSmda1d2Qux8McRrPNdz5pSQuk7po5EGH2Sr8a34Ho3fXfLQ/AgKQf
         ISgw==
X-Gm-Message-State: AOAM533zUBewTS6z2gnFoOjIzn4iB4q0wIZTQuq+eIyytYAF7YmFZILu
        PfcjoGOmlrhy7PmqBMe5tBjXIWihO0Biyg==
X-Google-Smtp-Source: ABdhPJwzP9XKjt2OANRgMC82UXqNJ/kn6lLddkdek0OKFvBOE6LikIdcIRjIGKw0bk+8oennH3ZpPA==
X-Received: by 2002:a17:90a:e656:: with SMTP id ep22mr228107pjb.60.1615916807990;
        Tue, 16 Mar 2021 10:46:47 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id q15sm79386pje.28.2021.03.16.10.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 10:46:47 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 7E83B40244; Tue, 16 Mar 2021 17:46:45 +0000 (UTC)
Date:   Tue, 16 Mar 2021 17:46:45 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-block@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     Luis Chamberlain <mcgrof@kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: blktests: block/009 next-20210304 failure rate average of 1/448
Message-ID: <20210316174645.GI4332@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I've managed to reproduce blktests block/009 failures with kdevops [0]
on linux-next tag next-20210304 with a current failure rate average of
1/448 (3 counted failures so far). I've documented the failure on
korg#212305 [1] and provide instructions on how to reproduce. The
failure happens on KVM virtualized guests, for the host OS I am
using debian testing, but the target kernel is linux-next.

My personal suspicion is not on the block layer but on scsi_debug
because this can fail:

modprobe scsi_debug; rmmod scsi_debug

This second issue may be a secondary separate issue, but I figured 
I'd mention it. To fix this later issue I've looked at ways to
make scsi_debug_init() wait until its scsi devices are probed,
however its not clear how to do this correctly. If someone has
an idea let me know. If that fixes this issue then we know it was
that.

[0] https://github.com/mcgrof/kdevops
[1] https://bugzilla.kernel.org/show_bug.cgi?id=212305

  Luis
