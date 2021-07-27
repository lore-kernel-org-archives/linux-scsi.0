Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD2EC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 19:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22A9360C51
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 19:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhG0T1X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 15:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229737AbhG0T1X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jul 2021 15:27:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2B47F60F6E
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jul 2021 19:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627414043;
        bh=wiHosoVt3KX00qODZX3s+/zhGRay81KsZs0XzfjuzHk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=csoDowlIIwdokXntHVDm1iZooB9mlmebzp+uP4L1pQXSxIfbu7tFhqj7klmAfSPAr
         jFwmVdvXVX8NecC9ON1OTk+mTJzLGmSgFEt9JuFjT0U52FISTqoRVwiBAJzLv2fcuj
         zL1ATySQy3sH8Z824V2D2Gzkecx6sjz8pFxIAbQsYlVADzGwTe39dedDLG4rkJp+yq
         YRKGcXI0vL/PVlIwREscpVl/qROv1dWgBnfwL0CaXo169BP1NMrDrLB/6XwzvlXRVt
         b1sCs5Au+Z2XLRkiw0KgqA+dcYeYgAYYchPQbUX2suBb7qfOSd1tzoGvIqs770xemO
         YZYDjtOjHgUIA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Tue, 27 Jul 2021 19:27:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-212337-11613-R0VH8zhZpk@https.bugzilla.kernel.org/>
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

--- Comment #20 from Luis Chamberlain (mcgrof@kernel.org) ---
I've narrowed down that using this patch:

http://lkml.kernel.org/r/20210508230745.27923-1-dgilbert@interlog.com

helps on older kernels. In particular, at least with kernel v5.3 one can
eventually run into a situation where the recnt can be see in
/sys/module/scsi_debug/refcnt as 0 and yet rmmod can fail.

This is not possible with linux-next.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
