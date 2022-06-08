Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEBFCCA486
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 07:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiFHHPu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 03:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241331AbiFHGui (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 02:50:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD10F16837B
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 23:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D84E0B825A0
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 06:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 741C9C3411D
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 06:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654670368;
        bh=9h1pr4VTUOSe+TSZxTXYfFCl3bVqAaVcO6njibrrgns=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rSYiHTlCWyf2XEUpffXH21wPnIXCQLsattCI8cIf92L6aj0TKTErHntYLYxfg6/Y8
         hO9ZtAUGLi51LKpusXT7oKJDSgzsm+hVEUDdqTvnQ4jrGFRPkVXCMv4Vdk10hh0uFf
         MKnXg3Oq7oxNWZgA7taeBc3OWeVggRCvNhMCew4VJQsGcrXGv3/M7g4uhzDnz/nI7V
         Y+BJyGlApcC0wO/LE+nF7MpMBB9K3iPaHAe7Y3uxZhlY9qzjrEc9hr/5XDmtXvG3Q+
         hmGajofaGf7sW3cJzh/Kgb68qbSKOMcrCYHF1AomMIenG5AB5leuetNrOBSKGSm159
         3BmH16SXFOjww==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5D59DC05FD5; Wed,  8 Jun 2022 06:39:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Wed, 08 Jun 2022 06:39:26 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: darren.armstrong85@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215943-11613-xxyWUMXM0G@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215943-11613@https.bugzilla.kernel.org/>
References: <bug-215943-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215943

--- Comment #5 from darren.armstrong85@gmail.com ---
That makes sense, the code path I saw this on was loading state from firmwa=
re.

I guess we need to resolve whether/how we can safely "spill over" into the
array in this manner. As above there's some assumptions implicitly behind m=
ade
about the layout of the ldTgtIdToLd map that the zero-th entry in ldSpanMap=
 is
special.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
