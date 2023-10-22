Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEFEC001DF
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Oct 2023 12:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjJVMnp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Oct 2023 08:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJVMno (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Oct 2023 08:43:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63011E9
        for <linux-scsi@vger.kernel.org>; Sun, 22 Oct 2023 05:43:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA25FC433C8
        for <linux-scsi@vger.kernel.org>; Sun, 22 Oct 2023 12:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697978621;
        bh=kEtvXKeZWP6f2Bq9YoZeK5G0lkS1EZNUfdMDhepbfGM=;
        h=From:To:Subject:Date:From;
        b=U6T5caEyvKTRHixvksU81wxmTFtfyiy/weFrNsUBnYpcq/kRsskPB2ozyRY4+BO59
         o9RCVAn1aBKkfQ09Kv3pKqzb+u5Gc8GY4VoYGgzD7Fj0k8M68KXxVRV0WyqGPNCPhr
         5k5mN3ESw1U6pYySqvUaJCiGRJf8iSxEuWE6a1cf41D1I8nkJmKIWJKfZAY25TBOc6
         Rwfaie1UaNqwTGBOyoFe4PtaVBpoU2nNnZCgYVn5I0Lb6yOcaHMw8uvNDpU3pTCE+O
         tKjLaRpbn+thF389nW4o6aWLOQbBQIxeC2QKF+EkFyRiVoNbZJpYcDZuhEVM7XZqZ8
         iwQJwAtrrQi9A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9F342C53BD0; Sun, 22 Oct 2023 12:43:41 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 218035] New: Adaptec 7805H (pm80xx) hangs even on light I/O
 with some Seagate HDDs
Date:   Sun, 22 Oct 2023 12:43:41 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: nickosbarkas@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-218035-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D218035

            Bug ID: 218035
           Summary: Adaptec 7805H (pm80xx) hangs even on light I/O with
                    some Seagate HDDs
           Product: IO/Storage
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: nickosbarkas@gmail.com
        Regression: No

Created attachment 305277
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305277&action=3Dedit
pm80xx hangs with Exos 7E2

Hello guys,
this is an old issue that happens when reading/writing data on specific
 Seagate SAS HDDs on a pm80xx based adapter.

Affected models:
ST2000NM0045 (Constellation ES.3)
ST4000NM0023 (Enterprise Capacity v5 or Exos 7E2)

Please note that neither the disks nor the adapter are defective, they work
fine. The disks have the latest available microcode installed, but the issue
occurred with the factory microcode too.=20

Even with very small sequential or random I/O, the driver enters into a not
workable state.

linux-scsi thread for this issue:
https://www.spinics.net/lists/linux-scsi/msg116653.html


I have uploaded a dmesg excerpt with debug logging that shows what happens =
when
I run a random i/o test with 128k block reads with 32 threads for 1 minute.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
