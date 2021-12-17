Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC667C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Dec 2021 20:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhLQUgo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Dec 2021 15:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236056AbhLQUgo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Dec 2021 15:36:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD251C061574
        for <linux-scsi@vger.kernel.org>; Fri, 17 Dec 2021 12:36:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B783B827DC
        for <linux-scsi@vger.kernel.org>; Fri, 17 Dec 2021 20:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17213C36AE5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Dec 2021 20:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639773401;
        bh=/Vdwg20NP4p02qeCP1y8+SkX8hpFC2HkJff71JSqpkI=;
        h=From:To:Subject:Date:From;
        b=dbH23yiWMx0AnSZ/80G8wbFtJb27mt4oP66aUzF2MIisyfCxbxWfZH4sio9Wvb+TN
         wGNeO3DrVFNzeQQRLc49JSczDgrl8M3+szeZbUXb92KtxtQcx9wgCmOKiSGjerhw3B
         Q82PS1+Nnp2uv1ZZ4hg/5Uk4+QgAw26OH4lLg53/f+kn69BObYhEap8Qlag0SznZ1j
         vICc7Reo3D0TbVhtBnycDenPf0dhXm8KHE9en88ZMbVhAO+Hhnw3TXu3J3IvqaZauq
         hGu2m1AugPPoLUDPkG4BbYDNYhx6dGwl9QdQabxF9l5Zto7YpcyLvR44xtgewzkLLt
         m2j5Wo6xFW6Ig==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 05C3360F54; Fri, 17 Dec 2021 20:36:41 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215353] New: VMWare LVM partitions not recognized, sees base
 disk, fails to Boot
Date:   Fri, 17 Dec 2021 20:36:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: DC395X
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: richr410@yahoo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215353-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215353

            Bug ID: 215353
           Summary: VMWare LVM partitions not recognized, sees base disk,
                    fails to Boot
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.4.126+
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: DC395X
          Assignee: scsi_drivers-dc395x@kernel-bugs.osdl.org
          Reporter: richr410@yahoo.com
        Regression: No

Hello,=20

VMWare LVM partitions are not recognized by the 5.4.126+ LT kernels; it sees
the base /dev/sda disk, but thats its, stalls, fails to Boot trying to acce=
ss
"/dev/mapper/...."

Kernels 5.4.125 and prior DO WORK, but 5.4.126+ DO NOT.

I have been able to isolate the kernel failing to commit
"1e209effe36cbf0a939844bcf9defd3fe1e2f593" in LT kernel 5.4.126.

[And Yes the "rd.lvm.lv=3D" and VG/LV names match the grub line (ie. lvs -o
vg_name,lv_name)]

So commit "1e209effe36cbf0a939844bcf9defd3fe1e2f593" BREAKS kernel recognit=
ion
of VMWare LVM partitions (but yes kernel DOES see /dev/sda but thats it).

This is on ESX 6.7.

Thanks

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
