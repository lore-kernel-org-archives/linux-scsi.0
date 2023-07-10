Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C90B9EB64D9
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 17:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjGJRAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 13:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjGJRAs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 13:00:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFE8F4
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 10:00:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D44F6112C
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 17:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12D9FC433BA
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689008446;
        bh=dmPLYREYR3rHWdCFQIrCdUFjpLnad54NWH8ss+jUyVk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ak37eWo6HMP14/K12Ae2XlAvev5U0sfPJ8Z8cTuJHVd/9wSaYC/h4RxfQzKS+Unwn
         KpDFaqbx3ytKt44rmPlcybBP3MKctt3sSnrtMB6uSzP+UF6aPg82D9KBP5aNMJBRz6
         oo14jV67VWgegccYXWGbkDpJXNOn45/lBaMqh5HT2pXhrpSKCDbTwltuPvMihP19NF
         +BzvYj3z76eV5jZpOc/oz2FJiU/qCfPOh+uc8mB+bCIDXtVHo+gnb++b+2biCk7isI
         dyhNZAc/lPH1sz/PVtjLUY4FfpSOmxgtZxiAQri/9rtRpoaMhuTlUTnM8Xp3W+TiHw
         SqngQU0gwJHBQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 02EC2C4332E; Mon, 10 Jul 2023 17:00:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215880] Resume process hangs for 5-6 seconds starting sometime
 in 5.16
Date:   Mon, 10 Jul 2023 17:00:44 +0000
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
Message-ID: <bug-215880-11613-q34r7iLERw@https.bugzilla.kernel.org/>
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

--- Comment #53 from Paul Ausbeck (paula@alumni.cse.ucsc.edu) ---
I sense that we are in disagreement. In my way of thinking disagreement is
overcome through logical argument. So here goes.

I argue that you can't call a bug fixed if the fix introduces a serious,
entirely separate, regression. I further argue that at resume the mouse poi=
nter
should be interactive at the same time that the display becomes active. I
further argue that if the mouse pointer is not interactive at any time that=
 the
display is active, that is a serious UX bug. I further argue that before the
recent kernel ATA changes this particular bug did not exist and therefore i=
t is
a regression. I further argue that though the regression is UX related it
cannot be patched over outside of the kernel. I further argue that this
regression likely affects any personal machine that contains a spinning disk
and that this class of machines is substantial in size. I further argue that
your reported deadlock between ata resume and scsi resume likely affects a =
far
smaller class of machines. I further argue that though for a single machine
deadlock is a more important problem than temporary lack of mouse pointer
interactivity, for the kernel as a whole, problem importance is proportiona=
l to
the multiplication of the individual seriousness and the size of the set of
affected machines. I further argue that your assertion that the non-interac=
tive
mouse pointer is not related to the libata resume changes is incorrect. I
further argue that the two dmesg fragments that I have posted to this thread
explain the situation quite clearly.

My argument contains 10 assertions. If you disagree with any of them, please
give details. In particular I don't have a clear idea of the size of the se=
t of
machines that might experience the "fixed" ata/scsi resume deadlock.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
