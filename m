Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AEBC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Dec 2021 00:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhLLA3P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Dec 2021 19:29:15 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:55249 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhLLA3O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Dec 2021 19:29:14 -0500
Received: by mail-io1-f70.google.com with SMTP id s8-20020a056602168800b005e96bba1363so12818091iow.21
        for <linux-scsi@vger.kernel.org>; Sat, 11 Dec 2021 16:29:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=nDG4SEwejxlIh6+HWy4XvDA2HuM5COpv4vJgPsHPavo=;
        b=2jhlY2Kg7xL+UnVAxoWxl27oFc0HpURQWjrckWyH2qiX7lMpG0CJXmfvD/hFbc8BPa
         hbmKHMhK1em/k8Nu0UPmHzaZoqivPAkckjH78s4Js0AxEkBGtPAW485bnpBsJVwQwaax
         KWKzoReYoqeg+B8uQVeENpN9AKanDlIKw1GSqmmBKo+tfWR4cQ006n5unZd4dkdQYw5c
         55F/SM2VZVY9p6stB5fBQ0D3TOrVtdHn2BjxNpiXWdfyMWCHBRQn6QCzbHpB6aPTGLGr
         LpzjDWfxnP5eedjy60ybvhWKLRL/jxxB2mmEabmijU/RX44a4FXZf8EJ76GUFAyakdtr
         P8dg==
X-Gm-Message-State: AOAM5312eyLZLP0zLMMKW+1aWqNPdv+2bjI+8stFYNSywfgH3sOc/k06
        pziQcpL9Fki9gEzizcTvW2jnPmpgu7uNVq7xYvJnJ104jRSj
X-Google-Smtp-Source: ABdhPJwzHakTYI1Wa9BYeGT4aejJxGYvhT9EdlMdrBDi7DNg035WzF6pyQvv8kDTCOTdf6YuX6qFjYtFrL2Zt2gyHUsIpsas+q7d
MIME-Version: 1.0
X-Received: by 2002:a05:6638:dd5:: with SMTP id m21mr24924006jaj.44.1639268953978;
 Sat, 11 Dec 2021 16:29:13 -0800 (PST)
Date:   Sat, 11 Dec 2021 16:29:13 -0800
In-Reply-To: <00000000000047627e05b17a6ec9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b17d0105d2e80b47@google.com>
Subject: Re: [syzbot] general protection fault in scsi_queue_rq
From:   syzbot <syzbot+0796b72dc61f223d8cc5@syzkaller.appspotmail.com>
To:     anmol.karan123@gmail.com, capitolscan@capitolsecuritypr.com,
        hare@suse.de, hch@lst.de, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com,
        tadeusz.struk@linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 20aaef52eb08f1d987d46ad26edb8f142f74d83a
Author: Tadeusz Struk <tadeusz.struk@linaro.org>
Date:   Wed Nov 3 17:06:58 2021 +0000

    scsi: scsi_ioctl: Validate command size

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11db6f3ab00000
start commit:   ec681c53f8d2 Merge tag 'net-5.15-rc6' of git://git.kernel...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=bab9d35f204746a7
dashboard link: https://syzkaller.appspot.com/bug?extid=0796b72dc61f223d8cc5
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1279df24b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a855f4b00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: scsi: scsi_ioctl: Validate command size

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
