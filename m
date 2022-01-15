Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B9DC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Jan 2022 13:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbiAONI7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Jan 2022 08:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiAONI5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Jan 2022 08:08:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6963C061574
        for <linux-scsi@vger.kernel.org>; Sat, 15 Jan 2022 05:08:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 414B4B80108
        for <linux-scsi@vger.kernel.org>; Sat, 15 Jan 2022 13:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15EB3C36AE3
        for <linux-scsi@vger.kernel.org>; Sat, 15 Jan 2022 13:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642252135;
        bh=AkOUKs2GmAcT8IgoTLDyVQPNOXsCu3DWViFc5/rRR1c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TqlMzCoGvuSZGITX6PTXTMcsRN5hXcn3hLnRR00kJ+Y1eDk0Mrt9naGrIamGnwdIV
         aLPhNcuNrU5p/zopVbVUSkChVo3xL8IoZwZEX7urzT6p+qIK3uatQDUMUPukmP9Lpk
         H8DPkj00arr9MMsS9cx54ClNrqWMQ+Y6xqpro69GLbcIJ33FDSENDh8FhN/t2Cr3Wa
         I7wocA2goK2lLHyz4f6CPhvA/KEHquVYpZaU7S9CTpufcr2i49/d7Mv1Gyw6stu2Yu
         NDw04TKd7GSDsX5d84Y6zTcFeomT+cLvpdnUwUf2xCJOk8CqSEh43+gVwgAQ1zs5b8
         c55WsZrUVSnXQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F3CA0CC13B0; Sat, 15 Jan 2022 13:08:54 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215447] sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
Date:   Sat, 15 Jan 2022 13:08:54 +0000
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
Message-ID: <bug-215447-11613-7nhV0R36aP@https.bugzilla.kernel.org/>
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

--- Comment #6 from Martin K. Petersen (martin.petersen@oracle.com) ---
Christopher,

> Is anyone able to comment on the sr_mod / cdrom / mptsas issue I'm
> experiencing (see details in bug)?  I fixed my issue with a one line
> patch, but I'd like to know if it's correct and what I should do to
> have it integrated upstream.

My concern is that switching to MODE SENSE(10) by default could break
things for other devices.

There are compelling arguments that we should use MODE SENSE(10). Most
ROM devices appear to favor it. The specs allow both but MMC3 (2001)
mentions MODE SENSE(10) as "shall implement" although it doesn't go as
far as marking it as mandatory in the SCSI command table.

In the current code we fall back to the MODE SENSE(6) command if a MODE
SENSE(10) fails. So if we change the default, unless a device hangs when
we send the 10-byte command, we should be OK.

Another option is to allow a fallback to the 10-byte command if the
6-byte command fails. We currently don't do that because MODE SENSE(6)
was required for so many years. This way we could accommodate devices
such as yours without the risk of changing the default.

The good news is that the "consumer" transports (ATA, FireWire, USB) all
use MODE SENSE(10) by default. So we are really only talking about
changing things for SPI-attached devices which typically are
well-behaved. So my hunch is that switching the default is probably OK,
although I would like the 6/10-byte fallback mechanism to work in both
directions as well.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
