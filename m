Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FF7C001E0
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 19:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjGaTER (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 15:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjGaTEO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 15:04:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AB6170A
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 12:04:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 285EA61276
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 19:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91F29C433C9
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 19:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690830252;
        bh=jATvBccFtxxbxpKdH5UhcF1owkiMcpQSr5lo12SYD48=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=kV6CSOYcCh33WjGFcALToHNJw6XpLYYVL7O1Ma1CCV20KkoG2gPAM7VTOhofL8Rw1
         rDSDKMyi1r0QwrEhZL0pR83+oNiqopNl+zAyzjubWkWH7RwlHTXei0GDoXRLftF6hn
         7bNxzsatHXhYn8l4bAqwc8mc7YrhMvA4vL6vbndvmaP74UdILfEFvedsP8nH8fWg13
         qc6oStESb+tknUIpNDPcR191MuZvIGnzQExjFFBpUvAoasnwfzIrRRK+6H/uZDgNpf
         LXADtutYExmkc2frv1PC6hGlGpdIVAg+P5phNetb2opkKNsQ3rAPhNT5zE0NMvC2s5
         5YfK2daRkY3gA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7D34CC53BD2; Mon, 31 Jul 2023 19:04:12 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Mon, 31 Jul 2023 19:04:12 +0000
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
Message-ID: <bug-217599-11613-ic6rkwuzBj@https.bugzilla.kernel.org/>
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

--- Comment #11 from pheidologeton@protonmail.com ---
Most likely the problem is with btrfs. When using zfs in the same luks2
container (sectorsize is 4k, stripesize on controller is 128k as cryptsetup
does not support sector size more than 4k now) with -o ashift=3D16 no contr=
oller
hangs are observed at any i/o, no resets under stress test for 4 hours alre=
ady.
kernel 6.4.7

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
