Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8ECC25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 07:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjJZHfG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 03:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjJZHfF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 03:35:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5705184
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 00:35:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43688C433C7
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 07:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698305702;
        bh=g1WkkHE9iLkjlW9CWPRi4g6xKuQI2bti0OQS6Nbrvw0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=R5thFgvNllmZ0K60CRHixONSRI/6vYjdfycMfOhr9zl8mxuzFkdEOLiA6wNSBAyRe
         KyrGw89WcEVNz6csXIu1Q5SexavsL8OMDu4CBdIjY/JEZ2+Ht9jdHgYKBWNKgOB0lE
         ZOdIlvt0Pv2LuQIfVCU/gdwahpCxDkRXwn5f0Yx6sggvsai8G5uUZsDkZT5Ux68lHZ
         tD6WoEhaS7Kwx51wSbTbsf55rXdpncN2waiEUicTGNj5EsaRIBK2Q1nWiu+vTRKPUd
         5ZTf5xDtDmonZlfMF905tAFLaj1urfCM/aO2VnbY9gCP6Lfkao41XvJ0sm/4CGyykm
         2gAEpMuymi7Fg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2CA12C53BD3; Thu, 26 Oct 2023 07:35:02 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Thu, 26 Oct 2023 07:35:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: maokaman@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-FPzDpEKWWB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #24 from Maokaman (maokaman@gmail.com) ---
(In reply to Hannes Reinecke from comment #23)
> Can you try with the above patch?

The patch does not fix the issue.

=3D=3D=3D
Oct 25 21:41:24 server-name kernel: aacraid: Host adapter abort request.
                                  aacraid: Outstanding commands on (0,0,0,0=
):
Oct 25 21:41:24 server-name kernel: aacraid: Host adapter abort request.
                                  aacraid: Outstanding commands on (0,0,0,0=
):
Oct 25 21:41:24 server-name kernel: aacraid: Host bus reset request. SCSI h=
ang
?
Oct 25 21:41:24 server-name kernel: aacraid 0000:af:00.0: outstanding cmd:
midlevel-0
Oct 25 21:41:24 server-name kernel: aacraid 0000:af:00.0: outstanding cmd:
lowlevel-0
Oct 25 21:41:24 server-name kernel: aacraid 0000:af:00.0: outstanding cmd:
error handler-0
Oct 25 21:41:24 server-name kernel: aacraid 0000:af:00.0: outstanding cmd:
firmware-32
Oct 25 21:41:24 server-name kernel: aacraid 0000:af:00.0: outstanding cmd:
kernel-0
Oct 25 21:41:24 server-name kernel: aacraid 0000:af:00.0: Controller reset =
type
is 3
Oct 25 21:41:24 server-name kernel: aacraid 0000:af:00.0: Issuing IOP reset
Oct 25 21:41:24 server-name kernel: INFO: task worker:6701 blocked for more
than 122 seconds.
Oct 25 21:41:24 server-name kernel:       Not tainted 6.4.7-arch1-61 #1
Oct 25 21:41:24 server-name kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 25 21:41:24 server-name kernel: task:worker          state:D stack:0=20=
=20=20=20
pid:6701  ppid:1      flags:0x00004002
Oct 25 21:41:24 server-name kernel: Call Trace:
Oct 25 21:41:24 server-name kernel:  <TASK>
Oct 25 21:41:24 server-name kernel:  __schedule+0x3e8/0x13f0
Oct 25 21:41:24 server-name kernel:  schedule+0x5e/0xd0
Oct 25 21:41:24 server-name kernel:  io_schedule+0x46/0x70
Oct 25 21:41:24 server-name kernel:  folio_wait_bit_common+0x13d/0x350
Oct 25 21:41:24 server-name kernel:  ? __pfx_wake_page_function+0x10/0x10
Oct 25 21:41:24 server-name kernel:  folio_wait_writeback+0x2c/0x90
Oct 25 21:41:24 server-name kernel:  __filemap_fdatawait_range+0x80/0xe0
Oct 25 21:41:24 server-name kernel:  file_write_and_wait_range+0x8b/0xb0
Oct 25 21:41:24 server-name kernel:  xfs_file_fsync+0x5e/0x2a0 [xfs
2be3d2e4a125ddff8482931cb8f078f6393b16a6]
Oct 25 21:41:24 server-name kernel:  __x64_sys_fdatasync+0x4c/0x90
Oct 25 21:41:24 server-name kernel:  do_syscall_64+0x5c/0x90
Oct 25 21:41:24 server-name kernel:  ? syscall_exit_to_user_mode+0x1b/0x40
Oct 25 21:41:24 server-name kernel:  ? do_syscall_64+0x6b/0x90
Oct 25 21:41:24 server-name kernel:  ? exit_to_user_mode_prepare+0x132/0x1e0
Oct 25 21:41:24 server-name kernel:  ? syscall_exit_to_user_mode+0x1b/0x40
Oct 25 21:41:24 server-name kernel:  ? do_syscall_64+0x6b/0x90
Oct 25 21:41:24 server-name kernel:  ? syscall_exit_to_user_mode+0x1b/0x40
Oct 25 21:41:24 server-name kernel:  ? do_syscall_64+0x6b/0x90
Oct 25 21:41:24 server-name kernel:  ? syscall_exit_to_user_mode+0x1b/0x40
Oct 25 21:41:24 server-name kernel:  ? do_syscall_64+0x6b/0x90
Oct 25 21:41:24 server-name kernel:  ? do_syscall_64+0x6b/0x90
Oct 25 21:41:24 server-name kernel:  entry_SYSCALL_64_after_hwframe+0x72/0x=
dc
Oct 25 21:41:24 server-name kernel: RIP: 0033:0x7f9ca1d087aa
Oct 25 21:41:24 server-name kernel: RSP: 002b:00007f93237fd6c0 EFLAGS: 0000=
0293
ORIG_RAX: 000000000000004b
Oct 25 21:41:24 server-name kernel: RAX: ffffffffffffffda RBX: 000000000000=
0000
RCX: 00007f9ca1d087aa
Oct 25 21:41:24 server-name kernel: RDX: 0000000000000000 RSI: 000000000000=
0000
RDI: 000000000000000f
Oct 25 21:41:24 server-name kernel: RBP: 0000560d212c66a0 R08: 000000000000=
0000
R09: 0000000000000000
Oct 25 21:41:24 server-name kernel: R10: 00007f93237fd6e0 R11: 000000000000=
0293
R12: 0000560d1f112e80
Oct 25 21:41:24 server-name kernel: R13: 0000560d2107b6c8 R14: 0000560d212c=
d9f0
R15: 00007f9322ffe000
Oct 25 21:41:24 server-name kernel:  </TASK>
Oct 25 21:41:24 server-name kernel: aacraid 0000:af:00.0: IOP reset succeed=
ed
Oct 25 21:41:24 server-name kernel: aacraid: Comm Interface type2 enabled
Oct 25 21:41:24 server-name kernel: aacraid 0000:af:00.0: Scheduling bus re=
scan
Oct 25 21:41:24 server-name kernel: aacraid 0000:af:00.0: DDR cache data
recovered successfully
Oct 25 21:41:25 server-name kernel: sd 0:0:0:0: [sdb] Very big device. Tryi=
ng
to use READ CAPACITY(16).
Oct 25 21:41:25 server-name kernel: sd 0:0:1:0: [sda] Very big device. Tryi=
ng
to use READ CAPACITY(16).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
