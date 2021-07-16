Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09DCC12002
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 22:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99EED613EE
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 22:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbhGPWkE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 18:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237699AbhGPWkB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jul 2021 18:40:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E4599613EE
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jul 2021 22:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626475025;
        bh=E7ztcrSMFbE73dOv8B/18ZBDZVm5N9k3txpLcm/CBq8=;
        h=From:To:Subject:Date:From;
        b=MCoHL5C6XvaVjuY/PMi1eOJaEkHUuqoxICzTn6z21eXxo4HFeGqnTTZaBLjod3ox4
         nNcom04Gc/u0BXvS1IR147DA6Gk4I4ReJr7Ar4T8nK1erMyvwIOqN6PKXW81qOK5ma
         hVaD0+hWgtmO0RVxEY0QVkVmPswkVMrl4wpf0HsKr9bogK4qLl/lOGaM+p4J+P6G49
         PiEW0UZT6Ug+ZaFLloGGwVsYN+v7UZLy3CGoYXi86uKRrpPC5QoALXpPtHlxGWe3iI
         qdoAI8MJQfjvhTHBcB4Q8oP8RALmHZe74E7Gafut9lxfadlz/J9kaaMqJ6O+ChPmDA
         PwKXYDl3xYIhA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] New: CD tray ejected on hibernate resume
Date:   Fri, 16 Jul 2021 22:37:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: computerpro_58@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-213759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

            Bug ID: 213759
           Summary: CD tray ejected on hibernate resume
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.10.48
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: computerpro_58@hotmail.com
        Regression: No

After resuming from hibernation (shutdown-disk), CD tray (which is empty and
untouched) is ejected on resume. I use a LUKS-encrypted root partition, and=
 the
tray is always ejected before my distro NixOS (cryptsetup) prompts for my k=
ey.

I bi-sect'd the problem commit down to this one:

From: ManYi Li <limanyi@uniontech.com>
To: axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        ManYi Li <limanyi@uniontech.com>
Subject: [PATCH] sr: Fix get the error media event code
Date: Fri, 11 Jun 2021 17:44:02 +0800
Message-ID: <20210611094402.23884-1-limanyi@uniontech.com> (raw)

Eject the specified slot or media through a mechanical switch on the Drive,
med->media_event_code is 3 not 1 in the sr_get_events().

If disk_flush_events() and sr_block_open() are called,
clearing is 1 or 3 in the sr_check_events(),then it report
DISK_EVENT_MEDIA_CHANGE not DISK_EVENT_EJECT_REQUEST.

If disk_flush_events() and sr_block_open() aren't called,
clearing is 0 in the sr_check_events(),then it doesn't
report any event.

Signed-off-by: ManYi Li <limanyi@uniontech.com>
---
 drivers/scsi/sr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 482a07b662a9..94c254e9012e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -220,6 +220,8 @@ static unsigned int sr_get_events(struct scsi_device *s=
dev)
                return DISK_EVENT_EJECT_REQUEST;
        else if (med->media_event_code =3D=3D 2)
                return DISK_EVENT_MEDIA_CHANGE;
+       else if (med->media_event_code =3D=3D 3)
+               return DISK_EVENT_EJECT_REQUEST;
        return 0;
 }


That commit was backported onto a number of kernels, so I can reproduce thi=
s on
a number of different kernels (master, stable, LTS). I'm not sure if this i=
s a
bug in the CD-reader (tossing back an incorrect status), or if the bug is
within this driver?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
