Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF4AEE7FF4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 07:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjIKHsl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 03:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbjIKHsl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 03:48:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7816E1FE7
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 00:48:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03D29C43395
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 07:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694418450;
        bh=STtS2XPkeFve3dQpiB7o5qxhu/dI4cexTdu/ehOVCHE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=O8ifnJkOjj6PaTcvv+SIwlx0z/t18Y2pNyvGVaN7NXBcJQKhzrnEpIVf+fxSJM+CX
         DvEZgoT+cBx5Xydt5rSFZXDe/YHLlfNMNrX6v1qgPbWBdFLcWUdK5SlLiVamcVbspv
         HAaFmAx7jR863sq86N8PQ4t4durnYWimGbIeL/9Iis7i7at3RrRvPonWw3sucxAWgw
         lGJ7HJ0on5OBGXKXaVgNUjbkmkBmRsgNhshL/doWIfpvmdEtAC0KEDc9je0pI9efbi
         7hiDaZaFjw/zSZJFKuJfdklidkQAerYnE0tNABr8f0dRwWbPppTtWHgO6qNC8tflJf
         Ku1euDxPWcq4g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E80E3C53BC6; Mon, 11 Sep 2023 07:47:29 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Mon, 11 Sep 2023 07:47:29 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ubuntologic@inbox.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215943-11613-ZhZxfYEihp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215943-11613@https.bugzilla.kernel.org/>
References: <bug-215943-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215943

ubuntologic@inbox.ru changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ubuntologic@inbox.ru

--- Comment #11 from ubuntologic@inbox.ru ---
ATOM BIOS: CAPILANO
radeon 0000:02:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1=
024M
used)
radeon 0000:02:00.0: GTT: 1024M 0x0000000040000000 - 0x000000007FFFFFFF
[drm] Detected VRAM RAM=3D1024M, BAR=3D256M
[drm] RAM width 128bits DDR
[drm] radeon: 1024M of VRAM memory ready
[drm] radeon: 1024M of GTT memory ready.
[drm] Loading REDWOOD Microcode
[drm] Internal thermal controller without fan control
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
UBSAN: array-index-out-of-bounds in
/home/kernel/COD/linux/drivers/gpu/drm/radeon/radeon_atombios.c:2620:43
index 1 is out of range for type 'UCHAR [1]'
CPU: 2 PID: 140 Comm: systemd-udevd Not tainted 6.5.1-060501-generic
#202309020842
Hardware name: Acer Aspire 7741/JE70_CP, BIOS V1.26 04/28/2011
Call Trace:
 <TASK>
 dump_stack_lvl+0x48/0x70
 dump_stack+0x10/0x20
 __ubsan_handle_out_of_bounds+0xc6/0x110
 radeon_atombios_parse_power_table_4_5+0x3c9/0x3f0 [radeon]
 radeon_atombios_get_power_modes+0x205/0x210 [radeon]
 radeon_pm_init_dpm+0x8e/0x2f0 [radeon]
 radeon_pm_init+0xd0/0x100 [radeon]
 evergreen_init+0x158/0x400 [radeon]
 radeon_device_init+0x540/0xa90 [radeon]
 radeon_driver_load_kms+0xcc/0x2f0 [radeon]
 drm_dev_register+0x10e/0x240 [drm]
 radeon_pci_probe+0xec/0x180 [radeon]
 local_pci_probe+0x47/0xb0
 pci_call_probe+0x55/0x190
 pci_device_probe+0x84/0x120
 really_probe+0x1c7/0x410
 __driver_probe_device+0x8c/0x180
 driver_probe_device+0x24/0xd0
 __driver_attach+0x10b/0x210
 ? __pfx___driver_attach+0x10/0x10
 bus_for_each_dev+0x8d/0xf0
 driver_attach+0x1e/0x30
 bus_add_driver+0x127/0x240
 driver_register+0x5e/0x130
 ? __pfx_radeon_module_init+0x10/0x10 [radeon]
 __pci_register_driver+0x62/0x70
 __pci_register_driver+0x62/0x70
 radeon_module_init+0x4c/0xff0 [radeon]
 do_one_initcall+0x5e/0x340
 do_init_module+0x68/0x260
 load_module+0xba1/0xcf0
 ? ima_post_read_file+0xe8/0x110
 ? security_kernel_post_read_file+0x75/0x90
 init_module_from_file+0x96/0x100
 ? init_module_from_file+0x96/0x100
 idempotent_init_module+0x11c/0x2b0
 __x64_sys_finit_module+0x64/0xd0
 do_syscall_64+0x5c/0x90
 ? do_syscall_64+0x68/0x90
 ? syscall_exit_to_user_mode+0x37/0x60
 ? do_syscall_64+0x68/0x90
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8
RIP: 0033:0x7fe86023089d
Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 =
48
89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 0>
RSP: 002b:00007fffe4257b08 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 0000560b8b980a10 RCX: 00007fe86023089d
RDX: 0000000000000000 RSI: 00007fe8603b0458 RDI: 0000000000000013
RBP: 00007fe8603b0458 R08: 0000000000000000 R09: 00007fffe4257c30
R10: 0000000000000013 R11: 0000000000000246 R12: 0000000000020000
R13: 0000560b8b978140 R14: 0000000000000000 R15: 0000560b8b90faf0
 </TASK>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
