Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F448C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 23:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62202610A4
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 23:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhIAXth (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 19:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230143AbhIAXtf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Sep 2021 19:49:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D7612610A1
        for <linux-scsi@vger.kernel.org>; Wed,  1 Sep 2021 23:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630540117;
        bh=le36FUgFKh7mwdHstRfQev7kaDSlL/XsUQdfHVKEIPA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XbkXKnB0s/rzSMmDKaV9h5PODg5xp+BQWIGO179CuZ6d4w5Y+lkdp+ihOMr6NB8T/
         L0vwjzLLftohJo65C/vCMQQaIwBhN6vwT3oGyhXBEXAg/2JQpuRj5Nj3oPnGpkp1vK
         XWnziPQ+FCrQWg/LjWoosht5rcjmJYak1BS/YVYQzdqJqDzgIU21U8SoD9C96FI6JV
         DZPrrDgQWbD4z1JXTf5XJW56BP0r/zeBJgdNEOl0pbfWOrtH8Dx6PWh8Hu3DpMVnGS
         E+BlfuvpxZbRp2M5mc9FImKEPj61lNjJX6qVSUblzzAtPlYUQLoF9VpT6NN8u3HH6v
         M0N/4WIEaz13Q==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214147] ISCSI broken in last release
Date:   Wed, 01 Sep 2021 23:48:37 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: michael.christie@oracle.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214147-11613-lBxVNo65LE@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214147-11613@https.bugzilla.kernel.org/>
References: <bug-214147-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214147

--- Comment #2 from michael.christie@oracle.com ---
On 8/23/21 6:08 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D214147
>=20
>             Bug ID: 214147
>            Summary: ISCSI broken in last release
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 5.13.12
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>           Assignee: linux-scsi@vger.kernel.org
>           Reporter: slavon.net@gmail.com
>         Regression: Yes
>=20
> Created attachment 298441
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D298441&action=3Dedit
> dmesg log
>=20
> After some time iscsi go to broke and help only reboot
>=20
What are you doing when you hit the issue?

What does your target setup look like? What are you using for the
backing store?

Are you able to build your own kernels?

The only major changes between 5.12 and 5.13 is some target patches
to batch cmds. However, it looks like you start to hit a problem
earlier than when that code comes into play. We first see you hit
a data out timeout, so we don't even have all the data for the
cmd, so the target changes in 5.13 don't come into play yet.

[10931.107057] Unable to recover from DataOut timeout while in ERL=3D0, clo=
sing
iSCSI connection for I_T Nexus
iqn.1991-05.com.microsoft:vhost11.dev.obs.group,i,0x400001370002,iqn.2003-0=
1.org.linux-iscsi.vm2.x8664:sn.b07943625401,t,0x01


However, we do see some cmds have made it to the core target layer
because we can see the target layer is waiting on cmds to complete
for part of the lun reset handling:

[19906.593285] INFO: task kworker/4:1:3770999 blocked for more than 122
seconds.
[19906.603670]       Tainted: P           O      5.13.12-1.el8.elrepo.x86_6=
4 #1
[19906.613975] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this
message.
[19906.624208] task:kworker/4:1     state:D stack:    0 pid:3770999 ppid:  =
   2
flags:0x00004000
[19906.624212] Workqueue: events target_tmr_work [target_core_mod]
[19906.624247] Call Trace:
[19906.624249]  __schedule+0x396/0x8a0
[19906.624252]  schedule+0x3c/0xa0
[19906.624255]  schedule_timeout+0x215/0x2b0
[19906.624258]  ? kasprintf+0x4e/0x70
[19906.624261]  wait_for_completion+0x9e/0x100
[19906.624264]  target_put_cmd_and_wait+0x55/0x80 [target_core_mod]
[19906.624279]  core_tmr_lun_reset+0x38b/0x660 [target_core_mod]
[19906.624294]  target_tmr_work+0xb4/0x110 [target_core_mod]
[19906.624309]  process_one_work+0x230/0x3d0
[19906.624312]  worker_thread+0x2d/0x3e0
[19906.624314]  ? process_one_work+0x3d0/0x3d0
[19906.624316]  kthread+0x118/0x140
[19906.624318]  ? set_kthread_struct+0x40/0x40
[19906.624320]  ret_from_fork+0x1f/0x30

and we can see iscsi layer not able to relogin because of outstanding
cmds/tmfs.

I can send you a patch that reverts the core target patches. If we can
rule them out then it would help narrow things down.

Or, because it sounds like this is easy to reproduce we can turn on some
extra lio debugging.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
