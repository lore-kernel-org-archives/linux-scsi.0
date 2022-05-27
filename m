Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14176C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 27 May 2022 20:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350587AbiE0UlT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 May 2022 16:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237106AbiE0UlS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2022 16:41:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8452F21A8
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2022 13:41:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 339BCB82522
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2022 20:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3076C385A9
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2022 20:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653684075;
        bh=ZXVMlXt9RPGUw6MOzPi4Opa0buDZyAb0BZnCXWxTruE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VraliJuahtBTPNR9alELmtt5cAkaul5ALnqfMJRr/YE/PFRdIgigK8cWvhd29u1UI
         mQJZUF+hUGnRpXYlGRL5/0QXl+yWOtuvj5XxpegbXN0BbGAB3ZFaqCgE00nVQB++1y
         0R1yTLaIrzCbxhbl5WOeT0s2i5+W9/vrQlAW0gKEv7JSTicR0b9tCWXnNrcJKZPFTr
         AJcFACPLcHbAW0YZHrGE6tUgLOAxISS98EHVBmWtS+AzQHJcXQXjYBvRu9P26bvCqe
         bvh+o1bVCP1dct2gNS3yjZtQyHfMGmmLpqNP1j8tyI85wD0nqNMhvbQgx+hkFVGiKT
         AQigNvCg34X+g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E29B9CAC6E2; Fri, 27 May 2022 20:41:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Fri, 27 May 2022 20:41:14 +0000
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
Message-ID: <bug-215943-11613-0TnOm6FOsw@https.bugzilla.kernel.org/>
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

--- Comment #3 from darren.armstrong85@gmail.com ---
That makes a *bit* more sense.  Is there something special about the zero-th
entry which allows for treating MR_DRV_RAID_MAP_ALL as a MR_DRV_RAID_MAP so=
me
of the time?  Something like that would explain why this code is set up in =
this
way and has persisted in this way for so long.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
