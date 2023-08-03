Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B36C001DF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Aug 2023 15:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237243AbjHCPx5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Aug 2023 11:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236922AbjHCPx4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2023 11:53:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343853A97
        for <linux-scsi@vger.kernel.org>; Thu,  3 Aug 2023 08:53:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6D4061DF0
        for <linux-scsi@vger.kernel.org>; Thu,  3 Aug 2023 15:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32130C433CB
        for <linux-scsi@vger.kernel.org>; Thu,  3 Aug 2023 15:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691078034;
        bh=cO9ttc4MU13udS41mxhogwdTTD099etqlwSE3p2fqPI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=MvpLZq/BvmHrcEQkEPPAjYqZ4b3ATHvFj9Dnh+TZeqI9hQp1aYYA/AkjV0D7FTS10
         gbyqIX7r2VIg/T/5ejLOkc7iYmnSwAsLpFXaTYiD5xz0tI7PcZQJgWvh7leT7VwstA
         jN2y7zs+RYJvo8B3FBGn1rP68Ah4MvibErv4kr+YGOZb43FYOGe2ee8F3zjca3SQJk
         wqjEaOXiPZIFhzRe5UPWok/uMxR9zP4CzJSTWfCHP8KJCi7ZNIm8n4blq34bosrn4R
         Hzh/eyB4wXMi06Makqu8H6BFCc6aMsae76C++XNCZ8jkgu0DQfHumPOyRS67TGfRtW
         yS2ZCJHKjLGyg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 21E49C53BD1; Thu,  3 Aug 2023 15:53:54 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Thu, 03 Aug 2023 15:53:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: maokaman@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-grqGT0HBu3@https.bugzilla.kernel.org/>
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

Maokaman (maokaman@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |maokaman@gmail.com

--- Comment #13 from Maokaman (maokaman@gmail.com) ---
I'm experiencing the same problem with the Adaptec ASR81605Z on 6.4.x kerne=
ls.
Reverting the following commit resolves the issue:
https://github.com/torvalds/linux/commit/9dc704dcc09eae7d21b5da0615eb2ed792=
78f63e

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
