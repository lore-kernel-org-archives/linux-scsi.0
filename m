Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024B5C63697
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 16:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90AB02083E
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 16:15:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UkU8aA5m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388485AbgKWQP0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 11:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732233AbgKWQP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 11:15:26 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0D0C0613CF
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2020 08:15:24 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id h11so5861445qkl.4
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2020 08:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=zhGy/VaesBxfi3+W6fnRnM6MABPlxi883ibFh6RCUrc=;
        b=UkU8aA5msM+3NFKBzL+CD73tH+XunSbblrgQdP1fvMT3stMPWZYx54aHe0ID222qBg
         gjAD54S23eLmwz6wMn4D+Ivg5Fg12yqsu/lp/3jq6YPZLcB+TDzBxeHf3m/drQrUlvfF
         TV/tkA67niDk02YqR7GhtoQ8Vrf1xg8KB0CraEKRf9/bL3JdhtDwx2GPRTZxn2+IyRmF
         YMg7Iu0Ln8sNKsExiJ2AmDJRbQ3Ya1Ksjxcv2NAyWYUy22tDk2+zc5nU+1X+hXPZywlo
         Dhaf7iJ85llY3UYtVdCBmVncZJPNA0Wbpe63xbyxvxbf5tVUzTtXS5wG71Bevrd5KqgL
         Jalw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=zhGy/VaesBxfi3+W6fnRnM6MABPlxi883ibFh6RCUrc=;
        b=OLPVLxJPzqxQtfjPMXBjgZi/DPTmYSEUYrvjpg6RU0uXMPcrcXZxSeadpluDKxbFvt
         4PbeP41wDgH9VbYzWmod+cfZvnWExvroomkGRXDXoHRFdKFVDruAl8OREYvy7Ixh3a83
         XXgZSVU/lonp6yRbCp6noWLr3ZYxMO1naDosjXcULz2OXvJrzx/0V4ArceNk7oFcD0eA
         xYEZ387hfmMstNa1jppW/vJaUvWKMgu3fNwLSRF0/CiVnMNk7phwTv3NETHNRoylQi7g
         LQQwuKXbewAfVHVDSwCTeSJs6ONvnrcizYGtwUDanP3PTITKDH/yi4sdsBZN/cbpkPTL
         vOpA==
X-Gm-Message-State: AOAM533BH3t/u9o7FWu9yd5x2XUkIvxptl7hbhqzbVyLLH0qn0GULMcK
        vnVle8amYon4wHtPpHcpTzcnmM+vCkaARQWgDCF7Gw==
X-Google-Smtp-Source: ABdhPJz5zXAygIYM32O8J7GLqxjV+QCZIKRK2OukLZ0cAolOP8zUbmt5N0btqJQfiueHa3G7v1WoJVW2Mczu6ijn7FU=
X-Received: by 2002:a37:4552:: with SMTP id s79mr205976qka.6.1606148123585;
 Mon, 23 Nov 2020 08:15:23 -0800 (PST)
MIME-Version: 1.0
From:   Alexander Potapenko <glider@google.com>
Date:   Mon, 23 Nov 2020 17:15:12 +0100
Message-ID: <CAG_fn=V5LczhvXzU5D-NF1sDPF3sr_DfKi-RbyeTT175kcPVxw@mail.gmail.com>
Subject: Potential double fetch in sg_scsi_ioctl()
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc:     Dmitriy Vyukov <dvyukov@google.com>,
        Merna Zakaria <mernazakaria@google.com>,
        linux-scsi@vger.kernel.org, mengxu.gatech@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christof, Jens,

We've found a double-fetch in sg_scsi_ioctl() using a prototype tool
(see the report below).

Turns out that sg_scsi_ioctl() reads the first byte of sic->data
twice: first when getting the opcode
(https://elixir.bootlin.com/linux/latest/source/block/scsi_ioctl.c#L439),
then when reading the command of the size calculated from that opcode
(https://elixir.bootlin.com/linux/latest/source/block/scsi_ioctl.c#L464).

At this point opcode and req->cmd[0] may mismatch.
The opcode is then used to determine rq->timeout and req->retries,
whereas req->cmd[0] is used by the underlying device drivers.
Not sure invalid timeout or retries is a big deal, but since the
command length also depends on the opcode, it is possible to trick the
kernel into using the remnants of the previous command by first
announcing a short command and then changing the opcode to a longer
one.

I've noticed that three years ago Meng Xu has reported the very same
bug already: https://patchwork.kernel.org/project/linux-block/patch/1505834=
638-37142-1-git-send-email-mengxu.gatech@gmail.com/
Was there any followup to that patch?

Alex

Double fetch report follows:

BUG: multi-read in sg_scsi_ioctl, syscall __x64_sys_ioctl

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D First Address Range Stack =3D=3D=3D=3D=3D=3D=3D
 df_save_stack+0x33/0x70 lib/df-detection.c:202
 add_address+0x2cb/0x370 lib/df-detection.c:48
 sg_scsi_ioctl+0x160/0x560 block/scsi_ioctl.c:439
 sg_ioctl_common+0xdb6/0x1110 drivers/scsi/sg.c:1109
 sg_ioctl+0x49/0xa0 drivers/scsi/sg.c:1163
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=3D=3D=3D=3D=3D=3D=3D Second Address Range Stack =3D=3D=3D=3D=3D=3D=3D
 df_save_stack+0x33/0x70 lib/df-detection.c:202
 add_address+0x2cb/0x370 lib/df-detection.c:48
 _copy_from_user+0x93/0xe0 lib/usercopy.c:17
 copy_from_user include/linux/uaccess.h:167 [inline]
 sg_scsi_ioctl+0x21a/0x560 block/scsi_ioctl.c:464
 sg_ioctl_common+0xdb6/0x1110 drivers/scsi/sg.c:1109
 sg_ioctl+0x49/0xa0 drivers/scsi/sg.c:1163
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
syscall number 16  System Call: __x64_sys_ioctl+0x0/0x140 fs/ioctl.c:800
First 0000000020000188 len 1 Caller sg_ioctl_common+0xdb6/0x1110
drivers/scsi/sg.c:1109
Second 0000000020000188 len 10 Caller copy_from_user
include/linux/uaccess.h:167 [inline]
Second 0000000020000188 len 10 Caller sg_scsi_ioctl+0x21a/0x560
block/scsi_ioctl.c:464

CPU: 0 PID: 6266 Comm: syz-executor.0 Not tainted 5.9.0-rc4+ #55
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/=
2014
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D




--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
