Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE0B1C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 14:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D25B061AF7
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 14:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhG0Oz0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 10:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231552AbhG0OzZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jul 2021 10:55:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B14E861B05
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 14:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627397725;
        bh=9L+z4GzvSCMkZh+HyB41w1/AjL9bLKZFUiVIAFzsj5o=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=MkbhS1VuVd16m52lCsvIrGkunjacCSYV4Ebug/Z1GtYzCVdNsafCiilhb/G6T8SI9
         eI9b+fejJzU+g8+mY2UnMoI7uA+hEsEl5+uyQbR+lfoqUxYqGhjlLQdRDAZOdDHMo4
         63C+/dmsGGaxL+MiMEi5+hCHiwB4OGTG6Z4oHt8PHdqic25oe7TLSNA9MGEUATPwTI
         Cz+kPOu7JD/Q6K2ZO0+ftMTIA4f4RQTrmrbrewtiTrsLK6KZlsQHvNgo39Ku2f0oz9
         jxjR2HgKCuTTrVnFnz5aUXfr19gOk02JACdedJkypiv6SlfWV7oylmSMHdH4d+2TFY
         2+vP3kNd/huhQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Tue, 27 Jul 2021 14:55:25 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vkuznets@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-213759-11613-vFyIdQUmyx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

vkuznets@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |vkuznets@redhat.com

--- Comment #8 from vkuznets@redhat.com ---
FWIW I'm seeing the same issue with Hyper-V Generation 2 VMs. After=20

commit 7dd753ca59d6c8cc09aa1ed24f7657524803c7f3
Author: ManYi Li <limanyi@uniontech.com>
Date:   Fri Jun 11 17:44:02 2021 +0800

    scsi: sr: Return appropriate error code when disk is ejected

DISK_EVENT_EJECT_REQUEST is generated when storvsc driver loads and in case
there's a udev rule to do "cdrom_id --eject-media ... " at this time the
virtual CDROM goes away.

Patch from https://bugzilla.kernel.org/show_bug.cgi?id=3D213759#c7 helps.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
