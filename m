Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472BCECAAD2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 22:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiH2WhL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 18:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiH2WhH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 18:37:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683C49DB65
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 15:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D50686130E
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 22:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32879C433B5
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 22:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661812625;
        bh=A/RkB2MoqavVbr7UWTeJZgsFu5yb+JULzHXJ4uov5iU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Yl96vcEKZkCfD1pBxc8VS216qcezBbpMtYQ1dFh9lmimRNAy7QOH8YZcdI8ukRIdE
         +3I0rFll11hmij5e/K3ekmAhM/XtSiVyZ7pOSYtK8y2Xz++u/YaT0zmsecPXDFJcQ+
         ATlKnyhD3Pcp42sPYgJdAHeKkTwxy2bDPsY4ELR+7M9c8xrH4Fuagnpj7QF5KPK52s
         K5BR2t5m9VTcm3zoqHWfKFJ/GowB1lfoxvYuJGHSm2WsROJyY75zDYgEoDilLL91PJ
         K9O2pKtFd6+i2kUiAMhqW9jwT5Mwdzkli3Gdh4qY/qEtL/xLTAgCw/oyjDOem202nG
         o2xPShZU9RSSQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1BE9BC433E9; Mon, 29 Aug 2022 22:37:05 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216413] [BISECT INCLUDED] scsi/sd Rework asynchronous resume
 support breaks S2idle and S3 on several systems
Date:   Mon, 29 Aug 2022 22:37:04 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: todd.e.brandt@intel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: bvanassche@acm.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-216413-11613-nj6s4Md5GC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216413-11613@https.bugzilla.kernel.org/>
References: <bug-216413-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216413

Todd Brandt (todd.e.brandt@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #9 from Todd Brandt (todd.e.brandt@intel.com) ---
Looks like the commit was successfully reverted in 6.0.0-rc3. S2idle works
again on the HP Pavillion x360 and Dell Inspiron 3493.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.=
