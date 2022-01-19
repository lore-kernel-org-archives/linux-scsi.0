Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B041C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 21:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357430AbiASVfL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357428AbiASVfK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 16:35:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC1CC061574
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 13:35:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1226BB81C20
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 21:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0990C340E4
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 21:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642628107;
        bh=sIsp/PP+ssYJOfGrptYuEk0vhSsUyaxwWeigeuy11ds=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WX3Jj0UBrGa6BtUZ8cvUySPc/ZkWJq0CvS2gieqPOP7csrpIXmD9DCWDTW7Fm24PM
         MaDDZHf5Gppl7J13iqbpLR3f9DPpLfBI3Nfr4FIidGHf5pbrZLRJand/ZDxZOZXA1J
         bn7cci27Ku3Y8maNryesPsH2P0MlEbClc7hWUhvcXOjs7YwxGd7ENOCLT97i2JXu0p
         dkB+4/p5m7NzXtJdqtfYsiE9I42JOQ/1xmTVoR5BQpDFy9JBMU8oX0tPkEWhYqcQWL
         cFAnC0yKVQbfsKyAt7u3zLvZVZb2OAgKh2oE5z68xzjtOVs8JuEcCDsv1OuP0h5iFG
         zTC61m2qi8kEw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id AAE97CC13B4; Wed, 19 Jan 2022 21:35:07 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215353] VMWare LVM partitions not recognized, sees base disk,
 fails to Boot
Date:   Wed, 19 Jan 2022 21:35:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: martin.petersen@oracle.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-dc395x@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215353-11613-fqz6KFe4FT@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215353-11613@https.bugzilla.kernel.org/>
References: <bug-215353-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215353

--- Comment #5 from Martin K. Petersen (martin.petersen@oracle.com) ---
> Update: Testing with Kernel 5.13.x (specifically 5.13.13) - Still
> fails to Pickup LVM partitions on /dev/sda (which is detected) in
> VMWare.

5.13 is no longer supported. The fix was merged in 5.16:

142c779d05d1 ("scsi: vmw_pvscsi: Set residual data length conditionally")

and I believe it has been backported to all the currently supported
stable releases.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
