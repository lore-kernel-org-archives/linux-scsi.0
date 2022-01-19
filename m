Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC61C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 04:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351312AbiASECb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jan 2022 23:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351133AbiASECa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jan 2022 23:02:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30420C061574
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2022 20:02:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCBC561581
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 04:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B0B1C340E7
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 04:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642564949;
        bh=dESXpt713ZI9UgnaChumQl/wlRiUSIuteObq/9FDMsU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=S2kyLfnO9VPE2jQEreQweaXTlpXxFbEbIO7N3y+HKRFm04yLPm+4i/ELHq5DBoubj
         lx/MF/HyIhCsNjjQEQvAm5QqYF0LEovc/nLaf2EyoppvGV5RpKIcMQatGoXxCOEoAG
         z+rQCIWhLu83Qhn1Y8c3BZxrf2EaZVjroF7mKQUhF7IJvJZAnqW+ID0x8XWdagi3Rw
         XLKcw531/D1ZyOUBHXdnJ3/Rdl7eiuK+uFPRCF7U6SBR1J5InmFl1v5pbxidEI+oNw
         7e8GeLsrd6YerVoZP4yQMY4hs1s74XfXMUyZib/+4JrLTRP/yU94EV1C7Z0YVreC3T
         r1i93l4RPAGEw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 21526CC13B2; Wed, 19 Jan 2022 04:02:29 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215447] sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
Date:   Wed, 19 Jan 2022 04:02:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: martin.petersen@oracle.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215447-11613-9Pf1xQibLB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215447-11613@https.bugzilla.kernel.org/>
References: <bug-215447-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215447

--- Comment #8 from Martin K. Petersen (martin.petersen@oracle.com) ---
> is it risky to implement the fallback mechanism in both directions? is
> there a chance of forever retry? (fail 6, fail 10, fail 6, fail 10...)

Just a heads-up that I am still working on a reasonable way to go about
this. It is not entirely trivial to perform the transition from MODE
SENSE(6) to (10) given how the SCSI disk driver works.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
