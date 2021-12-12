Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D00C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Dec 2021 16:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhLLQGW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Dec 2021 11:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbhLLQGW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Dec 2021 11:06:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01939C061714
        for <linux-scsi@vger.kernel.org>; Sun, 12 Dec 2021 08:06:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC45EB80CF0
        for <linux-scsi@vger.kernel.org>; Sun, 12 Dec 2021 16:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7ABB9C341C6
        for <linux-scsi@vger.kernel.org>; Sun, 12 Dec 2021 16:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639325179;
        bh=jtd+8pQDS3obxHYfMS6o527wxu4xNW8UVQcQEmkxOqM=;
        h=From:To:Subject:Date:From;
        b=URmAYpMY0VIYFedq0WGHL0jZrtwB/rmUpniUMUZwGPSXRQ18t+G2Lwr5MMuHGvNIZ
         kEKQ6b5/7l25skCmnwxkXUDgMZZjb3tb/uBA/iy03HMYjZhslQYVS6FCU4F940lDXB
         KfpgQik5xnrUSAlfD1Lw3gwalJZ/RZhYLK+TGa8bnmjbe8GqBL9jWo86AUrP4WdEku
         hfybNtmJYLoREWUKHRyDAqIEDxbywtnJuOewbYWkLUidFo5xOUK4dap4QJ+rbPPG4H
         BTjLGvWMxD4MhwgNZkUQD00gwT66UYoFfsnHcrZzDmKuXpgB/O+TAX7IFCw4OhinH1
         4YLPzpTtV36kQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 5DC8760FF0; Sun, 12 Dec 2021 16:06:19 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215311] New: Support ATA command passthrough for iSCSI -> SATA
Date:   Sun, 12 Dec 2021 16:06:19 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: enhancement
X-Bugzilla-Who: nfxjfg@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215311-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215311

            Bug ID: 215311
           Summary: Support ATA command passthrough for iSCSI -> SATA
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.10.x
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: nfxjfg@googlemail.com
        Regression: No

This would be a nice feature for using smartctl over iSCSI (where the targe=
t is
a SATA disk). So far, this seems to be needed in the iSCSI target
implementation or another part of the target's SCSI layer or SATA glue code=
. I
can actually send ATA passthrough commands (0x85) from a Linux initiator, j=
ust
the target rejects them as invalid or unknown.

Hints which subsystem or even source file would handle this would be nice t=
oo,
maybe I could attempt a patch (though somewhat unlikely I would succeed).

Does iSCSI+SATA really work by translating SCSI commands to ATA commands? C=
razy
world if that's correct.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
