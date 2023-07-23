Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD732C001DE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Jul 2023 18:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjGWSEB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Jul 2023 14:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjGWSEA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jul 2023 14:04:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9483E4A
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jul 2023 11:03:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4037F60DE6
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jul 2023 18:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DB03C433C7
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jul 2023 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690135438;
        bh=2syXxlTDfPiB7txbpvmE9Jc/GBXwpZwoYW1QV5r9pHo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=chau4iv9AoWpRd1jElvY75C7h18zOuEOslpRlTJZpUB1KN/+E2IxMxeIXD4pWoPvP
         ae4mrULuqsshgx7hg9pxlYvtFt3V9pPxNMe5DOlG5KjbO9chsuIBjLOOVqIPGf/A3K
         bRC6wS8dSROjPTVF+zsASx4Mx7//YZlwaxUDQFR1vSF8WQvh1s2ZrDJ2BH1qiAG1Q3
         3y57MV86vmq1ELu0TZGZ68VvtRaBvWlYiMro7QMSXfdEVsb2dDUe6EQMumtcRKEFeX
         GEzQdTOFM5b1mzOSHKupmgN2y3mSGwp6LGrLuSEFZ/BU5Y+sT23v7zAsarrBCS8+cP
         XzSbI9dB9YJcQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 87CDEC53BD0; Sun, 23 Jul 2023 18:03:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Sun, 23 Jul 2023 18:03:58 +0000
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
Message-ID: <bug-217599-11613-7AFzDWx1BJ@https.bugzilla.kernel.org/>
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

--- Comment #8 from pheidologeton@protonmail.com ---
Update. After disabling cache the error still occurs, but less often and on=
ly
during operations with very large i/o, e.g. btrfs balance

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
