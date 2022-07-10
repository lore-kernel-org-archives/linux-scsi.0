Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD376C43334
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jul 2022 09:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiGJJrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jul 2022 05:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJJrR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jul 2022 05:47:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBE912D12
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jul 2022 02:47:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18FC0CE0AFE
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jul 2022 09:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28154C341C6
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jul 2022 09:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657446432;
        bh=efxFGAAlln2KOPwwrpl39c3IbYEys6AEZBdNEjciPzQ=;
        h=From:To:Subject:Date:From;
        b=CYmGUF2CjP8dsedmgzkEPtuoGChAQgHgRKVBUpfl+1C/zOMSIOHhbwOVIDSW0Kf9q
         V96XPJpTqLPstW4QEp9SsT3QYnwAAiKnZKhn6hvOIuhQRbcb/Unpz2oCL8OHYL5uc0
         dfKw1War4MWg+KMhJKssqV9g06T0c/ShBzqE8u/oV+bBtPAGtIav8+APUHJ+1dTBOv
         LoC6RoQIm1JvdRZt1mmofwqRYrqwcrnKo1JVW7UHI1TqtFLWWFyIlkz3AqNGF4l6WL
         CtQ2ZzaeGtCker9k+QLsiRo3ryr9aJyZBQW0EsyP4OSJuGOgjZdmXdYc56rHbe760u
         2bAIHcLOwskMA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F1378C05FD2; Sun, 10 Jul 2022 09:47:11 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216232] New: mysterious block devices are shown under /dev
 folder
Date:   Sun, 10 Jul 2022 09:47:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-qla2xxx@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: QLOGIC QLA2XXX
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yshxxsjt715@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216232-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216232

            Bug ID: 216232
           Summary: mysterious block devices are shown under /dev folder
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.4.61
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: QLOGIC QLA2XXX
          Assignee: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
          Reporter: yshxxsjt715@gmail.com
        Regression: No

we are using linux kernel 5.4.61 and fibre channel card is qlogic's
ISP2722-based 16/32Gb adapter card.

the problem is that we are seeing some devices with lun 768 with size of 51=
2B
shown under /dev folder. In the syslog we saw something like

Jul 10 17:00:08 hci01 kernel: [21675145.568997] scsi_io_completion_action: =
24
callbacks suppressed
Jul 10 17:00:08 hci01 kernel: [21675145.569005] sd 6:0:0:768: [sdau] tag#12=
98
FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
Jul 10 17:00:08 hci01 kernel: [21675145.569011] sd 6:0:0:768: [sdau] tag#12=
98
Sense Key : Illegal Request [current]
Jul 10 17:00:08 hci01 kernel: [21675145.569015] sd 6:0:0:768: [sdau] tag#12=
98
Add. Sense: Logical block address out of range
Jul 10 17:00:08 hci01 kernel: [21675145.569019] sd 6:0:0:768: [sdau] tag#12=
98
CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
Jul 10 17:00:08 hci01 kernel: [21675145.569021] print_req_error: 24 callbac=
ks
suppressed
Jul 10 17:00:08 hci01 kernel: [21675145.569025] blk_update_request: critical
target error, dev sdau, sector 0 op 0x0:(READ) flags 0x80700 phys_seg 1 prio
class 0
Jul 10 17:00:08 hci01 kernel: [21675145.601879] sd 6:0:0:768: [sdau] tag#12=
99
FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
Jul 10 17:00:08 hci01 kernel: [21675145.601883] sd 6:0:0:768: [sdau] tag#12=
99
Sense Key : Illegal Request [current]
Jul 10 17:00:08 hci01 kernel: [21675145.601886] sd 6:0:0:768: [sdau] tag#12=
99
Add. Sense: Logical block address out of range
Jul 10 17:00:08 hci01 kernel: [21675145.601888] sd 6:0:0:768: [sdau] tag#12=
99
CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
Jul 10 17:00:08 hci01 kernel: [21675145.601891] blk_update_request: critical
target error, dev sdau, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio cl=
ass
0
Jul 10 17:00:08 hci01 kernel: [21675145.604213] buffer_io_error: 22 callbac=
ks
suppressed
Jul 10 17:00:08 hci01 kernel: [21675145.604215] Buffer I/O error on dev sda=
u,
logical block 0, async page read
Jul 10 17:00:08 hci01 kernel: [21675145.634149] sd 6:0:0:768: [sdau] tag#13=
00
FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
Jul 10 17:00:08 hci01 kernel: [21675145.634152] sd 6:0:0:768: [sdau] tag#13=
00
Sense Key : Illegal Request [current]
Jul 10 17:00:08 hci01 kernel: [21675145.634155] sd 6:0:0:768: [sdau] tag#13=
00
Add. Sense: Logical block address out of range
Jul 10 17:00:08 hci01 kernel: [21675145.634158] sd 6:0:0:768: [sdau] tag#13=
00
CDB: Read(10) 28 00 00 00 00 00 00 00 01 00

here, the lun id of 768 does not exist on SAN but when I try to manually de=
lete
it, after some seconds it still appears.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
