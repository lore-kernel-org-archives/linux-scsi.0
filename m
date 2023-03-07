Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0B4C678D4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 18:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjCGSLH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 13:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbjCGSKw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 13:10:52 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569EB9227E
        for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2023 10:05:43 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id i14-20020a056e0212ce00b0031d17f33e9aso5161612ilm.7
        for <linux-scsi@vger.kernel.org>; Tue, 07 Mar 2023 10:05:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678212342;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xMmGBPDCyE1o0KJbX11oQKUWmAnPR1ykDR3aht2SgWI=;
        b=HMCiph6Kctqyf/Xn++29a0WoyDOt7zkFZAxiskS52/dmRzwZK/W178rBbC6fFszE7v
         FI6s4vjPbTGxpOkcLA8uqmY9mzhl9R2RA75Xv1IV6sGa7suVaQJh6ivkOV75IiHB5sWX
         WGTpkFPXGSCXPtyJxe32KckUTpvDHn4ne45qMfQJR+hPc0eWTOltX12Xl8PeI93TO/xq
         z/9/pzaPYsCSz+pGk7G4nW4vvllPvQHhlO1AsDbPgNHafJLnJ+PaKaFQ1S+gUltLdmcx
         5vwgzSBbrm1eRxkYEF1g2w00QBRRZQ0gVaTFII5/DDlvF0I62XaV/R0GR8LVPLgR17Gp
         OGpQ==
X-Gm-Message-State: AO0yUKUit9SXU2Vs+1/49p187EjoEb5xmOrLekIP4MbcOixgySatsnlz
        act9y2JoyLdAPbls9SI7kvrk4ok5Q53lGWJHPweSY44Y3Yyz
X-Google-Smtp-Source: AK7set8LdW7Z5z903MhX750iHI+wLlKjA8IaDjBcJO9bYMe5iSsz69Kbuu35dLmnF/adaamHiU82LHqVZL8BP6K74ahoUX08nDSj
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:f43:b0:317:98ef:7060 with SMTP id
 y3-20020a056e020f4300b0031798ef7060mr7447962ilj.1.1678212342548; Tue, 07 Mar
 2023 10:05:42 -0800 (PST)
Date:   Tue, 07 Mar 2023 10:05:42 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000890fab05f65342b6@google.com>
Subject: [syzbot] [scsi?] memory leak in __proc_create
From:   syzbot <syzbot+645a4616b87a2f10e398@syzkaller.appspotmail.com>
To:     jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    8ca09d5fa354 cpumask: fix incorrect cpumask scanning resul..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17c39338c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=337fc5840f41dbbe
dashboard link: https://syzkaller.appspot.com/bug?extid=645a4616b87a2f10e398
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17500b98c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7b252fbf60d5/disk-8ca09d5f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4bd32a89510e/vmlinux-8ca09d5f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3d1b299dadec/bzImage-8ca09d5f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+645a4616b87a2f10e398@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88810af45b40 (size 192):
  comm "kworker/1:5", pid 5185, jiffies 4294972950 (age 13.730s)
  hex dump (first 32 bytes):
    00 00 00 00 01 00 00 00 48 5b f4 0a 81 88 ff ff  ........H[......
    48 5b f4 0a 81 88 ff ff 00 00 00 00 00 00 00 00  H[..............
  backtrace:
    [<ffffffff81749860>] kmem_cache_zalloc include/linux/slab.h:710 [inline]
    [<ffffffff81749860>] __proc_create+0x1a0/0x3b0 fs/proc/generic.c:426
    [<ffffffff8174a42e>] proc_create_reg+0xae/0x120 fs/proc/generic.c:553
    [<ffffffff8174a4d5>] proc_create_data+0x35/0x90 fs/proc/generic.c:573
    [<ffffffff82c2559c>] scsi_proc_host_add+0xdc/0x160 drivers/scsi/scsi_proc.c:233
    [<ffffffff82c0c26b>] scsi_add_host_with_dma+0x48b/0x500 drivers/scsi/hosts.c:311
    [<ffffffff832b7f52>] scsi_add_host include/scsi/scsi_host.h:774 [inline]
    [<ffffffff832b7f52>] usb_stor_probe2+0x2f2/0x410 drivers/usb/storage/usb.c:1056
    [<ffffffff832c5ff7>] sddr09_probe+0xb7/0x110 drivers/usb/storage/sddr09.c:1772
    [<ffffffff831c2549>] usb_probe_interface+0x179/0x3c0 drivers/usb/core/driver.c:396
    [<ffffffff82b40b0d>] call_driver_probe drivers/base/dd.c:552 [inline]
    [<ffffffff82b40b0d>] really_probe+0x12d/0x430 drivers/base/dd.c:631
    [<ffffffff82b40ecf>] __driver_probe_device+0xbf/0x140 drivers/base/dd.c:768
    [<ffffffff82b40f7a>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:798
    [<ffffffff82b4116b>] __device_attach_driver+0xfb/0x150 drivers/base/dd.c:926
    [<ffffffff82b3e0f1>] bus_for_each_drv+0xc1/0x110 drivers/base/bus.c:457
    [<ffffffff82b41692>] __device_attach+0x102/0x2a0 drivers/base/dd.c:998
    [<ffffffff82b3f79a>] bus_probe_device+0xca/0xd0 drivers/base/bus.c:532
    [<ffffffff82b3bdf1>] device_add+0x991/0xc80 drivers/base/core.c:3589



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
