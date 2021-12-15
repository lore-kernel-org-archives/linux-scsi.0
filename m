Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B98C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 13:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242672AbhLONHr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 08:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbhLONHq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 08:07:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCADC061574
        for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2021 05:07:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CCC6617F9
        for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2021 13:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6848BC34604
        for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2021 13:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639573665;
        bh=PJtpM5Ywq+tE+G6Hp+F0rFa9dASzY/8ZOv0rmBfTXGk=;
        h=From:To:Subject:Date:From;
        b=qNMlqiJKwbADfGJN0Pj6bgP7ed/9lw3GmAfSQenrsHYOacUAmLqQ22FH8EBGyo+LU
         9G09UCSSCF151GXCSHogG0NMIEM5EPohH2NdSnPRiAcQphynB7miA4764Hh9YZVZu+
         GnwN/g341StvuSehaQhzOCoFqfLKuzdt5pqhvBcZHCyOW6WlDVgBvTHrgSJHAPRTMZ
         w+kKRpBorzt8Fu+jHC02FqbNtp2pQzkUYp0xr134pr79DxG6D6sEGkenZpo4NjVOkB
         +m0KyMt3WUXpZlPbwLO0rGLV/Sggz7uYeuSyYtI9PmdHpSXdz8wdegt2ahQ9Ly2vZT
         gDHCNzhCm/Tzw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 4FF6660E8E; Wed, 15 Dec 2021 13:07:45 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215333] New: UAS keeps resetting disks
Date:   Wed, 15 Dec 2021 13:07:44 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: d.bergloev@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-215333-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215333

            Bug ID: 215333
           Summary: UAS keeps resetting disks
           Product: IO/Storage
           Version: 2.5
    Kernel Version: Any
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: d.bergloev@gmail.com
        Regression: No

Created attachment 300031
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300031&action=3Dedit
UAS Log from boot

Hi.=20

Not sure what the benefit of UAS should supposed to be, considering that is
never works, besides breaking things. I have had issues with this using
specific USB Disks with live installers in the past, and now I spent a whole
day debugging boot issues on two servers, caused by UAS on a specific USB/S=
ata
adapter.=20

https://superuser.com/questions/1693125/boot-loop-with-certain-sata-to-usb-=
adaptors/1693143#1693143=20

I have written in detail the issue in the above link along with other detai=
ls
from various testing that I have done. But in general here is the problem.=
=20

I had two different types of USB3/Sata adapters. One from Hama that seamed =
to
work and another from DeLock that would cause boot issues due to the fact t=
hat
UAS kept resetting the disks. I found that adding a quirks to usb-storage
module, would stop that adapter from being used by UAS and would make it wo=
rk
properly. I also found that the Hama adapter was already pre-disabled within
the usb-storage module, which is why it worked out-of-box. But it also means
that neither of the adapters works with UAS. So if nothing works with this,=
 but
rather just produces problems for people (There are a ton of these issues
across the web), why not remove it altogether. There may be some benefits f=
rom
UAS (When it works), but considering how much havoc it creates, is it worth=
 it?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
