Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACD8C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 16:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81FC564FDC
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 16:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhCLQ6s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:58:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231789AbhCLQ62 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 Mar 2021 11:58:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 55B646501A
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 16:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615568308;
        bh=K9TWx2kNigUd8BDK9SxileIqtX5eDBuferyJqwt6wgU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nVLjK5YONsLlyIncVq32EvsqfncVjt8gEAwgAg/fbIzui16CRC6vMjqZA5ga13w8o
         WkmrMrKh7+EeZYlJJcUjfzhBKSkaomxRHu74dpm4mvSGsHwBb4Q+Y+pTNYFgtqvyaa
         byhwGPzVcCE6ZZg5nzURAQS4kljc2SwGMk5+qDMIoeEJXBSBh0wRmIoS023LloqAk9
         vysmBK0WuMUr1l0Igxv+uefwpFtbvVI7Pry/VVgVF2mNz5SEcI3/1NeuESy+GdWVP+
         IYltzXwkMCNUyJK9OlsFHTNzoczYUzoufb8gCEYVHh2j2Da4D5oiU3w/HFA9xke/5j
         FwDWErS4zm08Q==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212183] st read statistics inaccurate when requested and
 physical block mismatch
Date:   Fri, 12 Mar 2021 16:58:28 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: etienne.mollier@cgg.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-212183-11613-9gJ6rKo8oR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212183-11613@https.bugzilla.kernel.org/>
References: <bug-212183-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212183

=C3=89tienne Mollier (etienne.mollier@cgg.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|5.3.1                       |5.3.1, 5.11.6

--- Comment #3 from =C3=89tienne Mollier (etienne.mollier@cgg.com) ---
Hi Kai,

Thanks for your comment about SILI, and the suggestion to factorize things a
bit.
Yes the correction is relevant when SILI is set, so we derived a bit from y=
our
proposal to apply the residual correction only when SILI is set.  The patch=
 is
in
attachment of the report.

We took that opportunity to try out Linux 5.11.6.  The patch applies
successfully
on this kernel version, and statistics reported by `tapestat` look much clo=
ser
to
the actual bandwidth of the tape.

Have a nice day,  :)
=C3=89tienne.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
