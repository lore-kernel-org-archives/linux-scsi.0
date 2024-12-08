Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A121EA65
	for <linux-scsi@vger.kernel.org>; Sun,  8 Dec 2024 18:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733682371; cv=none; b=MECQtZfBO2M/gI1gfsbtJPnFMp24Ft3gmNe28bEnm0L5tJmMMdMNyhn4a8i7LP1kdKl1bt5x9zT6JKGxShN7DaCnFhFxAlflg8LhYGXSZOheHOnyDzk/wQJtX1XYpVjdAYd5BXCeXruLB0bB12lcUtPJf+hjm+NwnOlR3hZ6pSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733682371; c=relaxed/simple;
	bh=zXFGGxYQxBDHP9MZI7vZwtps4V2mYH8HzN2Zeu+Qe30=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=QmghPZ5AqnoZSnQ/Prw8yPWCNe0wo4gJCsbDOxlIjgl9hRZ6AgtCbIBF/XtLRk3b0BlQT3r3cUQUWru8MMJa7v8bQNYe4/2MKhHpGb34SPYryKN/DHtFXa1ROu2HeEMzRz9a99VqigTw0NGOU0Ij5huOUe0D8JRL9qOtuhNL/2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NLPJ0eS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NLPJ0eS0"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DEBCC4CEE0
	for <linux-scsi@vger.kernel.org>; Sun,  8 Dec 2024 18:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733682370;
	bh=zXFGGxYQxBDHP9MZI7vZwtps4V2mYH8HzN2Zeu+Qe30=;
	h=From:To:Subject:Date:From;
	b=NLPJ0eS0THvUjU/yVGqVo9/mEFuttwRC/HFcAdhCegf0t++40/4i8QQw+ceCIE3tL
	 e2RZEdV39aftDPH38SWYT/nbAMy7z7IR6x2qL4LTc+SbXYEYFD9fBQhbwtqjEXRBxq
	 AqmkP7oU62gTqxJ9XSEIjJ3DIH2uT8+xQutb9dK5O8aoD640acUirw+arx2wD3pUT0
	 lZEyCfhsNh+2B7e3LDjUKaQ846ZkZQuMIDo3ntycHYcD4Wi0PjvmcCCUih/aymI7Rz
	 yyHQ8nUA5ezMfoQsYhQ/iQxd90S/ddXVdGVLLLwQ09JiOKTML9mXEEbF1EFT4D63Ys
	 nEK3Z1nDaF88w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8FE95C41612; Sun,  8 Dec 2024 18:26:10 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219575] New: UBSAN: array-index-out-of-bounds in
 drivers/message/fusion/mptsas.c:2446:22 ; index 1 is out of range for type
 'MPI_SAS_IO_UNIT0_PHY_DATA [1]'
Date: Sun, 08 Dec 2024 18:26:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jernej.jakob@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219575-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219575

            Bug ID: 219575
           Summary: UBSAN: array-index-out-of-bounds in
                    drivers/message/fusion/mptsas.c:2446:22 ; index 1 is
                    out of range for type 'MPI_SAS_IO_UNIT0_PHY_DATA [1]'
           Product: SCSI Drivers
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: jernej.jakob@gmail.com
        Regression: No

The following messages are printed when booting with a LSI SAS1068E card:

[  +0.000298] mptbase: ioc0: Initiating bringup
[  +0.099095] ioc0: LSISAS1068E B1: Capabilities=3D{Initiator}
[ +10.148787] scsi host8: ioc0: LSISAS1068E B1, FwRev=3D01210000h, Ports=3D=
1,
MaxQ=3D483, IRQ=3D16
[  +0.001685]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
[  +0.000039] UBSAN: array-index-out-of-bounds in
/var/tmp/portage/sys-kernel/gentoo-kernel-6.6.58-r1/work/linux-6.6/drivers/=
message/fusion/mptsas.c:2446:22
[  +0.000041] index 1 is out of range for type 'MPI_SAS_IO_UNIT0_PHY_DATA [=
1]'
[  +0.000032] CPU: 1 PID: 398 Comm: (udev-worker) Not tainted
6.6.58-gentoo-dist-hardened #1
[  +0.000038] Hardware name:  /DP965LT, BIOS MQ96510J.86A.1761.2009.0326.00=
01
03/26/2009
[  +0.000036] Call Trace:
[  +0.000030]  <TASK>
[  +0.000029]  dump_stack_lvl+0x47/0x60
[  +0.000036]  __ubsan_handle_out_of_bounds+0x95/0xd0
[  +0.000034]  mptsas_schedule_target_reset+0x5bd1/0x8dc0 [mptsas]
[  +0.000039]  mptsas_schedule_target_reset+0x6d92/0x8dc0 [mptsas]
[  +0.000036]  ? __pm_runtime_idle+0x4a/0xd0
[  +0.000033]  mptsas_schedule_target_reset+0x752f/0x8dc0 [mptsas]
[  +0.000037]  local_pci_probe+0x45/0xa0
[  +0.000032]  pci_device_probe+0xc7/0x260
[  +0.000034]  really_probe+0x19e/0x3e0
[  +0.000032]  ? __pfx___driver_attach+0x10/0x10
[  +0.000032]  __driver_probe_device+0x78/0x160
[  +0.000032]  driver_probe_device+0x1f/0x90
[  +0.000031]  __driver_attach+0xd2/0x1c0
[  +0.000032]  bus_for_each_dev+0x88/0xd0
[  +0.000032]  bus_add_driver+0x142/0x270
[  +0.000031]  driver_register+0x59/0x100
[  +0.000032]  init_module+0x143/0xff0 [mptsas]
[  +0.000035]  ? __pfx_init_module+0x10/0x10 [mptsas]
[  +0.000035]  do_one_initcall+0x5d/0x330
[  +0.000035]  do_init_module+0x90/0x270
[  +0.000032]  __do_sys_init_module+0x184/0x1c0
[  +0.000033]  do_syscall_64+0x5a/0x80
[  +0.000040]  entry_SYSCALL_64_after_hwframe+0x78/0xe2
[  +0.000034] RIP: 0033:0x7f69c467fe3e
[  +0.000034] Code: 48 8b 0d ed df 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2=
e 0f
1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 af
00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ba df 0c 00 f7 d8 64 8=
9 01
48
[  +0.000045] RSP: 002b:00007ffd65fe5c78 EFLAGS: 00000246 ORIG_RAX:
00000000000000af
[  +0.000038] RAX: ffffffffffffffda RBX: 0000563ec16483e0 RCX: 00007f69c467=
fe3e
[  +0.000032] RDX: 00007f69c485a31d RSI: 0000000000031a90 RDI: 0000563ec17d=
8e00
[  +0.000032] RBP: 0000563ec17d8e00 R08: 0000000000000007 R09: 000000000000=
0006
[  +0.000032] R10: 0000000000000070 R11: 0000000000000246 R12: 00007f69c485=
a31d
[  +0.000031] R13: 0000000000020000 R14: 0000563ec1644f50 R15: 0000563ec164=
a910
[  +0.000034]  </TASK>
[  +0.000029]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

The same array-index-out-of-bounds message is repeated a couple more times,=
 for
these lines:
drivers/message/fusion/mptsas.c:2448:22
drivers/message/fusion/mptsas.c:2451:7
drivers/message/fusion/mptsas.c:2443:46

I found this mailing list thread that fixes a couple similar arrays:
https://lkml.org/lkml/2023/8/6/165
but it's for mpt3sas, this card uses mptsas. The fix might be similar.

Otherwise the device functions normally.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
