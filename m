Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C94BC25B47
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 10:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbjJYKXF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 06:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbjJYKXC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 06:23:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1146B199
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 03:22:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48613C433CD
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 10:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698229374;
        bh=Wdo5ymWh8Z5c13nsqOQTsZ3drc6rL2decDr1ScstUdg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QyEdQnSQMS02xxQ+TcVWXhfYBAIjqnO+9xz4S1Pu/ijQxqXTBF5g/QJGDlBPEbbEA
         uyOVwG9yx3V0got5Pu8qDiLX9oq/LGNTObNlou/2qDqwe5oodfD98klFs2rSS/agqz
         tnbjBSFyCP9lo6AUfgKn10kARc4WMqIDAz2/ZX5KktUMGGBlcT4kLIiXszCPVNWHYI
         D4dEShQJ4pE87HB/VB7zCKw+HOxjApn9VS0pTOaRLkG3IGmDEyIQ4Ac+nbgiYZRkpC
         zurtbwaBlCfYl6qru1BImRwsNaDRpO1JGHo15guXW5Ufn96Neyv3R1GC409UaidDrY
         cEXHLCTeb12Qg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 33E12C53BCD; Wed, 25 Oct 2023 10:22:54 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date:   Wed, 25 Oct 2023 10:22:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: hare@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc attachments.created
Message-ID: <bug-217599-11613-8GkW1Ntpp3@https.bugzilla.kernel.org/>
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

Hannes Reinecke (hare@suse.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hare@suse.de

--- Comment #22 from Hannes Reinecke (hare@suse.de) ---
Created attachment 305290
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D305290&action=3Dedit
0001-aacraid-submit-internal-commands-on-vector-0.patch

aacraid: submit internal commands on vector 0

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
