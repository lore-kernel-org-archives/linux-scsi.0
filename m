Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25831C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 22:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237317AbiDFWvv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 18:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237296AbiDFWvp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 18:51:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D069D200344
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 15:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 563CAB8260A
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 22:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1BACC385A6
        for <linux-scsi@vger.kernel.org>; Wed,  6 Apr 2022 22:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649285385;
        bh=1P2hhxjQ4I4QlyTzcgU0WjIOOuFWsPqHhi11b4Y9RbI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RnfrIfYOKf2Dm856CI9pXFvfBW9DsBbM1G4XM4xEFv++fOF1mASqZZaTANZ27q7f+
         e1lUNuALnEOMqzFZ9WucsBm65L/3d6CPXUHtCMLG/X2vyY9GDzVToosL9BqJcnMG4Z
         +On4EFpAU/uf238pefMRZirYFVcF2qyV3JOgfJ3nfRv33VJ0uq+mdRI8KykXfomD2F
         QnISsF9LLD/Va12PlJFc21nF/IaoHMEX3DxRPy+KQefwtO/8/MjKX09uNgsanI8rg/
         4Af446MbPF8WrBThawPzFTzdHi4SwHtElDPRjNscdkkzvRk9xEYip7gtPNvw0dacvz
         cJUnS8vt8kyYg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id D1CB3C05FD5; Wed,  6 Apr 2022 22:49:44 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to initialize
 ARC-1280ML RAID controller
Date:   Wed, 06 Apr 2022 22:49:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: damien.lemoal@wdc.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215788-11613-bVpcit89wX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215788-11613@https.bugzilla.kernel.org/>
References: <bug-215788-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215788

--- Comment #10 from Damien Le Moal (damien.lemoal@wdc.com) ---
Arg. I am baffled... No clue what is happening here. Since accessing the 0x=
b9
vpd page simply fails, sd_read_cpr() should be a nop and do nothing. I have=
 no
idea why it creates a problem. Let me go back to the code and check again.

It does seem to be that the adapter is crashing though, so it may not like =
the
command sequence on initialization with that vpd page 0xb9 in the middle. H=
ave
you tried to check if there is a FW update for that HBA that may solve the
issue ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
