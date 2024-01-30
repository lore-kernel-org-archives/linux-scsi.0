Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99A156B94
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 09:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706605719; cv=none; b=D+YBzS2NgOAOv4rYVIWRMXbunDVOW3FhSzIrOX4WM2DkVowHTjKWxtPhMASBfQNCg09Rcfkd3WGlU2BFW0q8/BmZy4tiVEm5qDYDgCayj3IV4oS682y8NAKai4Fb85X+mxqUtdp5krLS5WnWIPnwL15dMHnIrYVNyXgSUQjSCUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706605719; c=relaxed/simple;
	bh=i5DY1yGqPhYYG5uV22sZe3rPQe+weo6zAUjBQ0d30HM=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=QIyUNr++TemFpWoAeLqUe9Jfw4fPGBD+jQeYZtCX+D1LNaSxbHcosTUgTWcpLCtfQpqp3wf6wCd02KLGywNJJZX95eXDJZ+X8ar6bI4/ruMoFhYjqXum7C/uS+9LqWq0AFoDGoyX0xYfG/HgRrwsErYZPWitILqs4tRCSuZHEjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0ZfCX6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0ZfCX6O"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A543C43390
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 09:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706605719;
	bh=i5DY1yGqPhYYG5uV22sZe3rPQe+weo6zAUjBQ0d30HM=;
	h=From:To:Subject:Date:From;
	b=a0ZfCX6OKk8qqfxuXLY5d7RH0u3gV3BC7j7X67aFKF4f4i4fqSjkHjxKCtMuND2jN
	 qpNjIzkwYv1EkYTM45TdgZSWm7c8tx4yythUhzO9wJmsnHPHrsVoupWHiadVbVdpIZ
	 pJQqrfDy0cKvH2+R0pC6XXZ2pwhH+tl+Iv6xwkTcW7y+U436ZVTz2srRzrm0Of6ZIs
	 zHDjXaRUN0mLzwFhOfZ6QgVCfI1Iwq5ZlxQwL0EPPDES2uRlSO1k90sPyjhbUeGrZ8
	 HAwPWNN10M5hUkFdwQrkxV2MnVzkHNzHjwqr9kPJqo5X0Smy0s/Ay4Sc3zbGvOqE36
	 JexaDtiuuhCkw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 42557C53BD2; Tue, 30 Jan 2024 09:08:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 218436] New: UBSAN: array-index-out-of-bounds in
 drivers/scsi/aacraid/aachba.c
Date: Tue, 30 Jan 2024 09:08:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: temnota.am@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-218436-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218436

            Bug ID: 218436
           Summary: UBSAN: array-index-out-of-bounds in
                    drivers/scsi/aacraid/aachba.c
           Product: SCSI Drivers
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: temnota.am@gmail.com
        Regression: No

UBSAN produced warnings on boot:

UBSAN: array-index-out-of-bounds in
/ml-build/mainline-stable/drivers/scsi/aacraid/aachba.c:3900:10
index 1 is out of range for type 'sgentryraw [1]'
CPU: 2 PID: 137 Comm: (udev-worker) Not tainted 6.7-672-generic #0~lch12
Hardware name: Intel S5000VSA/S5000VSA, BIOS S5000.86B.15.00.0101.110920101=
604
11/09/2010
Call Trace:
 <TASK>
 dump_stack_lvl+0x48/0x70
 dump_stack+0x10/0x20
 __ubsan_handle_out_of_bounds+0xc6/0x110
 aac_build_sgraw+0x261/0x2d0 [aacraid]
 aac_read_raw_io+0xaa/0x1c0 [aacraid]
 aac_read+0xf5/0x2a0 [aacraid]
 aac_scsi_cmd+0x7c3/0xe50 [aacraid]
 ? sd_init_command+0xfc/0x430
 aac_queuecommand+0x1b/0x30 [aacraid]
 scsi_dispatch_cmd+0x91/0x240
 scsi_queue_rq+0x2cc/0x680
 blk_mq_dispatch_rq_list+0x133/0x580
 ? sbitmap_get+0x73/0x180
 __blk_mq_do_dispatch_sched+0xbb/0x300
 __blk_mq_sched_dispatch_requests+0x151/0x190
 blk_mq_sched_dispatch_requests+0x37/0x80
 blk_mq_run_hw_queue+0x1c5/0x210
 blk_mq_dispatch_plug_list+0x13c/0x2c0
 blk_mq_flush_plug_list.part.0+0x5c/0x190
 blk_mq_flush_plug_list+0x19/0x30
 __blk_flush_plug+0xdf/0x130
 blk_finish_plug+0x31/0x50
 read_pages+0x1c2/0x290
 page_cache_ra_unbounded+0x135/0x1d0
 force_page_cache_ra+0x9b/0xd0
 page_cache_sync_ra+0x30/0xa0
 filemap_get_pages+0x109/0x3b0
 filemap_read+0xf5/0x460
 blkdev_read_iter+0x6d/0x160
 vfs_read+0x1fe/0x330
 ksys_read+0x73/0x100
 __x64_sys_read+0x19/0x30
 do_syscall_64+0x5f/0xf0
 ? count_memcg_events.constprop.0+0x2a/0x50
 ? handle_mm_fault+0xad/0x380
 ? do_user_addr_fault+0x21e/0x6c0
 ? exit_to_user_mode_prepare+0x30/0xb0
 ? irqentry_exit_to_user_mode+0x17/0x20
 ? irqentry_exit+0x43/0x50
 ? exc_page_fault+0x94/0x1b0
 entry_SYSCALL_64_after_hwframe+0x6e/0x76
RIP: 0033:0x77ed57d5509d
Code: 31 c0 e9 c6 fe ff ff 50 48 8d 3d 66 55 0a 00 e8 89 fe 01 00 66 0f 1f =
84
00 00 00 00 00 80 3d 41 25 0e 00 00 74 17 31 c0 0f 05 <48> 3d 00 f0 ff ff 7=
7 5b
c3 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec
RSP: 002b:00007ffdfc4944b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 000064784280e420 RCX: 000077ed57d5509d
RDX: 0000000000040000 RSI: 000077ed57522038 RDI: 000000000000000d
RBP: 0000000000000000 R08: 00000000ffffffff R09: 0000000000000000
R10: 0000000000000022 R11: 0000000000000246 R12: 000077ed57522010
R13: 0000000000040000 R14: 000064784280e478 R15: 000077ed57522028
 </TASK>

and with same backtrace with structure access on lines 3901-3905:
UBSAN: array-index-out-of-bounds in
/ml-build/mainline-stable/drivers/scsi/aacraid/aachba.c:3901:10
index 1 is out of range for type 'sgentryraw [1]'

UBSAN: array-index-out-of-bounds in
/ml-build/mainline-stable/drivers/scsi/aacraid/aachba.c:3902:10
index 1 is out of range for type 'sgentryraw [1]'

UBSAN: array-index-out-of-bounds in
/ml-build/mainline-stable/drivers/scsi/aacraid/aachba.c:3903:10
index 1 is out of range for type 'sgentryraw [1]'

UBSAN: array-index-out-of-bounds in
/ml-build/mainline-stable/drivers/scsi/aacraid/aachba.c:3904:10
index 1 is out of range for type 'sgentryraw [1]'

UBSAN: array-index-out-of-bounds in
/ml-build/mainline-stable/drivers/scsi/aacraid/aachba.c:3905:10
index 1 is out of range for type 'sgentryraw [1]'

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
