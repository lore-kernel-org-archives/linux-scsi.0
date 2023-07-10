Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B573CEB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 02:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjGJCvU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Jul 2023 22:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjGJCvT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jul 2023 22:51:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EB0123
        for <linux-scsi@vger.kernel.org>; Sun,  9 Jul 2023 19:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 217F460DCE
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 02:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85894C433B8
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 02:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688957473;
        bh=zASB2u9yWLF87mI/DGjncY37mV9Vs/HwCxgdg4UUmak=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=O1t8lAFv/jP182KOGEpGsikyU4ACa27NzGnZzC/nxjvI0hXKRWBF+LfX+40ylOQ/9
         xi/vGB8K4TBCn6bxqN509/ReoTEin5gnqkzIfxS9vFudCuT0Z4MnSIAOAvawzZUBS8
         p6QqITVfePKAebOdncLbiJzgGP5780J/5WFSwTvTW2KQef4sgTIHdD6uZIUk6Q41dh
         dhD70RJcYCcQd4AHtM6JyXE/Fu75LFzr27xbDvO70W9o1tkqeHrRnMPtT6IssaEwZb
         96mSnKazjZrJq3GDgJx4zrXcXVcMpqzWC2EVE1Xt3UwQ6j9EWuYsZfh85gFKamTa/v
         xR4MqdlLyzPVQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6E41AC4332E; Mon, 10 Jul 2023 02:51:13 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Mon, 10 Jul 2023 02:51:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: paula@alumni.cse.ucsc.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215880-11613-dKhXRPp2Q6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215880-11613@https.bugzilla.kernel.org/>
References: <bug-215880-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215880

--- Comment #51 from Paul Ausbeck (paula@alumni.cse.ucsc.edu) ---
The PCIe BAR (Base address register) is usually GPU related as lspci verifi=
es.
BAR mapping failures are pretty routine on my older machines. My assessment=
 is
that they aren't relevant except to show that at least some GPU activity is
deferred until after ATA bring up.

I think more important is that Restarting tasks ...  and even PM: suspend e=
xit
are happening before ATA bring up on 5.10 but after ATA bring up on 6.1.

This seems like a pretty serious change to me.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
