Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934EAC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Jan 2022 14:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbiAOOEh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Jan 2022 09:04:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39006 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiAOOEg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Jan 2022 09:04:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A124AB8091E
        for <linux-scsi@vger.kernel.org>; Sat, 15 Jan 2022 14:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 204A6C36AEA
        for <linux-scsi@vger.kernel.org>; Sat, 15 Jan 2022 14:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642255474;
        bh=jlj4wryKJbE/CpAeMvVdu6ZiA/B/C7WZoc1S0dng9qc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pwK+zliM6Vccgn1FCuOEVHmQ2WCNvNSQy0KYdnJhAmCN0EIg1ib8C3vhROduXoSzg
         KMBxwIAjCeIGdVITeKSIL7TxqjtUlw4tCmnupcPXJ9rfPXiUfoJx7Gt+XDHPsVjcd7
         oU8vzXNfVK79b9mwTbT9GNF2rBekdJeASB6RaIIHwEx3bFVy8NLVXeKd/uyPLxdgIw
         n5eQdzEU3ACey0BgbTIynrw1noTC/sSgyQWb5cda3sNMllt1yaO6Qww3YnQ4DBgeXZ
         vp2ZfmAhNBhrYS26XqY4HTgMIOuMWQtts8HfldhKnQts31qFlxHZXgOohZSNxokhT6
         lJZleBpXO1S1A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 083AFCC13AE; Sat, 15 Jan 2022 14:04:34 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215447] sr_mod scsi_mode_sense() failure -> "scsi-1 drive"
Date:   Sat, 15 Jan 2022 14:04:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cshorler@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215447-11613-ADkPpujB9c@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215447-11613@https.bugzilla.kernel.org/>
References: <bug-215447-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215447

--- Comment #7 from Chris Horler (cshorler@googlemail.com) ---
is it risky to implement the fallback mechanism in both directions? is ther=
e a
chance of forever retry? (fail 6, fail 10, fail 6, fail 10...)

scsi_lib.c:scsi_mode_sense(): ...

        if (!scsi_status_is_good(result) &&
            driver_byte(result) =3D=3D DRIVER_SENSE) {
                if (scsi_sense_valid(sshdr)) {
                        if ((sshdr->sense_key =3D=3D ILLEGAL_REQUEST) &&
                            (sshdr->asc =3D=3D 0x20) && (sshdr->ascq =3D=3D=
 0)) {
                                /*=20
                                 * Invalid command operation code
                                 */
                                sdev->use_10_for_ms =3D !sdev->use_10_for_m=
s;
                                goto retry;
                        }
                }
        }

I guess I could increase the default retry_count at initialisation and also
decrementing it here.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
