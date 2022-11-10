Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1FEC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 22:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiKJWWc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 17:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiKJWWT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 17:22:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3782D53EF1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 14:22:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2198B823C8
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 22:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83C0AC433B5
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 22:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668118931;
        bh=/o2nuO/xrM6A/dvftD+CG9ec2LrjQqRbmch04whpc0c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=eknqGJ68Va7stZ1SR+tPm7wXjczwnTfFI1DWB7cZ5Ra31Y8c+c9XLd/B2Kutylb/I
         ZAh9ZXfGgWkOq6NkeUKnTaZGmI4YZ1yt8d6HVrUT9TzClW7vNN/f9U9XV7KkGPbN0P
         cIQVeOqteOAjZlNPwg/cNSY9s87qH3ZJoJ421qsi8sgNSms1EZiFnBBdt3uRNfVbpg
         VR0l0I2+D4Sh39tBjYUD9MvYq0GS1iwX8oivOyL6NSqyNLeLejUiEPBd44dqYwbBcz
         3ku5uahtEXmv70Okr3STHqAeVxsbUdoEXE1b1G6sffWUUuh7dt6m9ecvTSt+XcxsgN
         6769DNP9bN6Fw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6F179C433E6; Thu, 10 Nov 2022 22:22:11 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Thu, 10 Nov 2022 22:22:11 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215943-11613-ClinN3WsuA@https.bugzilla.kernel.org/>
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

Roland Kletzing (devzero@web.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de

--- Comment #9 from Roland Kletzing (devzero@web.de) ---
is this a serious issue or only cosmetic one?=20=20

getting unsure because of  "i only noticed after the controller for some odd
reason gave up and the kernel obviously started complaining about all my sas
disks and not able to access them."


i put our 3108 based megaraid controller into jbod personality mode because=
 i'm
using the drives with proxmox/zfs (see exceprt from the manual at
https://forum.proxmox.com/threads/megaraid-personality-mode.93857/ )=20

when booting, i get this message, but it seems to work fine.  in raid
personality mode, this doesn't happen.

should i better keep the controller in raid mode (which jbod enabled) until
kernel the patch is in proxmox - or can/should i simply ignore this errors?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
