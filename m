Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D835CA0FFA
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 18:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbjIESKq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 14:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238422AbjIESKe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 14:10:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298566B093
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 10:02:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E571860244
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57245C433CA
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693929853;
        bh=vd4aAO4PVVag0yrQ/vVY7VLktIPSq5iyEoyfN7EpUuE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KfZBxtUHOi0ONUtro492seMS+phBLR84oY0C/pNX8gEzPtZK3X+HhtFxwomIXoFS7
         7ps6+N8B2LuYfIzqdybaB+rQnONfOIiY+1qrKm9JZhUl86PT/Is/FJOsxV86nENAMF
         Pg9on1xbSmVIRqsywE++cOM7bzd8k4vxPQyWvSxwUNxVfOcK+KMbUryqggnmMlHif4
         4fLcD2SL9zL7LyMD1k2cpbt6aBetntr/MAT7ZKJh5egAUg1cWGsP3kc//3EbFhbbUC
         MuL0GucDrSJUit4k89PV9HdkQWYAQXWdfGb8JeU8xqhKtNwDlvAuReSQhPpyhdmsYD
         vNXRIt4gLZ35g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 459F3C53BD0; Tue,  5 Sep 2023 16:04:13 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Tue, 05 Sep 2023 16:04:12 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-sVjyjwABlP@https.bugzilla.kernel.org/>
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

--- Comment #15 from Maokaman (maokaman@gmail.com) ---
I have the most recent firmware version:

# arcconf getconfig 1 AD | grep 'Model'
   Controller Model                           : Adaptec ASR81605Z

# arcconf getversion 1
Controllers found: 1
Controller #1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Firmware                               : 7.18-0 (33556)
Staged Firmware                        : 7.18-0 (33556)
BIOS                                   : 7.18-0 (33556)
Driver                                 : 1.2-1 (50983)
Boot Flash                             : 7.18-0 (33556)
CPLD (Load version/ Flash version)     : 5/ 12
SEEPROM (Load version/ Flash version)  : 1/ 1


#regzbot ^introduced 9dc704dcc09eae7d21b5da0615eb2ed79278f63e

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
