Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAA0C3DA7D
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Jan 2023 16:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbjAEQuC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Jan 2023 11:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbjAEQt4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2023 11:49:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA42551F2
        for <linux-scsi@vger.kernel.org>; Thu,  5 Jan 2023 08:49:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C23BFB81B3A
        for <linux-scsi@vger.kernel.org>; Thu,  5 Jan 2023 16:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7543DC43398
        for <linux-scsi@vger.kernel.org>; Thu,  5 Jan 2023 16:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672937392;
        bh=m/IY8gQxnLMeiXYT2TOyGTXcm3S8oywa63w5Iusw8/k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=akeZ6C0bJ3dplqWCC/Ajj6APhUBl0b97sDSw8Z/UEBf7yw1NlA38jjXkbR4WtJqVo
         h+v9CDrlEpYEHq3G/BJh3c+2QiduN5weBoqPzOs3d2EF/qgMWtxGRexdJDGbK8n53D
         hjWoZSTQa7k78wwM2pvqCHD/VIjlwa1GIiweZ+K1Xm9OvGRwWqMogzC0CTBfyxOMEE
         coidiM7m82ckudDUVYCVpRgANEIrE8hWzSfUuMRX8EMYXqTi+UBriyQCoE502wHRbl
         zifxqew/WD8sUwdPaM4vC3wKxEAV78RF+jYILTcBUUt4fBqIV7wHkvPd/Fkk8zjd5i
         +vO2OsLNmelfQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6295DC43142; Thu,  5 Jan 2023 16:49:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 204769] SCSI devices missing for disks attached to controller
Date:   Thu, 05 Jan 2023 16:49:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mwilck@suse.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-204769-11613-mpJ4jPbro6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204769-11613@https.bugzilla.kernel.org/>
References: <bug-204769-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D204769

Martin Wilck (mwilck@suse.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mwilck@suse.com

--- Comment #5 from Martin Wilck (mwilck@suse.com) ---
Personally, I'd say that 948e922fc446 ("scsi: core: map PQ=3D1, PDT=3Dother=
 values
to SCSI_SCAN_TARGET_PRESENT") is indeed broken.

But this has been discussed previously, and the SCSI maintainer disagrees:
https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg84659.html

Back then, the proposed solution was to "either have a SCSI host flag to
override the behavior or consider masking PQ in the driver", but apparently
neither idea has been implemented.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
