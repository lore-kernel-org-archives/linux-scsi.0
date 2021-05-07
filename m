Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F54C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 22:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33AE060FF2
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 22:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhEGWii (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 May 2021 18:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhEGWih (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 May 2021 18:38:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5199E60FF2
        for <linux-scsi@vger.kernel.org>; Fri,  7 May 2021 22:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620427057;
        bh=CWzN/Z+ogaoNWjBg79EnR1n6llBZJyrXcc2SNf4ORsE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Vd3U49lQ0CzvKFrcueAqESl4H9fcU+MNeWWufNDLPqQ3lBE+buniXmwx9ReEKmPEc
         zaQt7An6k/3MomqS/Tr781PzDiUlaw2sFkZCbA3SwMCH0IALqMGVvAEdsiaGYmX54A
         e0Q6BgPdhypJzZd0Fga70Wp+xTmlyN9NfNQvYJpUFRDMv4uwCc9xq0IOcYol6Qj6YY
         GsU39h1BffZ1PcK2zJbUzVOaoRVlx6qGPawveDQQe2mUboszbcUBuUmCgs3yFAP5vq
         I56oGGu9Ssv7IRevmZnzlg7Hy48qsxZEiJoPUAmCupG2CgY3ur17jp8fY3eZSIUMdf
         8d0Je6rjTEiFg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Fri, 07 May 2021 22:37:36 +0000
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
Message-ID: <bug-212337-11613-F7Ifcrj5Ci@https.bugzilla.kernel.org/>
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

--- Comment #18 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to d gilbert from comment #17)
> > It should appear right away if we attach sysfs stuff prior to the devic=
es
> > which probe asynchronously.
> >=20
>=20
> Yes, it does appear pretty early,=20

I thought scsi_debug had generic sysfs files to control adding new scsi dev=
ices
at run time or removing them, or controlling the scsi_debug driver generica=
lly,
but correct me if I'm wrong, I don't see them. If so then my statement was
incorrect in that "should" is an assumption.

All the sysfs knobs I'm seeing are per scsi device, not generic. And so I t=
ake
it back. Since scsi probes asynchronously its by chance they appear by the =
time
modprobe completes.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
