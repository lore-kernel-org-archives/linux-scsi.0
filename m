Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FB6C636D6
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Feb 2023 08:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjBCIxZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Feb 2023 03:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjBCIxY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2023 03:53:24 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C608520D16
        for <linux-scsi@vger.kernel.org>; Fri,  3 Feb 2023 00:53:21 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id c11-20020a056e020bcb00b0030be9d07d63so2941052ilu.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2023 00:53:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HKmKJPDbIloaVF9wxjUKzLZJm032XxjfFf+EFpRM0Yk=;
        b=NVxeZSDftOCB9Z8dD17VG6LshNHCkZ/UzeipGRkPAyLuhW1SBWf+ZnVLavE1xJyNmM
         7pBya/bA3NCHnfA94QODsb2iW/c0ETgKMpc1f7DATWEP35jptNDlIQ8ikrDT+4uA4ZEr
         7oaIc7PaZnxGLtpux01QvpYDTPhTzi7TiZAu/ZnF7lUBqfSt+1YDcxxFoy0QfWAXutWq
         MjPk8OXpAXQ5lkkvsDaeZka+RPL2xOpyMgkhJ3VHFiSfAWqRqut7NIslBnsfAWjW8oYe
         su6wQ/l02FmFDuLgKLIZ+3cq8oC6EmU44oHmeO1K3WH5vxIrR09qnXs2ZuaXgkQUWvoc
         sziw==
X-Gm-Message-State: AO0yUKUtYwwz51o3k+GHk+obsCzz+onJy3GNP0wlYT9Wi3MCZtTMKbQl
        UCbjqGh6pUcpw9M4gL7e5hRf6gWeAEsVbPuKBuI215HctzCl
X-Google-Smtp-Source: AK7set992YEjU59mc5KBs7LOS8DgjU2Yp0XuHbujD6DIew8NCUbNVWokx5RUonIbg1J0OqznsgdoGqUe6RiTEkrlZf+r1Sdtfvj2
MIME-Version: 1.0
X-Received: by 2002:a02:ac8e:0:b0:3b1:92c0:ac28 with SMTP id
 x14-20020a02ac8e000000b003b192c0ac28mr2337676jan.74.1675414401053; Fri, 03
 Feb 2023 00:53:21 -0800 (PST)
Date:   Fri, 03 Feb 2023 00:53:21 -0800
In-Reply-To: <000000000000cbd8aa05f1fd2516@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000039fb2d05f3c7d0ed@google.com>
Subject: Re: [syzbot] [ext4?] INFO: task hung in ext4_evict_ea_inode
From:   syzbot <syzbot+38e6635a03c83c76297a@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, alim.akhtar@samsung.com,
        avri.altman@wdc.com, beanhuo@micron.com, bvanassche@acm.org,
        hdanton@sina.com, jejb@linux.ibm.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu, wsa+renesas@sang-engineering.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

syzbot has bisected this issue to:

commit 82ede9c19839079e7953a47895729852a440080c
Author: Wolfram Sang <wsa+renesas@sang-engineering.com>
Date:   Tue Jun 21 14:46:53 2022 +0000

    scsi: ufs: core: Fix typos in error messages

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=132b298b480000
start commit:   a689b938df39 Merge tag 'block-2023-01-06' of git://git.ker..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10ab298b480000
console output: https://syzkaller.appspot.com/x/log.txt?x=172b298b480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=33ad6720950f996d
dashboard link: https://syzkaller.appspot.com/bug?extid=38e6635a03c83c76297a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114dd83a480000

Reported-by: syzbot+38e6635a03c83c76297a@syzkaller.appspotmail.com
Fixes: 82ede9c19839 ("scsi: ufs: core: Fix typos in error messages")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
