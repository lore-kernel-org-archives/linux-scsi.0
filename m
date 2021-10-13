Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76848C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 20:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FB3361139
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 20:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhJMVAp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 17:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229496AbhJMVAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 17:00:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 44C6161152
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 20:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634158721;
        bh=vHkdZr0X01FWXKFN6ZI3blgYE8cCVHKyCXefT/ToWt8=;
        h=From:To:Subject:Date:From;
        b=MBcWRUiRhrDerO/BzRq8ornf4vmA+wHr1N7FNKBr6DxzUucMni/uHt8hRCSydZOir
         GqlShEY+FfXBXRzHrWtyaiTKk1VGYCiw+YxaUoMJsxlw4+b1rHHGdPdcp8JL1HRHzR
         kQNmSBuZ24gT//5U9eav2Zhxt08JOmzZbZ0FiQFG2dXgKgw7HYveSWsEO0DMek/Oq5
         T+IzBg+c9/8JERuE+NWQimczBjpmk0GP24lVzAm5uC1zoqNESjrXJL67SvCFzX5FQT
         sVb2d9WGlcQUawd+rykxQTukBxmlmZnS8juQGPcYv4KFvm1N40SYl+W/Jbd6XYXRUw
         YYI9+UtuQmjSQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214711] New: Memory leakage from kernel to user space
Date:   Wed, 13 Oct 2021 20:58:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bao00065@umn.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-214711-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214711

            Bug ID: 214711
           Summary: Memory leakage from kernel to user space
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.15-rc5
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: bao00065@umn.edu
        Regression: No

Hi Maintainer,
I just found an uninitialized value use bug that causes memory leakage from
kernel to user space. Here are the details:

Vulnerable function is in /drivers/scsi/scsi_ioctl.c



static int scsi_put_cdrom_generic_arg(const struct cdrom_generic_command *c=
gc,
                                      void __user *arg)
{
#ifdef CONFIG_COMPAT
        if (in_compat_syscall()) {
                struct compat_cdrom_generic_command cgc32 =3D {
                        .buffer         =3D (uintptr_t)(cgc->buffer),
                        .buflen         =3D cgc->buflen,
                        .stat           =3D cgc->stat,
                        .sense          =3D (uintptr_t)(cgc->sense),
                        .data_direction =3D cgc->data_direction,
                        .quiet          =3D cgc->quiet,
                        .timeout        =3D cgc->timeout,
                        .unused         =3D (uintptr_t)(cgc->unused),
                };
                memcpy(&cgc32.cmd, &cgc->cmd, CDROM_PACKET_SIZE);

                if (copy_to_user(arg, &cgc32, sizeof(cgc32)))=20
                        return -EFAULT;

                return 0;
        }
#endif
        if (copy_to_user(arg, cgc, sizeof(*cgc)))
                return -EFAULT;

        return 0;
}

The issue is, struct cgc32 is partially initialized since pad[3] are not
initialized. Then this struct is passed to copy_to_user, and 3 bytes are le=
aked
from kernel space to userspace.=20


The struct is declared here:
struct compat_cdrom_generic_command {
        unsigned char   cmd[CDROM_PACKET_SIZE];
        compat_caddr_t  buffer;
        compat_uint_t   buflen;
        compat_int_t    stat;
        compat_caddr_t  sense;
        unsigned char   data_direction;
        unsigned char   pad[3];
        compat_int_t    quiet;
        compat_int_t    timeout;
        compat_caddr_t  unused;
};
#endif

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
