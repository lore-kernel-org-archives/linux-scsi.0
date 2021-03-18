Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4782FC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 17:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E457764E99
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 17:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCRRn6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 13:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231847AbhCRRns (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 13:43:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 06D7D64DFB
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616089428;
        bh=h9NGR0S5hjJXKR3i2z+99GqVgzKjZuy2vK+oOp7JWYA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=CCVlMlgj2/lrNN+lZvEe+A9ikHwxlt5Nol2VKaOm0TVTlEhfEvVydWCGzobQOHoz1
         3NKDif0M7QNfvcUZOm2dBzaOsCkJ7lf11Nb5tdazZqEuZvCrxBjyClzyEUaxJvUZAx
         CmsOqi3i+XxH8EVF/uJQ/gAGlfAzQOFwlkg/zK2PbI/M2zM/IkfsFx3hJKY7gt3rcx
         8EJ8oWabJqPFSTBQ0Jp+FBz412Hqhr1qrJXqCl5M//Nve3GsptLuYyTHPf9YZ+pbO6
         nfdX+QpzGuwp9oOSjISL18wn/7+uoSsveGu/9N3p49g4ucjWN+MP0Q1CpWzf68gnTd
         GDdTATJpskWwg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Thu, 18 Mar 2021 17:43:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: WILL_NOT_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-212337-11613-LRRFliE88y@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212337-11613@https.bugzilla.kernel.org/>
References: <bug-212337-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212337

--- Comment #2 from Luis Chamberlain (mcgrof@kernel.org) ---
Created attachment 295929
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D295929&action=3Dedit
Dealing with scsi_debug module removal / load races

Just for document ion purposes, providing a simple script which demos what =
can
be done to properly deal with the scsi_debug module load / unload races.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
