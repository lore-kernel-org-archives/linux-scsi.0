Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BDBC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 02:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E316061930
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 02:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhC2CVB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Mar 2021 22:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhC2CUc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 Mar 2021 22:20:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BF7646023C
        for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2021 02:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616984431;
        bh=uHm/+mm4o/soH5LjCjLbdh4bkciqxQFwdWMFSuzqSVo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FpL6K+4z4O0bozexSmaVQth/X89QAJOk+WSbaqlyukSTeZpnzoGSI882xd0FJjyik
         EzP/5ODyK6QrA+j4vYWIH5WW867NkaUoWSvO5gBTB/gWnYPSO9xNVA8oEQgAkzAOJ/
         +ljZSXDwVsmY4pFa6/UMa/AKyD11I4r+I28QTbF3lN6xZkUrdXxiFAu/RzIz35irY3
         UL0zUHmrFw13s7dD3eHmjdtd+kXFrX6WfmShAH3AnYGhOyM/tR5Gjqpj8ft/EOV7Ov
         tsltwN13STN2YTHr2LHUpl7FwXpy6/IUwB4WI2bMquqhutouaPnbO+Y9SA7lCxs42O
         NuWGqqwhWak7w==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 187221] HPSA resetting logical / reset logical
Date:   Mon, 29 Mar 2021 02:20:31 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vsudoblog@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-187221-11613-L6BlLg4XdB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-187221-11613@https.bugzilla.kernel.org/>
References: <bug-187221-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D187221

--- Comment #4 from vsudo (vsudoblog@gmail.com) ---
(In reply to vsudo from comment #2)
> I have a HPE Gen9 using RAI5, I get this error and distributed on this
> server is resynced and I don't understand the reason why OS doesn't accept
> and failure disk in RAID5 is normal.
>=20
> [Sun Mar 28 09:47:04 2021] hpsa 0000:03:00.0: device is ready.
> [Sun Mar 28 09:47:04 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: reset logical=
=20
> completed successfully Direct-Access     HP       LOGICAL VO
> LUME   RAID-5 SSDSmartPathCap- En- Exp=3D1
> [Sun Mar 28 09:54:54 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: resetting
> logical  Direct-Access     HP       LOGICAL VOLUME   RAID-5 SSDSm
> artPathCap- En- Exp=3D1
> [Sun Mar 28 09:55:50 2021] hpsa 0000:03:00.0: device is ready.
> [Sun Mar 28 09:55:50 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: reset logical=
=20
> completed successfully Direct-Access     HP       LOGICAL VO
> LUME   RAID-5 SSDSmartPathCap- En- Exp=3D1
> [Sun Mar 28 09:56:35 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: resetting
> logical  Direct-Access     HP       LOGICAL VOLUME   RAID-5 SSDSm
> artPathCap- En- Exp=3D1
> [Sun Mar 28 09:57:01 2021] hpsa 0000:03:00.0: device is ready.
> [Sun Mar 28 09:57:01 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: reset logical=
=20
> completed successfully Direct-Access     HP       LOGICAL VO
> LUME   RAID-5 SSDSmartPathCap- En- Exp=3D1
> [Sun Mar 28 10:00:56 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: resetting
> logical  Direct-Access     HP       LOGICAL VOLUME   RAID-5 SSDSm
> artPathCap- En- Exp=3D1
> [Sun Mar 28 10:00:57 2021] hpsa 0000:03:00.0: device is ready.
> [Sun Mar 28 10:00:57 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: reset logical=
=20
> completed successfully Direct-Access     HP       LOGICAL VO
> LUME   RAID-5 SSDSmartPathCap- En- Exp=3D1
> [Sun Mar 28 10:05:13 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: resetting
> logical  Direct-Access     HP       LOGICAL VOLUME   RAID-5 SSDSm
> artPathCap- En- Exp=3D1
> [Sun Mar 28 10:07:16 2021] INFO: task scsi_eh_0:473 blocked for more than
> 120 seconds.
> [Sun Mar 28 10:07:16 2021]       Not tainted 4.15.0-55-generic #60-Ubuntu
> [Sun Mar 28 10:07:16 2021] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sun Mar 28 10:07:16 2021] scsi_eh_0       D    0   473      2 0x80000000
> [Sun Mar 28 10:07:16 2021] Call Trace:
> [Sun Mar 28 10:07:16 2021]  __schedule+0x291/0x8a0
> [Sun Mar 28 10:07:16 2021]  ? dev_printk_emit+0x4a/0x70
> [Sun Mar 28 10:07:16 2021]  schedule+0x2c/0x80
> [Sun Mar 28 10:07:16 2021]  schedule_timeout+0x1cf/0x350
> [Sun Mar 28 10:07:16 2021]  ? __dev_printk+0x3c/0x80
> [Sun Mar 28 10:07:16 2021]  ? dev_printk+0x56/0x80
> [Sun Mar 28 10:07:16 2021]  io_schedule_timeout+0x1e/0x50
> [Sun Mar 28 10:07:16 2021]  wait_for_completion_io+0xba/0x140
> [Sun Mar 28 10:07:16 2021]  ? wake_up_q+0x80/0x80
> [Sun Mar 28 10:07:16 2021]  hpsa_scsi_do_simple_cmd.isra.60+0xb3/0xf0 [hp=
sa]
> [Sun Mar 28 10:07:16 2021]  hpsa_eh_device_reset_handler+0x3e4/0x7b0 [hps=
a]
> [Sun Mar 28 10:07:16 2021]  ? __switch_to_asm+0x40/0x70
> [Sun Mar 28 10:07:16 2021]  ? __switch_to_asm+0x34/0x70
> [Sun Mar 28 10:07:16 2021]  ? scsi_device_put+0x2b/0x30
> [Sun Mar 28 10:07:16 2021]  scsi_eh_ready_devs+0x333/0xbf0
> [Sun Mar 28 10:07:16 2021]  ? __pm_runtime_resume+0x5b/0x80
> [Sun Mar 28 10:07:16 2021]  ? scsi_try_target_reset+0x90/0x90
> [Sun Mar 28 10:07:16 2021]  scsi_error_handler+0x4c3/0x5b0
> [Sun Mar 28 10:07:16 2021]  kthread+0x121/0x140
> [Sun Mar 28 10:07:16 2021]  ? scsi_eh_get_sense+0x200/0x200
> [Sun Mar 28 10:07:16 2021]  ? kthread_create_worker_on_cpu+0x70/0x70
> [Sun Mar 28 10:07:16 2021]  ret_from_fork+0x35/0x40
> [Sun Mar 28 10:07:16 2021] INFO: task systemd-journal:109135 blocked for
> more than 120 seconds.
> [Sun Mar 28 10:07:16 2021]       Not tainted 4.15.0-55-generic #60-Ubuntu
> [Sun Mar 28 10:07:16 2021] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sun Mar 28 10:07:16 2021] systemd-journal D    0 109135      1 0x00000320
> [Sun Mar 28 10:07:16 2021] Call Trace:
> [Sun Mar 28 10:07:16 2021]  __schedule+0x291/0x8a0
> [Sun Mar 28 10:07:16 2021]  ? intel_pstate_update_pstate+0x40/0x40
>=20
> My website: https://vsudo.net

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
