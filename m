Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E8BC001DF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 13:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbjHBNBO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 09:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjHBNBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 09:01:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16124E77
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 06:01:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A73061976
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 13:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D96BBC433CA
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 13:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690981270;
        bh=qHtlkwT8uDSZaH619wHvEgF1uQlgMXX4E+/7KcXeQLk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BaKGOLQblex84ZvE04kaPMFcU4rJeEXS+Go/bdt+KUA+zZC8xswyUzXgZvUN87NFX
         /+d0Azzal6dxZgxQH1QrU3pSCPVclJn45S6Zeqf+SRD8XU8/sr//ZflzPj3t0K59qw
         tSBJq/pllqcrNSJ0lMpkiFzEvXYpb5M0/lM/ScVFaO0r7sECPA8lg43zjpb96pyoYA
         D4T+hgMTv83QHhqDCTW+NAUR6BoGXakYprFRJRL/burpb2I5BNSz3kEgA681pWv0GR
         62i35/aV6gEtO+y1TMKmxKCgFml5myk2c4zJmK3gAGCuesw51cFU7l32Zl1e/NpTeK
         15UKDmhXsv1gA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C3FD7C53BC6; Wed,  2 Aug 2023 13:01:10 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Wed, 02 Aug 2023 13:01:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pheidologeton@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-KSb0zvSu1p@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #12 from pheidologeton@protonmail.com ---
After 6 hours of stress tests with lots of small files, the problem repeated
itself. It does not occur with sequential i/o. Repeated the test with btrfs=
, no
problem on the newly created filesystem, but it repeats with random i/o. I
think it is caused by this patch
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D48dc810012a6b4f4ba94073d6b7edb4f76edeb72.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
