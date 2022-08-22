Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAB6C28D13
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Aug 2022 20:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiHVUrP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Aug 2022 16:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiHVUrO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2022 16:47:14 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC6B558DD
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 13:47:14 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id h5-20020a056e021d8500b002e9c0ad7c08so2518412ila.6
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 13:47:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=ckYm9/frTHKg5Q1caJilSY/IDUA7LKV/J33LIJTS+6o=;
        b=KCi0kUPs30xsaGaeeGMeznlvjvpUpUCJcLQC1GeCDVNHma3giqh/xW/5jR7lK6ogjc
         xe4qWz8ZxOkqRHvDRWUkZVNqU2eNeiXzfoQxWPHuNngunKaalUkRI5iSWspWnPOBod/4
         g1kgHeP2aj0OFGHBL5xsXceTYBX4u9wnmKAXEAavNKYWwIqyx11a9a194J8fuJJXgcF8
         +Lx5t+loiutComzZyFaI1sQkNrmhGiw6jRg3+DxDSgk4HxhU0MAtUJz/Jf2+iGg20AJc
         OD+qHUlPMHe0zHyTriQh9TzngiCd/qSAFE32VqGtISJsDQd0RFt41ucvvkFGhxUycVLv
         D9fQ==
X-Gm-Message-State: ACgBeo30twsKadnlK34mk4g5lcsJICGHh14kpwBmWTjfRsMbqxuNkBkd
        eaokY/ubKjNZhPWUV+/c1TVT/1aSEohOSsa7oFXsOPaFptFl
X-Google-Smtp-Source: AA6agR6YKQu5Soa4+q0bPpVeFbN8zg4kkMp/JQTJsc3IEH4Oq0YU6kHxNZ9NCy4plQ/ZFex72UUsvPyPZFK9XSwxn+cG2NVsEMVN
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1683:b0:345:9e65:cd07 with SMTP id
 f3-20020a056638168300b003459e65cd07mr10403135jat.128.1661201233559; Mon, 22
 Aug 2022 13:47:13 -0700 (PDT)
Date:   Mon, 22 Aug 2022 13:47:13 -0700
In-Reply-To: <000000000000b5187d05e6c08086@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d456105e6da8d58@google.com>
Subject: Re: [syzbot] INFO: task hung in scsi_remove_host
From:   syzbot <syzbot+bafeb834708b1bb750bc@syzkaller.appspotmail.com>
To:     bvanassche@acm.org, dsterba@suse.com, hch@lst.de, hdanton@sina.com,
        jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ming.lei@redhat.com, nborisov@suse.com,
        syzkaller-bugs@googlegroups.com, wqu@suse.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

syzbot has bisected this issue to:

commit ae643a74ebdb150b004601d0d5fe5a1faba9b04d
Author: Qu Wenruo <wqu@suse.com>
Date:   Sun May 22 11:47:48 2022 +0000

    btrfs: introduce a data checksum checking helper

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=176ef485080000
start commit:   e3f259d33c0e Merge tag 'i2c-for-6.0-rc2' of git://git.kern..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14eef485080000
console output: https://syzkaller.appspot.com/x/log.txt?x=10eef485080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3bd9363f7b80ef9c
dashboard link: https://syzkaller.appspot.com/bug?extid=bafeb834708b1bb750bc
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=108e1a3d080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154720f3080000

Reported-by: syzbot+bafeb834708b1bb750bc@syzkaller.appspotmail.com
Fixes: ae643a74ebdb ("btrfs: introduce a data checksum checking helper")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
