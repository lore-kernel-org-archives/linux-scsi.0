From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43359] New: LVM volumes not detected
Date: Sat,  9 Jun 2012 07:33:27 +0000 (UTC)
Message-ID: <bug-43359-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40309 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab2FIHdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jun 2012 03:33:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DA5A9203FE
	for <linux-scsi@vger.kernel.org>; Sat,  9 Jun 2012 07:33:29 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id E60B4203F7
	for <linux-scsi@vger.kernel.org>; Sat,  9 Jun 2012 07:33:28 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D43359

           Summary: LVM volumes not detected
           Product: IO/Storage
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: francois.valenduc@tvcablenet.be
        Regression: No


With kernel 3.5-rc1, LVM volumes are not detected. A bisection leads to=
 the
following commit:

commit 794c10fa0fa4d1781c5651c31e3d4d0b71629128
Author: J=C3=B6rn Engel <joern@logfs.org>
Date:   Thu Apr 12 17:32:48 2012 -0400

    [SCSI] sg: remove while (1) non-loop

    The while (1) construct isn't actually a loop at all.  So let's not
    pretent and obfuscate the code.

    Signed-off-by: Joern Engel <joern@logfs.org>
    Acked-by: Douglas Gilbert <dgilbert@interlog.com>
    Signed-off-by: James Bottomley <JBottomley@Parallels.com>

Unfortunately, I cannot revert it on top of 3.5-rc1 or 3.5-rc2 to confi=
rm this.
My harddisk is using the AHCI drivers. Can somebody explains what's hap=
pening ?

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
