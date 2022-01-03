Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4985C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 18:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiACSAn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Jan 2022 13:00:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56694 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiACSAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2022 13:00:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 981E3B8106E
        for <linux-scsi@vger.kernel.org>; Mon,  3 Jan 2022 18:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51D3EC36AEB
        for <linux-scsi@vger.kernel.org>; Mon,  3 Jan 2022 18:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641232840;
        bh=1ptJoccDURcd+xA6mTm1LtjDw100LvsB8p/ByR6xd68=;
        h=From:To:Subject:Date:From;
        b=ZnL40bGI5AYoSCyFG3OZW374HI+rEURB0rvrF1aw4R6MOSVaksmSZaWq7KldYTLZz
         sKvfoQwRa7zNW5e6EJtjdkmQL/Hxtso2pqxUs5es2iLotKiBiy2UilbUhx2C+sUV/L
         019UHTD+oYrTns+ntQ+AkcdOKCd/XeDaD/9x3IrKfNMWeND/Dllq/adbQisDDOxDp+
         7SVnTroxX0jfkyLry4zI31xr8hVeL0t795HeBi8fJAL53CRX7Rebf/HuSkOlBYl8UP
         HZ79vObQ59eDwFIJW8SM8KdCVlr7R/jsUQR4zGRvK03SAPbkhm7FgvV1C/fEuJp/S5
         hZrujXno/MHoQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4049DC004D8; Mon,  3 Jan 2022 18:00:40 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215447] New: sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
Date:   Mon, 03 Jan 2022 18:00:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cshorler@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-215447-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215447

            Bug ID: 215447
           Summary: sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.15.6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: cshorler@googlemail.com
        Regression: No

Created attachment 300216
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300216&action=3Dedit
SUSE Tumbleweed default kernel with CONFIG_FUSION_LOGGING (debug_level 0x48=
8)

scsi_lib.c: scsi_mode_sense() has defaults assuming MODE_SENSE_10, fallback=
 to
MODE_SENSE if that fails.

sr.c: doesn't set sdev->use_10_for_ms.  In my case this causes
scsi_mode_sense() to fail and "scsi-1 drive" fallback to be selected.

I tried setting use_10_for_ms in the sr_probe() function, seems to work for
code page 0x2A, as requested by sr.c.

I'm unsure where the request for code page 0x19 originates / if failure is
acceptable or if it indicates another issue.

4 attachments

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
