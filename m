Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4EFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 21:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiF1VRW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 17:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiF1VRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 17:17:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484A2326FB
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 14:17:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D84E661865
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 21:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4451BC341D6
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 21:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656451039;
        bh=DEQl6ReioOWAstMYFSE2LFlVmSdOoxlVN7EwL418rEk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GsIkI7c075eYgUu8QDUXwdb+QKW3BIKzwx4H/ote/KT9yq37bo3JK8KCdRX7mcJl/
         4a9i5qDmUIlUjfd7VqN12/HzEqGHfRn1w4IsVMorj5ESVrwOLl5mrJ6LHmj+GtqcXf
         3bH76icazcdrw0B0mw3OHpWAPAM9uKHEbLZYyMw421wJ+pDwUT2wzXyrRVMEpAA304
         XGwOBD1SeZWg6HoGXiMdY7hDEF+IHuYnByE6QeqgBUBHgOjDbOGATP+75Y0NXr1y5W
         ytT541BR6KWDcyurlQqY8L02M5kags6cjl6jjgZTk4mvXNhC4r9EZ0k4QIsKNhsnzz
         5xo3kDqo5kwPg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 31CE7C05FD6; Tue, 28 Jun 2022 21:17:19 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Tue, 28 Jun 2022 21:17:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jason600.groome@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215880-11613-9L88nnsUVm@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215880-11613@https.bugzilla.kernel.org/>
References: <bug-215880-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215880

jason600 (jason600.groome@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jason600.groome@gmail.com

--- Comment #26 from jason600 (jason600.groome@gmail.com) ---
I have been experiencing the same problem since 5.16. I have a hd and ssd (=
boot
from the ssd). Since 5.16 resume from suspend to ram is taking 6-8 seconds
(with 5.15 and before, it was less then 2 seconds.=20

I narrowed it down to the hd waiting for spinup to finish suspend. Hdparm h=
ad
not effect, also unmounting the drive had no effect. The only was to fix it=
 was
to remove the hd (mounted on sda) with=20

# echo 1 > /sys/block/sda/device/delete

Then it resumed in 2 seconds again, but I couldn=E2=80=99t access the hd ag=
ain until
reboot.

I installed the patches from https://github.com/bvanassche/linux/tree/sd-re=
sume
on Opensuse Tumbleweed kernel 5.18.6.

I can confirm the patches work, resume from suspend is now back to under 2
seconds, with no obvious problems.

Thank you very much.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
