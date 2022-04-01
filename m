Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE80C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 10:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345484AbiDAKyE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 06:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345232AbiDAKwp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 06:52:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C30D54689
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 03:50:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBCC1B82361
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 10:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B45BC3410F
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 10:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648810253;
        bh=vORGLpUjPW9hpSn9yhsfPIoSbk8cFbEHws+XTTPJEwY=;
        h=From:To:Subject:Date:From;
        b=KgO5lsXgu0oJAoFXzleUujO/wtXaExh7AdN28lxgdQb2c150wHm6AeVtyYqYt17s9
         TRIyu1PfL9ojdZCKycgcXJLGFnhCvQJ6rUjVJeXzFZfTJTVPfoPi2NJtWwYd37AJPJ
         keSJxk+a/IE75AqUTqvoivHMu4SMstv5LsR2Z723GFreRFhtMigI7SWuD/BFote7Bh
         THR/xhKwsXtNW+crbjK5vXJiJIm2qDA/iAUCazLT+KGYPEok5Zdq0Qns7deqbDfM5z
         E8Onq5VmITruuiV9t+hkdikdJ8QwRpmZZu+pkgFzmwDLKB3eK7Xnm9JASjQXiIixm3
         bt/Ip/BicyIgA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 83E28C05FD4; Fri,  1 Apr 2022 10:50:53 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] New: arcmsr driver on kernel 5.16 and up fails to
 initialize ARC-1280ML RAID controller
Date:   Fri, 01 Apr 2022 10:50:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jernej-bugzilla.kernel@ena.si
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-215788-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215788

            Bug ID: 215788
           Summary: arcmsr driver on kernel 5.16 and up fails to
                    initialize ARC-1280ML RAID controller
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.16, 5.17.1
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: jernej-bugzilla.kernel@ena.si
        Regression: No

Created attachment 300675
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300675&action=3Dedit
Bootup screenshot showing problem

I have an Areca ARC-1280ML RAID controller in my home server, and it appears
that something changed in kernel 5.16 causing the driver to hang with:

arcmsr0: abort device command of scsi id =3D 0 lun =3D 1
arcmsr0: abort device command of scsi id =3D 0 lun =3D 0
arcmsr0: abort device command of scsi id =3D 0 lun =3D 3
arcmsr: executing bus reset eh.....num_resets =3D 0, num_aborts =3D 3
arcmsr0: wait 'abort all outstanding command' timeout
arcmsr0: executing hw bus reset .....
arcmsr0: wait 'start adapter background rebuild' timeout
arcmsr: scsi bus reset eh returns with success
arcmsr0: abort device command of scsi id =3D 0 lun =3D 3
arcmsr: executing bus reset eh.....num_resets =3D 1, num_aborts =3D 4
arcmsr0: wait 'abort all outstanding command' timeout
arcmsr0: executing hw bus reset .....
arcmsr0: wait 'start adapter background rebuild' timeout
arcmsr: scsi bus reset eh returns with success

(this then repeats until system panics because it can't mount root)

When this happens, the card also stops responding on out-of-band network. W=
ith
kernel 5.15 there are no problems.

I normally run bcachefs kernels, but I also tested with regular 5.17.1 kern=
el,
where the same problem happens.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
