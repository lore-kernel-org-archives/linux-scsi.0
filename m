Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCAE7C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 07:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbiFHHSr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 03:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347114AbiFHGNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 02:13:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0200196A9D
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 22:36:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5B766198D
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 05:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1CCA6C385A5
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 05:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654666564;
        bh=zP4gQh6GvhRseDfs4cYtFBOrL8fq0wXj3xZ8ynDjLHg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FBcMrKiDB0jkGxugGszv2U+ipo2ehvBqZYGfyMtgCkYi4j1bYEOD58nWYneGiANUt
         IX6A2yU73L3Xz4eTfsVCEy3iOrqMTDqLXBaqDAABjaN4ks/i6Q9YpKmABBAyjIRHmy
         wwIthbcpA2qG6OmBvaCmoh5YJ4qPc+iZzQC+NL2z3MqJSrDTn42KoadHe6u/6xgkKt
         WctikFrZS8QJJklaZ6TirFOz9zOM/lJqKT/c1VlnL+0nGZsQ38aKBDINYV9tDHKjJp
         SftEnCQc8sL90oNqRrcGCScJw0pHsT2NbjuQS80mG1Xc9x6EXLgN9z8oeIjaB4ym1u
         f6I/tlXDvoOZg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F2741CC13B1; Wed,  8 Jun 2022 05:36:03 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Wed, 08 Jun 2022 05:36:03 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: torbjorn@jansson.tech
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215943-11613-aRpG0RXLVv@https.bugzilla.kernel.org/>
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

torbjorn@jansson.tech changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |torbjorn@jansson.tech

--- Comment #4 from torbjorn@jansson.tech ---
i have started seeing exactly the same problem in the log as well.
i only noticed after the controller for some odd reason gave up and the ker=
nel
obviously started complaining about all my sas disks and not able to access
them.

after reboot i checked dmesg and then found this UBSAN
array-index-out-of-bounds

in my case i a 9361-8i and a Supermicro C7X99-OCE-F/C7X99-OCE-F, BIOS 2.1a
06/15/2018 mainboard.
i'm running kernel 5.15.35

the UBSAN messages happened directly at boot

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
